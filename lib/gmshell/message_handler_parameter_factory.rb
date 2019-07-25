require_relative "input_processing_context"
require_relative "input_handler_registry"
require_relative "input_handlers/help_handler"
require_relative "input_handlers/query_table_handler"
require_relative "input_handlers/query_table_names_handler"
module Gmshell
  # Responsible for extracting the appropriate message to send based
  # on the given line.
  class MessageHandlerParameterFactory
    NON_EXPANDING_CHARATER = '!'.freeze

    def initialize
      @input_handler_registry = InputHandlerRegistry.new
      @input_handler_registry.register(handler: InputHandlers::HelpHandler)
      @input_handler_registry.register(handler: InputHandlers::QueryTableHandler)
      @input_handler_registry.register(handler: InputHandlers::QueryTableNamesHandler)
    end

    def extract(input)
      response = call(line: input.clone)
      InputProcessingContext.new(input: input, handler_name: response[0], **response[1])
    end

    def call(line:)
      line = line.strip
      if handler = @input_handler_registry.handler_for(input: line, skip_default: true)
        return handler.to_params(input: line)
      end
      case line[0]
      when '<'
        write_to_table(line)
      when NON_EXPANDING_CHARATER
        write(line[1..-1], expand_line: false)
      else ''
        write(line, expand_line: true)
      end
    end

    private

    def query_table_names(line, expand_line:)
      parameters = { expand_line: expand_line }
      args = [:query_table_names, parameters]
      if match = WITH_GREP_REGEXP.match(line)
        line = line.sub(match[:declaration], '')
        grep = match[:grep]
        parameters[:grep] = grep
      end
      args
    end

    def write(line, expand_line:)
      [:write_line, line: line.strip, expand_line: expand_line, to_output: true]
    end

    WITH_INDEX_REGEXP = %r{(?<declaration>\[(?<index>[^\]]+)\])}
    WITH_GREP_REGEXP = %r{(?<declaration>\/(?<grep>[^\/]+)/)}
    WITH_WRITE_TARGET_REGEXP = %r{\A<(?<table_name>[^>]+)>(?<line>.*)}
    def write_to_table(line)
      parameters = {}
      args = [:write_to_table, parameters]
      if match = WITH_WRITE_TARGET_REGEXP.match(line)
        line = match[:line].strip
        table_name = match[:table_name]
        if index_match = WITH_INDEX_REGEXP.match(table_name)
          table_name = table_name.sub(index_match[:declaration], '')
          index = index_match[:index]
          parameters[:index] = index
        elsif grep_match = WITH_GREP_REGEXP.match(table_name)
          table_name = table_name.sub(grep_match[:declaration], '')
          parameters[:grep] = grep_match[:grep]
        end
        parameters[:table_name] = table_name.downcase
      else
        raise "I don't know what to do"
      end
      if line[0] == NON_EXPANDING_CHARATER
        parameters[:expand_line] = false
        line = line[1..-1]
      else
        parameters[:expand_line] = true
      end
      parameters[:line] = line.strip
      args
    end
  end
end
