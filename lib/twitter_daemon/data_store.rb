module TwitterDaemon
  class DataStore
    def client
      @client ||= Mongo::MongoClient.new
    end

    def collection
      @collection ||= client.db('tweeamon').collection('tweets')
    end

    def save(obj)
      collection.insert obj
    end

    def find_by(id)
      collection.find({"id" => id}).first
    end

    def favorite(id, source)
      if tweet = find_by(id)
        if !(tweet["favorite_users"]) || (tweet["favorite_users"] && !(tweet["favorite_users"].map {|source| source["id"] }.include?(source["id"])))
          collection.update(
            {"id" => id},
            {"$inc" => {"favorite_count" => 1}, "$push" => {"favorite_users" => source}}
          )
        end
      end
    end
  end
end
