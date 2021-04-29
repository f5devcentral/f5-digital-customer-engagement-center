# frozen_string_literal: true

require 'json'

control 'workstation_iap' do
  title 'Verify IAP access to workstation VM'

  connection_helpers_json = input('output_connection_helpers', value: '{}')

  connection_helpers = JSON.parse(connection_helpers_json)
  describe connection_helpers do
    it { should_not be_nil }
    it { should_not be_empty }
    its(['code_server_tunnel']) { should match(/^gcloud compute start-iap-tunnel/) }
    its(['proxy_tunnel']) { should match(/^gcloud compute start-iap-tunnel/) }
    its(['ssh']) { should match(/^gcloud compute ssh/) }
  end
end
