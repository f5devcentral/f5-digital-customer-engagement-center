# F5 Digital Customer Engagement Center Repository
F5 Digital Engagement Center Code Repository

[Project Documentation in ReadTheDocs](https://f5-digital-customer-engagement-center.readthedocs.io/en/latest/index.html)
## Overview
This project will be utilized to demo and provide reusable configurations for F5 Digital Engagement Center labs and roadshows

## Getting Started
This repository and its examples are meant to support a bring your own credentials approach.
the credentials can be obtained through an F5 UDF course deployment, or your own cloud credentials.

## Installation

This project can be run with or without the provided container for development or [**devcontainer.**](https://code.visualstudio.com/docs/remote/containers)

### Devcontainer TLDR
  - Requirements:
      - [vscode](https://code.visualstudio.com/)
      - [ms-vscode-remote.vscode-remote-extensionpack](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.vscode-remote-extensionpack)
      - [docker](https://www.docker.com/)
      - [wsl2](https://docs.microsoft.com/en-us/windows/wsl/) on windows workstations
  - Running:
    - open vscode command pallet
      - >Remote-Containers: Rebuild and Reopen in Container
## Usage

The project is meant to deliver a framework for creation solutions using common or customized modules.


### Solutions
  Each solution will:
  - Explain which infrastructure it requires
      - readme.md
  - Provide step by step instructions to deploy the required infrastructure and configure it mirroring the scripts
    - formatting for readthedocs
  - Contain scripts to:
    - Deploy the required infrastructure
      - setup.sh
    - Create the required configuration
      - demo.sh
          - demo script is meant to be a wrapper for the scripts you want to use to configure your deployed solution infrastructure.
          the most common scenario of using ansible through a docker container, is permitted by the privileged devcontainer.
    - Destroy the required infrastructure
      - cleanup.sh
  - Accept variables
    - auto.tfvars.example
      an example of available variables for the infrastructure
  - Export variables
    - Solutions should be addressable as terraform modules, this requires they output relevant connection information in a standardized way.
  - Be responsible for any IAM objects needed
  - Create and manage any security groups/firewall rules needed by the solution.
  - Include defaults not present in the auto.tvfars when using terraform
  - Provide an auto.tfvars example when using terraform

a sample solution template is available in **~/solutions/solution_template**

---
### Modules
Each module will:
- Attempt to use community or vendor supported modules first
- Export consistent outputs following project naming [standards](contributing.md)
- Include standalone examples
- Work with existing networks
---
### Devcontainer
The container will:
- provide current releases of:
  - Terraform
  - Ansible
  - pre-commit
  - aws-cli
  - azure-cli
  - gcloud-cli

---
## Development

checking for secrets as well as linting is performed by git pre-commit with the module requirements handled in the devcontainer.

testing pre-commit hooks:
  ```bash
  # test pre commit manually
  pre-commit run -a -v
  ```
building documentation:
  ```bash
  mkdir -p docs_local
  #local
  sphinx-build -b html $PWD docs_local/
  #preview local
  # non wsl normal file path volume
  docker run -it --rm -d -p 80:80 --name docs -v $PWD/docs_local:/usr/share/nginx/html nginx
  # wsl requires volume path to original dockerhost filesystem
  docker run -it --rm -d -p 80:80 --name docs -v /c/github/f5-digital-customer-engagement-center/docs_local:/usr/share/nginx/html nginx
  ```
---
## Troubleshooting
module not pulling in changes:
  - force module update
    ```bash
    terraform get -update
    ```
---
## Support
For support, please open a GitHub issue.  Note, the code in this repository is community supported and is not supported by F5 Networks.  For a complete list of supported projects please reference [SUPPORT.md](SUPPORT.md).

---
## Community Code of Conduct
Please refer to the [F5 DevCentral Community Code of Conduct](code_of_conduct.md).

---
## License
[Apache License 2.0](LICENSE)

---
## Copyright
Copyright 2014-2020 F5 Networks Inc.

---
### F5 Networks Contributor License Agreement

Before you start contributing to any project sponsored by F5 Networks, Inc. (F5) on GitHub, you will need to sign a Contributor License Agreement (CLA).

If you are signing as an individual, we recommend that you talk to your employer (if applicable) before signing the CLA since some employment agreements may have restrictions on your contributions to other projects.
Otherwise by submitting a CLA you represent that you are legally entitled to grant the licenses recited therein.

If your employer has rights to intellectual property that you create, such as your contributions, you represent that you have received permission to make contributions on behalf of that employer, that your employer has waived such rights for your contributions, or that your employer has executed a separate CLA with F5.

If you are signing on behalf of a company, you represent that you are legally entitled to grant the license recited therein.
You represent further that each employee of the entity that submits contributions is authorized to submit such contributions on behalf of the entity pursuant to the CLA.
