#chat GPT
require 'rails_helper'

RSpec.describe MyCustomService, type: :service do
  describe '#call' do
    subject(:result) { described_class.new.call }

    it 'returns the expected string' do
      expect(result).to eq('Hello from service')
    end
  end
end
