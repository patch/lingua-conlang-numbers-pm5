use 5.010;
use strict;
use warnings;
use Test::More tests => 50;

use ok 'Lingua::EO::Numbers';


my @tests = (
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

    [ -9.0   => 'negativa naŭ'          ],
    [ -0.9   => 'negativa nul komo naŭ' ],
    [  0.0   => 'nul'                   ],
    [  0.9   => 'nul komo naŭ'          ],
    [  0.09  => 'nul komo nul naŭ'      ],
    [  0.009 => 'nul komo nul nul naŭ'  ],
    [  0.99  => 'nul komo naŭ naŭ'      ],
    [  9.0   => 'naŭ'                   ],
    [  9.9   => 'naŭ komo naŭ'          ],

    [ '-9'   => 'negativa naŭ'          ],
    [ '-9.0' => 'negativa naŭ komo nul' ],
    [   '.0' => 'komo nul'              ],
    [  '0.'  => 'nul'                   ],
    [  '0.0' => 'nul komo nul'          ],
    [   '.9' => 'komo naŭ'              ],
    [  '9'   => 'naŭ'                   ],
    [  '9.'  => 'naŭ'                   ],
    [ '+9'   => 'positiva naŭ'          ],
    [ '+9.0' => 'positiva naŭ komo nul' ],
    [  '9.0' => 'naŭ komo nul'          ],

    [  'inf' => 'senfineco'          ],
    [ '+inf' => 'positiva senfineco' ],
    [ '-inf' => 'negativa senfineco' ],
    [  'NaN' => 'ne nombro'          ],
);

are_num2eo(@tests);


SKIP: {
    skip 'bareword inf/NaN handling not provided', 3;

    my @skip_tests = (
        [  inf => 'senfineco'          ],
        [ -inf => 'negativa senfineco' ],
        [  NaN => 'ne nombro'          ],
    );

    are_num2eo(@skip_tests);
}


sub are_num2eo {
    my (@tests) = @_;

    while (@tests) {
        my ($num, $word) = @{ shift @tests };
        is num2eo($num), $word, "$num is $word";
    }
}
