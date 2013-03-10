# -*- coding: utf-8 -*-
require 'yaml'
require 'mongo'

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

    def store
      @store ||= DataStore.new
    end

    def register!
      methods.each do |name|
        callbacks[$1] << method(name).to_proc if name =~ /^on_(?!time)(.+)$/
      end
      self
    end

    def on_tweet(event)
      store.save event
    end

    def on_unknown(event)
      p event
    end


    ##TODO
    # Save who favorite the tweet
    # And prevent favorite or unfavorite several times.
    def on_favorite(event)
      store.favorite event["target_object"]["id"]
      p 'favorited'
      p event["target_object"]["id"]
    end

    def on_favorite_other(event)
      store.favorite event["target_object"]["id"]
      p 'favorited other'
      p event["target_object"]["id"]
    end

    def on_unfavorite(event)
      store.unfavorite event["target_object"]["id"]
      p 'unfavorited'
      p event["target_object"]["id"]
    end

    def on_unfavorite_other(event)
      store.unfavorite event["target_object"]["id"]
      p 'unfavorited other'
      p event["target_object"]["id"]
    end
  end

  class DataStore
    def client
      @client ||= Mongo::MongoClient.new
    end

    def db
      @db ||= client.db('tweeamon')
    end

    def collection
      @collection ||= db.collection('tweets')
    end

    def save(obj)
      collection.insert obj
    end

    def find_by(id)
      collection.find({"id" => id}).first
    end

    def op_of(target)
      target["favorite_count"] ? "$inc" : "$set"
    end

    def favorite(id)
      if target = find_by(id)
        collection.update({"id" => id}, {op_of(target) => {"favorite_count" => 1}})
      end
    end

    def unfavorite(id)
      if target = find_by(id)
        collection.update({"id" => id}, {"$inc" => {"favorite_count" => -1}}) if target = find_by(id)
      end
    end
  end
end

TwitterDaemon.run! if $0 == __FILE__
