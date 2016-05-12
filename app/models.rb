module Lorry
  module Models
    autoload :ComposeV1Validator, 'app/models/compose_v1_validator'
    autoload :ComposeV2Validator, 'app/models/compose_v2_validator'
    autoload :Validation, 'app/models/validation'
    autoload :Gistable,   'app/models/gistable'
    autoload :Document,   'app/models/document'
    autoload :Registry,   'app/models/registry'
  end
end
