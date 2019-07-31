require 'gm/notepad/throughput_text'
require 'dry-initializer'
module Gm
  module Notepad
    module InputHandlers
      class DefaultHandler
        def self.build_if_handled(input:, table_registry: Container.resolve(:table_registry))
          return false unless handles?(input: input)
          new(input: input, table_registry: table_registry)
        end

        def self.handles?(input:)
          true
        end

        extend Dry::Initializer
        option :input
        option :table_registry, default: -> { Container.resolve(:table_registry) }
        def initialize(*args)
          super
          after_initialize!
        end

        def lines
          input.lines
        end

        private

        def after_initialize!
        end
      end
    end
  end
end
