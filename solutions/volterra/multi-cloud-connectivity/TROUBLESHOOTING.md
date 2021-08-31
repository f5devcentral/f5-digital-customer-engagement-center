# Troubleshooting Multi-cloud deployment

<!-- spell-checker: ignore volterra markdownlint nating vnet -->

### Terraform Errors
- This is common with so many objects being created across various API endpoints.
- Are the errors coming from your Terraform shell? Or are they coming from the Volterra "tf param apply" Terraform job?
   - Fix = Re-run terraform again by running the setup.sh or "terraform apply" again
   - Fix = Run it again, then run it again. Work your errors down to just 1 or 2 errors
   - Based on final errors in Terraform shell, now troubleshoot relevant parts (aka Volterra site, bad credentials, etc)

### Google Credentials Error - 403 error
- Terraform must have Google credentials to pass "terraform plan" even if you are opt NOT to deploy google via commenting cloud credentials. Terraform will still read the module code, and if you do not have your vscode/terminal/ssh session ENV variables saved for Google credentials, then you will receive 403.
   - Fix = follow pre-reqs and create service account
   - Alternatives = comment entire module code for Google

### Azure Credentials Error - 403 error
- Terraform must have Azure credentials to pass "terraform plan" even if you are opt NOT to deploy google via commenting cloud credentials. Terraform will still read the module code, and if you do not have your vscode/terminal/ssh session using Azure credentials, then you will receive 403.
   - Fix = follow pre-reqs and create service principal
   - Alternatives = comment entire module code for Azure

### Terraform Errors During Volterra VPC/VNET Site Create - Client Header Timeout
- This is an API timeout issue between client and VoltConsole. Most likely the site creation failed and/or Terraform will not have correct TF state for the object.
   - Fix = manual go to VoltConsole GUI, find offending site, delete. Re-run "terraform apply"

### HTTP LB - 503 error
- You will notice that the Volterra HTTP LB will some times respond with a 503 service unavailable. During this time, other sites may work successfully. Also, the backend origin pool is fine. A ticket has been open with Volterra.
   - Ticket status = submitted 8/18
   - Fix = delete HTTP LB and origin pool via VoltConsole GUU. Then re-run "terraform apply"

### DNS Name Resolution Not Working
- The deployment may take time to properly register the domain "shared.acme.com" and create necessary records. As a result, there might be some delay after initial deployment of demo. Usually however, DNS starts resolving instantly.
- AWS Route53 seems to initially resolve slower than Azure and Google.
   - Troubleshooting - access jumphost, try to dig/nslookup endpoints, try to access Volterra node inside IP, see if site is working via direct curl to Volterra with Host Headers
```bash
curl <volterra-sli-IP> -H "Host: bu1app.shared.acme.com"
```

## Error: deleting Subnet - happens during a "terraform destroy"
- When you destroy an cloud environment, some times the dependent cloud objects like NICs and other items need to be removed first. In this case, Volterra site is still pending deletion but the cloud is trying to delete the subnet. You will see an error similar to below.
   - Fix = Re-run terraform again by running the destroy script that recently failed

```
Error: deleting Subnet: (Name "external" / Virtual Network Name "demo-mcn-vnet-bu13-92e2" / Resource Group "demo-mcn-rg-bu13-92e2"): network.SubnetsClient#Delete: Failure sending request: StatusCode=0 -- Original Error: Code="InUseSubnetCannotBeDeleted" Message="Subnet external is in use by /subscriptions/xxxx/resourceGroups/demo-mcn-bu13-volterra-92e2/providers/Microsoft.Network/loadBalancers/xxxx/frontendIPConfigurations/loadbalancer-frontend-slo-ip and cannot be deleted. In order to delete the subnet, delete all the resources within the subnet. See aka.ms/deletesubnet." Details=[]
```

## Error when reading or editing Subnetwork: googleapi
- When you destroy an cloud environment, some times the dependent cloud objects like NICs and other items need to be removed first. In this case, Volterra site is still pending deletion but the cloud is trying to delete the subnet. You will see an error similar to below.
   - Fix = Re-run terraform again by running the destroy script that recently failed

## Error: Error waiting for Deleting Network: The network resource 'projects/xxx/xxx
- When you destroy an cloud environment, some times the dependent cloud objects like NICs and other items need to be removed first. In this case, Volterra site is still pending deletion but the cloud is trying to delete the subnet. You will see an error similar to below.
   - Fix = Re-run terraform again by running the destroy script that recently failed
