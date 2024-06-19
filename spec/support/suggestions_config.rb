# frozen_string_literal: true

RSpec.shared_context 'suggestions config' do
  let(:suggestions_config) { 'spec/fixtures/suggestions_config.yml' }
  let(:dot_suggestions_config) { '.pronto.yml' }

  before { FileUtils.mv(suggestions_config, dot_suggestions_config) }
  after { FileUtils.mv(dot_suggestions_config, suggestions_config) }
end
