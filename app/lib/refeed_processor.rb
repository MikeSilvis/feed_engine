require 'json'
require 'net/http'
require 'twitter'
require "./config/initializers/twitter"

module Hungrlr
  class RefeedProcessor
    attr_accessor :base_url

    def initialize
      self.base_url = ENV["DOMAIN"].present? ? ENV["DOMAIN"] : "http://api.lvh.me:3000/v1"
    end

    def subscriptions
      subscriptions = Net::HTTP.get(URI("#{base_url}/subscriptions.json?token=HUNGRLR"))
      JSON.parse(subscriptions)["subscriptions"]
    end

    def get_growls(user_slug, last_status_id)
      growls = Net::HTTP.get(URI("#{base_url}/feeds/#{user_slug}.json?token=HUNGRLR&since=#{last_status_id}"))
      JSON.parse(growls)["items"]["most_recent"]
      # puts JSON.parse(growls)["items"]["most_recent"].inspect
    end

    def create_regrowls_for(user_slug, subscriber_token, growls)
      growls.each do |growl|
        uri_path = URI("#{base_url}/feeds/#{user_slug}/growls/#{growl["id"]}/refeed")
        Net::HTTP.post_form(uri_path, token: subscriber_token)
      end
    end

    def run
      subscriptions.each do |subscription|
        growls = get_growls(subscription["user_slug"], subscription["last_status_id"])
        create_regrowls_for(subscription["user_slug"], subscription["subscriber_token"], growls)
      end
    end
  end
end

# processor = Hungrlr::RefeedProcessor.new
# raise processor.subscriptions.inspect
# raise processor.get_growls("wengzilla", "1").inspect
# processor.run