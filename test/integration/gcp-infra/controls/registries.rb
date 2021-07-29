# frozen_string_literal: true

control 'registries' do
  title 'Verify GCP project registries'

  project_id = input('output_gcpProjectId')
  region = input('output_gcpRegion')
  prefix = input('output_projectPrefix')
  build_suffix = input('output_buildSuffix')
  registries_json = input('output_registries', value: '{}')
  features = input('output_features', value: {})
  registry_flag = features.fetch(:registry, false).to_s.downcase == 'true'

  only_if('fixture sets registry option') do
    registry_flag
  end

  expected_registries = {
    'container' => {
      'repo' => "#{region}-docker.pkg.dev/#{project_id}",
      'id' => "projects/#{project_id}/locations/#{region}/repositories/#{prefix}-container-#{build_suffix}"
    }
  }.freeze

  registries = JSON.parse(registries_json)
  describe registries do
    it { should_not be_nil }
    it { should_not be_empty }
    it { should cmp expected_registries }
  end
end
