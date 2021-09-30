*****
About
*****

General
#######

This project is a community-driven effort to enable F5 consumers to build/experiment/test F5 services in cloud environments.
The intent is to make it easier and faster to test the advanced security/ADC services offered by F5 by delivering modular pieces of automation code.

About the framework
###################

The f5 DCEC framework is built from the following components:

* Development Container
* Full solutions
* Automation modules

Tools
#####

The framework leverages several automation tools.

* Terraform is used as the primary automation tool to create and update cloud infrastructure components

  * more info on Terraform, https://www.terraform.io/intro/index.html

* Ansible modules may be used to control configuration management

  * more info on configuration management, https://www.ansible.com/use-cases/configuration-management

* Raw REST API calls or Linux scripting is used when no ansible module is available

  * more info on F5 iControl REST, https://devcentral.f5.com/Wiki/Default.aspx?Page=HomePage&NS=iControlREST
  * more info on NGINX REST, https://demo.nginx.com/swagger-ui/

* Github is used as the Source Control Manager

  * A single repo is used for the modules, solutions, and documentation.
  * repository, https://github.com/f5devcentral/f5-digital-customer-engagement-center

.. toctree::
   :maxdepth: 1
   :glob:
