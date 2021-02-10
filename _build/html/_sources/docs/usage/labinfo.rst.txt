Lab  Environment
~~~~~~~~~~~~~~~~~

Lab Environment
---------------

- Centralized logging server - Splunk server 
- Bigiq License manager to license the bigips
- slack account 


Automation workflow
---------------

This lab leverages several automation tools, 
one of the automation guidelines is to use F5 supported solutions where possible, 

- AWS cloud formation templates are used to deploy resources into AWS (network, app, BIGIP) 
 - for more information on CFT , https://aws.amazon.com/cloudformation/
 - F5 supported CFT's , https://github.com/F5Networks/f5-aws-cloudformation 
- Ansible modules are used to control BIGIP configuration (Profiles, waf policy upload, iApp) 
 - more info on F5 supported ansible modules http://clouddocs.f5.com/products/orchestration/ansible/devel/ 
- F5 REST API calls are used when no ansible module is available (for example, update a DOSL7 profile) 
 - more info on F5 iControl REST, https://devcentral.f5.com/Wiki/Default.aspx?Page=HomePage&NS=iControlREST
- Jenkins is used to create a full pipeline that ties several ansible playbooks together. 
 - Each Jenkins job correlates to one ansible playbook/Role 
 - Jenkins is also used for ops notifications (Slack)
- Git is used as the SCM
 - All references in the lab itself are to the local copy of the repos that is on /home/snops/


	|automation-workflow-010|
	
Accessing the lab
----------------

The lab is built from code, to run it you need a docker host (can be your laptop), and an AWS account with API access (access and secret keys):

.. toctree::
   :maxdepth: 1
   :glob:

   local
   udf

   
.. |lab-diag-010| image:: images/lab-diag-010.PNG
.. |automation-workflow-010| image:: images/automation-workflow-010.PNG