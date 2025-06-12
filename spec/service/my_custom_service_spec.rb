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



#copilot

# require 'rails_helper'

# RSpec.describe MyCustomService do
#   describe '#call' do
#     let(:service) { described_class.new }
    
#     it 'returns the expected greeting message' do
#       expect(service.call).to eq('Hello from service')
#     end
#   end
  
#   context 'when initialized' do
#     it 'creates a valid instance' do
#       expect(MyCustomService.new).to be_an_instance_of(MyCustomService)
#     end
#   end
  
#   # Example of testing with different initialization parameters
#   # Uncomment and adapt if you expand your service to accept parameters
#   # 
#   # context 'when initialized with custom parameters' do
#   #   let(:service) { described_class.new(greeting: 'Hi') }
#   #   
#   #   it 'uses the custom greeting' do
#   #     expect(service.call).to eq('Hi from service')
#   #   end
#   # end
# end