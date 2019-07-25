module Gmshell
  module MessageHandlers
    module QueryTableNamesHandler
      def self.call(grep: false, registry:, **kwargs)
        table_names = registry.table_names
        return table_names unless grep
        table_names.grep(%r{#{grep}})
      end
    end
  end
end
