class RedditListings
  def initialize(domain, sort = 'top')
    @domain = domain
    @sort = sort
    @current_page = nil
    @next_page = nil
    @pages = {}
    @pages[@current_page] = {}
  end

  def listings
    @pages[@current_page][:listings] ||= json_response['data']['children'].map do |listing|
      begin
        {
          title: listing['data']['title'],
          url: ImgurUrl::Image.new(listing['data']['url']),
          nsfw: listing['data']['over_18'],
        }
      rescue ImgurUrl::Exception => e
      end
    end.delete_if(&:nil?)
  end

  def next_page!
    json_response
    @current_page = @next_page
    @pages[@current_page] ||= {}
    json_response
  end

  private

  def json_response
    return @pages[@current_page][:json_response]  if @pages[@current_page][:json_response]

    response = RestClient.get "http://reddit.com/domain/#{@domain}/#{@sort}/.json?after=#{@current_page}", :user_agent => ENV['USER_AGENT'] || 'imggit - http://github.com/6/imggit'

    parsed_response = JSON.parse(response)
    @next_page = parsed_response['data']['after']
    @pages[@current_page][:json_response] = parsed_response
  end
end
