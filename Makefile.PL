use inc::Module::Install;

name          'Lingua-ART-Numbers';
all_from      'lib/Lingua/ART/Numbers.pm';
recommends    'Readonly::XS'   => '1.02';
requires      'Readonly'       => '1.03',
requires      'Regexp::Common' => '0.03',
test_requires 'ok'             => '0.01';
test_requires 'Test::More'     => '0.40';

WriteAll;
