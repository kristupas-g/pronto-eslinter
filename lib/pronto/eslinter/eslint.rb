# frozen_string_literal: true

module Pronto
  module Eslinter
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

        output = `#{full_command} 2>&1`

        raise StandardError("ESLint Error: \n#{output}") unless $CHILD_STATUS.success?

        output
      end

      def parse_output(output)
        json_str = output[/\[\{.+\}\]/m]
        JSON.parse(json_str, symbolize_names: true)
      end
    end
  end
end
