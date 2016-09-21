module RuboCop
  module Cop
    module Lint

      class SwallowException < Cop
        def on_resbody(node)
          p node
        end
      end

    end
  end
end