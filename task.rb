#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'yaml'
require 'date'
require 'feedjira'
require 'pp'

require './models'

setting =  YAML.load_file('setting.yml')

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
    
    latest_rss_entry_model = RssEntry.where(feed_key: feed_key).last
    feed.entries.reverse.each do |entry|
        if latest_rss_entry_model.nil? or entry.published > latest_rss_entry_model.published then
            rss_entry_model = RssEntry.create(
                :feed_key => feed_key,
                :entry_id => entry.entry_id,
                :title => entry.title,
                :summary => entry.summary,
                :url => entry.url,
                :published => entry.published
            )
        end
    end
    
end

puts 'done.'