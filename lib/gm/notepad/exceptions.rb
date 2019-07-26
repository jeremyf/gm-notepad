module Gm
  module Notepad
    class DuplicateKeyError < RuntimeError
      def initialize(key:, object:)
        super("Duplicate key for #{key.inspect} in #{object}")
      end
    end
  end
end
