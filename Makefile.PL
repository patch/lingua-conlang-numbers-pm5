use 5.010;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME         => 'Lingua::ART::Numbers',
    VERSION_FROM => 'lib/Lingua/ART/Numbers.pm',
    PREREQ_PM    => {
        'Readonly'       => 0,
        'Regexp::Common' => 0,
    },
    ( $] >= 5.005 ? (
        ABSTRACT_FROM  => 'lib/Lingua/ART/Numbers.pm',
        AUTHOR         => 'Nick Patch <n@atemoya.net>'
    ) : () ),
);
