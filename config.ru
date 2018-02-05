require 'rubygems'
require 'bundler'
require 'redis-sinatra'

Bundler.require

require './index.rb'

run Muraena.new