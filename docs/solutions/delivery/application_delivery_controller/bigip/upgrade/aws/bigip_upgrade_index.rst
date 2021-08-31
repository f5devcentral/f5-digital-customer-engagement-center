BIG-IP Upgrade Environment
--------------------------

This solution shares the experience of upgrading a traditional BIG-IP Active-Standby cluster. Consumers of the solution can upgrade with the in-place demo configuration or bring in a custom configuration.

BIG-IP environments are incredibly diverse. This solution creates a general environment where different upgrades and configurations can be emulated.

.. warning: This solution builds without using best practices. BIG-IP in public clouds should use secrets managers, ssh keys, availability zones, and **never** be accessible from the general internet. This was done intentionally to present the most commonly deployed BIG-IP environment where these tools are not used/available.

.. warning: The random BIG-IP password is stored in cloud-init. If this solution is running with longevity, it is recommended to change the password.

.. toctree::
   :maxdepth: 1
   :glob:

   labSetup*
   lab*


.. _`BIG-IP update and upgrade guide`: https://support.f5.com/csp/article/K84205182
