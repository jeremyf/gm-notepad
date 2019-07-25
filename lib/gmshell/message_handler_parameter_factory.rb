require_relative "message_context"
module Gmshell
  # Responsible for extracting the appropriate message to send based
  # on the given line.
  class MessageHandlerParameterFactory
    NON_EXPANDING_CHARATER = '!'.freeze
    QUERY_TABLE_NAMES_PREFIX = '+'.freeze
    HELP_PREFIX = '?'.freeze

    def extract(input)
      response = call(line: input.clone)
      MessageContext.new(input: input, handler_name: response[0], **response[1])
    end

    def call(line:)
      line = line.strip
      case line[0]
      when HELP_PREFIX
        help(line[1..-1], expand_line: false)
      when QUERY_TABLE_NAMES_PREFIX
        if line == QUERY_TABLE_NAMES_PREFIX || line[0..1] == "#{QUERY_TABLE_NAMES_PREFIX}/"
          query_table_names(line[1..-1], expand_line: false)
        else
          query_table(line[1..-1], expand_line: false)
        end
      when '<'
        write_to_table(line)
      when NON_EXPANDING_CHARATER
        write(line[1..-1], expand_line: false)
      else ''
        write(line, expand_line: true)
      end
    end

    private

    def help(line, expand_line:)
      [:help, { expand_line: expand_line }]
    end

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
    def query_table(line, expand_line:)
      parameters = {expand_line: expand_line}
      args = [:query_table, parameters]
      if match = WITH_INDEX_REGEXP.match(line)
        line = line.sub(match[:declaration], '')
        index = match[:index]
        parameters[:index] = index
      elsif match = WITH_GREP_REGEXP.match(line)
        line = line.sub(match[:declaration], '')
        grep = match[:grep]
        parameters[:grep] = grep
      end
      if line[-1] == NON_EXPANDING_CHARATER
        line = line[0..-2]
      end
      parameters[:table_name] = line.downcase
      args
    end

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
