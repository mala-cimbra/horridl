#!/usr/bin/env ruby
#encoding: utf-8

require 'sqlite3'

DATABASE = "animi.db"

DB = SQLite3::Database.open(DATABASE)

def lista(database)
    justify = 30
    lista = database.execute("SELECT * FROM animidb;")
    puts ""
    puts "- Animus list -"
    puts "#{"ID".ljust(4)}#{"Animo".ljust(justify)}\tEp.\tRisoluzione"
    lista.each do |animo|
        puts "#{animo[0].to_s.ljust(4)}#{animo[1].ljust(justify)}\t#{animo[2]}\t#{animo[3]}"
    end
    puts "--------------------------\n"
end

def vedi(database)
    lista(database)
    menu(database)
end

def aggiungi(database)
    puts "Name: (just copy the name on hs' list)"
    nome = gets.chomp.downcase
    puts "Episode: (enter for the first episode)"
    episodio = gets.chomp.to_i
    if (episodio == nil || episodio == "")
        episodio = 0
    end
    puts "Resolution: 480p, 720p, 1080p"
    puts "\t(not every animu have 1080p)"
    risoluzione = gets.chomp.downcase
    database.execute("INSERT INTO animidb (animo, episodio, risoluzione) VALUES (\"#{nome}\", \"#{episodio}\", \"#{risoluzione}\");")
    puts "Animu added!"
    puts "#######################\n"
    menu(database)
end

def modifica(database)
    lista(database)
    print "Input the number you want edit: "
    id = gets.chomp.to_i
    puts "Input the field you want to edit: "
    puts "\t1) episode"
    puts "\t2) resolution"
    puts ""
    print "Field: "
    campo = gets.chomp.to_i
    case campo
        when 1 then episodio(id, database)
        when 2 then risoluzione(id, database)
        else menu(database)
    end
end

def episodio(id, database)
    print "New episode number: "
    new_ep = gets.chomp.to_i
    database.execute("UPDATE animidb SET episodio=#{new_ep} WHERE id = \"#{id}\";")
    puts "Done!!"
    menu(database)
end

def risoluzione(id, database)
    print "New resolution: (480p, 720p, 1080p)"
    new_ris = gets.chomp.downcase
    database.execute("UPDATE animidb SET risoluzione=\"#{new_ris}\" WHERE id = \"#{id}\";")
    puts "Done!!"
    menu(database)
end

def elimina(database)
    lista(database)
    print "Select the number by ID that you want delete: "
    elimina = gets.chomp.to_i
    database.execute("DELETE FROM animidb WHERE id = \"#{elimina}\";")
    puts "Done!!"
    puts "#############################\n"
    menu(database)
end

def menu(db)
    puts "- Options -"
    puts ""
    puts "1) List all animus"
    puts "2) Add an animus"
    puts "3) Edit an animus"
    puts "4) Remove an animus"
    puts ""
    puts "Every other input will close the program."
    puts ""
    print "Select: "

    risposta = gets.to_i
    case risposta
    	when 1 then vedi(db)
        when 2 then aggiungi(db)
    	when 3 then modifica(db)
    	when 4 then elimina(db)
    	else exit(0)
    end
end

menu(DB)
