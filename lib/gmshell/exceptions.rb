module Gmshell
  class DuplicateKeyError < RuntimeError
    def initialize(term:, object:)
      super("Duplicate key for #{term.inspect} in #{object}")
    end
  end
end
