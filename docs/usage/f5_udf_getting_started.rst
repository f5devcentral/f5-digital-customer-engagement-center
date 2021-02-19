Getting started -F5 UDF Environment Access
--------------------------------------------------

F5 has an internal lab environment that can be used to launch solutions from this project. The benefit of utilizing the UDF environment is access to cloud accounts (AWS), clean-up, and cost.

The jumphost comes pre-configured with packages and software to make running solutions easier. However, code in this project is designed to be run in any environment.

If you have been or have access to the UDF environment, the blueprint for this project is a called **F5 Digital Engagement Center**

The following steps will get your UDF jumphost configured.

- Deploy the UDF Blueprint, Or if you are in a Lab class, your instructor will do this action for you.

|image01|

|image02|

- Once the blueprint is deployed, you will need to start it. This action does not happen automatically.

|image03|

- Default run-time is 8 hours. Most solutions will be completed in far less; choose an appropriate time window.

.. warning:: When a UDF blueprint is stopped, either by action or timer expiring, all cloud resources deployed will be removed.

|image04|

- Starting of the blueprint can take a few minutes. During this window, the ubuntuHost, VPC, and networking in AWS are all being created. Resources will turn green when available.

|image05|

- Every time a UDF blueprint is brought online with Cloud Accounts, and the ephemeral account is created. This account has access to resources highlighted either programmatically or through an AWS console. These resources are located on the "Cloud Accounts" tab.

|image06|

- With the resources available, we can log in to the ubuntuHost. There are a few access methods to the host. However, Coder has been installed and is the primary access method. Open the Coder Access Method

.. note:: Coder in its most basic form is VSCode in a web browser. It has access to all VSCode extensions and tools.

|image07|

- When accessing Coder, a simple password has been created, ``password``.

|image08|

- For users of VSCode, the screen should be very familiar. VSCode is an extendable IDE for users not aware, allowing you to craft and interact programmatically with systems. There has been a cached copy of the project repository installed on the ubuntuHost for you. Select the cached copy.

|image09|

- After selecting the repository, VSCode will reorganize itself to show you the contents of the repository.

|image10|

- Because the repository code constantly changes with solutions and updates, we need to update to current. We can do this from the VSCode terminal.

|image11|

- After the terminal is open, type ``git pull``, will pull down the repository bringing in any updates to the cached version.

|image12|

- At this point, the jumphost is ready to interact with the solutions.

.. warning:: We do not pull down a new version of the repository programmatically at any point. This is on purpose, so any configuration updated locally will not be overwritten.

**Cloud Accounts**

**For AWS Cloud Accounts**

The jumphost is in AWS but does not have AWS configuration enabled for programmatic access. To add programmatic access to the instance, you need to issue the ``aws configure`` command. This command has four inputs, the ``AWS Access Key ID`` and ``AWS Secret Access Key`` can be located on your UDF blueprint Cloud Accounts Tab.

.. warning:: the ``region`` must always be set to ``us-west-2`` if you are using UDF created cloud accounts. This is the only region resources that are allowed to be made.

|image06|

|image13|



.. |image01| image:: images/image01.png
  :width: 50%
.. |image02| image:: images/image02.png
  :width: 50%
.. |image03| image:: images/image03.png
.. |image04| image:: images/image04.png
  :width: 50%
.. |image05| image:: images/image05.png
.. |image06| image:: images/image06.png
.. |image07| image:: images/image07.png
.. |image08| image:: images/image08.png
  :width: 50%
.. |image09| image:: images/image09.png
.. |image10| image:: images/image10.png
.. |image11| image:: images/image11.png
  :width: 50%
.. |image12| image:: images/image12.png
.. |image13| image:: images/image13.png
