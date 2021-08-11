# frozen_string_literal: true

EXPECTED_SUBNET_DEFAULTS = {
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
  subnets = input('output_subnets').select do |k, _v|
    %i[main mgmt private public].include?(k)
  end
  vpc_options = input('output_vpc_options', value: {})
  expected_main_equiv = input('output_expected_main_equiv', value: 'mgmt').to_sym
  features = input('output_features', value: {})
  isolated_flag = features.fetch(:isolated, false).to_s.downcase == 'true'

  subnets.each_key do |subnet|
    describe subnet do
      it { should be_in EXPECTED_SUBNET_DEFAULTS.keys }
    end
  end

  describe subnets[:main] do
    it { should cmp subnets[expected_main_equiv] }
  end

  subnets.reject { |k, _v| k == :main }.each do |name, self_link|
    # rubocop:disable Layout/LineLength
    params = self_link.match(%r{/projects/(?<project>[^/]+)/regions/(?<region>[^/]+)/subnetworks/(?<name>.+)$}).named_captures
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
      its('ip_cidr_range') do
        should cmp vpc_options.fetch(name, {}).fetch(:primary_cidr, EXPECTED_SUBNET_DEFAULTS[name])
      end
      its('private_ip_google_access') { should be isolated_flag }
    end
  end
end
# rubocop:enable Metrics/BlockLength
