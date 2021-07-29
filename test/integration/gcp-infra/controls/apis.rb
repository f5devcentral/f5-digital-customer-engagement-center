# frozen_string_literal: true

control 'apis' do
  title 'Verify GCP services'

  project_id = input('output_gcpProjectId')
  features = input('output_features', value: {})
  isolated_flag = features.fetch(:isolated, false).to_s.downcase == 'true'
  registry_flag = features.fetch(:registry, false).to_s.downcase == 'true'

  expected_apis = %w[compute.googleapis.com
                     iam.googleapis.com
                     iap.googleapis.com
                     storage-api.googleapis.com
                     secretmanager.googleapis.com
                     cloudresourcemanager.googleapis.com]
  expected_apis.concat(%w[dns.googleapis.com]) if isolated_flag
  expected_apis.concat(%w[artifactregistry.googleapis.com containerscanning.googleapis.com]) if registry_flag
  expected_apis.uniq do |name|
    describe google_project_service(project: project_id, name: name) do
      it { should exist }
      its('state') { should cmp 'ENABLED' }
    end
  end
end
