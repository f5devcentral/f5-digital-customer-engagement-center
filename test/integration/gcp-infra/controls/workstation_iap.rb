# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
control 'workstation_iap' do
  title 'Verify IAP access to workstation VM'

  workstation_json = input('output_workstation', value: '{}')
  features = input('output_features', value: {})
  workstation_flag = features.fetch(:workstation, false).to_s.downcase == 'true'

  only_if('fixture sets workstation option') do
    workstation_flag
  end

  workstation_outputs = JSON.parse(workstation_json)
  describe workstation_outputs do
    it { should_not be_nil }
    it { should_not be_empty }
  end

  connection_helpers = workstation_outputs.fetch('connection_helpers', {})
  describe connection_helpers do
    it { should_not be_nil }
    it { should_not be_empty }
    its(['code_server_tunnel']) { should match(/^gcloud compute start-iap-tunnel/) }
    its(['proxy_tunnel']) { should match(/^gcloud compute start-iap-tunnel/) }
    its(['ssh']) { should match(/^gcloud compute ssh/) }
  end

  tls_certs = workstation_outputs.fetch('tls_certs', {})
  describe tls_certs do
    it { should_not be_nil }
    it { should_not be_empty }
    its(['ca_cert']) { should_not be_nil }
    its(['ca_cert']) { should_not be_empty }
    its(['tls_cert']) { should_not be_nil }
    its(['tls_cert']) { should_not be_empty }
  end
end
# rubocop:enable Metrics/BlockLength
