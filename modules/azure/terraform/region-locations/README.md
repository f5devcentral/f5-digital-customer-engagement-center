# Azure Region Locations

<!-- spell-checker: ignore volterra -->
This module takes no inputs and returns a single map of Azure compute regions to
an approximate latitude and longitude.

## Get the map and use
<!-- spell-checker: disable -->
```hcl
module "locations" {
  source = "github.com/f5devcentral/f5-digital-customer-engagement-center//modules/azure/terraform/region-locations/"
}

resource "volterra_azure_vnet_site" "site" {
  ...
  azureLocation = "westus2"
  # Add coordinates from locations module lookup
  coordinates {
    latitude = module.locations.lookup["westus2"].latitude
    longitude = module.locations.lookup["westus2"].longitude
  }
  ...
}
```
<!-- spell-checker: enable -->


<!-- spell-checker:ignore markdownlint bigip -->
<!-- markdownlint-disable MD033 MD034 -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13.0 |

## Providers

No provider.

## Modules

No Modules.

## Resources

No resources.

## Inputs

No input.

## Outputs

| Name | Description |
|------|-------------|
| lookup | A map of Azure compute region to a coordinate object with latitude and longitude fields. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- markdownlint-enable MD033 MD034 -->
