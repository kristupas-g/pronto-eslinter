# frozen_string_literal: true

require 'pronto'
require 'pry'

module Pronto
  class Eslinter < Runner
    def run
      return [] unless @patches

      files = @patches
        .select { |patch| patch.additions.positive? }
        .flat_map { |patch| patch.new_file_full_path.to_s }

      eslint_output = Pronto::Eslinter::Eslint.new(files).run
      suggestions = Pronto::Eslinter::Suggestions.new(eslint_output).suggest

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

class Eslint
  def initialize(files)
    @files = files
  end

  def run
    command = "cd client && pnpm eslint #{@files.join(' ')} --ext .js,.ts,.tsx --format json"
    print("\nRunning: #{command}\n")
    output = `#{command}`
    lines = output.split('\n')
    json = []
    add = false
    lines.each do |line|
      if line.start_with?('[') || add
        add = true
        json.append(line)
      end
    end
    json = json.join('\n')
    JSON.parse(json, symbolize_names: true)
  end

end

class LintedFile
  def initialize(lint_hash)
    @file = lint_hash[:filePath]
    @messages = lint_hash[:messages]
    @file_content = lint_hash[:source]
  end

  def violations
    @messages.map do |message|
      {
        path: @file,
        text: message[:message],
        level: message[:severity],
        line: message[:line],
        suggestions: handle_suggestions(message[:fix], message[:line]),
      }
    end
  end

  private

  def handle_suggestions(fixes, line_no)
    return if fixes.nil?

    puts fixes
    fixes.map do |fix|
      line = get_line(line_no)
      puts fix.class
      range = fix[:range]
      fixed_range = fix[:text]
      line[range[0]..range[1]] = fixed_range
      line
    end
  end

  def get_line(line_number)
    @file_content.split('\n')[line_number]
  end
end

to_lint = [
  'app/types/ui.ts',
  'app/types/utils.ts'
]

linted_files = Eslint.new(to_lint).run

linted_files.map do |linted_file|
  LintedFile.new(linted_file).violations
end
