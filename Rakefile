require 'logger'
require 'yaml'
require 'mongo'

$LOAD_PATH.unshift File.expand_path('../lib/chatroid/lib', __FILE__)
$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'chatroid'
require 'twitter_daemon'

task :default do
  puts `rake -T`
end

namespace :db do
  desc "add indexes for your database collection"
  task :create_index do
    puts "adding indexes..."

    store = TwitterDaemon::DataStore.new
    store.collection.ensure_index(
      {"id" => 1},
      {"unique" => true, "dropDups" => true}
    )
    store.collection.ensure_index({"user.id" => 1})

    puts "done!"
  end
end
