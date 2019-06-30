# frozen_string_literal: true

require 'dry/core/class_attributes'

module Dry
  module Effects
    class Provider
      module ClassInterface
        def self.extended(base)
          base.instance_exec do
            defines :type

            @mutex = ::Mutex.new
            @effects = ::Hash.new do |es, type|
              @mutex.synchronize do
                es.fetch(type) do
                  es[type] = Class.new(Provider).tap do |provider|
                    provider.type type
                  end
                end
              end
            end
          end
        end

        include Core::ClassAttributes

        def [](type)
          @effects[type]
        end

        def mixin(*args, **kwargs)
          handle_method = handle_method(**kwargs)

          handler = Handler.new(self, args, kwargs)

          ::Module.new do
            define_method(handle_method) do |*args, **kwargs, &block|
              handler.(args, kwargs, &block)
            end
          end
        end

        def handle_method(as: Undefined, **)
          Undefined.default(as) { :"handle_#{type}" }
        end
      end
    end
  end
end
