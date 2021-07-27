# Workstation

<!-- spell-checker: ignore jumphost -->

This module will create an Ubuntu VM that can be used as a Code Server workstation
and jumphost. The workstation will use GCP identity-aware proxy and OS Login
capabilities to limit access to accounts with the correct permissions.

![workstation](workstation.png)

> Figure 1: Resources provisioned by workstation module

1. Enable Identity-Aware Proxy in the GCP project

2. Firewall rule to allow ingress TCP to ports 22, 443, and 8888 on `workstation` from IAP CIDR

3. Workstation VM (Ubuntu Focal LTS) deployed to one of the AZs in region
   * [Code Server](https://github.com/cdr/code-server) v3.11.0
      * Latest [F5 VS-Code](https://github.com/f5devcentral/vscode-f5) extension
      * [Terraform VS-Code](https://open-vsx.org/extension/hashicorp/terraform) 2.13.2 extension
   * [NGINX OSS](https://nginx.org/) as reverse-proxy for Code Server, and forward-proxy to other resources on network
   * [F5 CLI](https://clouddocs.f5.com/sdk/f5-cli/)
   * [Terraform](https://www.terraform.io/docs/index.html) v0.14.11
   * [Docker CE](https://docker.io)
   * [Containerd](https://containerd.io)


## Using workstation

Terraform can provide some starter `gcloud` commands to perform various tasks;
access these using the `terraform output` command.

```shell
terraform output connection_helpers
```

```text
"{\"code_server_tunnel\":\"gcloud compute start-iap-tunnel emes-workstation-abcd 443 --local-host-port=localhost:8443 --project=my-google-project --zone=us-west1-b\",\"proxy_tunnel\":\"gcloud compute start-iap-tunnel emes-workstation-abcd 8888 --local-host-port=localhost:8888 --project=my-google-project --zone=us-west1-b\",\"ssh\":\"gcloud compute ssh emes-workstation-abcd --tunnel-through-iap --project=my-google-project --zone=us-west1-b\"}"
```

You can grab an individual connection command through copy and paste or with
[JQ](https://stedolan.github.io/jq/). E.g. to extract the command to start an IAP
tunnel to Code Server instance

```shell
terraform output connection_helpers | jq -r 'fromjson | .code_server_tunnel'
```

```text
gcloud compute start-iap-tunnel emes-workstation-abcd 443 --local-host-port=localhost:8443 --project=my-google-project --zone=us-west1-b
```

### Code Server (browser-based VS Code)

Use `gcloud` to start an IAP tunnel to the workstation, forwarding traffic from
port `8443` on your local computer to port `443` on the workstation.

```shell
gcloud compute start-iap-tunnel emes-workstation-abcd 443 --local-host-port=localhost:8443 --project=my-google-project --zone=us-west1-b
```

```text
Testing if tunnel connection works.
Listening on port [8443].
```

<!-- TODO @memes - add screenshots -->

### HTTPS Forward-Proxy

```shell
gcloud compute start-iap-tunnel emes-workstation-abcd 8888 --local-host-port=localhost:8888 --project=my-google-project --zone=us-west1-b
```

Configure proxy in browser localhost:8888

Connect to GCP resources using their DNS name or IP address

### SSH

```shell
gcloud compute ssh emes-workstation-abcd --tunnel-through-iap --project=my-google-project --zone=us-west1-b
```
