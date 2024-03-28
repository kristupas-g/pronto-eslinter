# frozen_string_literal: true

require 'pronto'
require 'pronto/eslinter/eslint'
require 'pronto/eslinter/suggestions'

module Pronto
  class Eslinter < Runner
    def run
      return [] unless @patches

      files = @patches
        .select { |patch| patch.additions.positive? }
        .flat_map { |patch| process_patch(patch) }
    end

    def process_patch(patch)
      file = patch.new_file_full_path.to_s
      return unless patch.new_file_full_path.to_s.match?(/\.js$|\.jsx$|\.ts$|\.tsx$/)

      eslint_output = Pronto::Eslinter::Eslint.new([file]).lint
      suggestions = Pronto::Eslinter::Suggestions.new(eslint_output).suggest

      suggestions.map do |suggestion|
        patch.added_lines.select { |line| line.new_lineno == suggestion[:line] }
          .map { |line| messages(suggestion, line) }
      end
    end

    def messages(suggestion, line)
      path = line.patch.delta.new_file[:path]

      Message.new(path, line, :warning, msg(suggestion), nil, self.class)
    end

    def msg(suggestion)
      return suggestion[:text] unless suggestions? && suggestion[:suggestion]

      "#{suggestion[:text]}\n\n```suggestion\n#{suggestion[:suggestion]}\n```"
    end

    def suggestions?
      return @suggestion unless @suggestion.nil?

      @suggestion ||= eslint_config['suggestions']
    end

    def eslint_config
      @eslint_config ||= Pronto::ConfigFile.new.to_h['eslinter'] || {}
    end
  end
end
