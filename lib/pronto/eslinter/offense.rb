# frozen_string_literal: true

require 'English'

module Pronto
  class Eslinter < Runner
    class Offense
      extend Forwardable

      attr_reader(
        :rule_id,
        :severity,
        :offense_message,
        :line,
        :column,
        :node_type,
        :message_id,
        :end_line,
        :end_column,
        :fix,
        :eslint_output
      )

      def_delegators :eslint_output, :eslint_config, :file_path, :patch

      def initialize(offense, eslint_output)
        map_offense(offense)
        @eslint_output = eslint_output
      end

      def message
        Message.new(file_path, patch_line, level, message_text, nil, Pronto::Eslinter)
      end

      private

      def map_offense(offense)
        @rule_id = offense[:ruleId]
        @severity = offense[:severity]
        @offense_message = offense[:message]
        @line = offense[:line]
        @column = offense[:column]
        @node_type = offense[:nodeType]
        @message_id = offense[:messageId]
        @end_line = offense[:endLine]
        @end_column = offense[:endColumn]
        @fix = offense[:fix]
      end

      def message_text
        "#{offense_message}#{rule}#{suggestion_text}"
      end

      def rule
        return if rule_id.nil?

        " eslint([#{rule_id}](https://eslint.org/docs/latest/rules/#{rule_id}))"
      end

      def suggestion_text
        Suggestion.new(self).suggest
      end

      def patch_line
        @patch_line ||= patch.added_lines.find { |l| l.new_lineno == line }
      end

      def level
        case severity
        when 1 then :warning
        when 2 then :error
        else :info
        end
      end
    end
  end
end
