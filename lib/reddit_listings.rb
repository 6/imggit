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
      {
        title: listing['data']['title'],
        url: listing['data']['url'],
      }
    end
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

    response = RestClient.get "http://reddit.com/domain/#{@domain}/#{@sort}/.json?after=#{@current_page}", :user_agent => ENV['USER_AGENT'] || 'http://github.com/6'

    parsed_response = JSON.parse(response)
    @next_page = parsed_response['data']['after']
    @pages[@current_page][:json_response] = parsed_response
  end
end
