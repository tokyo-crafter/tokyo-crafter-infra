terraform {
  cloud {
    organization = "tokyo-crafter"

    workspaces {
      name = "proxy-prd"
    }
  }
}
