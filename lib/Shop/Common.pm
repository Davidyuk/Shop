package Shop::Common;
use Dancer ':syntax';
use strict;
use warnings;

use Exporter;
our @ISA= qw( Exporter );
our @EXPORT = qw( addMessage addUserMenuItem timeToText printd error404 isParamNEmp isParamEq isParamUInt );

sub addMessage {
	#printd(vars->{messages});
	#var messages => [] unless vars->{messages};
	session messages => [] unless session('messages');
	session messages => [ @{session('messages')}, {
		text => shift,
		type => shift
	}];
	#printd(vars->{messages});
	#var messages => [ @{vars->{messages}}, {
	#	text => shift,
	#	type => shift
	#}];
	#printd(vars->{messages});
}

sub addUserMenuItem {
	var menu_user => [] unless vars->{menu_user};
	var menu_user => [ @{vars->{menu_user}}, shift];
}

use DateTime::Format::Pg;
use DateTime::Format::CLDR;
use DateTime::Locale::ru;

sub timeToText {
	my $locale = DateTime::Locale->load('ru_RU');
	my $cldr = DateTime::Format::CLDR->new(
		pattern => $locale->date_format_long, #datetime_format_full, date_format_full
		locale => $locale
	);
	return $cldr->format_datetime(DateTime::Format::Pg->parse_datetime(shift));
}

sub printd {
	say STDERR Data::Dumper::Dumper( shift );
}

sub error404 {
	status 404;
	addMessage('Ошибка 404. Нет такой страницы.', 'danger');
	forward '/catalog';
}

sub isParamNEmp {
	my $i = shift;
	return defined param($i) && param($i) ne '';
}

sub isParamEq {
	my $i = shift;
	return defined param($i) && param($i) eq shift;
}

sub isParamUInt {
	my $i = shift;
	return defined param($i) && param($i) =~ m/^\d+$/;
}

1;
