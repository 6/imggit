def update_imgur_images!
  SuckerPunch::Queue.new(:reddit_listings_scraper).async.perform
end

task :update_images => :environment do
  update_imgur_images!
end
