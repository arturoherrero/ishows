require 'rubygems'
require 'sinatra'
require 'mini_magick'

IMAGES_PATH = 'images/'


# Resize an image at the given URL.
# The path looks like:
#     http://imageServer.com/width/X/url
get '/width/:value/*/?' do |value, url|
  filename = create_filename(value, url)

  unless File.exists?(filename)
    image = open url
    resize image, value
    write image, filename
  end

  sendfile filename
end

# Resize and crop an image at the given URL.
# The path looks like:
#     http://imageServer.com/crop/XxY/url
get '/crop/:dimensions/*/?' do |dimensions, url|
  filename = create_filename(dimensions, url)

  unless File.exists?(filename)
    image = open url
    resize image, dimensions + '^'
    crop image, dimensions
    write image, filename
  end

  sendfile filename
end

# Delete all downloaded image files.
get '/clear' do
  FileUtils.rm_rf("#{IMAGES_PATH}/.")
  'Deleted all local images cached'
end


# Create the file name from a request.
def create_filename(dimensions, url)
  IMAGES_PATH + "#{dimensions}-" + find_filename(url)
end

# Find the file name from an URL.
def find_filename(url)
  url.split('/').last
end

# Opens a specific image file from an URI.
# WORKAROUND: Sinatra match the route parameter with only one slash http:/
def open(url)
  url['http:/'] = 'http://'
  MiniMagick::Image.open url
end

# Resize an image.
def resize(image, dimensions)
  image.resize dimensions
end

# Cut out one or more rectangular regions of the image.
# WORKAROUND: http://stackoverflow.com/q/8418973/462015
def crop(image, dimensions)
  image.combine_options do |c|
    c.gravity "center"
    c.crop dimensions + "+0+0"
  end
end

# Writes the temporary file out to either a file location.
def write(image, path)
  image.write path
end

# Sends the file by streaming it 8192 bytes at a time.
def sendfile(filename)
  send_file filename,
    :type => 'image/jpeg',
    :disposition => 'inline'
end
