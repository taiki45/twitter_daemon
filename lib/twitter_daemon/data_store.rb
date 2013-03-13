module TwitterDaemon
  class DataStore
    def client
      @client ||= Mongo::MongoClient.new
    end

    def config
      TwitterDaemon.datastore_conf
    end

    def db
      client.db(config[:database_name])
    end

    def collection
      @collection ||= db.collection('tweets')
    end

    def save(obj)
      collection.insert obj
    end

    def favorite(id, source)
      doc = Document.new(collection.find({"id" => id}).first)
      unless doc.nil? or doc.favorited_by(source)
        collection.update(
          {"id" => id},
          {"$inc" => {"favorite_count" => 1}, "$push" => {"favorite_users" => source}}
        )
      end
    end

    class Document
      def initialize(raw)
        @raw = raw
      end

      def favorited?
        @raw and @raw["favorite_count"] and @raw["favorite_users"]
      end

      def favorited_by(user)
        favorited_users.include?(user["id"])
      end

      def favorited_users
        favorited? ? @raw["favorite_users"].map { |source| source["id"] } : []
      end

      def method_missing(name, *args)
        @raw.send name, *args
      end

      def respond_to_missing?(name, include_private)
        @raw.respond_to_missing? name, include_private
      end
    end
  end
end
