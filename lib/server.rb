require "sinatra/base"
require "mini_magick"

IMAGES_PATH = "images/"

class Server < Sinatra::Base
  # Resize an image at the given URL.
  # http://server.com/width/X/url
  get "/width/:value/*/?" do |value, url|
    process_image(value, url) { |image|
      resize(image, value)
    }
  end

  # Resize and crop an image at the given URL.
  # http://server.com/crop/XxY/url
  get "/crop/:dimensions/*/?" do |dimensions, url|
    process_image(dimensions, url) { |image|
      resize(image, dimensions + "^")
      crop(image, dimensions)
    }
  end

  private

  def process_image(dimensions, url, &process)
    filename = create_filename(dimensions, url)

    unless File.exists?(filename)
      image = open(url)
      process.call(image)
      write(image, filename)
    end

    sendfile(filename)
  end

  def create_filename(dimensions, url)
    IMAGES_PATH + "#{dimensions}-" + find_filename(url)
  end

  def find_filename(url)
    url.split("/").last
  end

  # WORKAROUND: Sinatra match the route parameter with only one slash http:/
  def open(url)
    url["http:/"] = "http://"
    minimagick.open(url)
  end

  def resize(image, dimensions)
    image.resize(dimensions)
  end

  # WORKAROUND: http://stackoverflow.com/q/8418973/462015
  def crop(image, dimensions)
    image.crop(dimensions + "+0+0")
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

  def minimagick
    MiniMagick::Image
  end
end
