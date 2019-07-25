module GmShell
  module MessageHandlers
    module QueryTermsHandler
      def self.call(grep: false, registry:)
        terms = registry.terms.sort
        return terms unless grep
        terms.grep(%r{#{grep}})
      end
    end
  end
end
