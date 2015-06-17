package Shop::Common;
use Dancer ':syntax';
use strict;
use warnings;

use Exporter;
our @ISA= qw( Exporter );
our @EXPORT = qw( addMessage timeToText printd error404 isParamNEmp isParamEq isParamUInt);

sub addMessage {
	push $Shop::messages, {
		text => shift,
		type => shift
	};
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
	print STDERR Data::Dumper::Dumper( shift );
}

sub error404 {
	status 404;
	#addMessage('Страница не найдена', 'danger');
	return template 'index', {
		title => 'Страница не найдена'
	};
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