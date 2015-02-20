require "mini_magick"
require "sinatra/base"

IMAGES_PATH = "images/"

class Server < Sinatra::Base
  # Resize an image at the given URL.
  # http://localhost:3000/width/X/url
  get "/width/:value/*/?" do |value, url|
    process_image(value, url) do |image|
      resize(image, value)
    end
  end

  # Resize and crop an image at the given URL.
  # http://localhost:3000/crop/XxY/url
  get "/crop/:dimensions/*/?" do |dimensions, url|
    process_image(dimensions, url) do |image|
      resize(image, "#{dimensions}^")
      crop(image, dimensions)
    end
  end

  private

  def process_image(dimensions, url, &block)
    filename = create_filename(dimensions, url)

    unless File.exists?(filename)
      image = open(url)
      block.call(image)
      write(image, filename)
    end

    sendfile(filename)
  end

  def create_filename(dimensions, url)
    "#{IMAGES_PATH}#{dimensions}-#{key(url)}"
  end

  def key(url)
    Digest::SHA1.hexdigest(url)
  end

  # WORKAROUND: Sinatra match the route parameter with only one slash http:/
  def open(url)
    url[":/"] = "://"
    MiniMagick::Image.open(url)
  end

  def resize(image, dimensions)
    image.resize(dimensions)
  end

  # WORKAROUND: http://stackoverflow.com/q/8418973/462015
  def crop(image, dimensions)
    image.crop("#{dimensions}#{offset(image, dimensions)}")
  end

  def offset(image, dimensions)
    "+0+0"
  end

  def write(image, path)
    image.write(path)
  end

  def sendfile(filename)
    send_file(
      filename,
      :type => "image/jpeg",
      :disposition => "inline"
    )
  end
end
