use 5.010;
use strict;
use warnings;
use Test::More tests => 39;

BEGIN { use_ok 'Lingua::EO::Numbers' }

my @tests = (
    [      0, 'nul'            ],
    [      8, 'ok'             ],
    [     10, 'dek'            ],
    [     80, 'okdek'          ],
    [     88, 'okdek ok'       ],
    [    100, 'cent'           ],
    [    108, 'cent ok'        ],
    [    110, 'cent dek'       ],
    [    180, 'cent okdek'     ],
    [    800, 'okcent'         ],
    [   1000, 'mil'            ],
    [   8000, 'ok mil'         ],
    [  10000, 'dek mil'        ],
    [  11000, 'dek unu mil'    ],
    [  18000, 'dek ok mil'     ],
    [  80000, 'okdek mil'      ],
    [ 100000, 'cent mil'       ],
    [ 110000, 'cent dek mil'   ],
    [ 180000, 'cent okdek mil' ],
    [ 800000, 'okcent mil'     ],
    [ 888888, 'okcent okdek ok mil okcent okdek ok' ],

    [ 0.0,   'nul'                 ],
    [ 0.8,   'nul komo ok'         ],
    [ 0.08,  'nul komo nul ok'     ],
    [ 0.008, 'nul komo nul nul ok' ],
    [ 0.88,  'nul komo ok ok'      ],
    [ 8.0,   'ok'                  ],
    [ 8.8,   'ok komo ok'          ],

    [  '.0', 'komo nul'     ],
    [ '0.',  'nul'          ],
    [ '0.0', 'nul komo nul' ],
    [  '.8', 'komo ok'      ],
    [ '8.',  'ok'           ],
    [ '8.0', 'ok komo nul'  ],

    #[  inf, 'senfineco'          ],
    #[ +inf, 'senfineco'          ],
    #[ -inf, 'negativa senfineco' ],
    #[  NaN, 'ne nombro'          ],

    [  'inf', 'senfineco'          ],
    [ '+inf', 'senfineco'          ],
    [ '-inf', 'negativa senfineco' ],
    [  'NaN', 'ne nombro'          ],
);

while (@tests) {
    my ($num, $word) = @{ shift @tests };
    is num2eo($num), $word, "$num is $word";
}
