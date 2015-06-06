package Shop::Common;
use Dancer ':syntax';
use strict;
use warnings;

use Exporter;
our @ISA= qw( Exporter );
our @EXPORT = qw( addMessage timeToText );

sub addMessage {
	session messages => [] if ! defined session('messages');
	session messages => [@{session->{messages}}, {
		text => shift,
		type => shift
	}];
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

1;