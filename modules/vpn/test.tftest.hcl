# test.tftest.hcl
# Terraform native test file for VPN module

run "plan_vpn_module" {

  command = plan

  variables {
    name                   = "test-vpn"
    environment            = "test"
    vpc_cidr               = "10.10.0.0/16"
    public_subnet_cidrs    = ["10.10.1.0/24"]
    private_subnet_cidrs   = ["10.10.2.0/24"]
    customer_gateway_ip    = "1.2.3.4"
    customer_gateway_bgp_asn = 65000
    vpn_static_routes_only = true
    vpn_static_routes      = ["192.168.10.0/24"]
  }

  assert {
    condition     = length(terraform.resources) > 0
    error_message = "No resources were created by the VPN module."
  }

  assert {
    condition     = contains(keys(terraform.outputs), "vpn_connection_id")
    error_message = "vpn_connection_id output is missing."
  }

  assert {
    condition     = contains(keys(terraform.outputs), "vpn_gateway_id")
    error_message = "vpn_gateway_id output is missing."
  }
}

run "apply_vpn_module" {

  command = apply

  variables {
    name                   = "test-vpn"
    environment            = "test"
    vpc_cidr               = "10.10.0.0/16"
    public_subnet_cidrs    = ["10.10.1.0/24"]
    private_subnet_cidrs   = ["10.10.2.0/24"]
    customer_gateway_ip    = "1.2.3.4"
    customer_gateway_bgp_asn = 65000
    vpn_static_routes_only = true
    vpn_static_routes      = ["192.168.10.0/24"]
  }

  assert {
    condition     = terraform.outputs.vpn_connection_id.value != ""
    error_message = "VPN connection ID should not be empty after apply."
  }

  assert {
    condition     = terraform.outputs.vpn_gateway_id.value != ""
    error_message = "VPN gateway ID should not be empty after apply."
  }
}
