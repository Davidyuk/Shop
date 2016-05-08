use strict;
use warnings;
use ExtUtils::MakeMaker;

# Normalize version strings like 6.30_02 to 6.3002,
# so that we can do numerical comparisons on it.
my $eumm_version = $ExtUtils::MakeMaker::VERSION;
$eumm_version =~ s/_//;

WriteMakefile(
    NAME                => 'Shop',
    AUTHOR              => q{Denis Davidyuk <denis_davidyuk@hotmail.com>},
    VERSION_FROM        => 'lib/Shop.pm',
    ABSTRACT            => 'Интернет-магазин выполненный в рамках дисциплины "Веб-программирование".',
    ($eumm_version >= 6.3001
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
        'YAML'       => 0,
        'Dancer'     => 1.3132,
        'DateTime::Format::Pg'  => 0,
        'DateTime::Format::CLDR'  => 0,
        'Dancer::Plugin::Passphrase'  => 0,

        'Dancer::Plugin::Ajax'  => 0,
        'DateTime::Locale::ru'  => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Shop-*' },
);
