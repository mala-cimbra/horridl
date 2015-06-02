#!/usr/bin/env ruby
#encoding: utf-8

require 'sqlite3'

DATABASE = "animi.db"

DB = SQLite3::Database.open(DATABASE)

def lista(database)
    justify = 30
    lista = database.execute("SELECT * FROM animidb;")
    puts ""
    puts "Lista degli animi attuali"
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
    puts "Inserire il nome (copiare su quello che c'è scritto su HS)"
    nome = gets.chomp.downcase
    puts "Inserire l'episodio di partenza (invio per 0 che è il primo ep"
    episodio = gets.chomp.to_i
    if (episodio == nil || episodio == "")
        episodio = 0
    end
    puts "Inserire la risoluzione: 480p, 720p, 1080p"
    puts "\t(non tutti gli animi sono in 1080p)"
    risoluzione = gets.chomp.downcase
    database.execute("INSERT INTO animidb (animo, episodio, risoluzione) VALUES (\"#{nome}\", \"#{episodio}\", \"#{risoluzione}\");")
    puts "Animo aggiunto!!"
    puts "#######################\n"
    menu(database)
end

def modifica(database)
    lista(database)
    print "Inserisci il numero corrispondente all'anime che vuoi modificare: "
    id = gets.chomp.to_i
    puts "Inserisci il campo da modificare"
    puts "\t1) episodio"
    puts "\t2) risoluzione"
    puts ""
    print "Campo: "
    campo = gets.chomp.to_i
    case campo
        when 1 then episodio(id, database)
        when 2 then risoluzione(id, database)
        else menu(database)
    end
end

def episodio(id, database)
    print "Nuovo valore dell'episodio: "
    new_ep = gets.chomp.to_i
    database.execute("UPDATE animidb SET episodio=#{new_ep} WHERE id = \"#{id}\";")
    puts "Modificato!!"
    menu(database)
end

def risoluzione(id, database)
    print "Nuovo valore dell'episodio: "
    new_ris = gets.chomp.downcase
    database.execute("UPDATE animidb SET risoluzione=\"#{new_ris}\" WHERE id = \"#{id}\";")
    puts "Modificato!!"
    menu(database)
end

def elimina(database)
    lista(database)
    print "Inserisci il numero corrispondente all'anime che vuoi eliminare: "
    elimina = gets.chomp.to_i
    database.execute("DELETE FROM animidb WHERE id = \"#{elimina}\";")
    puts "Animo eliminato!!"
    puts "#############################\n"
    menu(database)
end

def menu(db)
    puts "Cosa vuoi fare?"
    puts ""
    puts "1) Vedere gli animi inseriti"
    puts "2) Aggiungere un animo"
    puts "3) Modificare gli animi inseriti"
    puts "4) Eliminare una serie anime"
    puts ""
    puts "Qualsiasi altra risposta chiude il programma."
    puts ""
    print "Opzione: "

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
