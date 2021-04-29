# frozen_string_literal: true

require 'json'

EXPECTED_HELPERS = %w[code_server_tunnel proxy_tunnel ssh].sort.freeze

# rubocop:disable Metrics/BlockLength
control 'workstation' do
  title 'Verify workstation VM properties'

  project_id = input('output_gcpProjectId')
  region = input('output_gcpRegion')
  prefix = input('output_projectPrefix')
  build_suffix = input('output_buildSuffix')
  service_account = input('output_service_account')
  self_link = input('output_self_link')
  resource_owner = input('output_resourceOwner')
  expected_vpc = input('output_vpcs', value: {}).fetch(:main, nil)
  expected_subnet = input('output_subnets', value: {}).fetch(:main, nil)

  describe self_link do
    it { should_not be_nil }
    it { should_not be_empty }
  end

  describe service_account do
    it { should_not be_nil }
    it { should_not be_empty }
    it { should match(/@#{project_id}\.iam\.gserviceaccount\.com$/) }
  end

  describe resource_owner do
    it { should_not be_nil }
    it { should_not be_empty }
  end

  params = self_link.match(%r{/projects/(?<project>[^/]+)/zones/(?<zone>[^/]+)/instances/(?<name>.+)$}).named_captures
  describe params do
    it { should_not be_nil }
    it { should_not be_empty }
    its(['project']) { should cmp project_id }
    its(['zone']) { should match(/^#{region}-[a-f]$/) }
    its(['name']) { should cmp "#{prefix}-wkstn-#{build_suffix}" }
  end

  describe google_compute_instance(project: params['project'], zone: params['zone'], name: params['name']) do
    it { should exist }
    its('status') { should cmp 'RUNNING' }
    its('can_ip_forward') { should cmp false }
    its('network_interfaces_count') { should be 1 }
    its('network_interfaces.first.access_configs') { should be_nil or be_empty }
    its('network_interfaces.first.alias_ip_ranges') { should be_nil or be_empty }
    # Workstation example doesn't output VPC details; don't verify network/subnet
    if expected_vpc && expected_vpc != 'undefined'
      its('network_interfaces.first.network') { should cmp expected_vpc }
      its('network_interfaces.first.subnetwork') { should cmp expected_subnet }
    end
    its('service_accounts.first.email') { should cmp service_account }
    its('service_accounts.first.scopes') { should cmp ['https://www.googleapis.com/auth/cloud-platform'] }
  end
  describe google_compute_instance(project: params['project'], zone: params['zone'],
                                   name: params['name']).metadata_value_by_key('enable-oslogin') do
    it { should cmp 'TRUE' }
  end
  describe google_compute_instance(project: params['project'], zone: params['zone'],
                                   name: params['name']).label_value_by_key('owner') do
    it { should cmp resource_owner }
  end
end
# rubocop:enable Metrics/BlockLength
