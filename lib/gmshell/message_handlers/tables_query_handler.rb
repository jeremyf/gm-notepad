module Gmshell
  module MessageHandlers
    module TablesQueryHandler
      def self.handle(notepad:, **kwargs)
        results = call(registry: notepad.table_registry, **kwargs)
        notepad.log(results)
      end
      def self.call(grep: false, registry:)
        tables = registry.tables
        return tables unless grep
        tables.grep(%r{#{grep}})
      end
    end
  end
end
