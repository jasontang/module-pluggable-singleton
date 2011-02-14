use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Module::Pluggable::Singleton',
    AUTHOR              => q{Jason Tang <tang.jason.ch@gmail.com>},
    VERSION_FROM        => 'lib/Module/Pluggable/Singleton.pm',
    ABSTRACT_FROM       => 'lib/Module/Pluggable/Singleton.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Module-Pluggable-Singleton-*' },
);
