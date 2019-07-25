module Gmshell
  # Responsible for extracting the appropriate message to send based
  # on the given line.
  class MessageHandlerParameterFactory
    NON_EXPANDING_CHARATER = '!'.freeze
    QUERY_TABLE_NAMES_PREFIX = '+'.freeze
    HELP_PREFIX = '?'.freeze
    def call(line:)
      line = line.strip
      case line[0]
      when HELP_PREFIX
        help(line[1..-1], expand: false)
      when QUERY_TABLE_NAMES_PREFIX
        if line == QUERY_TABLE_NAMES_PREFIX || line[0..1] == "#{QUERY_TABLE_NAMES_PREFIX}/"
          query_table_names(line[1..-1], expand: false)
        else
          query_table(line[1..-1], expand: false)
        end
      when '<'
        write_term(line)
      when NON_EXPANDING_CHARATER
        write(line[1..-1], expand: false)
      else ''
        write(line, expand: true)
      end
    end

    private

    def help(line, expand:)
      [:help, { expand: expand }]
    end

    def query_table_names(line, expand:)
      parameters = { expand: expand }
      args = [:query_table_names, parameters]
      if match = WITH_GREP_REGEXP.match(line)
        line = line.sub(match[:declaration], '')
        grep = match[:grep]
        parameters[:grep] = grep
      end
      args
    end

    def write(line, expand:)
      [:write_line, line: line.strip, expand: expand, to_output: true]
    end

    WITH_INDEX_REGEXP = %r{(?<declaration>\[(?<index>[^\]]+)\])}
    WITH_GREP_REGEXP = %r{(?<declaration>\/(?<grep>[^\/]+)/)}
    def query_table(line, expand:)
      parameters = {expand: expand}
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
      parameters[:term] = line.downcase
      args
    end

    WITH_WRITE_TARGET_REGEXP = %r{\A<(?<term>[^>]+)>(?<line>.*)}
    def write_term(line)
      parameters = {}
      args = [:write_term, parameters]
      if match = WITH_WRITE_TARGET_REGEXP.match(line)
        line = match[:line].strip
        term = match[:term]
        if index_match = WITH_INDEX_REGEXP.match(term)
          term = term.sub(index_match[:declaration], '')
          index = index_match[:index]
          parameters[:index] = index
        elsif grep_match = WITH_GREP_REGEXP.match(term)
          term = term.sub(grep_match[:declaration], '')
          parameters[:grep] = grep_match[:grep]
        end
        parameters[:term] = term.downcase
      else
        raise "I don't know what to do"
      end
      if line[0] == NON_EXPANDING_CHARATER
        parameters[:expand] = false
        line = line[1..-1]
      else
        parameters[:expand] = true
      end
      parameters[:line] = line.strip
      args
    end
  end
end
