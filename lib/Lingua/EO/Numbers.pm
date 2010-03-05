package Lingua::EO::Numbers;

use 5.008_001;
use strict;
use warnings;
use utf8;
use Readonly;
use Regexp::Common qw( number );

use base qw( Exporter );
our @EXPORT_OK = qw( num2eo num2eo_ordinal );
our %EXPORT_TAGS = ( all => \@EXPORT_OK );

our $VERSION = '0.02';

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

    return unless defined $number;

    if ($number eq 'NaN') {
        push @names, $WORDS{NaN};
    }
    elsif ($number =~ m/^ ( [-+] )? inf $/ixms) {
        push @names, $1 ? $WORDS{$1} : (), $WORDS{inf};
    }
    elsif ($number =~ m/^ $RE{num}{real}{-radix=>'[,.]'}{-keep} $/xms) {
        my ($sign, $int, $frac) = ($2, $4, $6);
        my @digits = split $EMPTY_STR, defined $int ? $int : $EMPTY_STR;

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
    else {
        return;
    }

    return join $SPACE, @names;
}

sub num2eo_ordinal {
    my ($number) = @_;
    my $name = num2eo($number);
    return unless defined $name;
    $name =~ s{ ( oj? | a )? [ ] }{-}gxms;
    return $name . 'a';
}

1;

__END__

=encoding utf8

=head1 NAME

Lingua::EO::Numbers - Convert numbers into Esperanto words

=head1 VERSION

This document describes Lingua::EO::Numbers version 0.02.

=head1 SYNOPSIS

    use 5.010;
    use Lingua::EO::Numbers qw( num2eo );

    for my $nombro (reverse 0 .. 99) {
        say ucfirst num2eo($nombro), ' boteloj da biero sur la muro.';
    }

output:

    Naŭdek naŭ boteloj da biero sur la muro.
    Naŭdek ok boteloj da biero sur la muro.
    Naŭdek sep boteloj da biero sur la muro.
      ...
    Nul boteloj da biero sur la muro.

=head1 DESCRIPTION

This module provides functions to convert numbers into words in Esperanto, a
constructed international auxiliary language created by L. L. Zamenhof and
published in 1887.

This module currently supports the standard Esperanto decimal separator (",")
or the standard Perl one (".") and does not support any thousands separator.
The option to set the supported decimal and thousands separators may be added
in the future.

=head1 FUNCTIONS

The following functions are provided but are not exported by default.

=over 4

=item num2eo EXPR

If EXPR looks like a number, the text describing the number is returned.  Both
integers and real numbers are supported, including negatives.  Special values
such as "inf" and "NaN" are also supported.

=item num2eo_ordinal EXPR

If EXPR looks like an integer, the text describing the number in ordinal form
is returned.  The behavior when passing a non-integer value is undefined.

=back

The returned string is UTF-8 encoded.  If EXPR is a value that does not look
like a number or is not currently supported by this module, C<undef> is
returned.

The C<:all> tag can be used to import all functions.

    use Lingua::EO::Numbers qw( :all );

=head1 TODO

=over 4

=item * support one million and greater

=item * support exponential notation

=item * option for setting the input decimal separator

=item * option for setting the input thousands separator

=item * provide POD translation in Esperanto

=back

=head1 SEE ALSO

L<Lingua::EO::Supersignoj>, L<http://bertilow.com/pmeg/gramatiko/nombroj/>

=head1 AUTHOR

Nick Patch, E<lt>n@atemoya.netE<gt>

=head1 ACKNOWLEDGEMENTS

MORIYA Masaki (a.k.a. Gardejo) created the Esperanto translation of this
document

Sean M. Burke created the current interface to L<Lingua::EN::Numbers>, which
this module is based on

=head1 COPYRIGHT AND LICENSE

Copyright 2009, 2010 Nick Patch

This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

=cut
