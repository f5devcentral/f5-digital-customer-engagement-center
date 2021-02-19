Nginx - Kubernetes Ingress Controller | Lab setup
----------------------------------------------

.. important:: You are responsible for the correct storing and protection of private keys and credentials that are used in the lab. 


1.  Complete the steps in the Getting started page. the following instructions will be perfromed on the dev container terminal

    
2.  Set your AWS credentials as environment variables


.. code-block:: bash

   export AWS_ACCESS_KEY_ID="your_access_ID"
   export AWS_SECRET_ACCESS_KEY="Your_access_secret_key"


3.  Open the solution directory in the terminal 


.. code-block:: bash

   cd /home/codespace/workspace/solutions/delivery/application_delivery_controller/nginx/kic/aws/

4. Create the vars file and update it with your settings

.. code-block:: bash

   cp admin.auto.tfvars.example admin.auto.tfvars
   code -r admin.auto.tfvars


============== ===========================================================
Variable Name   Variable Value
============== ===========================================================
 resourceOwner  Name of the person deploying the solution, used in tags (i.e. johnc)
 awsRegion      The AWS region in which you deploy the solution (i.e. us-west-2)
 sshPublicKey   SSH public key material in an AWS supported format - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html#how-to-generate-your-own-key-and-import-it-to-aws
============== ===========================================================


5. Run the setup script - this will create objects in your AWS account.

.. code-block:: bash

   ./setup.sh


6. Move to Lab1 - :doc:`lab01`




#






