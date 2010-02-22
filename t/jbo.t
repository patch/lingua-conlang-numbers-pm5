use 5.010;
use strict;
use warnings;
use Test::More tests => 66;

use ok 'Lingua::JBO::Numbers', qw( num2jbo );

are_num2jbo(
    # integers
    [      -9 => "ni'u so"              ],
    [       0 => "no"                   ],
    [       9 => "so"                   ],
    [      10 => "pa no"                ],
    [      90 => "so no"                ],
    [      99 => "so so"                ],
    [     100 => "pa no no"             ],
    [     109 => "pa no so"             ],
    [     110 => "pa pa no"             ],
    [     190 => "pa so no"             ],
    [     900 => "so no no"             ],
    [    1000 => "pa no no no"          ],
    [    9000 => "so no no no"          ],
    [   10000 => "pa no no no no"       ],
    [   11000 => "pa pa no no no"       ],
    [   19000 => "pa so no no no"       ],
    [   90000 => "so no no no no"       ],
    [  100000 => "pa no no no no no"    ],
    [  110000 => "pa pa no no no no"    ],
    [  190000 => "pa so no no no no"    ],
    [  900000 => "so no no no no no"    ],
    [  999999 => "so so so so so so"    ],
    [ 1000000 => "pa no no no no no no" ],

    # floating point numbers
    [ -9.0   => "ni'u so"        ],
    [ -0.9   => "ni'u no pi so"  ],
    [  0.0   => "no"             ],
    [  0.9   => "no pi so"       ],
    [  0.09  => "no pi no so"    ],
    [  0.009 => "no pi no no so" ],
    [  0.99  => "no pi so so"    ],
    [  9.0   => "so"             ],
    [  9.9   => "so pi so"       ],

    # strings
    [ '-9'     => "ni'u so"       ],
    [ '-9.0'   => "ni'u so pi no" ],
    [   '.0'   => "pi no"         ],
    [  '0.'    => "no"            ],
    [  '0.0'   => "no pi no"      ],
    [   '.9'   => "pi so"         ],
    [  '9'     => "so"            ],
    [  '9.'    => "so"            ],
    [ '+9'     => "ma'u so"       ],
    [ '+9.0'   => "ma'u so pi no" ],
    [  '9.0'   => "so pi no"      ],
    [  '9.000' => "so pi no no no" ],

    # special values
    [  'inf' => "ci'i"      ],
    [ '+inf' => "ma'u ci'i" ],
    [ '-inf' => "ni'u ci'i" ],
);

# negative tests
ok !num2jbo(undef), 'undef fails';
ok !num2jbo( q{} ), 'empty string fails';
for my $test ('abc', '1a', 'a1', '1.2.3', '1,2,3', '1,2') {
    ok !num2jbo($test), "$test fails";
}

TODO: {
    todo_skip 'bareword inf/NaN handling not provided', 3;

    # TODO: change fat commas to commas when bareword inf/NaN handling is added
    are_num2jbo(
        [  inf => "ci'i"         ],
        [ -inf => "ni'u ci'i"    ],
        [  NaN => "not a number" ],
    );
}

TODO: {
    our $TODO = 'exponential notation in strings not implemented';

    for my $test (qw<  5e5  5E5  5.5e5  5e-5  -5e5  -5e-5  >) {
        ok num2jbo($test), "$test passes";
    }
}

TODO: {
    local $TODO = 'NaN not translated';

    are_num2jbo( [ 'NaN' => "not a number" ] );
}

sub are_num2jbo {
    my (@tests) = @_;

    for my $test (@tests) {
        my ($num, $word) = @{$test};
        is num2jbo($num), $word, "$num -> $word";
    }
}
