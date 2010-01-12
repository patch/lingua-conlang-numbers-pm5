use 5.010;
use strict;
use warnings;
use Test::More tests => 51;

BEGIN { use_ok 'Lingua::JBO::Numbers' }

my @tests = (
    [     -9 => "ni'u so"           ],
    [      0 => 'no'                ],
    [      9 => 'so'                ],
    [      9 => 'so'                ],
    [     10 => 'pa no'             ],
    [     90 => 'so no'             ],
    [     99 => 'so so'             ],
    [    100 => 'pa no no'          ],
    [    109 => 'pa no so'          ],
    [    110 => 'pa pa no'          ],
    [    190 => 'pa so no'          ],
    [    900 => 'so no no'          ],
    [   1000 => 'pa no no no'       ],
    [   9000 => 'so no no no'       ],
    [  10000 => 'po no no no no'    ],
    [  11000 => 'po po no no no'    ],
    [  19000 => 'po so no no no'    ],
    [  90000 => 'so no no no no'    ],
    [ 100000 => 'po no no no no no' ],
    [ 110000 => 'po po no no no no' ],
    [ 190000 => 'po so no no no no' ],
    [ 900000 => 'so no no no no no' ],
    [ 999999 => 'so so so so so so' ],

    [ -9.0   => "ni'u so"        ],
    [ -0.9   => "ni'u no pi so"  ],
    [  0.0   => 'no'             ],
    [  0.9   => 'no pi so'       ],
    [  0.09  => 'no pi no so'    ],
    [  0.009 => 'no pi no no so' ],
    [  0.99  => 'no pi so so'    ],
    [  9.0   => 'so'             ],
    [  9.9   => 'so pi so'       ],

    [ '-9'   => "ni'u so"       ],
    [ '-9.0' => "ni'u so pi no" ],
    [   '.0' => 'pi no'         ],
    [  '0.'  => 'no'            ],
    [  '0.0' => 'no pi no'      ],
    [   '.9' => 'pi so'         ],
    [  '9'   => 'so'            ],
    [  '9.'  => 'so'            ],
    [ '+9'   => "ma'u so"       ],
    [ '+9.0' => "ma'u so pi no" ],
    [  '9.0' => "so pi no"      ],

    [  'inf' => "ci'i"      ],
    [ '+inf' => "ma'u ci'i" ],
    [ '-inf' => "ni'u ci'i" ],
);

while (@tests) {
    my ($num, $word) = @{ shift @tests };
    is num2eo($num), $word, "$num is $word";
}

SKIP: {
    skip 'bareword inf/NaN module not provided', 3;

    my @skip_tests = (
        [  inf => "ci'i"         ],
        [ -inf => "ni'u ci'i"    ],
        [  NaN => 'not a number' ],
    );

    while (@skip_tests) {
        my ($num, $word) = @{ shift @tests };
        is num2eo($num), $word, "$num is $word";
    }
}

TODO: {
    todo 'translate NaN', 1;

    my @todo_tests = (
        [ 'NaN' => 'not a number' ],
    );

    while (@todo_tests) {
        my ($num, $word) = @{ shift @tests };
        is num2eo($num), $word, "$num is $word";
    }
}
