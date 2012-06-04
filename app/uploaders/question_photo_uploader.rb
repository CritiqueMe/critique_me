# encoding: utf-8

class QuestionPhotoUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick
  # include CarrierWave::ImageScience

  # Choose what kind of storage to use for this uploader:
  if %w(production staging).include?(Rails.env)
    storage :fog
  else
    storage :file
  end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    # we do this test switch to make it easier for tests to clean up after themselves
    # this also prevents collisions with stuff from prod/dev modes
    if Rails.env == 'test'
      "test_attachments/question_photos/#{mounted_as}/#{model.id}"
    else
      "question_photos/#{mounted_as}/#{model.id}"
    end
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]

  process :resize_to_limit => [160,160]

  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  version :thumb do
    process :resize_to_fit => [70,70]
  end

  version :mini_thumb do
    process :resize_to_fit => [28,28]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
     %w(jpg jpeg gif png)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end
