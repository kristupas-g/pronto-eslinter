# frozen_string_literal: true

require 'English'

module Pronto
  class Eslinter < Runner
    class Eslint
      def initialize(files)
        @files = files
      end

      def lint
        eslint_output = run_eslint
        parse_output(eslint_output)
      end

      private

      def eslint_config
        @eslint_config ||= Pronto::ConfigFile.new.to_h['eslinter'] || {}
      end

      def command
        eslint_config['command'] || 'npx eslint'
      end

      def run_eslint
        full_command = "#{command} #{@files.join(' ')} --format json"

        output = `#{full_command} 3>&1`
        raise "ESLint Error: \n#{output}" unless $CHILD_STATUS.success?

        output
      end

      def parse_output(output)
        json_str = output
          .split("\n")
          .drop_while { |line| !line.start_with?('[') }
          .join("\n")

        JSON.parse(json_str, symbolize_names: true)
      end
    end
  end
end
