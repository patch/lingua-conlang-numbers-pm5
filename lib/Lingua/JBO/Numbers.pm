package Lingua::JBO::Numbers;

use 5.010;
use strict;
use warnings;
use Readonly;
use Regexp::Common qw( number );

use base qw( Exporter );
our @EXPORT_OK = qw( num2jbo num2jbo_ordinal );
our %EXPORT_TAGS = ( all => \@EXPORT_OK );

our $VERSION = '0.01';

Readonly my $SPACE     => q{ };
Readonly my $EMPTY_STR => q{};
Readonly my @NAMES1    => qw< no pa re ci vo mu xa ze bi so >;
Readonly my %WORDS     => (
    '.' => "pi",
    ',' => "ki'o",
    '-' => "ni'u",
    '+' => "ma'u",
    inf => "ci'i",
    NaN => "na namcu",
);

sub num2jbo {
    my ($number) = @_;
    my @names;

    return unless defined $number;

    given ($number) {
        when ($_ eq 'NaN') {
            push @names, $WORDS{NaN};
        }
        when (m/^ (?<sign> [-+] )? inf $/ixms) {
            push @names, $+{sign} ? $WORDS{ $+{sign} } : (), $WORDS{inf};
        }
        when (m/^ $RE{num}{real}{-radix=>'[.]'}{-keep} $/xms) {
            my ($sign, $int, $frac) = ($2, $4, $6);

            push(
                @names,
                $WORDS{$sign} || (),
                map { $NAMES1[$_] } split $EMPTY_STR, $int // $EMPTY_STR,
            );

            if (defined $frac && $frac ne $EMPTY_STR) {
                push(
                    @names,
                    $WORDS{'.'},
                    map { $NAMES1[$_] } split $EMPTY_STR, $frac,
                );
            }
        }
        default { return }
    }

    return join $SPACE, @names;
}

sub num2jbo_ordinal {
    my ($number) = @_;
    my $name = num2jbo($number);
    return unless defined $name;
    $name =~ tr{ }{}d;
    return $name . 'moi';
}

1;

__END__

=head1 NAME

Lingua::JBO::Numbers - Convert numbers into Lojban words

=head1 VERSION

This document describes Lingua::JBO::Numbers version 0.01.

=head1 SYNOPSIS

    use 5.010;
    use Lingua::JBO::Numbers qw( num2jbo );

    my $namcu = 99;

    while ($namcu >= 0) {
        say '.', num2jbo( $namcu-- ), ' botpi le birje cu cpana le bitmu';
    }

output:

    .so so botpi le birje cu cpana le bitmu
    .so bi botpi le birje cu cpana le bitmu
    .so ze botpi le birje cu cpana le bitmu
      ...
    .no botpi le birje cu cpana le bitmu

=head1 DESCRIPTION

This module provides functions to convert numbers into words in Lojban, a
constructed logical language created by The Logical Language Group and
published in 1998.

=head1 FUNCTIONS

The following functions are provided but are not exported by default.

=over 4

=item num2jbo EXPR

If EXPR looks like a number, the text describing the number is returned.  Both
integers and real numbers are supported, including negatives.  Special values
such as "inf" and "NaN" are also supported.

=item num2jbo_ordinal EXPR

If EXPR looks like an integer, the text describing the number in ordinal form
is returned.  The behavior when passing a non-integer value is undefined.

=back

If EXPR is a value that does not look like a number or is not currently
supported by this module, C<undef> is returned.

The C<:all> tag can be used to import all functions.

    use Lingua::JBO::Numbers qw( :all );

=head1 TODO

=over 4

=item * support exponential notation

=item * support "ra'e" for repeating decimals

=item * option for using either space or nothing to separate output words

=item * option for using the thousands separator "ki'o" in output

=item * option for eluding to zeros using "ki'o"

=item * provide POD translation in Lojban

=back

=head1 SEE ALSO

L<http://www.lojban.org/publications/reference_grammar/chapter18.html>

=head1 AUTHOR

Nick Patch, E<lt>n@atemoya.netE<gt>

=head1 ACKNOWLEDGEMENTS

Sean M. Burke created the current interface to L<Lingua::EN::Numbers>, which
this module is based on

=head1 COPYRIGHT AND LICENSE

Copyright 2010 Nick Patch

This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

=cut
