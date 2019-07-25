module GmShell
  module MessageHandlers
    module QueryHandler
      def self.call(registry:, term:, expand: false, index: nil, grep: false)
        table = registry.table_for(term: term)
        if index
          entries = [table.lookup(index: index)]
        elsif grep
          regexp = %r{#{grep}}i
          entries = table.grep(regexp)
        end
        return entries unless expand
        entries.map do |entry|
          registry.evaluate(line: entry.to_s)
        end
      end
    end
  end
end
