#!/usr/bin/env ruby
#encoding: utf-8
#
#------------------

require 'sqlite3'
require 'yaml'

puts """
###########################
#                         #
# HORRIBLESUBS DOWNLOADER #
#                         #
###########################
"""

database = SQLite3::Database.new("animi.db")

database.execute("CREATE TABLE animidb(id integer primary key, animo text, episodio integer, risoluzione text);")

puts "Database ready!!"
puts ""

print "Transmission username: "
usr = gets.chomp.to_s
print "Transmission password: "
psw = gets.chomp.to_s
print "Transmission host: "
host = gets.chomp.to_s

config = {"transmission" => {"username" => "#{usr}", "password" => "#{psw}", "host" => "#{host}"}, "database" => "animi.db"}

f = File.new("config.yml", "w")
f.write(config.to_yaml)

puts "Config file ready!!"
puts "Manage your animus via horridb.rb!!"
