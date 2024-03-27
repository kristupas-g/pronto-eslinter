# frozen_string_literal: true

require 'pronto'
require 'pronto/eslinter/eslint'
require 'pronto/eslinter/suggestions'

module Pronto
  class Eslinter < Runner
    def run
      pp "#{@patches.any?} patches found"

      return [] unless @patches

      files = @patches
        .select { |patch| patch.additions.positive? }
        .flat_map { |patch| patch.new_file_full_path.to_s }

      eslint_output = Pronto::Eslinter::Eslint.new(files).lint
      pp eslint_output
      suggestions = Pronto::Eslinter::Suggestions.new(eslint_output).suggest
      pp suggestions

      messages(suggestions)
    end

    def messages(linted_files)
      messages = []
      linted_files.map do |linted_file|
        messages += LintedFile.new(linted_file).violations.map do |violation|
          Message.new(violation.path, violation.line, :warning, violation.text, nil, self.class)
        end
      end
      messages
    end
  end
end
