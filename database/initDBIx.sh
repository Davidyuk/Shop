#!/bin/bash
#DBIx::Class::Schema::Loader
dbicdump Shop::Schema 'dbi:Pg:dbname=shop;host=localhost' 'postgres' 'QWE-123'
#dbicdump -o dump_directory=./lib Shop::Schema 'dbi:Pg:dbname=shop;host=localhost' 'postgres' 'QWE-123'
#pause