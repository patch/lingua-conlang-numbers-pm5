use 5.010;
use strict;
use warnings;
use Test::More tests => 52;

use ok 'Lingua::TokiPona::Numbers', qw( num2toki_pona );

are_num2toki_pona(
    # integers
    [ -100, 'ale ala'  ],
    [   -3, 'mute ala' ],
    [   -2, 'tu ala'   ],
    [   -1, 'wan ala'  ],
    [    0, 'ala'      ],
    [    1, 'wan'      ],
    [    2, 'tu'       ],
    [    3, 'mute'     ],
    [    4, 'mute'     ],
    [   10, 'mute'     ],
    [   99, 'mute'     ],
    [  100, 'ale'      ],
    [ 1000, 'ale'      ],

    # floating point numbers
    [ -0.1, 'wan ala' ],
    [  0.0, 'ala'     ],
    [  0.1, 'wan'     ],
    [  1.0, 'wan'     ],
    [  1.1, 'tu'      ],
    [  2.1, 'mute'    ],
    [ 99.1, 'mute'    ],

    # strings
    [ '-1'   => 'wan ala' ],
    [ '-1.0' => 'wan ala' ],
    [   '.0' => 'ala'     ],
    [  '0.'  => 'ala'     ],
    [  '0.0' => 'ala'     ],
    [   '.1' => 'wan'     ],
    [  '1'   => 'wan'     ],
    [  '1.'  => 'wan'     ],
    [ '+1'   => 'wan'     ],
    [ '+1.0' => 'wan'     ],

    # special values
    [  'inf' => 'ale'     ],
    [ '+inf' => 'ale'     ],
    [ '-inf' => 'ale ala' ],
    [  'NaN' => 'ala'     ],
);

# negative tests
ok !num2toki_pona(undef), 'undef fails';
ok !num2toki_pona( q{} ), 'empty string fails';
for my $test ('abc', '1a', 'a1', '1.2.3', '1,2,3', '1,2') {
    ok !num2toki_pona($test), "$test fails";
}

TODO: {
    todo_skip 'bareword inf/NaN handling not provided', 3;

    # TODO: change fat commas to commas when bareword inf/NaN handling is added
    are_num2toki_pona(
        [  inf => 'ale'     ],
        [ -inf => 'ale ala' ],
        [  NaN => 'ala'     ],
    );
}

TODO: {
    our $TODO = 'exponential notation in strings not implemented';

    for my $test (qw<  5e5  5E5  5.5e5  5e-5  -5e5  -5e-5  >) {
        ok num2toki_pona($test), "$test passes";
    }
}

sub are_num2toki_pona {
    my (@tests) = @_;

    for my $test (@tests) {
        my ($num, $word) = @{$test};
        is num2toki_pona($num), $word, "$num -> $word";
    }
}
