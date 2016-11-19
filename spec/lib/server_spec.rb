require "server"

RSpec.describe Server do
  let(:url)        { "http://www.thetvdb.com/banners/fanart/original/81189-43.jpg" }
  let(:filename)   { "bb3c1ebe443d97df948f77c078075a51b1b6c143" }
  let(:value)      { "305" }
  let(:dimensions) { "305x105" }
  let(:image)      { MiniMagick::Image.open(Dir["#{IMAGES_PATH}/*"].first) }
  subject(:app)    { Server.new }

  after(:all) { FileUtils.rm_rf(Dir.glob("#{IMAGES_PATH}/*")) }

  describe "GET /resize" do
    it "resizes the image with the right width" do
      get "/width/#{value}/#{url}"

      expect(image[:width]).to eq(305)
      expect(last_response).to be_ok
    end
  end

  describe "GET /crop" do
    it "crops the image with the right dimensions" do
      get "/crop/#{dimensions}/#{url}"

      expect(image[:width]).to  eq(305)
      expect(image[:height]).to eq(105)
      expect(last_response).to  be_ok
    end

    context "for a https image" do
      let(:url)  { "https://www.thetvdb.com/banners/fanart/original/81189-43.jpg" }

      it "crops the image with the right dimensions" do
        get "/crop/#{dimensions}/#{url}"

        expect(image[:width]).to  eq(305)
        expect(image[:height]).to eq(105)
        expect(last_response).to  be_ok
      end
    end
  end
end
