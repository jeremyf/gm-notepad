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
        super(%((Missing table "#{name}")))
      end
      alias to_buffer_message to_s
    end
    class MissingTableEntryError < RuntimeError
      def initialize(table_name:, index:)
        super(%(Missing index "#{index}" for table "#{table_name}"))
      end
      alias to_buffer_message to_s
    end

    class ExceededTimeToLiveError < RuntimeError
      attr_reader :text_when_time_to_live_exceeded
      def initialize(text:, time_to_live:, text_when_time_to_live_exceeded:)
        @text_when_time_to_live_exceeded = text_when_time_to_live_exceeded
        super(%(Expanding the given text "#{text}" exceed the time to live of #{time_to_live}))
      end
      alias to_buffer_message to_s
    end
  end
end
