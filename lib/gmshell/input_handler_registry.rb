module Gmshell
  class InputHandlerRegistry
    def initialize
      @registry = []
    end

    def handler_for(input:, skip_default: false)
      handler = nil
      @registry.each do |registered_handler|
        next unless registered_handler.handles?(input: input)
        handler = registered_handler
        break
      end
      return handler unless handler.nil?
      return nil if skip_default
      default_handler
    end

    def register(handler:)
      @registry << handler
    end

    def default_handler
      DefaultHandler
    end

    private

    module DefaultHandler
      def self.handles?(input:)
        true
      end
      def self.handle(line:, **kwargs)
        line.to_s.strip
      end
    end
  end
end
