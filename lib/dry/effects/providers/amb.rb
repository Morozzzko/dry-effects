# frozen_string_literal: true

require 'dry/effects/provider'

module Dry
  module Effects
    module Providers
      class Amb < Provider[:amb]
        include Dry::Equalizer(:id, :value)

        param :id

        attr_reader :value

        def get
          value
        end

        def call(_, _)
          @value = false
          first = yield
          @value = true
          [first, yield]
        end

        def provide?(effect)
          super && id.equal?(effect.id)
        end
      end
    end
  end
end
