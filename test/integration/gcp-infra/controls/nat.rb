# frozen_string_literal: true

control 'nat' do
  title 'Verify NAT assignments'

  project_id = input('output_gcpProjectId')
  prefix = input('output_projectPrefix')
  build_suffix = input('output_buildSuffix')
  region = input('output_gcpRegion')
  vpcs = input('output_vpcs').select do |k, _v|
    %i[mgmt private public].include?(k)
  end
  vpc_options = input('output_vpc_options', value: {})
  features = input('output_features', value: {})
  isolated_flag = features.fetch(:isolated, false).to_s.downcase == 'true'

  vpcs.each do |name, self_link|
    expect_nat = !isolated_flag && vpc_options.fetch(name, {}).fetch(:nat, false).to_s.downcase == 'true'
    describe google_compute_router(project: project_id, region: region,
                                   name: "#{prefix}-#{name}-router-#{build_suffix}") do
      if expect_nat
        it { should exist }
        its('network') { should cmp self_link }
      else
        it { should_not exist }
      end
    end
  end
end
