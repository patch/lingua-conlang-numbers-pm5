package Lingua::EO::Numbers;

use 5.010;
use strict;
use warnings;
use Readonly;
use Regexp::Common qw( number );

require Exporter;
our @ISA = qw( Exporter );
our @EXPORT = qw( num2eo );

our $VERSION = '0.01';

Readonly my $SPACE     => q{ };
Readonly my $EMPTY_STR => q{};
Readonly my @NAMES1    => qw< nul unu du tri kvar kvin ses sep ok naŭ >;
Readonly my @NAMES2    => qw< dek cent mil >;
Readonly my %WORDS     => (
    ',' => 'komo',
    '-' => 'negativa',
    '+' => 'positiva',
    inf => 'senfineco',
    NaN => 'ne nombro',
);

sub num2eo {
    my ($number) = @_;
    my @names;

    given ($number) {
        when ($_ eq 'NaN') {
            push @names, $WORDS{NaN};
        }
        when (m/^ (?<sign> [-+] )? inf $/ixms) {
            push @names, $+{sign} ? $WORDS{ $+{sign} } : (), $WORDS{inf};
        }
        when (m/^ $RE{num}{real}{-radix=>'[,.]'}{-keep} $/xms) {
            my ($sign, $int, $frac) = ($2, $4, $6);
            my @digits = split $EMPTY_STR, $int // $EMPTY_STR;

            # numbers >= a million not currently supported
            return if @digits > 6;

            DIGIT:
            for my $i (1 .. @digits) {
                my $digit = $digits[-$i];
                my $name  = $NAMES1[$digit];

                # skip 0 unless it is the entire number
                next DIGIT
                    if !$digit
                    && @digits != 1
                    && !($i == 4 && @digits > 4);

                unshift(
                    @names,
                    $i == 1 ? $name : (
                        $digit && (
                            $digit != 1 || $i == 4 && @digits > 4
                        ) ? $name . ($i == 4 ? $SPACE : $EMPTY_STR)
                          : $EMPTY_STR
                    ) . $NAMES2[ abs($i) - ($i < 5 ? 2 : 5) ],
                );
            }

            if (defined $frac && $frac ne $EMPTY_STR) {
                push(
                    @names,
                    $WORDS{','},
                    map { $NAMES1[$_] } split $EMPTY_STR, $frac,
                );
            }

            unshift @names, $WORDS{$sign} || ();
        }
        default { return }
    }

    return join $SPACE, @names;
}

1;

__END__

=head1 NAME

Lingua::EO::Numbers - Convert numbers to Esperanto words

=head1 SYNOPSIS

  use Lingua::EO::Numbers;

  say 'Vi havas ', num2eo(int rand 1000), ' pomojn';

=head1 DESCRIPTION

The Lingua::EO::Numbers module provides one function, C<num2eo>, which
converts numbers to words in Esperanto.

=over 4

=item num2eo
X<num2eo>

The C<num2eo> function ...

=back

=head1 SEE ALSO

L<Lingua::EN::Numbers>, L<Lingua::Any::Numbers>

=head1 AUTHOR

Nick Patch, E<lt>n@atemoya.netE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2009, 2010 Nick Patch

This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself, either Perl version 5.10.0 or, at your option,
any later version of Perl 5 you may have available.

=cut
