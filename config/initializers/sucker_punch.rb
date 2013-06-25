SuckerPunch.config do
  queue name: :reddit_listings_scraper, worker: RedditListingsWorker, workers: 2
end
