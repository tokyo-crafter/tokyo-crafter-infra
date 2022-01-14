#!/bin/bash

###### install docker
echo "install docker"
sudo rm -f /etc/yum.repos.d/docker-ce.repo
sudo yum update -y

sudo yum install yum-utils amazon-linux-extras -y
sudo amazon-linux-extras install docker -y

sudo groupadd docker
sudo usermod -aG docker $USER

sudo systemctl enable docker
sudo systemctl enable containerd
sudo systemctl start containerd
sudo systemctl status containerd
sudo systemctl start docker
sudo systemctl status docker

###### install docker-compose
echo "install docker-compose"
sudo yum install curl
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
docker-compose --version

###### install vpn client
echo "setup vpn"
sudo amazon-linux-extras install epel -y
sudo yum install strongswan xl2tpd -y

sudo tee -a /etc/strongswan/ipsec.conf <<EOF >/dev/null
include /etc/strongswan/ipsec.d/*.conf
EOF

sudo tee -a /etc/strongswan/ipsec.d/yamaha.conf <<EOF >/dev/null

conn %default
    keyingtries=0

conn yamaha
    # Serviceを起動したら自動でIPsecトンネルを張るようにする
    auto=start
    # L2TPの場合はトランスポートに設定
    type=transport
    # 認証方法はPSKを使用
    authby=secret
    # 鍵交換アルゴリズムの設定
    keyexchange=ikev1
    # IKEの暗号化アルゴリズムの設定
    ike=aes128-sha1-modp1024
    # ESPの暗号化アルゴリズムの設定
    esp=aes128-sha1
    # サーバのIP
    left=%defaultroute
    leftid=%defaultroute
    # ヤマハルータのIP
    right=$VPN_TARGET_IP
    rightid=$VPN_TARGET_IP_ID
    compress=no
    # IKEライフタイム(8時間)
    #ikelifetime=8h
    # SAのライフタイム(8時間)
    #lifetime=8h
    keyingtries=%forever
    # サーバ側のトランスポートのポート番号(L2TP =>UDP:1701)
    leftprotoport=17/1701
    # ヤマハルータ側のトランスポートのポート番号(L2TP =>UDP:1701)
    rightprotoport=17/1701
    # 20秒ごとにdpdパケットを送信
    dpddelay=20
    # タイムアウトは60
    dpdtimeout=60
    # DPDがタイムアウトしたらトンネルを貼り直す
    dpdaction=restart
    # 予期せずトンネルが切断したらトンネルを貼り直す
    closeaction=restart

EOF

sudo tee -a /etc/strongswan/ipsec.secrets <<EOF >/dev/null
: PSK "$VPN_PSK"
EOF

sudo tee /etc/xl2tpd/xl2tpd.conf <<EOF >/dev/null
[lac yamaha]
lns = $VPN_TARGET_IP
require chap = yes
refuse pap = yes
require authentication = yes
ppp debug = yes
pppoptfile = /etc/ppp/options.xl2tpd.yamaha
length bit = yes
redial = yes
redial timeout = 10
max redials = 10

EOF

sudo tee /etc/ppp/options.xl2tpd.yamaha <<EOF >/dev/null
# L2TPトンネルのユーザ名
name $VPN_USER

# 認証を設定しない。
noauth

# 最大受信単位 (MRU), 最大転送単位 (MTU)
mtu 1258
mru 1258

# ヤマハルータをデフォルト経路として追加しない
nodefaultroute

# Proxy ARP により接続してきたホストがローカルネットワークに在るように見せます。
proxyarp

# ログファイル保管場所
logfile /var/log/ppp/yamaha.log

EOF

sudo tee /etc/ppp/chap-secrets <<EOF >/dev/null
$VPN_USER    *    $VPN_PASSWORD    *
EOF

sudo tee /etc/ppp/pap-secrets <<EOF >/dev/null
$VPN_USER    *    $VPN_PASSWORD    *
EOF

sudo systemctl enable strongswan
sudo systemctl start strongswan

sleep 10

sudo systemctl enable xl2tpd
sudo systemctl start xl2tpd

sleep 20

sudo xl2tpd-control connect yamaha

sleep 30

sudo mkdir /etc/cron.every_minute
sudo tee /etc/cron.d/0every_minute <<EOF >/dev/null
SHELL=/bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin
MAILTO=root
HOME=/
* * * * * root run-parts /etc/cron.every_minute
EOF

sudo mkdir /var/log/xl2tpd
sudo touch /var/log/xl2tpd/keepalive.log
sudo tee /etc/cron.every_minute/keepalive_vpn.sh <<EOF >/dev/null

#!/bin/sh
echo $(date) > /var/log/xl2tpd/keepalive.log
ping $VPN_TARGET_IP_ID -c 1 >> /var/log/xl2tpd/keepalive.log

EOF
sudo chmod a+x /etc/cron.every_minute/keepalive_vpn.sh

vpn_connected=false
for i in {1..100}; do

  if cat /var/log/xl2tpd/keepalive.log | grep "1 received"; then
    vpn_connected=true
  fi

  if [ $vpn_connected == true ]; then
    break
  else
    echo "waiting...($i)"
  fi
  sleep 10
done
echo "vpn connected"

exit 0
