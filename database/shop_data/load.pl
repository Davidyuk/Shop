#!/usr/bin/perl
use strict;
use warnings;
use utf8;

binmode(STDOUT,':utf8');

use DBI;

my $file;
open($file, '<:utf8', 'dns_price.csv') or die "Could not open file $!";
my $line = 0;

my $db = DBI->connect('dbi:Pg:dbname=shop;host=localhost', 'postgres', 'QWE-123', { pg_enable_utf8 => 1, pg_utf8_strings => 1 }) or die $DBI::errstr;

sub get_category_location {
	my ($id) = @_;
	my $sql = 'select location from categories where id = ?';
	my $sth = $db->prepare($sql) or die $db->errstr;
	$sth->execute($id) or die $sth->errstr;
	my @arr = $sth->fetchrow_array;
	if ($#arr != -1) {
		return $arr[0];
	}
}

sub get_category_id {
	my ($name, $parent_id) = @_;
	#print "get_category_id : $name\n";
	my $sql = 'select id, name from categories where name = ?';
	my $sth = $db->prepare($sql) or die $db->errstr;
	$sth->execute($name) or die $sth->errstr;
	my @arr = $sth->fetchrow_array;
	if ($#arr != -1) {
		#print "get_category_id : $arr[0], $arr[1]\n";
		return $arr[0];
	} else {
		my $sql = 'INSERT INTO categories(name, location) VALUES (?, ?);';
		my $sth = $db->prepare($sql) or die $db->errstr;
		my $location = '';
		if (defined get_category_location($parent_id) && get_category_location($parent_id) ne '') {
			$location .= get_category_location($parent_id) . ',';
		}
		$location .= $parent_id;
		$sth->execute($name, $location) or die $sth->errstr;
		return get_category_id($name);
	}
}

sub get_store_id {
	my $name = shift;
	my $sql = 'select id, name from stores where name = ?';
	#$db->do(qq{SET NAMES 'utf8';});
	my $sth = $db->prepare($sql) or die $db->errstr;
	$sth->execute($name) or die $sth->errstr;
	my @arr = $sth->fetchrow_array;
	if ($#arr != -1) {
		#print "test $arr[1]\n";
		return $arr[0];
	} else {
		my $sql = 'INSERT INTO stores(name) VALUES (?);';
		#$db->do(qq{SET NAMES 'utf8';});
		my $sth = $db->prepare($sql) or die $db->errstr;
		$sth->execute($name) or die $sth->errstr;
		return get_store_id($name);
	}
}

sub get_item_id { #($name, $category_id)
	my ($name, $price, $category_id) = @_;
	#print "get_item_id : $name, $price, $category_id\n";
	my $sql = 'select id, name from catalog where name = ?';
	my $sth = $db->prepare($sql) or die $db->errstr;
	$sth->execute($name) or die $sth->errstr;
	my @arr = $sth->fetchrow_array;
	if ($#arr != -1) {
		#print "test $arr[1]\n";
		return $arr[0];
	} else {
		my $sql = 'INSERT INTO catalog(name, price, category_id) VALUES (?, ?, ?);';
		my $sth = $db->prepare($sql) or die $db->errstr;
		$sth->execute($name, $price, $category_id) or die $sth->errstr;
		return get_item_id($name, $price, $category_id);
	}
}

sub set_stocks {
	my ($item_id, $store_id, $count) = @_;
	my $sql = 'INSERT INTO stocks(catalog_id, store_id, count) VALUES (?, ?, ?);';
	my $sth = $db->prepare($sql) or die $db->errstr;
	$sth->execute($item_id, $store_id, $count) or die $sth->errstr;
}

#my $category = get_category_id("Category1");
#my $item = get_item_id("Item1", 4, $category);
#my $store = get_store_id("Store1");
#print "\n$category $item $store \n";
#set_stocks($item, $store, 15);

my $category_id;
while (my $row = <$file>) {
	chomp $row;
	my $name;
	if ('"' eq substr($row, 0, 1)) {
		$name = substr($row, 1, rindex($row, '";') - 1);
		$name =~ s/""/"/g;
		$row = substr($row, rindex($row, '";') + 2);
	} else {
		$name = substr($row, 0, index($row, ';'));
		$row = substr($row, index($row, ';') + 1);
	}
	
	#print "row - $row\n";
	my @cells = split(/;/, $row);
	#require Data::Dumper;
	#print STDERR Data::Dumper::Dumper( @cells );
	#print "cells[0] - $cells[0]\n";
	
	if (! defined $cells[0]) {
		next; #brand name
	} elsif ($cells[0] eq 'цена, руб') {
		$category_id = 0;
		foreach my $i (split(/\//, $name)) {
			$i =~ s/^\s+|\s+$//g;
			$category_id = get_category_id($i, $category_id)
		}
	} else {
		my $item_id = get_item_id($name, $cells[0], $category_id);
		for (my $i = 1; $i < $#cells; ++$i) {
			if ($cells[$i] ne '') {
				set_stocks($item_id, get_store_id($cells[$i]), int(rand(50) + 1));
			}
		}
	}
	#print "\n";
	#last if (++$line == 4);
}

#my $sql = 'select item_id, item_name, item_price from items';
#my @ins = ();
#if ( defined params->{'q'} && params->{'q'} ne '' ) {
#	$sql .= q{ where item_name like ?};
#	@ins = ('%'.params->{'q'}.'%');
#}
#my $sth = $db->prepare($sql) or die $db->errstr;
#$sth->execute(@ins) or die $sth->errstr;
#template 'index', {
#	'items' => $sth->fetchall_hashref('item_id')
#};