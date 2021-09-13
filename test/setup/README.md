# Setup

The Terraform in this folder will be executed before creating resources and can
be used to setup service accounts, service principals, etc, that are used by the
inspec-* verifiers.

## Configuration

Create a local `terraform.tfvars` file that configures the common AWS, Azure,
and GCP settings to be used by all individual tests.

<!-- TODO @memes - the tests are only GCP right now, extend to AWS and Azure? --->

```hcl
resourceOwner = "my-name"
gcpProjectId = "my-gcp-project-id"
```

<!-- markdownlint-disable MD033 MD034 -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 0.14.5 |
| google | >= 3.54 |

## Providers

| Name | Version |
|------|---------|
| local | n/a |
| random | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| gcpProjectId | gcp project id | `string` | n/a | yes |
| resourceOwner | Who's running this test? | `string` | `"anonymous-kitchen-user"` | no |

## Outputs

| Name | Description |
|------|-------------|
| harness\_tfvars | The name of the generated harness.tfvars file that will be a common input to all<br>test fixtures. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- markdownlint-enable MD033 MD034 -->
