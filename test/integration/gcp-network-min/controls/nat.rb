# frozen_string_literal: true

control 'nat' do
  title 'Verify NAT is in-place'

  project_id = input('output_gcpProjectId')
  prefix = input('output_projectPrefix')
  build_suffix = input('output_buildSuffix')
  region = input('output_gcpRegion')
  mgmt_vpc = input('output_vpcs')['mgmt']

  describe mgmt_vpc do
    it { should_not be_nil }
    it { should_not be_empty }
  end

  describe google_compute_router(project: project_id, region: region, name: "#{prefix}-mgmt-router-#{build_suffix}") do
    it { should exist }
    its('network') { should cmp mgmt_vpc }
  end
end
