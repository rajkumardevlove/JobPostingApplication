#Chat GPT

require 'rails_helper'

RSpec.describe JobsHelper, type: :helper do
  describe '#transformed_image_path' do
    let(:image_path) { 'uploads/sample.png' }
    let(:width) { 200 }
    let(:height) { 100 }
    let(:source_full_path) { Rails.root.join('public', image_path) }
    let(:temp_file_path) { Rails.root.join('tmp', "transformed_#{File.basename(image_path)}") }
    let(:image_double) { instance_double(MiniMagick::Image) }

    before do
      allow(MiniMagick::Image).to receive(:open)
        .with(source_full_path)
        .and_return(image_double)
      allow(image_double).to receive(:resize)
      allow(image_double).to receive(:write)
    end

    it 'opens the image from the public directory' do
      helper.transformed_image_path(image_path, width, height)
      expect(MiniMagick::Image).to have_received(:open).with(source_full_path)
    end

    it 'resizes the image with correct dimensions' do
      helper.transformed_image_path(image_path, width, height)
      expect(image_double).to have_received(:resize).with("#{width}x#{height}>")
    end

    it 'writes the transformed image to the tmp directory' do
      helper.transformed_image_path(image_path, width, height)
      expect(image_double).to have_received(:write).with(temp_file_path)
    end

    it 'returns the path to the transformed image file' do
      result = helper.transformed_image_path(image_path, width, height)
      expect(result).to eq(temp_file_path)
    end
  end
end


#copilot

# require 'rails_helper'

# RSpec.describe JobsHelper, type: :helper do
#   describe '#transformed_image_path' do
#     let(:image_path) { 'images/test.jpg' }
#     let(:width) { 100 }
#     let(:height) { 200 }
#     let(:mock_image) { double('MiniMagick::Image') }
#     let(:temp_file_path) { Rails.root.join('tmp', "transformed_test.jpg") }

#     before do
#       allow(MiniMagick::Image).to receive(:open).and_return(mock_image)
#       allow(mock_image).to receive(:resize)
#       allow(mock_image).to receive(:write)
#       allow(File).to receive(:basename).with(image_path).and_return('test.jpg')
#     end

#     it 'opens the image with MiniMagick' do
#       expect(MiniMagick::Image).to receive(:open).with(Rails.root.join('public', image_path))
#       helper.transformed_image_path(image_path, width, height)
#     end

#     it 'resizes the image to specified dimensions' do
#       expect(mock_image).to receive(:resize).with("#{width}x#{height}>")
#       helper.transformed_image_path(image_path, width, height)
#     end

#     it 'writes the resized image to a temporary file' do
#       expect(mock_image).to receive(:write).with(temp_file_path)
#       helper.transformed_image_path(image_path, width, height)
#     end

#     it 'returns the path to the temporary file' do
#       allow(mock_image).to receive(:write)
#       result = helper.transformed_image_path(image_path, width, height)
#       expect(result).to eq(temp_file_path)
#     end

#     context 'with different image dimensions' do
#       let(:width) { 300 }
#       let(:height) { 400 }

#       it 'uses the provided dimensions for resizing' do
#         expect(mock_image).to receive(:resize).with("300x400>")
#         helper.transformed_image_path(image_path, width, height)
#       end
#     end
#   end
# end