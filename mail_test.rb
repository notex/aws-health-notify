#!/usr/bin/env ruby
# -*- coding:utf-8 -*-

require 'pony'

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

Pony.mail(
  :to => [],
  :bcc => ['notexy@gmail.com', 'notex@mac.com'],
  :from => 'aws-health-notify<app34367913@heroku.com>',
  :subject => '日本語',
  :body => 'こんにちは'
)
