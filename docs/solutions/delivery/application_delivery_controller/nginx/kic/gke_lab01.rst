NGINX Kubernetes Ingress Controller | Deployment (GKE)
------------------------------------------------------

1. Clone the official NGINX repo and change your working directory to ``kubernetes-ingress``. Everything we need to build and deploy NGINX+ as KIC is in this repo.

   .. code-block:: bash

      git clone -b 'v1.12.0' --single-branch https://github.com/nginxinc/kubernetes-ingress
      cd kubernetes-ingress


2. Copy your NGINX+ license key and certificate to the kubernetes-ingress directory. You can copy and paste by dragging and dropping into VS Code editor.

   * nginx-repo.key

   * nginx-repo.crt


   .. image:: images/kic_gke/8_drag_and_drop_lic.png
     :scale: 50%


   Confirm both files exist in the kubernetes-ingress directory:

   .. code-block:: bash

      ls nginx-repo*

3. Build and push the NGINX Plus Docker image to the Artifact Registry repo.

   From the GCP Console, in the search bar at the top, look for **Artifact Registry**. Click on your repo. Copy the complete path to the Artifact Registry repo. For    example: ``us-east4-docker.pkg.dev/f5-gcs-4261-sales-na-ne/marfil-my-repo``. Save this text to your notes.


   .. image:: images/kic_gke/6a_copy_paste_repository_path.png
     :scale: 50%


   Build the ``nginx-plus-ingress`` Docker image.

   .. note:: Replace the repo path in the examples below, with your own repo path from the previous step.

   .. code-block:: bash

      make debian-image-plus PREFIX=us-east4-docker.pkg.dev/f5-gcs-4261-sales-na-ne/marfil-my-repo/nginx-plus-ingress TARGET=container

   Once done. Combine the full path to your image and tag like this:

   .. code-block:: bash

      docker images | grep nginx-plus-ingress

   For example, the output below:

   ``us-east4-docker.pkg.dev/f5-gcs-4261-sales-na-ne/marfil-my-repo/nginx-plus-ingress   1.12.0-SNAPSHOT-c9d3618   1cc1b47cf228   12 seconds ago   131MB``

   Would become:

   ``us-east4-docker.pkg.dev/f5-gcs-4261-sales-na-ne/marfil-my-repo/nginx-plus-ingress:1.12.0-SNAPSHOT-c9d3618``

   Finally, push the image to your Artifact Registry repo:

   .. code-block:: bash

      docker push us-east4-docker.pkg.dev/f5-gcs-4261-sales-na-ne/marfil-my-repo/nginx-plus-ingress:1.12.0-SNAPSHOT-c9d3618

   From the GCP console, you should see the new image in your Artifact Registry repo.

   .. image:: images/kic_gke/9a_make_and_push_image.png
     :scale: 50%

4. Deploy ``nginx-plus-ingress`` to your GKE cluster.

   Change your working directory to ``deployments``:

   .. code-block:: bash

      cd deployments


   You need to make two edits to the ``deployment/nginx-plus-ingress.yaml`` manifest. From the VS Code Explorer menu to the left of the code editor, double-click on    ``deployment/nginx-plus-ingress.yaml`` to open in the VS Code editor. Alternatively, you can edit the file from your terminal with any popular text editor such as ``vim`` or ``nano``.

   * Change the ``image`` parameter to reference the nginx-plus-ingress image in our repo.

   * Add ``args`` to enable the NGINX Plus statistics dashboard.

    .. code-block:: bash

       - -nginx-status-allow-cidrs=0.0.0.0/0


   .. image:: images/kic_gke/10_nginx_deployment_edits.png
     :scale: 50%

   **Save your changes.**

   To deploy nginx-plus-ingress, you can apply multiple yaml manifest with a single command.

   Copy and paste the code block below to the VS Code terminal.

   .. code-block:: bash

      kubectl apply \
      -f common/ns-and-sa.yaml \
      -f rbac/rbac.yaml \
      -f rbac/ap-rbac.yaml \
      -f common/default-server-secret.yaml \
      -f common/nginx-config.yaml \
      -f common/ingress-class.yaml \
      -f common/crds/k8s.nginx.org_virtualservers.yaml \
      -f common/crds/k8s.nginx.org_virtualserverroutes.yaml \
      -f common/crds/k8s.nginx.org_transportservers.yaml \
      -f common/crds/k8s.nginx.org_policies.yaml \
      -f common/crds/k8s.nginx.org_globalconfigurations.yaml \
      -f service/loadbalancer.yaml \
      -f deployment/nginx-plus-ingress.yaml


   .. image:: images/kic_gke/11_nginx_install_apply_manifests.png
     :scale: 50%


   The ``service/loadbalancer.yaml`` manifest has created a load balancer service for our NGINX Ingress. This maps all HTTP and HTTPS traffic coming in to the    load-balancer's public IP address to one or more NGINX Ingresses:


   .. code-block:: bash

      kubectl get svc -n nginx-ingress


   Let's create a second load balancer service to the NGINX Plus deployment running the stats dashboard on TCP port 8080.

   .. code-block:: bash

      cat << EOF | kubectl apply -f -
      apiVersion: v1
      kind: Service
      metadata:
        name: dashboard-nginx-ingress
        namespace: nginx-ingress
      spec:
        type: LoadBalancer
        ports:
        - port: 80
          targetPort: 8080
          protocol: TCP
          name: http
        selector:
          app: nginx-ingress
      EOF


   .. image:: images/kic_gke/11_nginx_install_apply_manifests.png
     :scale: 50%


   Confirm both ``nginx-ingress`` and ``dashboard-nginx-ingress`` services are running.

   .. code-block:: bash

      kubectl get svc -n nginx-ingress


   Both the ``nginx-ingress`` and ``dashboard-nginx-ingress`` services should be accessible from any browser. Test both.

   **nginx-ingress:**

   .. note:: The nginx-ingress service will reply with **404 Not Found**. This is expected at this point in the lab: after the nginx deployment is running but before the ingress has been configured.

   .. image:: images/kic_gke/12_kubectl_get_svc_ingress.png
     :scale: 50%


   **dashboard-nginx-ingress:**


   .. image:: images/kic_gke/12b_kubectl_get_svc_ingress_dashboard.png
     :scale: 50%


5. Let's make the ``EXTERNAL-IP`` addresses resolvable via DNS on our lab machines and create some useful environment variables.

     .. note:: Continue to check periodically until EXTERNAL-IP's are no longer <pending>.

        .. code-block:: bash

           kubectl get svc -n nginx-ingress

     .. note:: Do not run the commands below until _after_ EXTERNAL-IP's have been assigned.

   From the VS Code terminal:

   .. code-block:: bash

      export nginx_ingress=arcadia.local
      export dashboard_nginx_ingress=stats.arcadia.local
      export ip_dashboard_nginx_ingress=$(kubectl get svc dashboard-nginx-ingress --namespace=nginx-ingress | tr -s " " | cut -d' ' -f4 | grep -v "EXTERNAL-IP")
      export ip_nginx_ingress=$(kubectl get svc nginx-ingress --namespace=nginx-ingress | tr -s " " | cut -d' ' -f4 | grep -v "EXTERNAL-IP")
      printenv | grep nginx


   We can make the load balancer services' public IP addresses resolvable locally by mapping names to IP addresses in our local hosts file.


   Backup your hosts file.

   .. code-block:: bash

       sudo cp /etc/hosts /etc/hosts.bak.$(date '+%s')


   Append host entries to your ``/etc/hosts`` file for both ``arcadia.local`` and ``stats.arcadia.local``.

   .. code-block:: bash

       sudo bash -c "echo '${ip_dashboard_nginx_ingress} stats.arcadia.local' >> /etc/hosts"

       sudo bash -c "echo '${ip_nginx_ingress} arcadia.local' >> /etc/hosts"


   Confirm changes (last two lines were appended).

   .. code-block:: bash

       cat /etc/hosts

   Now, append local hosts file entries *on your computer*--This must be a computer with a modern browser installed.

   .. note:: The hosts file location varies by Operating System.

      - On Linux and MacOS the file is located at: ``/etc/hosts``
      - On Windows the file is located at: ``C:\Windows\System32\drivers\etc\hosts``


   .. image:: images/kic_gke/13_exports_and_hosts_edit.png
     :scale: 50%


   With your browser, hit the (unconfigured) nginx-ingress service:

   http://arcadia.local/

   |

   With your browser hit the dashboard-nginx-ingress service:

   http://stats.arcadia.local/dashboard.html

   |

Proceed to `Arcadia Application | Deployment (GKE)`_

.. _`Arcadia Application | Deployment (GKE)`: gke_lab02.html
