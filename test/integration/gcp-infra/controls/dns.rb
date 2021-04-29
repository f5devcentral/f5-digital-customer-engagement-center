# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
control 'dns' do
  title 'Verify DNS is configured for restricted access'

  project_id = input('output_gcpProjectId')
  prefix = input('output_projectPrefix')
  build_suffix = input('output_buildSuffix')
  resource_owner = input('output_resourceOwner')
  vpcs = input('output_vpcs').select do |k, _v|
    %i[mgmt private public].include?(k)
  end
  features = input('output_features', value: {})
  isolated_flag = features.fetch(:isolated, false).to_s.downcase == 'true'

  only_if('fixture sets isolated option') do
    isolated_flag
  end

  describe google_dns_managed_zone(project: project_id, zone: "#{prefix}-restricted-googleapis-#{build_suffix}") do
    it { should exist }
    its('dns_name') { should cmp 'googleapis.com.' }
    its('visibility') { should cmp 'private' }
  end

  describe google_dns_managed_zone(project: project_id,
                                   zone: "#{prefix}-restricted-googleapis-#{build_suffix}").labels do
    it { should_not be_nil }
    it { should_not be_empty }
    its(['owner']) { should cmp resource_owner }
    its(['purpose']) { should cmp 'private-google-api-access' }
  end

  # rubocop:disable Layout/LineLength
  describe google_dns_managed_zone(project: project_id,
                                   zone: "#{prefix}-restricted-googleapis-#{build_suffix}").private_visibility_config.networks.map(&:network_url).sort do
    it { should cmp vpcs.values.sort }
  end
  # rubocop:enable Layout/LineLength

  describe google_dns_managed_zone(project: project_id, zone: "#{prefix}-restricted-gcr-#{build_suffix}") do
    it { should exist }
    its('dns_name') { should cmp 'gcr.io.' }
    its('visibility') { should cmp 'private' }
  end

  describe google_dns_managed_zone(project: project_id, zone: "#{prefix}-restricted-gcr-#{build_suffix}").labels do
    it { should_not be_nil }
    it { should_not be_empty }
    its(['owner']) { should cmp resource_owner }
    its(['purpose']) { should cmp 'private-google-api-access' }
  end

  # rubocop:disable Layout/LineLength
  describe google_dns_managed_zone(project: project_id,
                                   zone: "#{prefix}-restricted-gcr-#{build_suffix}").private_visibility_config.networks.map(&:network_url).sort do
    it { should cmp vpcs.values.sort }
  end
  # rubocop:enable Layout/LineLength

  describe google_dns_managed_zone(project: project_id, zone: "#{prefix}-restricted-artifacts-#{build_suffix}") do
    it { should exist }
    its('dns_name') { should cmp 'pkg.dev.' }
    its('visibility') { should cmp 'private' }
  end

  describe google_dns_managed_zone(project: project_id,
                                   zone: "#{prefix}-restricted-artifacts-#{build_suffix}").labels do
    it { should_not be_nil }
    it { should_not be_empty }
    its(['owner']) { should cmp resource_owner }
    its(['purpose']) { should cmp 'private-google-api-access' }
  end

  # rubocop:disable Layout/LineLength
  describe google_dns_managed_zone(project: project_id,
                                   zone: "#{prefix}-restricted-artifacts-#{build_suffix}").private_visibility_config.networks.map(&:network_url).sort do
    it { should cmp vpcs.values.sort }
  end
  # rubocop:enable Layout/LineLength
end
# rubocop:enable Metrics/BlockLength
