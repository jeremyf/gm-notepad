module GmShell
  module MessageHandlers
    class QueryTermsHandler
      def self.call(grep: false, registry:)
        terms = registry.terms.sort
        return terms unless grep
        terms.grep(%r{#{grep}})
      end
      private
      attr_accessor :grep
    end
  end
end
