class RedditListingsWorker
  include SuckerPunch::Worker

  def perform
    scraper = RedditListings.new("imgur.com", 'top')

    # Ensures the connection is returned back to the pool when completed
    ActiveRecord::Base.connection_pool.with_connection do
      5.times do
        scraper.listings.each do |listing|
          image = ImgurImage.find_or_initialize_by_remote_id(listing[:url].id)
          new_record = image.new_record?
          image.title = listing[:title]
          image.nsfw = listing[:nsfw]
          image.save!
          image.tags.create!(text: listing[:subreddit])  if new_record
        end
        scraper.next_page!
      end
    end
  end
end
