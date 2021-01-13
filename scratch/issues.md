# issues
## EULAs
 - myf5
  - nginx software
  - bigip software
 - f5cloud services
 - UDF

## Network design
- min - small demos
  - 1 vpc
  - 2 subnets?
  - 4 subnets 2 per az?
- max - SCA networking
  - multiple vpcs
  - multiple subnets

## Documentation

- RST/read the docs vs markdown and gitdocs

## Private container registries
- create a registry in the envrionment
  - https://hub.docker.com/_/registry
  - https://github.com/alexeadem/qbo-ctl/blob/master/conf/registry.yaml
- cloud specific private registries
- static registry
  - https://github.com/psvmcc/static_docker_v2_registry
- udf hosted private registry on jump box

## Software downloads

For items without programatic downloads or marketplace images.

- nginx controller
- nginx service mesh
- udf jumphost with files?
  - issues with EULA/download access

## license keys

- variables into secrets managers
- variables into vault
- pull from udf host?
  - issues with EULA/license access


## kubernetes
- eks module
  - SG rules too open 0.0.0.0/0
    - ip assigned to worker nodes is unknown and default is public

## default credentials
- random passwords?
- ssh keys only

## module variable everything
 - instance size
 - export all objects

## naming conventions
 - camelCase
 - under_scores
 - terraform variables
 - terraform "resources"
 - module inputs
 - module outputs
 - tagging style objects vms
 - ansible group names
