use 5.010;
use ExtUtils::MakeMaker;

# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME         => 'Lingua::EO::Numbers',
    VERSION_FROM => 'lib/Lingua/EO/Numbers.pm',
    PREREQ_PM    => {},
    ( $] >= 5.005 ? (
        ABSTRACT_FROM  => 'lib/Lingua/EO/Numbers.pm',
        AUTHOR         => 'Nick Patch <n@atemoya.net>'
    ) : () ),
);
