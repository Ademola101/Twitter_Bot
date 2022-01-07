require_relative '../lib/bot_logic'
describe 'Retweet' do
  let(:MAX_HASHTAG) { Array.new(12, '#rails') }
  let(:tweeter) { Twitter::Retweet.new }
  describe '#tweet' do
    it 'should return false if the class is of a tweet' do
      expect(tweeter.send(:tweet?, 'This is a string and not a tweet')).to eql false
    end
  end
end
