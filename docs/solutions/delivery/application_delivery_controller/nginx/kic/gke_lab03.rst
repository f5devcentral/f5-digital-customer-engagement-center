NGINX Kubernetes Ingress Controller | Examples (GKE)
----------------------------------------------------

Included below are several examples of NGINX Ingress Controller deployments. It is recommended that you progress through building on top of each other. Going this way highlights the lifecycle of container-based services that will evolve.

|image51|

The VirtualServer and VirtualServerRoute resources are new load-balancing configurations introduced in release 1.5 as an alternative to the Ingress resource. The resources enable use cases not supported with the Ingress resource, such as traffic splitting and advanced content-based routing. The resources are implemented as `Custom Resources`_.

A custom resource is an extension of the Kubernetes API that is not necessarily available in a default Kubernetes installation. It represents a customization of a particular Kubernetes installation. However, many core Kubernetes functions are now built using custom resources, making Kubernetes more modular.

Custom resources can appear and disappear in a running cluster through dynamic registration, and cluster admins can update custom resources independently of the cluster itself. Once a custom resource is installed, users can create and access its objects using kubectl, just as they do for built-in resources like Pods.

**NGINX Ingress Controller Examples**:

- Basic: This is a simple layer 7 routing ingress, taking our EXTERNAL-IP address and moving clients to Arcadia Application
- HTTPS: Layer 7 routing ingress with TLS, TLS secret is stored in Kubernetes as a TLS secret
- HTTPS with Active Monitors: HTTPS + Active Health Monitors to Pods
- HTTPS with Active Monitors, Caching: HTTPS + Active Health Monitors + Caching for site content

1. Basic

   Create NGINX Ingress Controller with Basic HTTP:

   In the terminal window, copy the below text and paste+enter:

   .. literalinclude :: ../../../../../../solutions/delivery/application_delivery_controller/nginx/kic/templates/ingress-arcadia.yml
      :language: text

   Example:

   |image31|

   NGINX Dashboard should be updated reflecting the new services discovered

   NGINX Dashboard URL: ``http://stats.arcadia.local/dashboard.html``

   Example:

   |image32|

   Arcadia application is now exposed through the NGINX Ingress Controller on HTTP!

   NGINX Ingress Controller URL: ``http://arcadia.local/``

   Example:

   |image33|

2. HTTPS

   .. note:: There is no change to the Dashboard when using HTTPS. However, the Ingress will now listen on both port 80 and port 443

   TLS Secrets stored in Kubernetes can be referenced with NGINX Ingress Controller. First, we need to install them into Kubernetes.

   Step 1. Create Kubernetes TLS Secret

   In the terminal window, copy the below text and paste+enter:

   .. literalinclude :: ../../../../../../solutions/delivery/application_delivery_controller/nginx/kic/templates/arcadiaSecret.yml
      :language: text

   Step 2. Create NGINX Ingress Controller with HTTPS:

   In the terminal window, copy the below text and paste+enter:

   .. literalinclude :: ../../../../../../solutions/delivery/application_delivery_controller/nginx/kic/templates/ingress-arcadia-https.yml
      :language: text

   Arcadia application is now exposed through the NGINX Ingress Controller on HTTPS!

   NGINX Ingress Controller URL: ``https://arcadia.local/`` or ``http://arcadia.local/``

3. HTTPS with Active Monitors

   NGINX Plus can periodically check the health of upstream servers by sending special health-check requests to each server and verifying the correct response.

   Create NGINX Ingress Controller with HTTPS with Active Monitors:

   In the terminal window, copy the below text and paste+enter:

   .. literalinclude :: ../../../../../../solutions/delivery/application_delivery_controller/nginx/kic/templates/ingress-arcadia-https-monitor.yml
      :language: text

   Example:

   |image35|

   NGINX Dashboard should be updated reflecting the active monitors

   NGINX Dashboard URL: ``http://stats.arcadia.local/dashboard.html#upstreams``

   Example:

   |image36|

   Arcadia application is now exposed through the NGINX Ingress Controller only on HTTP with monitors!

   NGINX Ingress Controller URL: ``https://arcadia.local/``

4. HTTPS with Active Monitors, Caching

   A content cache sits in between a client and an **origin server**, and saves copies of all the content it sees. If a client requests content that the cache has stored, it returns the content directly without contacting the origin server. This improves performance as the content cache is closer to the client and more efficiently uses the application servers because they do not have to generate pages from scratch each time.

   Step 1. Create NGINX Ingress Controller Caching Path:

   In the terminal window, copy the below text and paste+enter:

   .. literalinclude :: ../../../../../../solutions/delivery/application_delivery_controller/nginx/kic/templates/nginx-config-cache-gke.yml
      :language: text

   Example:

   |image37|

   Step 2.  NGINX Dashboard should be updated with the cache location

   Example:

   |image38|

   Step 3. Create NGINX Ingress Controller with HTTPS with Active Monitors, Caching:

   In the terminal window, copy the below text and paste+enter:

   .. literalinclude :: ../../../../../../solutions/delivery/application_delivery_controller/nginx/kic/templates/ingress-arcadia-cache.yml
      :language: text

   Example:

   |image39|

   Arcadia application is now exposed through the NGINX Ingress Controller only on HTTP with monitors and caching!

   NGINX Ingress Controller URL: ``https://arcadia.local/``

5. The fun does not need to stop yet!

   The NGINX product team creates several examples of using NGINX VirtualServers, Ingress, and Configmaps, all of the examples in the `nginxinc GitHub repository`_ will also work in this environment.

6. NGINX Examples have all been completed

   At this point, as good stewards of automation, the next step is the destruction of the environment.

   Proceed to `NGINX Kubernetes Ingress Controller | Destruction (GKE)`_

.. |image31| image:: images/image31.png
.. |image32| image:: images/image32.png
.. |image33| image:: images/image33.png
.. |image35| image:: images/image35.png
.. |image36| image:: images/image36.png
.. |image37| image:: images/image37.png
.. |image38| image:: images/image38.png
.. |image39| image:: images/image39.png
.. |image51| image:: images/image51.png

.. _`Custom Resources`: https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/
.. _`NGINX Kubernetes Ingress Controller | Destruction (GKE)`: gke_lab04.html
.. _`nginxinc GitHub repository`: https://github.com/nginxinc/kubernetes-ingress/tree/master/examples/custom-resources
