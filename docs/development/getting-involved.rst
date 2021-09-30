*******************
How to get involved
*******************

Thank you for getting involved with this project.

You can contribute in a number of different ways.

Here is some information that can help set your expectations.


Areas of work
#############

We break down the work into 3 main themes:

#. Solutions
#. Modules
#. Framework

Developing and supporting your solution
#######################################

At a minimum each solution should:
**********************************

* Explain which infrastructure it requires

  * ``readme.md``

* Provide step by step instructions to deploy the required infrastructure and configure it mirroring the scripts

  * ``restructured text`` - formatting for readthedocs

* Contain scripts to:

  * ``setup.sh`` - Deploy the required infrastructure
  * ``demo.sh`` - Create the required configuration
  * ``cleanup.sh``- Destroy the required infrastructure

* Utilize variables

  * ``auto.tfvars.example`` - Include an example variables file
  * Export variables - Solutions should be addressable as terraform modules, this requires they output relevant connection information in a standardized way.

* Be responsible for any IAM objects needed

* Create and manage any security groups/firewall rules needed by the solution

.. note:: A sample solution template is available in **~/solutions/solution_template**

Developing and supporting your module
#####################################

Each module will:

* Attempt to use community or vendor supported modules first
* Export consistent outputs following the naming convention (see code-conventions)
* Include standalone examples
* Work with existing modules


What to work on
###############

Work is organized in github, https://github.com/f5devcentral/f5-digital-customer-engagement-center/projects

Please review the existing items and check if there is already some work in progress on the desired solution/module
