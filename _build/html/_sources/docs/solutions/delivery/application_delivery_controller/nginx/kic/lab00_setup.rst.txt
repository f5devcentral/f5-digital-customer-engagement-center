Nginx - Kubernetes Ingress Controller | Lab setup
----------------------------------------------

1. Complete the steps in the 'Getting started' page. the following instructions will be perfromed on the dev container terminal

2. Set your AWS credentials as environment variables 
    .. code-block:: terminal
       export AWS_ACCESS_KEY_ID="your_access_ID"
       export AWS_SECRET_ACCESS_KEY="Your_access_secret_key"

3. Create the vars file and update it with your settings
    .. code-block:: terminal
       cp admin.auto.tfvars.example admin.auto.tfvars
       # MODIFY THE FILE TO YOUR SETTINGS

4. Open the solution directory in the terminal 
    .. code-block:: terminal
       cd /home/codespace/workspace/solutions/delivery/application_delivery_controller/nginx/kic/aws/

5. Run the setup script - this will create objects in your AWS account.
    .. code-block:: terminal
       ./setup.sh


