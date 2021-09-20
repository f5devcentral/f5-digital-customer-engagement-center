BIG-IP Upgrade | Deployments
----------------------------

From: `BIG-IP update and upgrade guide`_

F5 suggests you update or upgrade the software on your BIG-IP appliances and Virtual Editions (VEs) to optimize the security, performance, and total cost of ownership of your BIG-IP systems. At a minimum, F5 recommends that you upgrade your BIG-IP appliances to at least BIG-IP 14.1 and your BIG-IP VEs to at least BIG-IP 15.1.

Because F5 customers use a variety of configurations and tools, there are many update and upgrade scenarios. This guide is a work in progress; request the update or upgrade scenarios you want to see in this guide. Use the feedback or survey button on this page, or email AskF5 at TellAskF5@f5.com. For more information, refer to `K43940246: Submitting feedback to AskF5`_.

Before you update or upgrade, F5 recommends you review the update and upgrade known issues in `K38680436: Update and upgrade known issues for August 2021 CVEs`_.

Automated Upgrade Solutions
###########################

The environment built in this solution can be upgraded in numerous ways. The automation examples below have been tested and validated to work:

- F5 Provided Ansible: `Update or upgrade BIG-IP system software using F5 Modules for Ansible`_
- Sebastian Maniak (@sebbycorp): `F5 Upgrade Process`_

.. _`K43940246: Submitting feedback to AskF5`: https://support.f5.com/csp/article/K43940246
.. _`K38680436: Update and upgrade known issues for August 2021 CVEs`: https://support.f5.com/csp/article/K38680436
.. _`BIG-IP update and upgrade guide`: https://support.f5.com/csp/article/K84205182
.. _`Update or upgrade BIG-IP system software using F5 Modules for Ansible`: https://support.f5.com/csp/article/K89192130
.. _`F5 Upgrade Process`: https://github.com/maniak-academy/f5-ansible-upgrade
