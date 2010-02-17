use 5.010;
use strict;
use warnings;
use Test::More tests => 50;

use ok 'Lingua::JBO::Numbers';


my @tests = (
    [     -9 => "ni'u so"           ],
    [      0 => 'no'                ],
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
    [  10000 => 'pa no no no no'    ],
    [  11000 => 'pa pa no no no'    ],
    [  19000 => 'pa so no no no'    ],
    [  90000 => 'so no no no no'    ],
    [ 100000 => 'pa no no no no no' ],
    [ 110000 => 'pa pa no no no no' ],
    [ 190000 => 'pa so no no no no' ],
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

are_num2jbo(@tests);


SKIP: {
    skip 'bareword inf/NaN handling not provided', 3;

    my @skip_tests = (
        [  inf => "ci'i"         ],
        [ -inf => "ni'u ci'i"    ],
        [  NaN => 'not a number' ], # translate
    );

    are_num2jbo(@skip_tests);
}


TODO: {
    todo_skip 'translate NaN', 1;

    my @todo_tests = (
        [ 'NaN' => 'not a number' ],
    );

    are_num2jbo(@todo_tests);
}


sub are_num2jbo {
    my (@tests) = @_;

    while (@tests) {
        my ($num, $word) = @{ shift @tests };
        is num2jbo($num), $word, "$num is $word";
    }
}
