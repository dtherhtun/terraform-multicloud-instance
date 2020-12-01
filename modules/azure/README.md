# terraform-cloud-vm/azure
deploys a VM on Azure

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| azurerm | n/a |
| random | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| environment | n/a | <pre>object({<br>    name             = string<br>    background_color = string<br>  })</pre> | n/a | yes |
| location | n/a | `string` | `"southeastasia"` | no |

## Outputs

| Name | Description |
|------|-------------|
| network\_address | n/a |
| public\_ip | n/a |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
