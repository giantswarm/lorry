module Lorry
  module Models
    class Validation
      attr_accessor :document

      def initialize(document)
        @document = document

        case detect_version
        when :v1
          validator = ComposeV1Validator.new
        when :v2
          validator = ComposeV2Validator.new
        end

        if yaml
          validator.services = yaml.keys if yaml.respond_to?(:keys)
        end

        @parser = Kwalify::Yaml::Parser.new(validator)
        @parser.parse(document) if document
      rescue Kwalify::SyntaxError => e
        raise ArgumentError.new(e.message)
      end

      def detect_version
        if yaml && yaml.is_a?(Hash) && yaml.fetch("version", nil) == "2"
          :v2
        else
          :v1
        end
      end

      def yaml
        YAML.load(document)
      end

      def errors
        @parser.errors.map { |err| err if err.instance_of? Kwalify::ValidationError }.compact
      end

      def warnings
        @parser.errors.map { |err| err if err.instance_of? Lorry::Errors::ComposeValidationWarning }.compact
      end
    end
  end
end
