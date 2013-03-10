# -*- coding: utf-8 -*-

module TwitterDaemon
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
end
