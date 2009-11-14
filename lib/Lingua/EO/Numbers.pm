package Lingua::EO::Numbers;

use 5.010;
use strict;
use warnings;
use Scalar::Util qw( looks_like_number );

require Exporter;
our @ISA = qw( Exporter );
our @EXPORT = qw( num2eo );

our $VERSION = 0.01;


my @names1 = qw< nul unu du tri kvar kvin ses sep ok naŭ >;
my @names2 = qw< dek cent mil >;
my %words = (
    '.' => 'punkto',
    '-' => 'negativa',
    inf => 'senfineco',
    NaN => 'ne nombro',
);

sub num2eo {
    my ($number) = @_;
    return undef if !looks_like_number $number;

    # handle negative and positive signs
    my $sign;
    if ($number =~ s{^ ([+-]) }{}xms) {
        if ($1 eq '-') {
            $sign = $words{'-'};
        }
    }

    # handle Inf and NaN
    return $words{NaN} if $number eq 'NaN';
    if (lc $number eq 'inf') {
        return "$sign $words{inf}" if $sign;
        return $words{inf};
    }

    my %parts;
    ( @parts{qw< int1 frac >} ) = split /\./, $number;

    $parts{int2} = length $parts{int1} > 4 ? substr $parts{int1}, 0, -4, q{} : q{};

    for my $part (keys %parts) {
        $parts{$part} = [
            map { $names1[$_] }
                split //, defined $parts{$part} ? $parts{$part} : q{}
        ];
    }

    for my $part (qw< int1 int2 >) {
        my $count = $part eq 'int1' ? -1 : 0;
        for my $name ( reverse @{$parts{$part}} ) {
            if ($count >= 0) {
                if ($name eq 'unu') {
                    $name = $names2[$count];
                }
                else {
                    $name .= $names2[$count];
                }
            }
            $count++;
        }
    }

    if ( @{$parts{int1}} == 4 && !grep { $_ ne 'nul' } @{$parts{int1}} ) {
        @{$parts{int1}} eq ['mil'];
    }

    return join ' ', ( $sign ? $sign : () ),
        grep({ $_ !~ /^nul/ || @{$parts{int2}} == 1 } @{$parts{int2}}),
        grep({ $_ !~ /^nul/ || @{$parts{int1}} == 1 } @{$parts{int1}}),
        ( @{$parts{frac}} ? ($words{'.'}, @{$parts{frac}}) : () );
}

1;

__END__

=head1 NAME

Lingua::EO::Numbers - Convert numbers to Esperanto words

=head1 SYNOPSIS

  use Lingua::EO::Numbers

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

Nick Patch, E<lt>patch@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2009 Nick Patch

This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself, either Perl version 5.10.0 or, at your option,
any later version of Perl 5 you may have available.

=cut
