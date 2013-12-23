require "sinatra/base"
require "mini_magick"

IMAGES_PATH = "images/"

class Server < Sinatra::Base

  # Resize an image at the given URL.
  # http://server.com/width/X/url
  get "/width/:value/*/?" do |value, url|
    filename = create_filename(value, url)

    unless File.exists?(filename)
      image = open(url)
      resize(image, value)
      write(image, filename)
    end

    sendfile(filename)
  end

  # Resize and crop an image at the given URL.
  # http://server.com/crop/XxY/url
  get "/crop/:dimensions/*/?" do |dimensions, url|
    filename = create_filename(dimensions, url)

    unless File.exists?(filename)
      image = open(url)
      resize(image, dimensions + "^")
      crop(image, dimensions)
      write(image, filename)
    end

    sendfile(filename)
  end

  private

  def create_filename(dimensions, url)
    IMAGES_PATH + "#{dimensions}-" + find_filename(url)
  end

  def find_filename(url)
    url.split("/").last
  end

  # WORKAROUND: Sinatra match the route parameter with only one slash http:/
  def open(url)
    url["http:/"] = "http://"
    MiniMagick::Image.open(url)
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
end
