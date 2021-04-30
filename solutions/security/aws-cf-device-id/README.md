# Description
WebApp in AWS, protected by AWS WAF and F5 device-id. fronted by cloudfront. 
Analytics in a managed elasticsearch 

## Diagram

## Requirements

- AWS account, access and secret key

## Usage example

- Clone the repo and open the solution's directory
```bash
git clone https://github.com/f5devcentral/f5-digital-customer-engagement-center
cd f5-digital-customer-engagement-center/solutions/security/aws-cf-device-id
```

- Set AWS environment variables
```bash
export AWS_ACCESS_KEY_ID="your_key"
export AWS_SECRET_ACCESS_KEY="your_secret_key"
```

create the vars file and update it with your settings

```bash
cp admin.auto.tfvars.example admin.auto.tfvars
# MODIFY TO YOUR SETTINGS
vi admin.auto.tfvars
```

run the setup script to deploy all of the components into your AWS account (remember that you are responsible for the cost of those components)

```bash
./setup.sh
```


## TEST your setup:

v

![Request log](request_log.png)

## Cleanup
use the following command to destroy all of the resources

```bash
./destroy.sh
```


## How to Contribute

Submit a pull request

# Authors
Yossi rosenboim
