Nginx - Kubernetes Ingress Controller | Part 1
----------------------------------------------

Through Terraform and the deployment scripts, we have deployed the applications but did not expose the services.

We need to be able to route the requests to the relevant service.

Nginx Kubernetes Ingress to save the day! :) The NGINX Ingress Controller for Kubernetes provides enterprise‑grade delivery services for Kubernetes applications, with benefits for users of both NGINX Open Source and NGINX Plus. With the NGINX Ingress Controller for Kubernetes, you get basic load balancing, SSL/TLS termination, support for URI rewrites, and upstream SSL/TLS encryption. NGINX Plus users additionally get session persistence for stateful applications and JSON Web Token (JWT) authentication for APIs.

Start with the Nginx deployment.
''''''''''''''''''''''''''''''''''''''

We are going to use the Nginx installation manifests based on the Nginx Ingress Controller installation guide <https://docs.nginx.com/nginx-ingress-controller/installation/installation-with-manifests/>`__. For simplicity - we have already prepared the installation in a single yaml file.

1. Run the command bellow:

.. raw:: html

  <pre>
  Command:
  kubectl apply -f files/5ingress/nginx-ingress-install.yaml

  Output:
  namespace/nginx-ingress created
  serviceaccount/nginx-ingress created
  clusterrole.rbac.authorization.k8s.io/nginx-ingress created
  clusterrolebinding.rbac.authorization.k8s.io/nginx-ingress created
  secret/default-server-secret created
  configmap/nginx-config created
  deployment.apps/nginx-ingress created
  service/nginx-ingress created
  </pre>

2. Expose the Nginx Ingress Dashboard (copy and paste in the command line the bellow).

.. raw:: html

  <pre>
  cat << EOF \| kubectl apply -f - apiVersion: v1 kind: Service
  metadata: name: dashboard-nginx-ingress namespace: nginx-ingress
  annotations:
  service.beta.kubernetes.io/aws-load-balancer-backend-protocol: "tcp"
  spec: type: LoadBalancer ports:

  port: 80 targetPort: 8080 protocol: TCP name: http selector: app:
  nginx-ingress EOF
  </pre>

3. Check what we did so far is actually working:

.. raw:: html

   <pre>
   Command:
   kubectl get svc --namespace=nginx-ingress

   Output:
   NAME                      TYPE           CLUSTER-IP      EXTERNAL-IP                                                                 PORT(S)                      AGE
   dashboard-nginx-ingress   LoadBalancer   172.20.36.60    aeb592ad4011544219c0bc49581baa13-421891138.eu-central-1.elb.amazonaws.com   80:32044/TCP                 11m
   nginx-ingress             LoadBalancer   172.20.14.206   ab21b88fec1f445d98c79398abc2cd5d-961716132.eu-central-1.elb.amazonaws.com   80:30284/TCP,443:31110/TCP   5h35m
   </pre>

.. ::note the EXTERNAL-IP of the "dashboard-nginx-ingress".

This is the hostname that we are going to use in order to view the Nginx Dashboard. Browse to the following location and verify you can see the dashboard:
``http://<DASHBOARD-EXTERNAL-IP>/dashboard.html``

Note the EXTERNAL-IP of the "nginx-ingress". This is the hostname that we are going to use in order to publish the Arcadia web application. Browse to the following location and verify that you receive a 404
status code: ``http://<INGRESS-EXTERNAL-IP>/``

.. ::warning Please note that it might take some time for the DNS names to become available.

Now we can get to the interesting part
''''''''''''''''''''''''''''''''''''''

Expose all the application services and route traffic based on the HTTP
path. We will start with a basic configuration.

4. Create a new file (for example ``files/5ingress/arcadia-vs.yaml``) using the configuration bellow.

.. ::warning Please use the following folder: ``files/5ingress/`` for all future K8s config files in this guide.

.. ::warning: Please note: you need to replace the ``host`` value with the EXTERNAL-IP of the ``nginx-ingress`` service.

.. raw:: yaml

   <pre>
   apiVersion: extensions/v1beta1
   kind: Ingress
   metadata:
     name: arcadia
   spec:
     rules:
     - host: MUST BE REPLACED WITH "EXTERNAL-IP" OF THE "nginx-ingress" SERVICE
       http:
         paths:
         - path: /
           backend:
             serviceName: arcadia-main
             servicePort: 80
         - path: /api/
           backend:
             serviceName: arcadia-app2
             servicePort: 80
         - path: /app3/
           backend:
             serviceName: arcadia-app3
             servicePort: 80
   </pre>

Note how the various HTTP paths (``/, /api/, /app3/``) are routed by Ingress to the relevant K8s services.

5. Apply the configuration. Click here for detailed instructions.

.. code:: bash

    kubectl apply -f files/5ingress/arcadia-vs.yaml

    </details>

At this stage the basic install is finished and all that's left is to check the connectivity to the Arcadia web application. Get the public hostname of the exposed `nginx-ingress` service.

6. Browse to the following location and verify that you can access the site: `http://<INGRESS-EXTERNAL-IP>/`

7. Login to the application using the following credentials:

Username: admin Password: **iloveblue**

At the moment we still have two key features missing: - We are serving
only http, not https. We want our site to be fully secured therefore all
communications need to be encrypted - We are not actively monitoring the
health of the pods through the data path

8.  Take a look at the ``files/5ingress/2arcadia.yaml`` file. It increases the number of pods for our services to two - and also defines how the http health checks will looks like.

9.  Apply this new configuration. Click here for detailed instructions.

.. raw:: html

    <pre>
    Command:
    kubectl apply -f files/5ingress/2arcadia.yaml
    </pre>

10. Look at the Nginx dashboard, you can see that right now that two
    HTTP upstreams have 2 members but no health checks are being done.
    In our next step we will finish this part of the configuration, we
    will implement the following:

-  Enable health checks
-  Enable https for the application and redirect http requests to https

11. Create ``ingress-arcadia.yaml`` to reflect the bellow and apply the
    configuration.
    :warning: Please note: you need to replace the ``host`` value with
    the EXTERNAL-IP of the ``nginx-ingress`` service.

.. raw:: html

   <pre>
   apiVersion: v1
   kind: Secret
   metadata:
     name: arcadia-tls
     namespace: default
   data:
     tls.crt: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUZWRENDQkR5Z0F3SUJBZ0lTQTZmZXlEYXhUUFc4eFdlLys2K1h0eUhOTUEwR0NTcUdTSWIzRFFFQkN3VUEKTUVveEN6QUpCZ05WQkFZVEFsVlRNUll3RkFZRFZRUUtFdzFNWlhRbmN5QkZibU55ZVhCME1TTXdJUVlEVlFRRApFeHBNWlhRbmN5QkZibU55ZVhCMElFRjFkR2h2Y21sMGVTQllNekFlRncweU1EQTBNVGd4TURJNU1qUmFGdzB5Ck1EQTNNVGN4TURJNU1qUmFNQmt4RnpBVkJnTlZCQU1NRGlvdWMyOXlhVzVpTG1Oc2IzVmtNSUlCSWpBTkJna3EKaGtpRzl3MEJBUUVGQUFPQ0FROEFNSUlCQ2dLQ0FRRUFtLzI0WDZpb0gybWhWUjJSQlhCQXd1KzlFMkxTZldMRwpldEtJbU1RdTN2Mzh5NDZJbnZubmpDNis1VDFqdk1INEVIY1Bmcy9qUS8zbDRjUWtiRWhQYUEwVXluRmEwbEUvClNidmJmbVdsOUlBZmc0eXc0cWxmTW5GNFdXVEFWQlhwVDhpZFZnc2tQaDVuMVdQUDdBSVJxNXFhUkR3YWVZMUEKOE5VREY1T3RsYXNvYitxdTBOTnJnSUZvQ0ZVODQ4cUJEWllLODhXalYyQStxVG5xSko0U3ZoMFNOUDBYWmRoQgo2TkRKT3RBWDlYbWdybTlxWFBFMXE0QU0yazNTNFllb1ZvRWNnQnRMdTRocWRxMlhhQWhOc1RHcVYzaXgvNkhFCjRFMU5iMElEdmxGdHlhVFl6ZXhTRHRKOGx4OEIwa0Jwa2xoaG93MjBQS3R2NjhkOUE0TGc5UUlEQVFBQm80SUMKWXpDQ0FsOHdEZ1lEVlIwUEFRSC9CQVFEQWdXZ01CMEdBMVVkSlFRV01CUUdDQ3NHQVFVRkJ3TUJCZ2dyQmdFRgpCUWNEQWpBTUJnTlZIUk1CQWY4RUFqQUFNQjBHQTFVZERnUVdCQlFaS3M4Q1FJRmd6NWFQQXJKWE13aDVhNW4yCkR6QWZCZ05WSFNNRUdEQVdnQlNvU21wakJIM2R1dWJST2JlbVJXWHY4Nmpzb1RCdkJnZ3JCZ0VGQlFjQkFRUmoKTUdFd0xnWUlLd1lCQlFVSE1BR0dJbWgwZEhBNkx5OXZZM053TG1sdWRDMTRNeTVzWlhSelpXNWpjbmx3ZEM1dgpjbWN3THdZSUt3WUJCUVVITUFLR0kyaDBkSEE2THk5alpYSjBMbWx1ZEMxNE15NXNaWFJ6Wlc1amNubHdkQzV2CmNtY3ZNQmtHQTFVZEVRUVNNQkNDRGlvdWMyOXlhVzVpTG1Oc2IzVmtNRXdHQTFVZElBUkZNRU13Q0FZR1o0RU0KQVFJQk1EY0dDeXNHQVFRQmd0OFRBUUVCTUNnd0pnWUlLd1lCQlFVSEFnRVdHbWgwZEhBNkx5OWpjSE11YkdWMApjMlZ1WTNKNWNIUXViM0puTUlJQkJBWUtLd1lCQkFIV2VRSUVBZ1NCOVFTQjhnRHdBSFlBc2g0RnpJdWl6WW9nClRvZG0rU3U1aWlVZ1oydmErbkRuc2tsVExlK0xrRjRBQUFGeGpRemx3UUFBQkFNQVJ6QkZBaUFLdDdienBvcEcKUjd6MFNFajdES0xxUjFoTFhMVElrZWJkNEFqaE04dHg4UUloQUxXNTFJVFd2WFMyV09DZkRUcEF2WWFZaEMyVApyWlM5K1ZtTzBLL0dsMnBuQUhZQWIxTjJyREh3TVJuWW1RQ2tVUlgvZHhVY0Vka0N3UUFwQm8yeUNKbzMyUk1BCkFBRnhqUXptaWdBQUJBTUFSekJGQWlCejZxbWF4UDNlWTVNOHh4S0hsL25nTlhsNU40SlhHdXhZNGFEY1BqNW4KZVFJaEFJNzMwd2oxS3BwbXRTOXhkb3JOdTdTaGJROGVFZFhXZXF2SnRrWVMvVlgyTUEwR0NTcUdTSWIzRFFFQgpDd1VBQTRJQkFRQTZiQkR4ZUVyaXJ3NmNTK2RwVGV5dVo4bTZsbWUyMmxrN3dMaENtUlJWL25LMURVVGJVdlFWCitEK290ZjlNTEU0TjZMUll5RTlVeHZrTTc2SkVpMHpLVjdEKzhuaUI5SkV1ZTFqL1dwcTJSdXZwRnVmYTVUZVgKL01pVXJNU2tXc0Q3dkx4MWNqdHhoa2FCZk1GUUd6ek9ma0FialBRdTRQTk1tNW03bWdHV1pTT0VxQTNQVE5XSwpuUzZSTEtTSjlIWUZuZ3MzTFhleERzTTNNd1d3TmJyMktJNUFPU3oyellYbzN2Uzh5Y25rWDU2QzJTOEYvaGRSCjVmVUsxZXdHN1RHTk9rRmhKckQwTUhYbzR4c28rVXRCY0k1Z3lHVFcwM3dwMmNTVHcraFhrczQyVUJVS3BIQkgKSjlHQkY5SDRJUXV3aHAyalZzR1pXRVBYelg2R2lVYzAKLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo=
     tls.key: LS0tLS1CRUdJTiBQUklWQVRFIEtFWS0tLS0tCk1JSUV2d0lCQURBTkJna3Foa2lHOXcwQkFRRUZBQVNDQktrd2dnU2xBZ0VBQW9JQkFRQ2IvYmhmcUtnZmFhRlYKSFpFRmNFREM3NzBUWXRKOVlzWjYwb2lZeEM3ZS9mekxqb2llK2VlTUxyN2xQV084d2ZnUWR3OSt6K05EL2VYaAp4Q1JzU0U5b0RSVEtjVnJTVVQ5SnU5dCtaYVgwZ0IrRGpMRGlxVjh5Y1hoWlpNQlVGZWxQeUoxV0N5UStIbWZWClk4L3NBaEdybXBwRVBCcDVqVUR3MVFNWGs2MlZxeWh2NnE3UTAydUFnV2dJVlR6anlvRU5sZ3J6eGFOWFlENnAKT2Vva25oSytIUkkwL1JkbDJFSG8wTWs2MEJmMWVhQ3ViMnBjOFRXcmdBemFUZExoaDZoV2dSeUFHMHU3aUdwMgpyWmRvQ0UyeE1hcFhlTEgvb2NUZ1RVMXZRZ08rVVczSnBOak43RklPMG55WEh3SFNRR21TV0dHakRiUThxMi9yCngzMERndUQxQWdNQkFBRUNnZ0VBQnFJMGpBVGRHWERoaG9BYVliUFRYVGJhd0k5TVNqN0FHQXNKK2cwbHZSL3AKOXpJWmgwRXpZcGUrVUh0YTJYVWFPb0VGckt2a2kwaXAxUDhGV1lGOXR2d1BiVWlDeHp6alJ4eHhDaUFDZmJKUgpKTVAvNWJPME02MzFveitRbWtMUVNDOU0yWkxodUs2TVZkdkh4TTZWdDhsOFUvaUdXN0x4Rnd6SDgrRzQyUXQ4ClRCeDUzUWdDZGgxcDVFNC9sSFNzUmdIRlRRbUZXWmE0M3NkVlA1VUs4VHhtcElpdXBid0JrUG1TQ2JDUXoxM0YKTlRGQSs2aXIrQjdETzJUaGxJMytXNEdoYVdPaXBUYk5xTGFMR2xXOEhrZFhzRFlDRXRHRFRnWEtVSDBBUFZzTgpUTnYxYkhTS0hhc1UwejlaNk5IdmU1THdPK214K1RYUE42bXRURURnUlFLQmdRRE96R1B1TGd4a1dwYWxHNDRHClJhcHhqa1pUMnNRbjdWa1IzMXQveElOZGNIV3JZMG8xaWxpYVdBdDA5NDhmUGJKT3JCOFNSdDVkTGN3MlBzMUwKR2UyQTUxUFlpeTRGVkR6S3laSmNqMFczMEVZMG5kSWM5UHh3ME1oMUtqZndJTEJJTlFaSDBJQWtiWC9GU0EyYQpOaWVXRDNiL000NklGUTl5eFlIY1JLeGEvd0tCZ1FEQkdzWnBEU2hCMVFFVTRxbEhkRTdXOGFxM0hZWG15RnRGCm9xREhQNmNiUEtFVEpTcEc4NWkwRHo0ZUMxbTUvTFZiR3lvR1FGdlFEem03Q1ZtdGxYMExSOTBzNWpuSmZwWGEKc1FtY1VPdmc3RVI0YmhUM1FDUzRVUy9CamsrTFJTVnpIVWFpbG94ZDdVVGtlS21BbEI2dFdEaVNsTXZod3NXKwpYbjg1Z2IwSUN3S0JnUUNzYTNtK01xS2VZWEZOQkNac1VGV0dER3ZTcW9uMkNFekZQQWRjQmdySk0yVElteVphCmNaamlSeHAyVVpvQklEMjBub25oZ1RrUlU0ZjZpbTQ4ZWNldVBER0tVTEQwUElIYlNpbEFCeXpIejExWnJXUnMKUkU3ZCtSWEpxb090TUhRS0lEdTJVTDhtb0MxeDNWdUtBakVMU3FXYXJlL2V3a0I1SHZmaElWamJIUUtCZ1FDcgovdkk4ZllpZTRsODlRQW53NkFxVTd0blVrZ3BESGJBV0hSMUJlMU9YTWZCeVFnY2UvVGZGSVZKOXBqUjhNVGRECmQ3VjlyZk5aSlVhUmJtbWU3K2habE4vT2J4MkhlQ1YzalhwMjdhaTdSUlpUZ2hGUWpLUm9PMy9pMGFQTjgzL0EKd1pHNW5ZaFczTkFoQTh4T0J5QXYyOFUvNGlLYTZrWUJJdUFFMDZjUU13S0JnUUNMYTBSaHV5MEl1T2k5djBacgpwTjdWd1FaK2JwVWhBQmtXaEg5SGJWTndpclYvaTZBWElTT2JFbjRZdU1zN2w2ZkhCdDJDSlVicENlM2JCUS9nCjdCMG9VR0xMMVdOOG0xVHlKaWhXaC9WZk5sMUlNTTJEZkc3L1FpaFNKZWUxaW04RnlVZUx4TGVjYnllUmZHRDMKUXlTMlVIL2orYnZOYStMekF3SmJTNmN0UkE9PQotLS0tLUVORCBQUklWQVRFIEtFWS0tLS0tCg==
   type: kubernetes.io/tls

   ---

   apiVersion: extensions/v1beta1
   kind: Ingress
   metadata:
     name: arcadia
     annotations:
       nginx.com/health-checks: "true"
       ingress.kubernetes.io/ssl-redirect: "true"
   spec:
     tls:
     - hosts:
       - MUST BE REPLACED WITH "EXTERNAL-IP" OF THE "nginx-ingress" SERVICE
       secretName: arcadia-tls
     rules:
     - host: MUST BE REPLACED WITH "EXTERNAL-IP" OF THE "nginx-ingress" SERVICE
       http:
         paths:
         - path: /
           backend:
             serviceName: arcadia-main
             servicePort: 80
         - path: /api/
           backend:
             serviceName: arcadia-app2
             servicePort: 80
         - path: /app3/
           backend:
             serviceName: arcadia-app3
             servicePort: 80
   </pre>

 Click here for detailed instructions.

.. raw:: html

   <pre>
   Command:
   kubectl apply -f files/5ingress/ingress-arcadia.yaml
   </pre>

12. Browse to the Arcadia website with http and you will be automatically redirected to https. Look at the Nginx dashboard and observe that Nginx has started monitoring the pods.

Speed up application performance and enable caching.

13. Create a new file ``nginx-config.yaml`` that reflects the bellow configuration and apply it. We are telling Nginx to create a caching entity that will be used by our Ingress.

.. raw:: html

   <pre>
   kind: ConfigMap
   apiVersion: v1
   metadata:
     name: nginx-config
     namespace: nginx-ingress
   data:
     proxy-protocol: "True"
     real-ip-header: "proxy_protocol"
     set-real-ip-from: "0.0.0.0/0"
     http-snippets  : |
       proxy_cache_path /var/tmp/a levels=1:2 keys_zone=my_cache:10m max_size=100m inactive=60m use_temp_path=off;
   </pre>

 Click here for detailed instructions.

``bash kubectl apply -f files/5ingress/nginx-config.yaml``

Configure the Nginx Ingress to start using it and start caching.

14. Create a new file ``nginx-ingress-update.yaml`` with the configuration below and apply it.

.. ::warning Please note: you need to replace the ``host`` value with the EXTERNAL-IP of the ``nginx-ingress`` service.

.. raw:: html

   <pre>
   apiVersion: extensions/v1beta1
   kind: Ingress
   metadata:
     name: arcadia
     annotations:
       nginx.com/health-checks: "true"
       ingress.kubernetes.io/ssl-redirect: "true"
       nginx.org/server-snippets: |
         proxy_ignore_headers X-Accel-Expires Expires Cache-Control;
         proxy_cache_valid any 30s;
       nginx.org/location-snippets: |
         proxy_cache my_cache;
         add_header X-Cache-Status $upstream_cache_status;

   spec:
     tls:
     - hosts:
       - MUST BE REPLACED WITH "EXTERNAL-IP" OF THE "nginx-ingress" SERVICE
       secretName: arcadia-tls
     rules:
     - host: MUST BE REPLACED WITH "EXTERNAL-IP" OF THE "nginx-ingress" SERVICE
       http:
         paths:
         - path: /
           backend:
             serviceName: arcadia-main
             servicePort: 80
         - path: /api/
           backend:
             serviceName: arcadia-app2
             servicePort: 80
         - path: /app3/
           backend:
             serviceName: arcadia-app3
             servicePort: 80
   </pre>

 Click here for detailed instructions.

``bash kubectl apply -f files/5ingress/nginx-ingress-update.yaml``

15. We have two simple indicators to check that all is working:

  -  First if we open the browser developer tools we can see a new http header in the response called "X-Cache-Status". If the response was taken from the cache it will have a value of "HIT" otherwise if it was server by the server the value will be "MISS"

  -  The second options is to look at the Nginx Dashboard -> Caches and observe the HIT ration and traffic served
