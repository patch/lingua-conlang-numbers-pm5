package Lingua::IO::Numbers;

use 5.008_001;
use strict;
use warnings;
use Readonly;
use Regexp::Common qw( number );

use parent qw( Exporter );
our @EXPORT_OK = qw( num2io num2io_ordinal );
our %EXPORT_TAGS = ( all => \@EXPORT_OK );

our $VERSION = '0.01';

# up to 999 decillion (long scale) supported
# i.e., 999 novemdecillion (short scale)
Readonly my $MAX_INT_DIGITS => 38;

Readonly my $EMPTY_STR          => q{};
Readonly my $SPACE              => q{ };
Readonly my $ORDINAL_SUFFIX     => q{esma};
Readonly my $SINGULAR_SUFFIX    => q{o};
Readonly my $PLURAL_SUFFIX      => q{i};
Readonly my $MULTIPLY_SEPARATOR => q{a-};
Readonly my $ADD_SEPARATOR      => q{-e-};
Readonly my $GROUP_SEPARATOR    => q{ e };

Readonly my @NAMES1 => qw< zero un du tri quar kin sis sep ok non >;
Readonly my @NAMES2 => $EMPTY_STR, qw< dek cent >;
Readonly my @GROUPS => (
    undef, qw< mil miliono miliardo >,
    map { $_ . 'iliono' } qw< b tr quadr quint sext sept okt non dec >,
);

Readonly my %WORDS => (
    ',' => 'komo',
    '-' => 'negativa',
    '+' => 'positiva',
    inf => 'infinito',
    NaN => 'ne nombro',
);

# convert number to words
sub num2io {
    my ($number) = @_;
    my @names;

    return unless defined $number;
    return $WORDS{NaN} if $number eq 'NaN';

    if ($number =~ m/^ ( [-+] )? inf $/ix) {
        # infinity
        push @names, $1 ? $WORDS{$1} : (), $WORDS{inf};
    }
    elsif ($number =~ m/^ $RE{num}{real}{-radix=>'[,.]'}{-keep} $/x) {
        my ($sign, $int, $frac) = ($2, $4, $6);

        return if length $int > $MAX_INT_DIGITS;

        # sign and integer
        unshift @names, $WORDS{$sign} || (), _convert_int($int);

        # fraction
        if (defined $frac && $frac ne $EMPTY_STR) {
            push @names, (
                $WORDS{','},
                map { $NAMES1[$_] } split $EMPTY_STR, $frac,
            );
        }
    }
    else {
        return;
    }

    return join $SPACE, @names;
}

# convert number to ordinal words
sub num2io_ordinal {
    my ($number) = @_;
    my $name = num2io($number);

    return unless defined $name;

    # remove word suffixes
    for ($name) {
        s{ [aio]? [ ] }{-}gx;
        s{ [io] $}{}x;
    }

    return $name . $ORDINAL_SUFFIX;
}

# convert integers to words
sub _convert_int {
    my ($int) = @_;
    my @number_groups = _split_groups($int);
    my @name_groups;
    my $group_count = 0;

    GROUP:
    for my $group (reverse @number_groups) {
        # skip zeros unless it is the only digit
        next GROUP if $group == 0 && $int != 0;

        my $type = $GROUPS[$group_count];

        # pluralize nouns
        if ($type && $type ne $GROUPS[1] && $group > 1) {
            $type =~ s{ $SINGULAR_SUFFIX $}{$PLURAL_SUFFIX}x;
        }

        my @names = do {
            # use thousand instead of one thousand
            if ( $group == 1 && $type eq $GROUPS[1] ) { () }

            # groups for billions and greater contain thousands sub-groups
            elsif (length $group > 3) { _convert_int(   $group ) }
            else                      { _convert_group( $group ) }
        };

        unshift @name_groups, @names, $type ? $type : ();
    }
    continue {
        $group_count++;
    }

    # regroup last two groups when they include thousands
    if (@name_groups > 1 && $name_groups[-1] =~ m{^ $GROUPS[1] \b }x) {
        $name_groups[-2] .= $MULTIPLY_SEPARATOR . pop @name_groups;
    }

    return @name_groups;
}

# split integer into groups for use with thousands, millions, etc.
# the first 3 groups contain 3 digits and the rest contain 6 digits
sub _split_groups {
    my ($int) = @_;
    my $group_length = 3;
    my @groups;

    while ($int =~ s[ ( .{1,$group_length} ) $ ][]x) {
        unshift @groups, $1;
    }
    continue {
        if (@groups == 4) {
            $group_length = 6;
        }
    }

    return @groups;
}

# the actual integer to word conversion
# this expects an integer group of 1 to 3 digits
sub _convert_group {
    my ($int) = @_;
    my @digits = split $EMPTY_STR, defined $int ? $int : $EMPTY_STR;
    my $digit_count = 0;
    my @names;

    DIGIT:
    for my $digit (reverse @digits) {
        # skip zero unless it is the only digit
        next DIGIT if $digit == 0 && $int != 0;

        # leave off one for ten and hundred
        unshift @names, (
            $digit == 1
                && $digit_count ? $EMPTY_STR :
                   $digit_count ? $NAMES1[$digit] . $MULTIPLY_SEPARATOR :
                                  $NAMES1[$digit]
        ) . $NAMES2[$digit_count];
    }
    continue {
        $digit_count++;
    }

    return join $ADD_SEPARATOR, @names;
}

1;

__END__

=head1 NAME

Lingua::IO::Numbers - Convert numbers into Ido words

=head1 VERSION

This document describes Lingua::IO::Numbers version 0.01.

=head1 SYNOPSIS

    use 5.010;
    use Lingua::IO::Numbers qw( num2io );

    for my $nombro (reverse 0 .. 99) {
        say ucfirst num2io($nombro), ' boteli de biro sur la muro.';
    }

output:

    Nona-dek-e-non boteli de biro sur la muro.
    Nona-dek-e-ok boteli de biro sur la muro.
    Nona-dek-e-sep boteli de biro sur la muro.
      ...
    Zero boteli de biro sur la muro.

=head1 DESCRIPTION

This module provides functions to convert numbers into words in Ido, a
constructed international auxiliary language created by a group of reformist
Esperanto speakers and released in 1907.

This module currently supports the standard Ido decimal separator (",") or the
standard Perl one (".") and does not support any thousands separator.  The
option to set the supported decimal and thousands separators may be added in
the future.

=head1 FUNCTIONS

The following functions are provided but are not exported by default.

=over 4

=item num2io EXPR

If EXPR looks like a number, the text describing the number is returned.  Both
integers and real numbers are supported, including negatives.  Special values
such as "inf" and "NaN" are also supported.

=item num2io_ordinal EXPR

If EXPR looks like an integer, the text describing the number in ordinal form
is returned.  The behavior when passing a non-integer value is undefined.

=back

If EXPR is a value that does not look like a number or is not currently
supported by this module, C<undef> is returned.

The C<:all> tag can be used to import all functions.

    use Lingua::IO::Numbers qw( :all );

=head1 TODO

=over 4

=item * support exponential notation

=item * option for setting the input decimal separator

=item * option for setting the input thousands separator

=item * option for using ' e ' as the addition separator instead of '-e-'

=item * option for using 'a' as the multiplication separator instead of 'a-'

=back

=head1 SEE ALSO

L<Lingua::Conlang::Numbers>, L<http://www.ido-france.org/KGD/nombri.htm>

=head1 AUTHOR

Nick Patch <patch@cpan.org>

=head1 COPYRIGHT AND LICENSE

Copyright 2009, 2010 Nick Patch

This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

=cut
