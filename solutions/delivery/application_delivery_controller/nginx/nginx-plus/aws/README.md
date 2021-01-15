# nginx-plus
  - network type aws min
  - ansible false
  - ubuntu virtual machine nginx-plus

# demo setups

## login

option one:
- Set AWS environment variables
```bash
export AWS_ACCESS_KEY_ID="dfsafsa"
export AWS_SECRET_ACCESS_KEY="fdsafds"
export AWS_SESSION_TOKEN="kgnfdskg"
```

## setup
```bash
cp admin.auto.tfvars.example admin.auto.tfvars
# MODIFY TO YOUR SETTINGS
. setup.sh
```

## run lab steps
```
< lab steps here>
```

# cleanup
```bash
. cleanup.sh
```
