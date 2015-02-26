# -*- coding: utf-8 -*-
require 'mongoid'
Mongoid.load!('./mongoid.yml')

class RssFeed
  include Mongoid::Document
  field :feed_key,   type: String
  field :title,   type: String
  field :feed_url,   type: String
  field :etag,   type: String
  field :last_modified, type: DateTime
end

class RssEntry
  include Mongoid::Document
  field :feed_key,   type: String
  field :entry_id,  type: String
  field :title,  type: String
  field :summary,  type: String
  field :url,  type: String
  field :published, type: DateTime
end