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

Pony.mail(:to => 'notexy@gmail.com', :from => 'aws-health-notify<notex@mac.com>', :subject => 'hi', :body => 'Hello there.')
