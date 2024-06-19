# frozen_string_literal: true

RSpec.shared_context 'file filter config' do
  let(:file_filter_config) { 'spec/fixtures/file_filter_config.yml' }
  let(:dot_file_filter_config) { '.pronto.yml' }

  before { FileUtils.mv(file_filter_config, dot_file_filter_config) }
  after { FileUtils.mv(dot_file_filter_config, file_filter_config) }
end
