require 'sinatra'
require "mini_magick"

# Resize an image at the given url.
# The path looks like:
#     http://imageServer.com/width/X/url
get '/width/:value/*/?' do |value, url|
  image = open url
  resize image, value
  write image, "width" + find_file_name(url)
end

# Resize and crop an image at the given url.
# The path looks like:
#     http://imageServer.com/crop/XxY/url
get '/crop/:dimensions/*/?' do |dimensions, url|
  image = open url
  resize image, dimensions + '^'
  crop image, dimensions
  write image, "crop" + find_file_name(url)
end


# Find the name of the file for a url.
def find_file_name(url)
  file_name = url.split('/').last
end


# Opens a specific image file either on the local file system or at a URI.
def open(url)
  file_name = find_file_name(url)

  if File.exists?(file_name)
    open_from_file file_name
  else
    image = open_from_uri url
    write image, file_name
    image
  end
end

def open_from_uri(url)
  MiniMagick::Image.open "http://#{url}"
end

def open_from_file(path)
  MiniMagick::Image.open path
end


# Writes the temporary file out to either a file location.
def write(image, path)
  image.write path
end


# MiniMagick gives you access to all the commandline options ImageMagick has.
# http://www.imagemagick.org/script/command-line-options.php#resize
# http://www.imagemagick.org/script/command-line-options.php#crop
# http://www.imagemagick.org/script/command-line-processing.php#geometry

# Resize an image.
def resize(image, dimensions)
  image.resize dimensions
end

# Cut out one or more rectangular regions of the image.
# WORKAROUND: http://stackoverflow.com/q/8418973/462015
def crop(image, dimensions)
  image.crop dimensions + "+0+0"
end
