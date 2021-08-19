# Troubleshooting Multi-cloud deployment

<!-- spell-checker: ignore volterra markdownlint nating vnet -->

### Terraform Errors
- This is common with so many objects being created across various API endpoints.
- Are the errors coming from your Terraform shell? Or are they coming from the Volterra "tf param apply" Terraform job?
   - Fix = Re-run terraform again by running the setup.sh or "terraform apply" again
   - Fix = Run it again, then run it again. Work your errors down to just 1 or 2 errors
   - Based on final errors in Terraform shell, now troubleshoot relevant parts (aka Volterra site, bad credentials, etc)

### Google Credentials Error - 403 error
- Terraform must have google credentials to pass "terraform plan" even if you are opt NOT to deploy google via commenting cloud credentials. Terraform will still read the module code, and if you do not have your vscode/terminal/ssh session ENV variables saved for Google credentials, then you will receive 403.
   - Fix = follow pre-reqs and create service account
   - Alternatives = comment entire module code for Google

### Azure Credentials Error - 403 error
- Terraform must have google credentials to pass "terraform plan" even if you are opt NOT to deploy google via commenting cloud credentials. Terraform will still read the module code, and if you do not have your vscode/terminal/ssh session using Azure credentials, then you will receive 403.
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