require 'spec_helper'

describe RedditListings do
  let(:raw_listings_json) { File.read(File.join(fixture_path, 'listings_imgur_top.json')) }

  before(:each) do
    RestClient.stub(:get) { raw_listings_json }
  end

  subject { described_class.new('imgur.com', 'top') }

  describe "#listings" do
    it "returns an array of listings hashes" do
      subject.listings.size.should == 19
      subject.listings.each do |listing|
        listing[:title].should_not be_empty
        listing[:url].should be_a(ImgurUrl::Image)
        listing[:url].id.should_not be_empty
        (listing[:nsfw].is_a?(TrueClass) || listing[:nsfw].is_a?(FalseClass)).should be_true
      end
    end
  end

  describe "#next_page!" do
    it "uses the correct `after` param for the next page" do
      RestClient.should_receive(:get).with("http://reddit.com/domain/imgur.com/top/.json?after=t3_1gi3vo", kind_of(Hash)).and_return(raw_listings_json)
      subject.next_page!
    end
  end
end
