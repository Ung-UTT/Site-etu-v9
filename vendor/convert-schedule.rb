#!/usr/bin/env ruby

# Convertit les exports de la base SQL de l'UTT en un fichier .marshal
# qui est un hash de trois tableaux : horaires, salles et utilisateurs

# À partir des fichiers .sql reçus, il faut les importer dans une base
# MySQL

require File.expand_path("../../config/environment", __FILE__)

DB_FILE = Rails.root.join('vendor', 'data', 'schedule.marshal')

