# frozen_string_literal: true

require 'spec_helper'

module Pronto
  describe Eslinter do
    let(:eslint) { Eslinter.new(patches) }

    describe '#run' do
      subject(:run) { eslint.run }

      let(:eslint_doc_url) { 'https://eslint.org/docs/latest/rules/' }

      include_context 'eslint pre config deprecation'

      context 'when using dot config on a pre-deprecation release of eslint' do
        include_context 'test repo'

        let(:patches) { repo.diff('main') }
        let(:messages) do
          [
            "'Hello' is defined but never used. eslint([no-unused-vars](#{eslint_doc_url}no-unused-vars))",
            "Missing space before opening brace. eslint([space-before-blocks](#{eslint_doc_url}space-before-blocks))",
            "'foo' is not defined. eslint([no-undef](#{eslint_doc_url}no-undef))",
            "Unary operator '++' used. eslint([no-plusplus](#{eslint_doc_url}no-plusplus))",
            "'foo' is not defined. eslint([no-undef](#{eslint_doc_url}no-undef))",
            "Unexpected alert. eslint([no-alert](#{eslint_doc_url}no-alert))"
          ]
        end

        it { expect(run.map(&:msg)).to match_array(messages) }
      end

      context 'when using dot config on a pre-deprecation release of eslint with suggestions' do
        include_context 'test repo'
        include_context 'suggestions config'

        let(:patches) { repo.diff('main') }
        let(:eslint_doc_url) { 'https://eslint.org/docs/latest/rules/' }
        let(:messages) do
          [
            "'Hello' is defined but never used. eslint([no-unused-vars](#{eslint_doc_url}no-unused-vars))",
            "Missing space before opening brace. eslint([space-before-blocks](#{eslint_doc_url}space-before-blocks))" \
            "\n\n```suggestion\nfunction Hello(name) {\n\n```",
            "'foo' is not defined. eslint([no-undef](#{eslint_doc_url}no-undef))",
            "Unary operator '++' used. eslint([no-plusplus](#{eslint_doc_url}no-plusplus))",
            "'foo' is not defined. eslint([no-undef](#{eslint_doc_url}no-undef))",
            "Unexpected alert. eslint([no-alert](#{eslint_doc_url}no-alert))"
          ]
        end

        it { expect(run.map(&:msg)).to match_array(messages) }
      end
    end
  end
end
