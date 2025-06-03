module JobsHelper
  def transformed_image_path(image_path, width, height)
    image = MiniMagick::Image.open(Rails.root.join('public', image_path))
    image.resize "#{width}x#{height}>"
    temp_file = Rails.root.join('tmp', "transformed_#{File.basename(image_path)}")
    image.write(temp_file)
    temp_file
  end
end

