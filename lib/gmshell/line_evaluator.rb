module Gmshell
  # Responsible for recording entries and then dumping them accordingly.
  class LineEvaluator
    TOKEN_REGEXP = %r{(?<term_container>\{(?<term>[^\}]+)\})}
    def call(line:, term_evaluation_function:)
      while match = line.match(TOKEN_REGEXP)
        evaluated_term = term_evaluation_function.call(term: match[:term].strip)
        line.sub!(match[:term_container], evaluated_term)
      end
      line
    end
  end
end
