# frozen_string_literal: true

EXPECTED_SUBNETS = {
  :main => '10.0.10.0/24',
  :mgmt => '10.0.10.0/24',
  :private => '10.0.20.0/24',
  :public => '10.0.30.0/24'
}.freeze

# rubocop:disable Metrics/BlockLength
control 'subnets' do
  title 'Verify GCP VPC subnets'

  project_id = input('output_gcpProjectId')
  region = input('output_gcpRegion')
  prefix = input('output_projectPrefix')
  build_suffix = input('output_buildSuffix')
  # TODO @memes - why is this control receiving keys as strings when all others
  # get an automatic transform to symbol? Manually applying transform for consistency.
  subnets = input('output_subnets').transform_keys(&:to_sym).select do |k, _v|
    %i[main mgmt private public].include?(k)
  end

  describe(subnets.keys.sort) do
    it { should cmp EXPECTED_SUBNETS.keys.sort }
  end

  describe subnets[:main] do
    it { should cmp subnets[:mgmt] }
  end

  EXPECTED_SUBNETS.reject { |k, _v| k == :main }.each do |name, cidr|
    # rubocop:disable Layout/LineLength
    params = subnets[name].match(%r{/projects/(?<project>[^/]+)/regions/(?<region>[^/]+)/subnetworks/(?<name>.+)$}).named_captures
    # rubocop:enable Layout/LineLength
    describe params do
      it { should_not be_nil }
      it { should_not be_empty }
      its(['project']) { should cmp project_id }
      its(['region']) { should cmp region }
      its(['name']) { should match(/^#{prefix}-#{name}-subnet-#{build_suffix}$/) }
    end
    describe google_compute_subnetwork(project: params['project'], region: params['region'],
                                       name: params['name']) do
      it { should exist }
      its('ip_cidr_range') { should cmp cidr }
      its('private_ip_google_access') { should be false }
    end
  end
end
# rubocop:enable Metrics/BlockLength
