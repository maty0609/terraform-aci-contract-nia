locals {
  service_payload = [for _, s in var.services : s if s.status == "passing"]
}

data "aci_tenant" "tenant" {
  name = var.tenant_name
}

data "aci_contract" "contract" {
  tenant_dn  =  data.aci_tenant.tenant.id
  name       = "hashi2022-app-web"
  name       = var.aci_contract
}

data "aci_filter" "filter" {
	tenant_dn = data.aci_tenant.tenant.id
	name      = "hashi2022-app"
  name       = var.aci_filter
}

resource "aci_contract_subject" "subject" {
  for_each                     = { for _, policy in distinct([for s in local.service_payload : s.name]) : policy => policy }
	contract_dn                  = data.aci_contract.contract.id
	name                         = each.value
	relation_vz_rs_subj_filt_att = [data.aci_filter.filter.id]
}