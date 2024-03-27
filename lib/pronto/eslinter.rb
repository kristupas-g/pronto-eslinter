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
        .flat_map { |patch| patch.new_file_full_path.to_s}
        .select{ |file| file[/\.js$|\.jsx$|\.ts$|\.tsx$/] }

      return [] unless files
      eslint_output = Pronto::Eslinter::Eslint.new(files).lint
      suggestions = Pronto::Eslinter::Suggestions.new(eslint_output).suggest

      messages(suggestions)
    end

    def messages(suggestions)
      messages = []
      suggestions.map do |suggestion|
        Message.new(suggestion[:path], suggestion[:line], :warning, msg(suggestion), nil, self.class)
      end
      messages
    end

    def msg(suggestion)
      return suggestion[:text] unless suggestions? && suggestion[:suggestions]

      "#{suggestion[:text]}\n\n```suggestion\n#{suggestion[:suggestion]}```"
    end

    def suggestions?
      return @suggestion unless @suggestion.nil?

      @suggestion ||= eslint_config['suggestion']
    end

    def eslint_config
      @eslint_config ||= Pronto::ConfigFile.new.to_h['eslinter'] || {}
    end
  end
end
