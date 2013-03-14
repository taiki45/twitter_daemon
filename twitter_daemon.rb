# -*- coding: utf-8 -*-
require 'logger'
require 'yaml'
require 'mongo'

$LOAD_PATH.unshift File.expand_path('../lib/chatroid/lib', __FILE__)
$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'chatroid'
require 'twitter_daemon/client'
require 'twitter_daemon/data_store'
require 'twitter_daemon/logging'

module TwitterDaemon
  CLIENT_CONF = %w(
    service consumer_key consumer_secret access_key access_secret
  ).map {|e| e.to_sym }.freeze

  class << self
    include Logging

    def config
      @config ||= Hash[YAML.load_file(path).map {|k, v| [k.to_sym, v] }]
    end

    def client_conf
      config.select {|k, v| CLIENT_CONF.include? k }
    end

    def datastore_conf
      config.select {|k, v| [:database_name].include? k }
    end

    def path
      File.expand_path('../config.yaml', __FILE__)
    end

    def run!
      info 'starting service...'
      Client.new(client_conf).register!.run!
    end
  end
end

TwitterDaemon.run! if $0 == __FILE__
