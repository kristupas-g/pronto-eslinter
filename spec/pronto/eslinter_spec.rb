# frozen_string_literal: true

require 'spec_helper'

module Pronto
  describe Eslinter do
    let(:eslint) { Eslinter.new(patches) }

    describe '#run' do
      subject(:run) { eslint.run }

      context 'when patches are nil' do
        let(:patches) { nil }

        it { should == [] }
      end

      context 'without patches' do
        let(:patches) { [] }

        it { should == [] }
      end

      context 'with an invalid .eslintrc config' do
        include_context 'test repo'
        include_context 'eslintrc error'

        let(:patches) { repo.diff('main') }

        its(:count) { should == 1 }
        its(:'first.msg') { should == 'Parsing error: Invalid ecmaVersion.' }
      end

      context 'with patches including warnings' do
        include_context 'test repo'
        include_context 'eslintrc'

        let(:patches) { repo.diff('main') }
        let(:messages) do
          [
            'Expected a function expression. eslint([func-style](https://eslint.org/docs/latest/rules/func-style))',
            "'Hello' is defined but never used. eslint([no-unused-vars](https://eslint.org/docs/latest/rules/no-unused-vars))",
            "'foo' is not defined. eslint([no-undef](https://eslint.org/docs/latest/rules/no-undef))",
            "Expected { after 'if' condition. eslint([curly](https://eslint.org/docs/latest/rules/curly))",
            "Unary operator '++' used. eslint([no-plusplus](https://eslint.org/docs/latest/rules/no-plusplus))",
            "'foo' is not defined. eslint([no-undef](https://eslint.org/docs/latest/rules/no-undef))",
            'Unexpected alert. eslint([no-alert](https://eslint.org/docs/latest/rules/no-alert))',
            "'alert' is not defined. eslint([no-undef](https://eslint.org/docs/latest/rules/no-undef))"
          ]
        end

        its(:count) { should == 8 }
        it { expect(run.map(&:msg)).to match_array(messages) }
      end

      context 'with patches including suggestions' do
        include_context 'test repo'
        include_context 'eslintrc'
        include_context 'suggestions config'

        let(:patches) { repo.diff('main') }
        let(:messages) do
          [
            'Expected a function expression. eslint([func-style](https://eslint.org/docs/latest/rules/func-style))',
            "'Hello' is defined but never used. eslint([no-unused-vars](https://eslint.org/docs/latest/rules/no-unused-vars))",
            "'foo' is not defined. eslint([no-undef](https://eslint.org/docs/latest/rules/no-undef))",
            "Expected { after 'if' condition. eslint([curly](https://eslint.org/docs/latest/rules/curly))\n\n```suggestion\n{foo++;}\n```",
            "Unary operator '++' used. eslint([no-plusplus](https://eslint.org/docs/latest/rules/no-plusplus))",
            "'foo' is not defined. eslint([no-undef](https://eslint.org/docs/latest/rules/no-undef))",
            'Unexpected alert. eslint([no-alert](https://eslint.org/docs/latest/rules/no-alert))',
            "'alert' is not defined. eslint([no-undef](https://eslint.org/docs/latest/rules/no-undef))"
          ]
        end

        its(:count) { should == 8 }
        it { expect(run.map(&:msg)).to match_array(messages) }
      end

      context 'when using a custom command' do
        include_context 'test repo'
        include_context 'eslintrc'
        include_context 'command config'

        let(:patches) { repo.diff('main') }
        let(:messages) do
          [
            'Expected a function expression. eslint([func-style](https://eslint.org/docs/latest/rules/func-style))',
            "'Hello' is defined but never used. eslint([no-unused-vars](https://eslint.org/docs/latest/rules/no-unused-vars))",
            "'foo' is not defined. eslint([no-undef](https://eslint.org/docs/latest/rules/no-undef))",
            "Expected { after 'if' condition. eslint([curly](https://eslint.org/docs/latest/rules/curly))",
            "Unary operator '++' used. eslint([no-plusplus](https://eslint.org/docs/latest/rules/no-plusplus))",
            "'foo' is not defined. eslint([no-undef](https://eslint.org/docs/latest/rules/no-undef))",
            'Unexpected alert. eslint([no-alert](https://eslint.org/docs/latest/rules/no-alert))',
            "'alert' is not defined. eslint([no-undef](https://eslint.org/docs/latest/rules/no-undef))"
          ]
        end

        its(:count) { should == 8 }
        it { expect(run.map(&:msg)).to match_array(messages) }
      end
    end
  end
end
