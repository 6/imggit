require 'spec_helper'

describe RedditListingsWorker, worker: true do
  describe "#perform" do
    let(:listings) do
      [
        {
          title: 'Image 1',
          url: ImgurUrl::Image.new('http://imgur.com/abcde'),
          nsfw: false,
        },
        {
          title: 'Image 2',
          url: ImgurUrl::Image.new('http://imgur.com/cdefg'),
          nsfw: true,
        },
        {
          title: 'Image 3',
          url: ImgurUrl::Image.new('http://imgur.com/fghij'),
          nsfw: false,
        },
      ]
    end

    before(:each) do
      RedditListings.any_instance.stub(:listings) { listings }
      RedditListings.any_instance.stub(:next_page!)
    end

    def go!
      SuckerPunch::Queue.new(:reddit_listings_scraper).async.perform
    end

    it "creates new ImgurImage models if they are not already in database" do
      expect { go! }.to change { ImgurImage.count }.by(listings.size)
    end

    it "sets the expected title and remote_id values on each created model" do
      go!

      ImgurImage.find_by_remote_id("abcde").tap do |i|
        i.title.should == 'Image 1'
        i.should_not be_nsfw
      end
      ImgurImage.find_by_remote_id("cdefg").tap do |i|
        i.title.should == 'Image 2'
        i.should be_nsfw
      end
      ImgurImage.find_by_remote_id("fghij").tap do |i|
        i.title.should == 'Image 3'
        i.should_not be_nsfw
      end
    end

    it "does not create duplicate models" do
      existing_image = FactoryGirl.create(:imgur_image, remote_id: listings.first[:url].id)

      expect { go! }.to change { ImgurImage.count }.by(2)
      ImgurImage.find_by_remote_id(listings.first[:url].id).should == existing_image
    end

    it "paginates for 3 pages" do
      RedditListings.any_instance.should_receive(:next_page!).exactly(3).times
      go!
    end
  end
end
