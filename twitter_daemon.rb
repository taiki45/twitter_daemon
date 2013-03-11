# -*- coding: utf-8 -*-
require 'yaml'
require 'mongo'

require 'pry'

$LOAD_PATH.unshift File.expand_path('../lib/chatroid/lib', __FILE__)
$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'chatroid'
require 'twitter_daemon/client'
require 'twitter_daemon/data_store'

module TwitterDaemon
  class << self
    def config
      @config ||= Hash[YAML.load_file(path).map {|k, v| [k.to_sym, v] }]
    end

    def path
      File.expand_path('../config.yaml', __FILE__)
    end

    def run!
      puts 'starting...'
      Client.new(config).register!.run!
    end
  end
end

TwitterDaemon.run! if $0 == __FILE__
