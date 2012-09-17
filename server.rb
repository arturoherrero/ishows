require 'sinatra'
require "mini_magick"

# Resize an image at the given url.
# The path looks like:
#     http://imageServer.com/width/X/urlImg
get '/width/:value/*/?' do |value, urlImg|
  image = MiniMagick::Image.open "http://#{urlImg}"
  resize image, value
  image.write "width.jpg"
end

# Resize and crop an image at the given url.
# The path looks like:
#     http://imageServer.com/crop/XxY/urlImg
get '/crop/:dimensions/*/?' do |dimensions, urlImg|
  image = MiniMagick::Image.open "http://#{urlImg}"
  resize image, dimensions + '^'
  crop image, dimensions
  image.write "crop.jpg"
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
