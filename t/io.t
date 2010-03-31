#!/usr/bin/perl
use strict;
use warnings;
use Test::More tests => 99;

use ok 'Lingua::IO::Numbers', qw( :all );

are_num2io(
    # integers
    [     -9, 'negativa non'         ],
    [      0, 'zero'                 ],
    [      9, 'non'                  ],
    [     10, 'dek'                  ],
    [     90, 'nona-dek'             ],
    [     99, 'nona-dek-e-non'       ],
    [    100, 'cent'                 ],
    [    109, 'cent-e-non'           ],
    [    110, 'cent-e-dek'           ],
    [    190, 'cent-e-nona-dek'      ],
    [    900, 'nona-cent'            ],
    [   1000, 'mil'                  ],
    [   9000, 'nona-mil'             ],
    [  10000, 'deka-mil'             ],
    [  11000, 'dek-e-una-mil'        ],
    [  19000, 'dek-e-nona-mil'       ],
    [  90000, 'nona-deka-mil'        ],
    [ 100000, 'centa-mil'            ],
    [ 110000, 'cent-e-deka-mil'      ],
    [ 190000, 'cent-e-nona-deka-mil' ],
    [ 900000, 'nona-centa-mil'       ],
    [ 999999, 'nona-cent-e-nona-dek-e-nona-mil-e-'
            . 'nona-cent-e-nona-dek-e-non' ],

    # floating point numbers
    [ -9.0,   'negativa non'            ],
    [ -0.9,   'negativa zero komo non'  ],
    [  0.0,   'zero'                    ],
    [  0.9,   'zero komo non'           ],
    [  0.09,  'zero komo zero non'      ],
    [  0.009, 'zero komo zero zero non' ],
    [  0.99,  'zero komo non non'       ],
    [  9.0,   'non'                     ],
    [  9.9,   'non komo non'            ],

    # strings
    [ '-9'     => 'negativa non'            ],
    [ '-9,0'   => 'negativa non komo zero'  ],
    [   ',0'   => 'komo zero'               ],
    [  '0,'    => 'zero'                    ],
    [  '0,0'   => 'zero komo zero'          ],
    [   ',9'   => 'komo non'                ],
    [  '9'     => 'non'                     ],
    [  '9,'    => 'non'                     ],
    [ '+9'     => 'positiva non'            ],
    [ '+9,0'   => 'positiva non komo zero'  ],
    [  '9,0'   => 'non komo zero'           ],
    [  '9,000' => 'non komo zero zero zero' ],
    [  '9.9'   => 'non komo non'            ],

    # special values
    [  'inf' => 'infinito'          ],
    [ '+inf' => 'positiva infinito' ],
    [ '-inf' => 'negativa infinito' ],
    [  'NaN' => 'ne nombro'         ],

    # large numbers
    [             1000000, 'un miliono'                 ],
    [             9000000, 'non milioni'                ],
    [             9900000, 'non milioni nona-centa-mil' ],
    [          1000000000, 'un miliardo'                ],
    [       1000000000000, 'un biliono'                 ],
    [     999999999999999, 'nona-cent-e-nona-dek-e-non bilioni e '
                         . 'nona-cent-e-nona-dek-e-non miliardi e '
                         . 'nona-cent-e-nona-dek-e-non milioni e '
                         . 'nona-cent-e-nona-dek-e-nona-mil-e-'
                         . 'nona-cent-e-nona-dek-e-non' ],
    [ '1000000000000000000', 'un triliono'              ],
);

# ordinals
are_num2io_ordinal(
    [   '+9', 'positiv-nonesma'          ],
    [     -9, 'negativ-nonesma'          ],
    [      0, 'zeresma'                  ],
    [      9, 'nonesma'                  ],
    [     10, 'dekesma'                  ],
    [     90, 'nona-dekesma'             ],
    [     99, 'nona-dek-e-nonesma'       ],
    [    100, 'centesma'                 ],
    [    109, 'cent-e-nonesma'           ],
    [    110, 'cent-e-dekesma'           ],
    [    190, 'cent-e-nona-dekesma'      ],
    [    900, 'nona-centesma'            ],
    [   1000, 'milesma'                  ],
    [   9000, 'nona-milesma'             ],
    [  10000, 'deka-milesma'             ],
    [  11000, 'dek-e-una-milesma'        ],
    [  19000, 'dek-e-nona-milesma'       ],
    [  90000, 'nona-deka-milesma'        ],
    [ 100000, 'centa-milesma'            ],
    [ 110000, 'cent-e-deka-milesma'      ],
    [ 190000, 'cent-e-nona-deka-milesma' ],
    [ 900000, 'nona-centa-milesma'       ],
    [ 999999, 'nona-cent-e-nona-dek-e-nona-mil-e-'
            . 'nona-cent-e-nona-dek-e-nonesma' ],

    # large numbers
    [             1000000, 'un-milionesma'                   ],
    [             9000000, 'non-milionesma'                  ],
    [             9900000, 'non-milion-e-nona-centa-milesma' ],
    [          1000000000, 'un-miliardesma'                  ],
    [       1000000000000, 'un-bilionesma'                   ],
    [     999999999999999, 'nona-cent-e-nona-dek-e-non-bilion-e-'
                         . 'nona-cent-e-nona-dek-e-non-miliard-e-'
                         . 'nona-cent-e-nona-dek-e-non-milion-e-'
                         . 'nona-cent-e-nona-dek-e-nona-mil-e-'
                         . 'nona-cent-e-nona-dek-e-nonesma'  ],
    [ '1000000000000000000', 'un-trilionesma'                ],
);

# negative tests
ok !num2io(undef), 'undef fails';
ok !num2io( q{} ), 'empty string fails';
for my $test ('abc', '1a', 'a1', '1.2.3', '1,2,3') {
    ok !num2io($test), "$test fails";
}

TODO: {
    our $TODO = 'exponential notation in strings not implemented';

    for my $test (qw<  5e5  5E5  5.5e5  5e-5  -5e5  -5e-5  >) {
        ok num2io($test), "$test returns value";
    }
}

sub are_num2io {
    my (@tests) = @_;

    for my $test (@tests) {
        my ($num, $word) = @{$test};
        is num2io($num), $word, "$num -> $word";
    }
}

sub are_num2io_ordinal {
    my (@tests) = @_;

    for my $test (@tests) {
        my ($num, $word) = @{$test};
        is num2io_ordinal($num), $word, "$num -> $word";
    }
}
