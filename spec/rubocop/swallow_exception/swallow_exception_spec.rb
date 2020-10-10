require 'spec_helper'

RSpec.describe RuboCop::Cop::SwallowException::SwallowException do

  subject(:cop) { described_class.new(config) }

  let(:config) { RuboCop::Config.new }

  it "has a version number" do
    expect(RuboCop::SwallowException::VERSION).not_to be nil
  end

  it 'offense: rescue body is empty' do
    expect_offense(<<~RUBY)
      def bad_method
        p :hello
      rescue => e
      ^^^^^^^^^^^ swallow exception found
        # do nothing
      end
    RUBY
  end

  it 'ok: raise new exception without any condition' do
    expect_no_offenses(<<~RUBY)
      def bad_method
        p :hello
      rescue => e
        log.error 'error occured'
        log.error e.backtrace.join("\n")
        raise e
      end
    RUBY
  end

  it 'ok: call Raven.capture_exception' do
    expect_no_offenses(<<~RUBY)
      def bad_method
        p :hello
      rescue => e
        Raven.capture_exception(e)
      end
    RUBY
  end

  it 'offense: logging only' do
    expect_offense(<<~RUBY)
      def bad_method
        p :hello
      rescue => e
      ^^^^^^^^^^^ swallow exception found
        log.error 'error occured'
        log.error e.backtrace.join("\n")
      end
    RUBY
  end

  it 'offense: just return value' do
    expect_offense(<<~RUBY)
      def verify_token(env)
        token = BEARER_TOKEN_REGEX.match(env['HTTP_AUTHORIZATION'])[1]
      rescue ::JWT::VerificationError => error
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ swallow exception found
        3
      end
    RUBY
  end

  it 'offense: only logging with some method, and just return value' do
    expect_offense(<<~RUBY)
      def verify_token(env)
        token = BEARER_TOKEN_REGEX.match(env['HTTP_AUTHORIZATION'])[1]
      rescue ::JWT::VerificationError => error
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ swallow exception found
        write_log(error)
        return_error('token_signature_verification_failed')
      end
    RUBY
  end

  it 'offense: only logging with some method, and just return value on multiple rescue block' do
    expect_offense(<<~RUBY)
      def authenticate_user!
        begin
          user = User.find_by(id: env['jwt.payload'].try(:[], 'user_id'))
          raise AccountError::NotFound if user.nil?
          raise AccountError::Deactivated if user.user_status_deactive?
          raise AccountError::Blocked if user.user_status_block?
        rescue AccountError::NotFound => error
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ swallow exception found
          write_log(error)
          render json: { execution_result: RESPONSE_ENUMS[:user_not_found] }, status: :ok
        rescue AccountError::Deactivated => error
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ swallow exception found
          write_log(error)
          render json: { execution_result: RESPONSE_ENUMS[:user_deactivated] }, status: :ok
        rescue AccountError::Blocked => error
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ swallow exception found
          write_log(error)
          render json: { execution_result: RESPONSE_ENUMS[:user_blocked] }, status: :ok
        rescue StandardError => error
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ swallow exception found
          write_log(error)
          render json: { execution_result: RESPONSE_ENUMS[:user_unknown_error] }, status: :ok
        end
      end
    RUBY
  end

end
