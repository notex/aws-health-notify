#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'yaml'
require 'date'
require 'feedjira'
require 'pony'
require 'pp'

require './models'


def save_entry(feed_key, entry)
    RssEntry.create(
        :feed_key => feed_key,
        :entry_id => entry.entry_id,
        :title => entry.title,
        :summary => entry.summary,
        :url => entry.url,
        :published => entry.published
    )
end


Pony.options = {
  :via => :smtp,
  :via_options => {
    :address => 'smtp.sendgrid.net',
    :port => '587',
    :domain => 'heroku.com',
    :user_name => ENV['SENDGRID_USERNAME'],
    :password => ENV['SENDGRID_PASSWORD'],
    :authentication => :plain,
    :enable_starttls_auto => true
  }
}

setting =  YAML.load_file('settings.yml')

setting['rss_feeds'].each do |feed_key, feed_url|

    feed = Feedjira::Feed.fetch_and_parse(feed_url)
    rss_feed_model = RssFeed.where(feed_key: feed_key).first
    if rss_feed_model.nil? then
        RssFeed.create(
            :feed_key => feed_key,
            :title => feed.title,
            :feed_url => feed.feed_url,
            :etag => feed.etag,
            :last_modified => feed.last_modified
        )
    else
        rss_feed_model.last_modified = feed.last_modified
        rss_feed_model.save
    end
    
    new_feeds = [];
    latest_rss_entry_model = RssEntry.where(feed_key: feed_key).last
    feed.entries.reverse.each do |entry|
        if latest_rss_entry_model.nil? or entry.published > latest_rss_entry_model.published then
            save_entry(feed_key, entry)
            new_feeds << entry unless latest_rss_entry_model.nil?
        end
    end
    
    if ENV.key?('RACK_ENV') and ENV['RACK_ENV'] == 'production' and new_feeds.count > 0 then
        new_feeds.each do |entry|
            mail_subject = "[aws-health-notify #{feed_key}] #{entry.title}"
            mail_body = entry.summary + "\n\n" + entry.url
            setting['mail_to'].each do |mail_to|
                Pony.mail(
                  :to => mail_to,
                  :from => setting['mail_from'],
                  :subject => mail_subject,
                  :body => mail_body
                )
            end
        end
    end
    
end

puts 'done.'