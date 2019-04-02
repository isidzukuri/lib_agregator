class ArticleCoverUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{model.id}/#{mounted_as}"
  end

  version :thumb do
    process resize_to_fill: [300, 300]
  end

  version :poster do
    process resize_to_fill: [800, 500]
  end

end
