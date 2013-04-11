# -*- coding: utf-8 -*-
require 'logger'
require 'yaml'
require 'mongo'

require 'pry'

$LOAD_PATH.unshift File.expand_path('../lib/chatroid/lib', __FILE__)
$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'chatroid'
require 'twitter_daemon'


TwitterDaemon.run! if $0 == __FILE__
