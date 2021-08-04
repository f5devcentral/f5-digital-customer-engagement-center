# Multi-cloud Volterra demo

<!-- spell-checker: ignore volterra markdownlint tfvars -->
This module will create a set of Volterra AWS VPC, Azure VNET, and GCP VPC Sites
with ingress/egress gateways configured and a virtual site that spans the cloud
sites.

![multi-cloud-volterra-hla.png](images/multi-cloud-volterra-hla.png)
<!-- markdownlint-disable no-inline-html -->
<p align="center">Figure 1: High-level overview of solution; this modu</p>
<!-- markdownlint-enable no-inline-html -->

HTTP load balancers are created for each business unit service, and are advertised
on every CE site that match the selector predicate for the Virtual Site. This means
that existing resources can use DNS discovery via the Volterra gateways without
changing the deployment.

> See [Scenario](SCENARIO.md) document for details on why this solution was chosen
> for a hypothetical customer looking for a minimally invasive solution
> to multi-cloud networking.

<!-- markdownlint-disable no-inline-html -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- markdownlint-enable no-inline-html -->
