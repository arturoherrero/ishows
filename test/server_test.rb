require 'rubygems'
require 'test/unit'
require 'rack/test'
require 'lib/server.rb'

class ServerTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def setup
    @url = 'http://www.thetvdb.com/banners/fanart/original/81189-43.jpg'
    @url_one_slash = 'http:/www.thetvdb.com/banners/fanart/original/81189-43.jpg'
    @filename = '81189-43.jpg'
    @value = '305'
    @dimensions = '305x105'
  end

  def app
    Sinatra::Application
  end


  def test_image_path_directory_exists
    assert File.exists?(IMAGES_PATH)
  end

  def test_create_filename_with_dimensions_and_url
    assert_equal "#{IMAGES_PATH}#{@dimensions}-#{@filename}", create_filename(@dimensions, @url)
  end

  def test_find_filename_from_url
    assert_equal @filename, find_filename(@url)
  end


  def test_image_open
    image = open(@url_one_slash)
    assert image.valid?
    image.destroy!
  end

  def test_image_resize
    image = open(@url_one_slash)
    resize(image, @value)
    assert_equal 305, image[:width]
    assert_match 'JPEG', image[:format]
    image.destroy!
  end

  def test_image_crop
    image = open(@url_one_slash)
    crop(image, @dimensions)
    assert_equal 305, image[:width]
    assert_equal 105, image[:height]
    assert_match 'JPEG', image[:format]
    image.destroy!
  end

  def test_image_write
    image = open(@url_one_slash)
    write(image, @filename)
    assert File.exists?(@filename)
    File.delete(@filename)
    image.destroy!
  end


  def test_width_image
    get "/width/#{@value}/#{@url}"

    path = "#{IMAGES_PATH}#{@value}-#{@filename}"
    assert File.exists?(path)

    image = MiniMagick::Image.open(path)
    assert_equal 305, image[:width]
    assert last_response.ok?

    File.delete(path)
    image.destroy!
  end

  def test_crop_image
    get "/crop/#{@dimensions}/#{@url}"

    path = "#{IMAGES_PATH}#{@dimensions}-#{@filename}"
    assert File.exists?(path)

    image = MiniMagick::Image.open(path)
    assert_equal 305, image[:width]
    assert_equal 105, image[:height]
    assert last_response.ok?

    File.delete(path)
    image.destroy!
  end

  def test_clear_image_directory
    get '/clear'
    assert Dir["#{IMAGES_PATH}/*"].empty?
    assert last_response.ok?
    assert_equal 'Deleted all local images cached', last_response.body
  end
end
