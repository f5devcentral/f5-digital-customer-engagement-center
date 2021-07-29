# frozen_string_literal: true

EXPECTED_VPC_NAMES = %i[main mgmt private public].sort.freeze

# rubocop:disable Metrics/BlockLength
control 'vpcs' do
  title 'Verify GCP VPC networks'

  project_id = input('output_gcpProjectId')
  prefix = input('output_projectPrefix')
  build_suffix = input('output_buildSuffix')
  vpcs = input('output_vpcs').select do |k, _v|
    %i[main mgmt private public].include?(k)
  end
  vpc_options = input('output_vpc_options', value: {})
  expected_main_equiv = input('output_expected_main_equiv', value: 'mgmt').to_sym

  vpcs.each_key do |vpc|
    describe vpc do
      it { should be_in EXPECTED_VPC_NAMES }
    end
  end

  describe vpcs[:main] do
    it { should cmp vpcs[expected_main_equiv] }
  end

  # NOTE: 'main' VPC is alias of another VPC; exclude 'main'
  vpcs.reject { |k, _v| k == :main }.each do |name, self_link|
    params = self_link.match(%r{/projects/(?<project>[^/]+)/global/networks/(?<name>.+)$}).named_captures
    describe params do
      it { should_not be_nil }
      it { should_not be_empty }
      its(['project']) { should cmp project_id }
      its(['name']) { should match(/^#{prefix}-#{name}-vpc-#{build_suffix}$/) }
    end
    describe google_compute_network(project: params['project'], name: params['name']) do
      it { should exist }
      its('description') { should_not be_empty }
      its('mtu') { should cmp vpc_options.fetch(name, {}).fetch(:mtu, 1460) }
      its('routing_config.routing_mode') { should cmp 'REGIONAL' }
    end
  end
end
# rubocop:enable Metrics/BlockLength
