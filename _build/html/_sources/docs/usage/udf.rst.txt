F5 Unified Demo Framework (UDF)
-------------------------------

.. NOTE:: This environment is currently available for F5 employees only

Determine how to start your deployment:

- **Official Events (ISC, SSE Summits):**  Please follow the
  instructions given by your instructor to join the UDF Course.

- **Self-Paced/On Your Own:** Login to UDF,
  :guilabel:`Deploy` the 
  :guilabel:`Reference solutions as code`
  Blueprint and :guilabel:`Start` it.

1.  Connecting to the Environment
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To connect to the lab environment we will use SSH to the jumphost. 

SSH key has to be configured in UDF in order to access the jumphost. 


The lab environment provides several access methods to the Jumphost:

- SSH to RS-CONTAINER 
- SSH to the linux  host 
- HTTP Access to Jenkins (only available after you start the lab) 


1.1 Connect using SSH to the RS-CONTAINER
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

#. In UDF navigate to the  :guilabel:`Deployments` 

#. Click the :guilabel:`Details` button for your DevSecOps Deployment

#. Click the :guilabel:`Components` tab

#. Find the ``Linux Jumphost`` Component and click the the :guilabel:`ACCESS`
   button.
   
#. use your favorite SSH client to connect to :guilabel:`RS-CONTAINER` using your UDF private key. username is :guilabel:`root`


1.2 initial setup or skip to solutions 
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
   
- Move on to configure the container:

.. toctree::
   :maxdepth: 1
   :glob:

   first_time_run

2. Start a solution
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
.. toctree::
   :maxdepth: 1
   :caption: Solutions
   :glob:

   /solutions/*/*_index
      