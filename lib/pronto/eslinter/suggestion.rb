# frozen_string_literal: true

module Pronto
  class Eslinter < Runner
    class Suggestion
      extend Forwardable

      attr_reader :offense

      def_delegators :offense, :eslint_config, :eslint_output, :line, :fix
      def_delegators :eslint_output, :source

      def initialize(offense)
        @offense = offense
      end

      def suggest
        return unless enabled? && suggestable?

        "\n\n```suggestion\n#{fixed_line}\n```"
      end

      private

      def suggestable?
        enabled? && !fix.nil?
      end

      def original_lines
        (source || '').lines
      end

      def original_line
        original_lines[line - 1]
      end

      def line_start_in_source
        original_lines[0...line - 1].join.length
      end

      def fixed_line
        range_start, range_end = fix[:range]
        adjusted_start = range_start - line_start_in_source
        adjusted_end = range_end - line_start_in_source

        original_line.dup[adjusted_start...adjusted_end] = fix[:text]
      end

      def enabled?
        eslint_config['suggestions'] || false
      end
    end
  end
end
