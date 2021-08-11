# frozen_string_literal: true

require 'json'

EXPECTED_WORKSTATION_KEYS = %w[connection_helpers self_link service_account tls_certs].sort.freeze

# rubocop:disable Metrics/BlockLength
control 'workstation' do
  title 'Verify workstation VM properties'

  project_id = input('output_gcpProjectId')
  region = input('output_gcpRegion')
  prefix = input('output_projectPrefix')
  build_suffix = input('output_buildSuffix')
  resource_owner = input('output_resourceOwner')
  workstation_json = input('output_workstation', value: '{}')
  expected_vpc = input('output_vpcs').fetch(:main)
  expected_subnet = input('output_subnets').fetch(:main)
  features = input('output_features', value: {})
  workstation_flag = features.fetch(:workstation, false).to_s.downcase == 'true'

  describe resource_owner do
    it { should_not be_nil }
    it { should_not be_empty }
  end

  if workstation_flag
    workstation_outputs = JSON.parse(workstation_json)
    describe workstation_outputs['self_link'] do
      it { should_not be_nil }
      it { should_not be_empty }
    end
    describe workstation_outputs['service_account'] do
      it { should_not be_nil }
      it { should_not be_empty }
      it { should match(/@#{project_id}\.iam\.gserviceaccount\.com$/) }
    end

    # rubocop:disable Metrics/LineLength
    params = workstation_outputs['self_link'].match(%r{/projects/(?<project>[^/]+)/zones/(?<zone>[^/]+)/instances/(?<name>.+)$}).named_captures
    # rubocop:enable Metrics/LineLength
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
      its('network_interfaces.first.network') { should cmp expected_vpc }
      its('network_interfaces.first.subnetwork') { should cmp expected_subnet }
      its('service_accounts.first.email') { should cmp workstation_outputs['service_account'] }
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
  else
    describe workstation_outputs do
      it { should be_nil.or be_empty }
    end
  end
end
# rubocop:enable Metrics/BlockLength
