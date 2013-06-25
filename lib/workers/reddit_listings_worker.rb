class RedditListingsWorker
  include SuckerPunch::Worker

  def perform
    scraper = RedditListings.new("imgur.com", 'top')

    # Ensures the connection is returned back to the pool when completed
    ActiveRecord::Base.connection_pool.with_connection do
      3.times do
        scraper.listings.each do |listing|
          image = ImgurImage.find_or_initialize_by_remote_id(listing[:url].id)
          image.title = listing[:title]
          image.nsfw = listing[:nsfw]
          image.save!
        end
        scraper.next_page!
      end
    end
  end
end
