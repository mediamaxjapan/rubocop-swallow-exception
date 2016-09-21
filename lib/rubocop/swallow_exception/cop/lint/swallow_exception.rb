module RuboCop
  module Cop
    module Lint

      class SwallowException < Cop

        def on_resbody(node)
          # rescue の中身が空ならエラー
          unless node.children[2]
            add_offense(node, :expression, 'rescue body is empty!', :fatal)
            return
          end
          body = node.children[2]
          # トップレベルで条件なしに raise していれば OK
          return if has_raise?(body)
          # トップレベルで Raven.capture_exception 呼び出していれば OK
          return if has_raven_capture_exception?(body)
          # raise も Raven.capture_exception もなければエラー
          add_offense(node, :expression, (<<-MSG).strip, :fatal)
            you have to raise exception or capture exception by Raven in rescue body.
          MSG
        end

        def has_raven_capture_exception?(node)
          case node.type
            when :send
              raven_capture_exception?(node)
            when :begin
              node.children.any? { |c| raven_capture_exception?(c) }
          end
        end

        def has_raise?(node)
          case node.type
            when :send
              raise?(node)
            when :begin
              node.children.any? { |c| raise?(c) }
          end
        end

        def raven_capture_exception?(node)
          node.type == :send &&
              raven?(node.children[0]) &&
              node.children[1] == :capture_exception
        end

        def raven?(node)
          node.type == :const && node.children[1] == :Raven
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