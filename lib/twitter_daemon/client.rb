# -*- coding: utf-8 -*-

module TwitterDaemon
  class Client < Chatroid
    include Logging

    def initialize(config)
      config.each { |key, val| set key, val }
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

    def on_favorite(event)
      store.favorite(event["target_object"]["id"], event['source'])
      info "favorited by #{event['source']['screen_name']}"
    end

    def on_favorite_other(event)
      store.favorite(event["target_object"]["id"], event['source'])
      info "favorited #{event['target_object']['screen_name']}"
    end
  end
end
