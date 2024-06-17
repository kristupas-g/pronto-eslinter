# frozen_string_literal: true

RSpec.shared_context 'command config' do
  let(:command_config) { 'spec/fixtures/command_config.yml' }
  let(:dot_command_config) { '.pronto.yml' }

  before { FileUtils.mv(command_config, dot_command_config) }
  after { FileUtils.mv(dot_command_config, command_config) }
end
