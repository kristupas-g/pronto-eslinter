# frozen_string_literal: true

require 'pronto'
require 'rspec/its'
require 'pronto/eslinter'

RSpec.shared_context 'test repo' do
  let(:git) { 'spec/fixtures/test.git/git' }
  let(:dot_git) { 'spec/fixtures/test.git/.git' }

  before { FileUtils.mv(git, dot_git) }
  let(:repo) { Pronto::Git::Repository.new('spec/fixtures/test.git') }
  after { FileUtils.mv(dot_git, git) }
end

RSpec.shared_context 'eslintrc' do
  let(:eslintrc) { 'spec/fixtures/eslint.config.js' }
  let(:dot_eslintrc) { 'eslint.config.js' }

  before { FileUtils.mv(eslintrc, dot_eslintrc) }
  after { FileUtils.mv(dot_eslintrc, eslintrc) }
end

RSpec.shared_context 'eslintrc error' do
  let(:eslintrc) { 'spec/fixtures/eslint.config.js.bad' }
  let(:dot_eslintrc) { 'eslint.config.js' }

  before { FileUtils.mv(eslintrc, dot_eslintrc) }
  after { FileUtils.mv(dot_eslintrc, eslintrc) }
end

RSpec.shared_context 'suggestions config' do
  let(:suggestions_config) { 'spec/fixtures/suggestions_config.yml' }
  let(:dot_suggestions_config) { '.pronto.yml' }

  before { FileUtils.mv(suggestions_config, dot_suggestions_config) }
  after { FileUtils.mv(dot_suggestions_config, suggestions_config) }
end

RSpec.shared_context 'command config' do
  let(:command_config) { 'spec/fixtures/command_config.yml' }
  let(:dot_command_config) { '.pronto.yml' }

  before { FileUtils.mv(command_config, dot_command_config) }
  after { FileUtils.mv(dot_command_config, command_config) }
end

RSpec.shared_context 'esbuild pre config deprecation' do
  let(:fixture_path) { 'spec/fixtures/' }
  let(:package_json) { 'spec/fixtures/package_dot_config.json' }
  let(:yarn_lock) { 'spec/fixtures/yarn_dot_config.lock' }
  let(:package_json_latest) { 'package.json' }
  let(:yarn_lock_latest) { 'yarn.lock' }

  let(:dotrc_config) { 'spec/fixtures/.eslintrc.yml' }
  let(:dotrc) { '.eslintrc.yml' }

  before(:all) do
    FileUtils.mv('spec/fixtures/.eslintrc.yml', '.eslintrc.yml')
    `yarn remove eslint 2>&1 > /dev/null`
    `yarn add eslint@8.57.0 eslint-config-airbnb-base eslint-plugin-import 2>&1 > /dev/null`
  end
  after(:all) do
    FileUtils.mv('.eslintrc.yml', 'spec/fixtures/.eslintrc.yml')
    `yarn remove eslint@8.57.0 2>&1 > /dev/null`
    `yarn remove eslint-config-airbnb-base 2>&1 > /dev/null`
    `yarn remove eslint-plugin-import 2>&1 > /dev/null`
    `yarn add eslint@latest 2>&1 > /dev/null`
  end
end

RSpec.configure do |config|
  config.filter_run focus: true
  config.order = 'random'
  config.run_all_when_everything_filtered = true
end
