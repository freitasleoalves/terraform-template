# Used as workaround for bug in azuread provider
# https://github.com/hashicorp/terraform-provider-azuread/issues/624#issuecomment-941128484
data "azuread_user" "user" {
  user_principal_name = var.user_principal_name
}
