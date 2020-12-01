# terraform-cloud-vm/aws
deploys an ec2 on AWS


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| environment | n/a | <pre>object({<br>    name             = string<br>    background_color = string<br>  })</pre> | n/a | yes |
| ssh\_keypair | n/a | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| network\_address | n/a |
| public\_ip | n/a |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

