require "logger"
require "mini_magick"
require "sinatra/base"

IMAGES_PATH = "images/"
BAD_URLS_FILE = "tmp/bad-urls.txt"

class Server < Sinatra::Base
  # Resize an image for a given URL: http://localhost:3000/width/X/url
  get "/width/:value/*/?" do |value, url|
    process_image(value, url) do |image|
      resize(image, value)
    end
  end

  # Resize and crop an image for a given URL: http://localhost:3000/crop/XxY/url
  get "/crop/:dimensions/*/?" do |dimensions, url|
    process_image(dimensions, url) do |image|
      resize(image, "#{dimensions}^")
      crop(image, dimensions)
    end
  end

  private

  def process_image(dimensions, url)
    url[":/"] = "://"  # WORKAROUND: Sinatra match the route parameter with only one slash http:/

    if !File.foreach(BAD_URLS_FILE).any? { |line| line.include?(url) }
      unless File.exists?(filename)
        image = open(url)
        yield(image)
        write(image, filename)
      end

      sendfile(filename)
    end
  rescue Exception => e
    logger.error(url)
  end

  def filename
    @filename ||= "#{IMAGES_PATH}#{key(request.path)}"
  end

  def key(path)
    Digest::SHA1.hexdigest(path)
  end

  def open(url)
    MiniMagick::Image.open(url)
  end

  def resize(image, dimensions)
    image.resize(dimensions)
  end

  # WORKAROUND: http://stackoverflow.com/q/8418973/462015
  def crop(image, dimensions)
    image.crop("#{dimensions}+0+0")
  end

  def write(image, path)
    image.write(path)
  end

  def sendfile(filename)
    send_file(filename,
      type: "image/jpeg",
      disposition: "inline"
    )
  end

  def logger
    Logger.new(BAD_URLS_FILE)
  end
end
