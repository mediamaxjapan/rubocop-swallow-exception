module RuboCop
  module Cop
    module SwallowException

      class SwallowException < Base

        MSG = 'swallow exception found'

        def on_resbody(node)
          # disallow empty rescue block
          unless node.children[2]
            add_offense(node)
            return
          end
          body = node.children[2]
          # allow if raise new exception
          return if has_raise?(body)
          # allow if capture exception with Raven (Sentry)
          return if has_raven_capture_exception?(body)
          # disalow otherwise
          add_offense(node)
        end

        def has_raven_capture_exception?(node)
          if node.type == :begin
            node.children.any? { |c| raven_capture_exception?(c) }
          else
            raven_capture_exception?(node)
          end
        end

        def has_raise?(node)
          if node.type == :begin
            node.children.any? { |c| raise?(c) }
          else
            raise?(node)
          end
        end

        def raven_capture_exception?(node)
          node.type == :send &&
              raven?(node.children[0]) &&
              node.children[1] == :capture_exception
        end

        def raven?(node)
          node && node.type == :const && node.children[1] == :Raven
        end

        def raise?(node)
          node.type == :send &&
              node.children[0] == nil &&
              node.children[1] == :raise
        end

      end
    end
  end
end