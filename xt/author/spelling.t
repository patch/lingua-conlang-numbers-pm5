use strict;
use warnings;
use Test::More tests => 1;

eval 'use Test::Spelling';
plan skip_all => 'Test::Spelling not installed; skipping' if $@;

add_stopwords(<DATA>);
pod_file_spelling_ok('lib/Lingua/Conlang/Numbers.pm');

# TODO: add stopwords for other modules
#set_pod_file_filter(sub { $_[0] !~ /EO\.pod$/ });
#all_pod_files_spelling_ok();

__DATA__
conlang
eo
EO
epo
EPO
EXPR
Flexione
ido
Ido
Interlingua
io
jbo
Loglan
Lojban
Na'vi
num
Pona
Quenya
tlh
TODO
Toki
tokipona
TokiPona
Volapük
