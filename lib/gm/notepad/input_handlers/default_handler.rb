require 'gm/notepad/throughput_text'
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

        def initialize(input:, table_registry: Container.resolve(:table_registry))
          # TODO Remove coercion
          self.input = input.is_a?(ThroughputText) ? input : ThroughputText.new(original_text: input, table_registry: table_registry)
          self.table_registry = table_registry
          after_initialize!
        end
        attr_accessor :table_registry, :input

        def after_initialize!
        end

        def lines
          input.lines
        end
      end
    end
  end
end
