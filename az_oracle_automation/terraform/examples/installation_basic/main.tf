module "virtual_network" {
  source = "../../modules/virtual_network"
}

module "bastion" {
  source = "../../modules/bastion"
}

module "virtual_machine" {
  source = "../../modules/virtual_machine"
}
