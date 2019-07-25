module Gmshell
  module MessageHandlers
    module WriteLineHandler
      def self.handle(notepad:, expand:, **kwargs)
        results = call(expand: expand, **kwargs)
        notepad.log(results, expand: expand, capture: true)
      end
      def self.call(line:, expand: false)
        line
      end
    end
  end
end
