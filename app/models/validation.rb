module Lorry
  module Models
    class Validation
      attr_accessor :document

      def initialize(document)
        @document = document
        validator = ComposeValidator.new

        if yaml
          validator.services = yaml.keys if yaml.respond_to?(:keys)
        end

        @parser = Kwalify::Yaml::Parser.new(validator)
        @parser.parse(document) if document
      rescue Kwalify::SyntaxError => e
        raise ArgumentError.new(e.message)
      end

      def detect_version
        if yaml && yaml.fetch("version", nil) == "2"
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
