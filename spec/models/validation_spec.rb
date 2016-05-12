require 'spec_helper'

describe Validation do
  subject do
    Validation.new(document)
  end

  let(:parser_with_errors) do
    double('parser',
           parse: true,
           errors: [Kwalify::ValidationError.new('error'),
                    Lorry::Errors::ComposeValidationWarning.new('warning')])
  end

  let(:parser_without_errors) { double('parser', errors: [], warnings: []) }
  let(:validator) { double('validator') }
  let(:document) { "" }

  before do
    allow(ComposeV1Validator).to receive(:new).and_return(validator)
    allow(validator).to receive(:services=).and_return(true)
    allow(validator).to receive(:parse)
    allow(validator).to receive(:rule)
    allow(validator).to receive(:_validate)
  end

  describe '#detect_version' do
    context('v1 document') do
      let(:document) { "" }

      it('returns v1') do
        expect(subject.detect_version).to equal(:v1)
      end
    end

    context('v2 document') do
      let(:document) { "version: '2'" }

      it('returns v2') do
        expect(subject.detect_version).to equal(:v2)
      end
    end

    context('invalid document') do
      let(:document) { "foo" }

      it('returns v2') do
        expect(subject.detect_version).to equal(:v1)
      end
    end
  end

  describe '#errors' do
    context('when the document has errors') do
      before do
        allow(Kwalify::Yaml::Parser).to receive(:new).and_return(parser_with_errors)
      end

      it('returns an array') do
        expect(subject.errors).to be_an(Array)
      end

      it('returns an array with only Kwalify::ValidationError instances') do
        expect(subject.errors).to all(be_an_instance_of Kwalify::ValidationError)
      end
    end
  end

  describe '#warnings' do
    context('when the document has warnings') do
      before do
        allow(Kwalify::Yaml::Parser).to receive(:new).and_return(parser_with_errors)
      end

      it('returns an array') do
        expect(subject.warnings).to be_an(Array)
      end

      it('returns an array with only Lorry::Errors::ComposeValidationWarning instances') do
        expect(subject.warnings).to all(be_an_instance_of Lorry::Errors::ComposeValidationWarning)
      end
    end
  end
end
