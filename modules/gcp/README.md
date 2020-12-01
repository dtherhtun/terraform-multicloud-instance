# terraform-cloud-vm/gcp
deploys a VM on GCP

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| google | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| environment | n/a | <pre>object({<br>    name             = string<br>    background_color = string<br>  })</pre> | n/a | yes |
| project\_id | The GCP project id | `string` | n/a | yes |
| region | GCP region | `string` | `"us-central1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| network\_address | n/a |
| public\_ip | n/a |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
