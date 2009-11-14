use 5.010;
use strict;
use warnings;
use Test::More;

BEGIN { use_ok 'Lingua::EO::Numbers' }

my @tests = (
    [      0, 'nul'              ],
    [      8, 'ok'               ],
    [     10, 'dek'              ],
    [     80, 'okdek'            ],
    [     88, 'okdek ok'         ],
    [    100, 'cent'             ],
    [    108, 'cent ok'          ],
    [    110, 'cent dek'         ],
    [    180, 'cent okdek'       ],
    [    800, 'okcent'           ],
    [   1000, 'mil'              ],
    [   8000, 'okmil'            ],
    [  10000, 'dekmil'           ],
    [  11000, 'dek unu mil'      ],
    [  18000, 'dek ok mil'       ],
    [  80000, 'okdekmil'         ],
    [ 100000, 'centmil'          ],
    [ 110000, 'cent dek mil'          ],
    [ 180000, 'cent okdek mil'          ],
    [ 800000, 'okcentmil'        ],
    [ 888888, 'okcent okdek ok mil okcent okdek ok' ],

    [ 0.0,   'nul'                   ],
    [ 0.8,   'nul punkto ok'         ],
    [ 0.08,  'nul punkto nul ok'     ],
    [ 0.008, 'nul punkto nul nul ok' ],
    [ 0.88,  'nul punkto ok ok'      ],
    [ 8.0,   'ok'                    ],
    [ 8.8,   'ok punkto ok'          ],

    [  '.0', 'punkto nul'     ],
    [ '0.',  'nul'            ],
    [ '0.0', 'nul punkto nul' ],
    [  '.8', 'punkto ok'      ],
    [ '8.',  'ok'             ],
    [ '8.0', 'ok punkto nul'  ],

#    [  inf, 'senfineco'          ],
#    [ +inf, 'senfineco'          ],
#    [ -inf, 'negativa senfineco' ],
#    [  NaN, 'ne nombro'          ],

    [  'inf', 'senfineco'          ],
    [ '+inf', 'senfineco'          ],
    [ '-inf', 'negativa senfineco' ],
    [  'NaN', 'ne nombro'          ],
);

plan tests => scalar @tests;

push @tests, [undef];

while ( my ($num, $word) = @{ shift @tests } ) {
    is num2eo($num), $word, "$num is $word";
}
