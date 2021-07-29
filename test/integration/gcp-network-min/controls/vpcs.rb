# frozen_string_literal: true

require 'inspec'

EXPECTED_VPC_NAMES = %w[main mgmt private public].sort.freeze

# rubocop:disable Metrics/BlockLength
control 'vpcs' do
  title 'Verify GCP VPC networks'

  project_id = input('output_gcpProjectId')
  prefix = input('output_projectPrefix')
  build_suffix = input('output_buildSuffix')
  vpcs = input('output_vpcs').select do |k, _v|
    %w[main mgmt private public].include?(k)
  end

  describe(vpcs.keys.sort) do
    it { should cmp EXPECTED_VPC_NAMES }
  end

  # Main is an alias for the mgmt VPC network
  describe vpcs['main'] do
    it { should cmp vpcs['mgmt'] }
  end

  # NOTE: 'main' VPC is alias of 'mgmt', so name based tests will fail; exclude 'main'
  EXPECTED_VPC_NAMES.reject { |name| name == 'main' }.each do |name|
    params = vpcs[name].match(%r{/projects/(?<project>[^/]+)/global/networks/(?<name>.+)$}).named_captures
    describe params do
      it { should_not be_nil }
      it { should_not be_empty }
      its(['project']) { should cmp project_id }
      its(['name']) { should match(/^#{prefix}-#{name}-vpc-#{build_suffix}$/) }
    end
    describe google_compute_network(project: params['project'], name: params['name']) do
      it { should exist }
      its('description') { should_not be_empty }
      its('mtu') { should be 1460 }
      its('routing_config.routing_mode') { should cmp 'REGIONAL' }
    end
  end
end
# rubocop:enable Metrics/BlockLength
