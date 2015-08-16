#!/usr/bin/env ruby
#encoding: utf-8
require 'nokogiri'
require 'open-uri'
require 'sqlite3'
require 'yaml'

#db animidb
#animo, episodio, risoluzione

# ------------------
# configurazione
# ------------------

folder = "/home/pi/horridl/"

if (!File.exist?("#{folder}animi.db") || !File.exist?("#{folder}config.yml"))
    puts "DB and/or config file missing!!"
    puts "Run horrisetup.rb first!!"
    exit(0)
end

config = YAML.load(File.open("#{folder}config.yml","r"))

transmission_username = config["transmission"]["username"]
transmission_password = config["transmission"]["password"]
transmission_host = config["transmission"]["host"]

# ------------------
# var usabili sempre
# ------------------
LINK_SEARCH = "http://horriblesubs.info/lib/search.php?value="
DATABASE = config["database"]

DB = SQLite3::Database.open(folder + DATABASE)

ANIMO_NOME_DB = DB.execute "SELECT animo FROM animidb"
ANIMO_NOME = ANIMO_NOME_DB.flatten

ANIMO_NOME.each do |animo|
    risoluzione_db = DB.execute "SELECT risoluzione FROM animidb WHERE animo like \"#{animo}\""
    risoluzione = risoluzione_db.flatten[0]
    
    episodio_db = DB.execute "SELECT episodio FROM animidb WHERE animo like \"#{animo}\""
    episodio = episodio_db.flatten[0].to_i
    
    pagina = Nokogiri::HTML(open(LINK_SEARCH + animo.split.join("%20")))
    
    episodio_hs = pagina.css("body").css("div")[0]["id"].split("-").last.to_i
    
    if episodio < episodio_hs
	link = pagina.css("body").css("div")[0].css("div.resolution-block").css("span#" + risoluzione).css("a")[0]["href"]
	system("transmission-remote #{transmission_host}:9091 --auth #{transmission_username}:#{transmission_password} --add \"#{link}\"")
	DB.execute "UPDATE animidb SET episodio=#{episodio_hs} WHERE animo like \"#{animo}\""
    end
end
