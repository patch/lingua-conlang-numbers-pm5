use 5.010;
use strict;
use warnings;
use utf8;
use Test::More tests => 71;

# handle utf8 output
my $builder = Test::More->builder;
binmode $builder->output,         ':utf8';
binmode $builder->failure_output, ':utf8';
binmode $builder->todo_output,    ':utf8';

use ok 'Lingua::EO::Numbers';

are_num2eo(
    # integers
    [     -9 => 'negativa naŭ'    ],
    [      0 => 'nul'             ],
    [      9 => 'naŭ'             ],
    [     10 => 'dek'             ],
    [     90 => 'naŭdek'          ],
    [     99 => 'naŭdek naŭ'      ],
    [    100 => 'cent'            ],
    [    109 => 'cent naŭ'        ],
    [    110 => 'cent dek'        ],
    [    190 => 'cent naŭdek'     ],
    [    900 => 'naŭcent'         ],
    [   1000 => 'mil'             ],
    [   9000 => 'naŭ mil'         ],
    [  10000 => 'dek mil'         ],
    [  11000 => 'dek unu mil'     ],
    [  19000 => 'dek naŭ mil'     ],
    [  90000 => 'naŭdek mil'      ],
    [ 100000 => 'cent mil'        ],
    [ 110000 => 'cent dek mil'    ],
    [ 190000 => 'cent naŭdek mil' ],
    [ 900000 => 'naŭcent mil'     ],
    [ 999999 => 'naŭcent naŭdek naŭ mil naŭcent naŭdek naŭ' ],

    # floating point numbers
    [ -9.0   => 'negativa naŭ'          ],
    [ -0.9   => 'negativa nul komo naŭ' ],
    [  0.0   => 'nul'                   ],
    [  0.9   => 'nul komo naŭ'          ],
    [  0.09  => 'nul komo nul naŭ'      ],
    [  0.009 => 'nul komo nul nul naŭ'  ],
    [  0.99  => 'nul komo naŭ naŭ'      ],
    [  9.0   => 'naŭ'                   ],
    [  9.9   => 'naŭ komo naŭ'          ],

    # strings
    [ '-9'     => 'negativa naŭ'          ],
    [ '-9,0'   => 'negativa naŭ komo nul' ],
    [   ',0'   => 'komo nul'              ],
    [  '0,'    => 'nul'                   ],
    [  '0,0'   => 'nul komo nul'          ],
    [   ',9'   => 'komo naŭ'              ],
    [  '9'     => 'naŭ'                   ],
    [  '9,'    => 'naŭ'                   ],
    [ '+9'     => 'positiva naŭ'          ],
    [ '+9,0'   => 'positiva naŭ komo nul' ],
    [  '9,0'   => 'naŭ komo nul'          ],
    [  '9,000' => 'naŭ komo nul nul nul'  ],
    [  '9.9'   => 'naŭ komo naŭ'          ],

    # special values
    [  'inf' => 'senfineco'          ],
    [ '+inf' => 'positiva senfineco' ],
    [ '-inf' => 'negativa senfineco' ],
    [  'NaN' => 'ne nombro'          ],
);

# negative tests
ok !num2eo(undef), 'undef fails';
ok !num2eo( q{} ), 'empty string fails';
for my $test ('abc', '1a', 'a1', '1.2.3', '1,2,3') {
    ok !num2eo($test), "$test fails";
}

TODO: {
    our $TODO = '1 million and higher not implemented';

    are_num2eo(
        [ 1000000 => 'unu miliono'              ],
        [ 9000000 => 'naŭ milionoj'             ],
        [ 9900000 => 'naŭ milionoj naŭcent mil' ],
        [ 1000000000          => 'unu miliardo' ],
        [ 1000000000000       => 'unu biliono'  ],
        [ 1000000000000000000 => 'unu triliono' ],
    );
}

TODO: {
    our $TODO = 'exponential notation in strings not implemented';

    for my $test (qw<  5e5  5E5  5.5e5  5e-5  -5e5  -5e-5  >) {
        ok num2eo($test), "$test passes";
    }
}

TODO: {
    todo_skip 'bareword inf/NaN handling not provided', 3;

    # TODO: change fat commas to commas when bareword inf/NaN handling is added
    are_num2eo(
        [  inf => 'senfineco'          ],
        [ -inf => 'negativa senfineco' ],
        [  NaN => 'ne nombro'          ],
    );
}

sub are_num2eo {
    my (@tests) = @_;

    for my $test (@tests) {
        my ($num, $word) = @{$test};
        is num2eo($num), $word, "$num -> $word";
    }
}
