NGINX Kubernetes Ingress Controller | Destruction (GKE)
-------------------------------------------------------

To delete the GKE cluster permanently:

.. code-block:: bash

   gcloud container clusters delete ${namespace}-my-cluster


To temporarily resize the cluster to zero nodes so you don't incur compute charges:

.. code-block:: bash

   gcloud container clusters resize ${namespace}-my-cluster --num-nodes=0

GO FIND `ANOTHER SOLUTION`_ TO LEARN!

.. _`ANOTHER SOLUTION`: ../../../../../../index.html
