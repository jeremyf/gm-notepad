module Gmshell
  module MessageHandlers
    module QueryHandler
      def self.handle(notepad:, expand:, **kwargs)
        results = call(registry: notepad.table_registry, expand: expand, **kwargs)
        notepad.log(results, expand: false)
      end
      def self.call(registry:, term:, expand: false, index: nil, grep: false)
        table = registry.fetch_table(name: term)
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
