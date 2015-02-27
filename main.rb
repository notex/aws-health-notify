require 'sinatra'
require 'yaml'
require 'pp'

require './models'

set :public_folder, File.dirname(__FILE__) + '/public'

configure do
    yml = YAML.load_file('settings.yml')
    yml.each do |k, v|
       set k, v
    end
end

get '/' do
    @feeds = []
    settings.rss_feeds.keys.each do |feed_key|
        rss_feed_model = RssFeed.where(feed_key: feed_key).first
        rss_entry_models = RssEntry.where(feed_key: feed_key).last
        latest_rss_entry_model = RssEntry.where(feed_key: feed_key).last
        @feeds << { :feed => rss_feed_model, :latest_entry => latest_rss_entry_model }
    end
    
    erb :index
end