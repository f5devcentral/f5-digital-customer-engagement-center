How to get involved
===================

Thank you for getting involved with this project.

You can contribute in a number of different ways.

Here is some information that can help set your expectations.


Areas of work 
-------------------------------------

We break down the work into 3 main themes:

1. Solutions 

2. Modules 

3. Framework 


Developing and supporting your solution
----------------------------------------------

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

Developing and supporting your module
-------------------------------------

Each module will:
- Attempt to use community or vendor supported modules first
- Export consistent outputs following the naming convention (see code-conventions)
- Include standalone examples
- Work with existing modules


What to work on
---------------

Work is organized in github, https://github.com/f5devcentral/f5-digital-customer-engagement-center/projects

please review the existing items and check if there is already some work in progress on the desired solution/module 


