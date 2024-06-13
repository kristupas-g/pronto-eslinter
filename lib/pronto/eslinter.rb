# frozen_string_literal: true

require 'pronto'
require 'pronto/eslinter/eslint'
require 'pronto/eslinter/output'
require 'pronto/eslinter/offense'
require 'pronto/eslinter/suggestion'

module Pronto
  class Eslinter < Runner
    def run
      return [] unless @patches

      @patches
        .select { |patch| patch.additions.positive? }
        .flat_map { |patch| process_patch(patch) }
        .compact
    end

    def process_patch(patch)
      file = patch.new_file_full_path.to_s
      return unless patch.new_file_full_path.to_s.match?(/\.js$|\.jsx$|\.ts$|\.tsx$/)

      Pronto::Eslinter::Eslint.new([file], patch, self).lint.messages
    end

    def eslint_config
      @eslint_config ||= Pronto::ConfigFile.new.to_h['eslinter'] || {}
    end
  end
end
