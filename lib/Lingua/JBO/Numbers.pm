package Lingua::JBO::Numbers;

use 5.010;
use strict;
use warnings;
use Regexp::Common;

require Exporter;
our @ISA = qw( Exporter );
our @EXPORT = qw( num2jbo );

our $VERSION = 0.01;

my @names1 = qw< no pa re ci vo mu xa ze bi so >;
my %words = (
    '.' => "pi",
    ',' => "ki'o",
    '-' => "ni'u",
    '+' => "ma'u",
    inf => "ci'i",
);

sub num2jbo {
    my ($number) = @_;
    my @names;

    given ($number) {
        when (m/^ (?<sign> [-+] )? inf $/ixms) {
            push @names, $+{sign} ? $words{ $+{sign} } : (), $words{inf};
        }
        when (m/^ $RE{num}{real}{-radix=>'[,.]'}{-keep} $/xms) {
            my $sign = $2;
            my $int  = $4;
            my $frac = $6;

            push @names, $words{$sign} || (), map { $names1[$_] } split //, $int // q{};

            if ( defined $frac && $frac ne q{} ) {
                push @names, $words{'.'}, map { $names1[$_] } split //, $frac;
            }
        }
        default { return }
    }

    return join q{ }, @names;
}

1;

__END__

=head1 NAME

Lingua::JBO::Numbers - Convert numbers to Lojban words

=head1 SYNOPSIS

  use Lingua:JBO::Numbers

  say num2jbo(int rand 1000);

=head1 DESCRIPTION

The Lingua::JBO::Numbers module provides one function, C<num2jbo>, which
converts numbers to words in Lojban.

=over 4

=item num2jbo
X<num2jbo>

The C<num2jbo> function ...

=back

=head1 SEE ALSO

L<Lingua::EN::Numbers>, L<Lingua::Any::Numbers>

=head1 AUTHOR

Nick Patch, E<lt>n@atemoya.netE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2009 Nick Patch

This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself, either Perl version 5.10.0 or, at your option,
any later version of Perl 5 you may have available.

=cut
