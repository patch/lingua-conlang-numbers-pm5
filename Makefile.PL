use 5.010;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME         => 'Lingua::ART::Numbers',
    VERSION_FROM => 'lib/Lingua/ART/Numbers.pm',
    PREREQ_PM    => {
        'Readonly'       => '0.06',
        'Regexp::Common' => '0.03',
    },
    ( $] >= 5.005 ? (
        ABSTRACT_FROM  => 'lib/Lingua/ART/Numbers.pm',
        AUTHOR         => 'Nick Patch <n@atemoya.net>'
    ) : () ),
    ( $] >= 5.008_009 ? (
        MIN_PERL_VERSION => '5.010',
        LICENSE      => 'perl',
    ) : () ),
);
