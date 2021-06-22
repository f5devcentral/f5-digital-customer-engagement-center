Above are the common deployment examples( 1, 2, 3, 4.....) and we can extend to N-nic deployments based on user provided subnet_ids and securitygroup_ids.

With module count, user can deploy multiple bigip instances in the aws cloud (with the default value of count being one )

#### BIG-IP Automation Toolchain InSpec Profile for testing readiness of Automation Tool Chain components 

After the module deployment, we can use inspec tool for verifying the Bigip connectivity along with ATC components

This InSpec profile evaluates the following:

* Basic connectivity to a BIG-IP management endpoint ('bigip-connectivity')
* Availability of the Declarative Onboarding (DO) service ('bigip-declarative-onboarding')
* Version reported by the Declarative Onboarding (DO) service ('bigip-declarative-onboarding-version')
* Availability of the Application Services (AS3) service ('bigip-application-services')
* Version reported by the Application Services (AS3) service ('bigip-application-services-version')
* Availability of the Telemetry Streaming (TS) service ('bigip-telemetry-streaming')
* Version reported by the Telemetry Streaming (TS) service ('bigip-telemetry-streaming-version')
* Availability of the Cloud Failover Extension( CFE ) service ('bigip-cloud-failover-extension')
* Version reported by the Cloud Failover Extension( CFE ) service('bigip-cloud-failover-extension-version')

#### run inspec tests

we can either run inspec exec command or execute runtests.sh in any one of example nic folder which will run below inspec command ( with the inspec profile located in inspec/bigip-ready/controls/files/ )

inspec exec inspec/bigip-ready  --input bigip_address=$BIGIP_MGMT_IP bigip_port=$BIGIP_MGMT_PORT user=$BIGIP_USER password=$BIGIP_PASSWORD do_version=$DO_VERSION as3_version=$AS3_VERSION ts_version=$TS_VERSION fast_version=$FAST_VERSION cfe_version=$CFE_VERSION

The profile requires a set of inputs which can be provided on the command line or with an input file. We listed the necessary inputs below in a sample YAML input file

* bigip_address: FQDN or ip address of the BIG-IP to test
* bigip_port: the port for the BIG-IP management service, commonly 443
* user: the user account with which to authenticate to the BIG-IP
* password: the password to use to authenticate to the BIG-IP
* do_version: the expected version of declarative onboarding
* as3_version: the expected version of application services
* ts_version: the expected version of telemetry streaming
* cfe_version: the expected version of cloud failover extension