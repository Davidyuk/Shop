package Shop::DB;
use strict;
use warnings;
use Shop::Schema;

my $db;

# db singleton
sub db {
	$db ||= Shop::Schema->connect('dbi:Pg:dbname=shop;host=localhost', 'postgres', 'QWE-123');
}

1;