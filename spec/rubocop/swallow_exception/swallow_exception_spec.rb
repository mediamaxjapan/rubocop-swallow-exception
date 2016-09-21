require 'spec_helper'

describe RuboCop::SwallowException do

  subject(:cop) { RuboCop::Cop::Lint::SwallowException.new }

  it 'has a version number' do
    expect(RuboCop::SwallowException::VERSION).not_to be(nil)
  end

  it 'rescue body が空なら NG' do
    inspect_source(cop, <<-EOS)
      def bad_method
        p :hello
      rescue => e
        # do nothing
      end
    EOS
    expect(cop.offenses.size).to eq(1)
    expect(cop.messages.first).to eq('rescue body is empty!')
  end

  it 'rescue body トップレベルで条件なしに raise してれば OK' do
    inspect_source(cop, <<-EOS)
      def bad_method
        p :hello
      rescue => e
        log.error 'error occured'
        log.error e.backtrace.join("\n")
        raise e
      end
    EOS
    expect(cop.offenses.size).to eq(0)
  end

  it 'rescue body トップレベルで Raven.capture_exception 呼びだしてれば OK' do
    inspect_source(cop, <<-EOS)
      def bad_method
        p :hello
      rescue => e
        Raven.capture_exception(e)
      end
    EOS
    expect(cop.offenses.size).to eq(0)
  end

  it 'raise も Raven もなければ NG' do
    inspect_source(cop, <<-EOS)
      def bad_method
        p :hello
      rescue => e
        log.error 'error occured'
        log.error e.backtrace.join("\n")
      end
    EOS
    expect(cop.offenses.size).to eq(1)
    expect(cop.messages.first).to match(/you have to/)
  end

  it 'const など send でない場合のパターンも' do
    inspect_source(cop, <<-EOS)
      def verify_token(env)
        token = BEARER_TOKEN_REGEX.match(env['HTTP_AUTHORIZATION'])[1]
      rescue ::JWT::VerificationError => error
        3
      end
    EOS
    expect(cop.offenses.size).to eq(1)
    expect(cop.messages.first).to match(/you have to/)
  end

  it '中でメソッド呼び出ししている場合の Raven チェックで例外が出ていた' do
    inspect_source(cop, <<-EOS)
      def verify_token(env)
        token = BEARER_TOKEN_REGEX.match(env['HTTP_AUTHORIZATION'])[1]
      rescue ::JWT::VerificationError => error
        write_log(error)
        return_error('token_signature_verification_failed')
      end
    EOS
    expect(cop.offenses.size).to eq(1)
    expect(cop.messages.first).to match(/you have to/)
  end

  it 'これも問題が発生したパターン。send で raven チェックがおかしかった' do
    inspect_source(cop, <<-EOS)
      def authenticate_user!
        begin
          user = User.find_by(id: env['jwt.payload'].try(:[], 'user_id'))
          raise AccountError::NotFound if user.nil?
          raise AccountError::Deactivated if user.user_status_deactive?
          raise AccountError::Blocked if user.user_status_block?
        rescue AccountError::NotFound => error
          write_log(error)
          render json: { execution_result: RESPONSE_ENUMS[:user_not_found] }, status: :ok
        rescue AccountError::Deactivated => error
          write_log(error)
          render json: { execution_result: RESPONSE_ENUMS[:user_deactivated] }, status: :ok
        rescue AccountError::Blocked => error
          write_log(error)
          render json: { execution_result: RESPONSE_ENUMS[:user_blocked] }, status: :ok
        rescue StandardError => error
          write_log(error)
          render json: { execution_result: RESPONSE_ENUMS[:user_unknown_error] }, status: :ok
        end
      end
    EOS
    expect(cop.offenses.size).to eq(4)
    (0..3).each do |i|
      expect(cop.messages[i]).to match(/you have to/)
    end
  end

end
