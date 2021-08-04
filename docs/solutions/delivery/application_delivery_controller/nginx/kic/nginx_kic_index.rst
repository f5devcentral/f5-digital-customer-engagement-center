NGINX Kubernetes Ingress Controller
-----------------------------------

|image00|

This solution is designed to share the experience of deploying a modern application along with the NGINX Kubernetes Ingress Controller. Throughout the solution are steps and notes highlighting the procedure to create a successful deployment. Examples at the end of the solution are in place to share current relevant deployment styles for todays applications.

NGINX Kubernetes Ingress Controller solution can run on multiple clouds. The documents below have an order of operation to deploy the solution thoroughly. Each document, however, could be used independently with an existing environment.

.. warning:: Choose the cloud provider environment listed below to start the solution. Example: **NGINX Kubernetes Ingress Controller | AWS Environment**

.. |image00| image:: images/image00.png
  :width: 75%
  :align: middle

**Amazon Web Services (AWS) and Azure**

.. toctree::
   :maxdepth: 1
   :glob:

   labSetup*
   lab*

**Google Kubernetes Engine (GKE)**

.. toctree::
   :maxdepth: 1
   :glob:

   gke_labSetupGKE*
   gke*
