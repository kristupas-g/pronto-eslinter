# frozen_string_literal: true

RSpec.shared_context 'eslint pre config deprecation' do
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
