# frozen_string_literal: true

module Pronto
  class Eslinter < Runner
    class Suggestions
      def initialize(data)
        @data = data
      end

      def suggest
        suggestions = []

        @data.each do |entry|
          original_source = entry.fetch(:source, '')
          original_lines = original_source.lines

          entry[:messages].each do |message|
            next unless message[:fix] || message[:line] != message[:endLine]

            fix = message[:fix]
            line_num = message[:line]
            line_fix_suggestion = apply_fix_to_line(original_lines[line_num - 1], fix, original_lines, line_num)
            next if line_fix_suggestion.nil?

            suggestions << {
              path: entry[:filePath], ## This is full path, what should we do with that? we need relative path to the project....
              text: message[:message],
              level: message[:severity],
              line: line_num,
              end_line: message[:endLine],
              original: original_lines[line_num - 1].chomp, ## just for debug
              suggestion: line_fix_suggestion.chomp
            }
          end
        end

        suggestions
      end

      def apply_fix_to_line(original_line, fix, original_lines, line_num)
        line_start_in_source = original_lines[0...line_num - 1].join.length
        range_start, range_end = fix[:range]
        adjusted_start = range_start - line_start_in_source
        adjusted_end = range_end - line_start_in_source

        fixed_line = original_line.dup
        fixed_line[adjusted_start...adjusted_end] = fix[:text]

        return nil if fixed_line.match?(/\n/)

        fixed_line
      end
    end
  end
end
