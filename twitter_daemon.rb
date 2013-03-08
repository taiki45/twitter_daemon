# -*- coding: utf-8 -*-
require 'yaml'
require 'twitter'

$LOAD_PATH.unshift File.expand_path('../lib/chatroid/lib', __FILE__)
require 'chatroid'

require 'pry'

module TwitterDaemon
  class << self
    def config
      @config ||= Hash[YAML.load_file(path).map {|k, v| [k.to_sym, v] }]
    end

    def path
      File.expand_path('../config.yaml', __FILE__)
    end

    def run!
      Signal.trap :INT do
        puts "\nexitting.."
        exit
      end
      puts 'starting...'
      Client.new.register!.run!
    end
  end

  class Client < Chatroid
    def initialize
      TwitterDaemon.config.each do |key, val|
        set key, val
      end
    end

    def register!
      methods.each do |name|
        callbacks[$1] << method(name).to_proc if name =~ /^on_(?!time)(.+)$/
      end
      self
    end

    def on_tweet(event)
    end

    def on_favorite(event)
      p event["target"]
    end

    def on_favorite_other(event)
      p event["target"]
    end
  end
end

TwitterDaemon.run! if $0 == __FILE__
