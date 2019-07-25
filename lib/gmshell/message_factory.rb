module Gmshell
  # Responsible for extracting the appropriate message to send based
  # on the given line.
  class MessageFactory
    NON_EXPANDING_CHARATER = '!'.freeze
    QUERY_PREFIX = '?'.freeze
    def call(line:)
      line = line.strip
      case line[0]
      when QUERY_PREFIX
        returning_value = query(line[1..-1])
        return returning_value unless returning_value.last.fetch(:term) == ''
        parameters = {}
        parameters[:grep] = returning_value.last[:grep] if returning_value.last.key?(:grep)
        [:query_terms, parameters]
      when '<'
        write_term(line)
      when NON_EXPANDING_CHARATER
        write(line[1..-1], expand: false)
      else ''
        write(line, expand: true)
      end
    end

    private

    def write(line, expand:)
      [:write_line, line: line.strip, expand: expand]
    end

    WITH_INDEX_REGEXP = %r{(?<declaration>\[(?<index>[^\]]+)\])}
    WITH_GREP_REGEXP = %r{(?<declaration>\/(?<grep>[^\/]+)/)}
    def query(line)
      parameters = {}
      args = [:query, parameters]
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
        parameters[:expand] = false
      else
        parameters[:expand] = true
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
