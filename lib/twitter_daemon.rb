# -*- coding: utf-8 -*-
require 'twitter_daemon/logging'
require 'twitter_daemon/client'
require 'twitter_daemon/data_store'

module TwitterDaemon
  CLIENT_CONF = %w(
    service consumer_key consumer_secret access_key access_secret
  ).map(&:to_sym).freeze

  class << self
    include Logging

    def config
      @config ||= Hash[YAML.load_file(path).map { |k, v| [k.to_sym, v] }]
    end

    def client_conf
      config.select { |k, v| CLIENT_CONF.include? k }
    end

    def datastore_conf
      config.select { |k, v| [:database_name].include? k }
    end

    def path
      File.expand_path('../../config.yaml', __FILE__)
    end

    def run!
      info 'starting service...'
      loop do
        begin
          Client.new(client_conf).register!.run!
        rescue => e
          fatal e
        end
      end
    end
  end
end
