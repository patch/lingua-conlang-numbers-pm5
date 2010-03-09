use Module::Build;

my $build = Module::Build->new(
    module_name  => 'Lingua::Conlang::Numbers',
    dist_version => '0.03',
    license      => 'perl',
    build_requires => {
        'ok'         => '0.01',
        'Test::More' => '0.40',
    },
    requires => {
        'perl'           => '5.8.1',
        'Readonly'       => '1.03',
        'Regexp::Common' => '0.03',
    },
    recommends => {
        'Readonly::XS' => '1.02',
    },
    meta_add => {
        resources => {
            repository => 'http://github.com/patch/lingua-conlang-numbers',
        },
    },
);

$build->create_build_script;
