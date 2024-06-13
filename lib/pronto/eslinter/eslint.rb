# frozen_string_literal: true

require 'English'

module Pronto
  class Eslinter < Runner
    class Eslint
      extend Forwardable

      attr_reader :files, :patch, :eslinter

      def_delegator :eslinter, :eslint_config

      def initialize(files, patch, eslinter)
        @files = files
        @patch = patch
        @eslinter = eslinter
      end

      def lint
        Output.new(parse_output(run_eslint), patch, eslinter)
      end

      private

      def command
        eslint_config['command'] || 'npx eslint'
      end

      def run_eslint
        `#{command} #{files.join(' ')} --format json 3>&1`
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
