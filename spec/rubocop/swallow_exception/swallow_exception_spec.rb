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

end
