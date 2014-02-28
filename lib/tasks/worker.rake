#!/usr/bin/env ruby
require 'rubygems'
require 'bundler/setup'

namespace :ci do
  desc "Run the builder forever"
  task :runonce => :environment do
    Runner.new.runonce
  end


  desc "Runs a single build then dies"
  task :run => :environment do
    Runner.new.start
  end
end