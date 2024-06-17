# frozen_string_literal: true

RSpec.shared_context 'eslint.config.js' do
  let(:eslint_config_js) { 'spec/fixtures/eslint.config.js' }
  let(:dot_eslint_config_js) { 'eslint.config.js' }

  before { FileUtils.mv(eslint_config_js, dot_eslint_config_js) }
  after { FileUtils.mv(dot_eslint_config_js, eslint_config_js) }
end
