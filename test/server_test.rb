require 'rubygems'
require 'test/unit'
require 'rack/test'
require 'lib/server.rb'
 
class ServerTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def setup
    @url = 'http://www.thetvdb.com/banners/fanart/original/81189-43.jpg'
    @filename = '81189-43.jpg'
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

  def test_clear_image_directory
    get '/clear'
    assert last_response.ok?
    assert_equal 'Deleted all local images cached', last_response.body
  end
end
