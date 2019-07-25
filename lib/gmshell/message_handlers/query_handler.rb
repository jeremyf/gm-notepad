module Gmshell
  module MessageHandlers
    module QueryHandler
      def self.handle(notepad:, **kwargs)
        results = call(registry: notepad.term_registry, **kwargs)
        notepad.log(results.sort)
      end
      def self.call(registry:, term:, expand: false, index: nil, grep: false)
        table = registry.table_for(term: term)
        if index
          [table.lookup(index: index)]
        elsif grep
          regexp = %r{#{grep}}i
          table.grep(regexp)
        else
          table.all
        end
      end
    end
  end
end
