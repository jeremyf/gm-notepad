module Gmshell
  class DuplicateKeyError < RuntimeError
    def initialize(term:, table_name: term, object:)
      super("Duplicate key for #{table_name.inspect} in #{object}")
    end
  end
end
