module TwitterDaemon
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
