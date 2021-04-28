# TLS

<!-- spell-checker: ignore markdownlint -->
This module will store the supplied TLS certificate and key, and optionally a CA
certificate, in a Google Secret Manager slot. If a certificate and key are not
provided, a self-signed certificate will be generated and stored in Secret Manager.

## Generate a self-signed certificate with wildcard DNS for example.com

<!-- spell-checker: disable -->
```hcl
module "tls" {
    source                  = "../../../../../google/terraform/tls/"
    gcpProjectId            = var.gcpProjectId
    secret_manager_key_name = "my-tls-cert"
    domain_name             = "example.com"
}
```
<!-- spell-checker: enable -->

## Generate a self-signed certificate and set secret accessors

<!-- spell-checker: disable -->
```hcl
module "tls" {
    source                  = "../../../../../google/terraform/tls/"
    gcpProjectId            = var.gcpProjectId
    secret_manager_key_name = "my-tls-cert"
    domain_name             = "example.com"
    secret_accessors        = [
       "user:jane@example.com",
       "group:admins@example.com",
       "serviceAccount:webserver-sa@my-project.iam.gserviceaccount.com",
    ]
}
```
<!-- spell-checker: enable -->

## Store an existing certificate and key pair

<!-- spell-checker: disable -->
```hcl
module "tls" {
    source                  = "../../../../../google/terraform/tls/"
    gcpProjectId            = var.gcpProjectId
    secret_manager_key_name = "my-tls-cert"
    tls_cert                = file("/path/to/certificate.pem")
    tls_key                 = file("/path/to/certificate.key")
}
```
<!-- spell-checker: enable -->

<!-- markdownlint-disable no-inline-html -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 0.14.5 |
| google | >= 3.54 |

## Providers

| Name | Version |
|------|---------|
| tls | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| tls_secret | memes/secret-manager/google | 1.0.2 |

## Resources

| Name |
|------|
| [tls_cert_request](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/cert_request) |
| [tls_locally_signed_cert](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/locally_signed_cert) |
| [tls_private_key](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) |
| [tls_self_signed_cert](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/self_signed_cert) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| ca\_cert | An optional CA certificate to install in Secret Manager, if TLS cert and key pair<br>are provided. Ignored if a self-signed TLS cert is generated because either of<br>`tls_cert` or `tls_key` are missing. | `string` | `""` | no |
| domain\_name | An optional DNS domain name to add to a generated TLS certificate with wildcard.<br>Ignored if `tls_cert` and `tls_key` are provided.<br><br>E.g. if domain\_name = "example.com", the generated TLS certificate will include<br>SANs for 'example.com' and '*.example.com', in addition to defaults. | `string` | `""` | no |
| gcpProjectId | gcp project id | `string` | n/a | yes |
| secret\_accessors | An optional list of users, groups, and/or service accounts that will be granted<br>access to the TLS secret value.<br><br>E.g. to allow service account foo@bar.iam.gserviceaccount.com to read the secret<br>secret\_accessors = [<br>  "serviceAccount:foo@bar.iam.gserviceaccount.com",<br>] | `list(string)` | `[]` | no |
| secret\_manager\_key\_name | The unique key name to use for stored TLS credentials. Must be unique within the<br>GCP project specified by `gcpProjectId`. | `string` | n/a | yes |
| tls\_cert | An optional TLS certificate, preferably a full chain, to install in Secret Manager.<br>If left blank (default), a self-signed cert will be generated and used. See also<br>`tls_key` and `ca_cert` variables. | `string` | `""` | no |
| tls\_key | An optional TLS private key to install in Secret Manager. If left blank (default),<br>a self-signed cert will be generated and used. See also `tls_cert` and `ca_cert`<br>variables. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| tls\_secret\_key | The project-local Secret Manager key containing the TLS certificate, key, and CA. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- markdownlint-enable no-inline-html -->
