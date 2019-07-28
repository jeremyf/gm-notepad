module Gm
  module Notepad
    class RuntimeError < ::RuntimeError
    end
    class DuplicateKeyError < RuntimeError
      def initialize(key:, object:)
        super("Duplicate key for #{key.inspect} in #{object}")
      end
    end
    class MissingTableError < RuntimeError
      def initialize(name:)
        @name = name
        super(%(Missing table "#{name}"))
      end
      alias to_buffer_message to_s
    end
    class MissingTableEntryError < RuntimeError
      def initialize(table_name:, index:)
        super(%(Missing index "#{index}" for table "#{table_name}"))
      end
      alias to_buffer_message to_s
    end
  end
end
