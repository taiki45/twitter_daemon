# -*- coding: utf-8 -*-
require 'json'
require 'yaml'
require 'twitter/json_stream'
require 'twitter'

module TwitterDaemon
  class << self
    def config
      @config ||= Hash[YAML.load_file(path).map {|k, v| [k.to_sym, v] }]
    end

    def path
      File.expand_path('../config.yaml', __FILE__)
    end

    def client
      @client ||= Client.new(config)
    end

    def run!
      Signal.trap :INT do
        puts "\nexitting.."
        exit 0
      end

      puts 'starting...'
      start_stream
    end

    def start_stream
      EventMachine::run do
        stream = Twitter::JSONStream.connect(
          host: 'userstream.twitter.com',
          path: '/1.1/user.json',
          port: 443,
          ssl: true,
          oauth: {
            consumer_key: config[:consumer_key],
            consumer_secret: config[:consumer_secret],
            access_key: config[:oauth_token],
            access_secret: config[:oauth_token_secret]
          }
        )

        stream.each_item do |json|
          client.respond JSON.parse(json), json
        end

        stream.on_error do |message|
          puts message
        end

        stream.on_max_reconnects do |timeout, retries|
          puts "max reconnected. timeout: #{timeout}, retries: #{retries}"
          sleep 60 * 15
        end
      end
    end
  end

  class Client
    def initialize(config)
      @client = Twitter::Client.new config
    end

    def respond(event, json)
      __send__ 'on_' + event['event'], event, json
    end

    def on_favorite(event, json)
    end

    def on_unfavorite(event, json)
    end
  end
end

TwitterDaemon.run! if $0 == __FILE__
