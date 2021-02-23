About
~~~~~~~~~~~~~~~~~

General
---------------

This project is a community driven effort to enable F5 users to build/experiment/test F5 services in their own cloud environments.
The intent is to make it easier and faster to test the advanced security/ADC services offered by F5 by delivering modular pieces of automation code.

About the framework
-------------------
The f5-dcec framework is built from the following components:

- Development container
- Full solutions
- Automation modules



Tools
----------------
The framework leverages several automation tools

- Terraform is used as the main automation tool to create and update cloud componenets.
   - More info on terraform https://www.terraform.io/intro/index.html
- Ansible modules may be used to control BIGIP configuration (Profiles, waf policy upload)
   - more info on F5 supported ansible modules http://clouddocs.f5.com/products/orchestration/ansible/devel/
- F5 REST API calls are used when no ansible module is available
   - more info on F5 iControl REST, https://devcentral.f5.com/Wiki/Default.aspx?Page=HomePage&NS=iControlREST
- Github is used as the SCM
   - A single repo is used for the modules, solutions and documentation



Getting started
----------------

You can run the container from any docker host, follow the instructions here:

.. toctree::
   :maxdepth: 1
   :glob:

   getting_started
