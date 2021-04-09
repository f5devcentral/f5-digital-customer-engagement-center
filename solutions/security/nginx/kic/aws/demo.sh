#!/bin/bash
echo "----start kic-aws----"
kubectl apply -f ../templates/arcadia.yml
kubectl apply -f ../templates/nginx-ingress-install.yml
kubectl apply -f ../templates/nginx-ingress-dashboard.yml

export dashboard_nginx_ingress=$(kubectl get svc dashboard-nginx-ingress --namespace=nginx-ingress | tr -s " " | cut -d' ' -f4 | grep -v "EXTERNAL-IP")
export nginx_ingress=$(kubectl get svc nginx-ingress --namespace=nginx-ingress | tr -s " " | cut -d' ' -f4 | grep -v "EXTERNAL-IP")

## ingress for the app
cat << EOF | kubectl apply -f -
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: arcadia
spec:
  rules:
  - host: $nginx_ingress
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
EOF

curl http://$nginx_ingress/

echo "----kic-aws done----"
