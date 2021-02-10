Regular run (after you completed the initial setup) 
------------------------------------------

.. NOTE:: The following instructions will create a volume on your docker host and will instruct you 
          to store private information in the host volume. the information in the volume will persist 
          on the host even after the container is terminated. 


1. Copy ssh key, aws credentials and global parameters file
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

the SSH key will be used when creating EC2 instances.  
we will store them in the Jenkins SSH folder so that Jenkins can use them to access instances.

Copy credentials and parameters files from the host folder using the following script: 

.. code-block:: terminal

   /home/snops/startup.sh
       

2. Start a solution
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

List of available solutions:
 
.. toctree::
   :maxdepth: 1
   :caption: Solutions
   :glob:

   /solutions/*/*_index
   