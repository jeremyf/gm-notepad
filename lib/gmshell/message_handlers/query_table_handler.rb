module Gmshell
  module MessageHandlers
    module QueryTableHandler
      def self.handle(notepad:, expand:, **kwargs)
        results = call(registry: notepad.table_registry, expand: expand, **kwargs)
        notepad.log(results, expand: false)
      end
      def self.call(registry:, table_name:, expand: false, index: nil, grep: false)
        begin
          table = registry.fetch_table(name: table_name)
        rescue KeyError
          message = "Unknown table #{table_name.inspect}. Did you mean: "
          message += registry.table_names.grep(/\A#{table_name}/).map(&:inspect).join(", ")
          return [message]
        end
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
