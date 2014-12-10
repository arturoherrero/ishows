require "server"
require "rack/test"

describe Server do
  include Rack::Test::Methods

  let(:url)        { "http://www.thetvdb.com/banners/fanart/original/81189-43.jpg" }
  let(:filename)   { "bb3c1ebe443d97df948f77c078075a51b1b6c143" }
  let(:value)      { "305" }
  let(:dimensions) { "305x105" }
  let(:image)      { MiniMagick::Image.open(path) }
  subject(:app)    { Server.new }

  after { File.delete(path) }

  describe "resize" do
    let(:path) { "#{IMAGES_PATH}#{value}-#{filename}" }

    it "resizes an image" do
      get "/width/#{value}/#{url}"

      expect(image[:width]).to eq 305
      expect(last_response).to be_ok
    end
  end

  describe "crop" do
    let(:path) { "#{IMAGES_PATH}#{dimensions}-#{filename}" }

    it "crops an image" do
      get "/crop/#{dimensions}/#{url}"

      expect(image[:width]).to eq 305
      expect(image[:height]).to eq 105
      expect(last_response).to be_ok
    end
  end
end
