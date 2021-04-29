# frozen_string_literal: true

control 'routes' do
  title 'Verify GCP VPC routes'

  project_id = input('output_gcpProjectId')
  prefix = input('output_projectPrefix')
  build_suffix = input('output_buildSuffix')
  vpcs = input('output_vpcs').select do |k, _v|
    %i[mgmt private public].include?(k)
  end
  features = input('output_features', value: {})
  isolated_flag = features.fetch(:isolated, false).to_s.downcase == 'true'

  only_if('fixture sets isolated option') do
    isolated_flag
  end

  vpcs.each do |name, self_link|
    describe google_compute_route(project: project_id, name: "#{prefix}-#{name}-restricted-api-#{build_suffix}") do
      it { should exist }
      its('network') { should cmp self_link }
      its('dest_range') { should cmp '199.36.153.4/30' }
      its('next_hop_gateway') { should match(%r{projects/#{project_id}/global/gateways/default-internet-gateway$}) }
    end
  end
end
