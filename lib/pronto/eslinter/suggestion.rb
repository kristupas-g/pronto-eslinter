# frozen_string_literal: true

module Pronto
  class Eslinter < Runner
    class Suggestion
      extend Forwardable

      attr_reader :offense

      def_delegators :offense, :eslint_config, :eslint_output, :line, :fix, :column, :end_line, :end_column
      def_delegators :eslint_output, :source

      def initialize(offense)
        @offense = offense
      end

      def suggest
        return unless enabled? && suggestable?

        "\n\n```suggestion\n#{fixed_line}#{new_line_maybe}```"
      end

      private

      def suggestable?
        enabled? && !fix.nil?
      end

      def original_lines
        (source || '').lines("\n")
      end

      def original_line
        original_lines[line - 1]
      end

      def line_start_in_source
        original_lines[0...line - 1].join.length
      end

      def fixed_line
        "#{left}#{fix[:text]}#{right}"
      end

      def left
        original_line[0...column - 1]
      end

      def right
        if end_column < column
          original_line[left.size...]
        else
          original_line[end_column - 1...]
        end
      end

      def new_line_maybe
        "\n" unless fixed_line.end_with?("\n")
      end

      def enabled?
        eslint_config['suggestions'] || false
      end
    end
  end
end
