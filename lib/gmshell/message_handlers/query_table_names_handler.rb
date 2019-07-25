module Gmshell
  module MessageHandlers
    module QueryTableNamesHandler
      def self.handle(notepad:, **kwargs)
        results = call(registry: notepad.table_registry, **kwargs)
        notepad.log(results)
      end
      def self.call(grep: false, registry:)
        table_names = registry.table_names
        return table_names unless grep
        table_names.grep(%r{#{grep}})
      end
    end
  end
end
