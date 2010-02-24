package Lingua::TokiPona::Numbers;

use 5.008_001;
use strict;
use warnings;
use Scalar::Util qw( looks_like_number );

use base qw( Exporter );
our @EXPORT_OK = qw( num2tokipona num2tokipona_ordinal );

our $VERSION = '0.01';

sub num2tokipona {
    my ($number) = @_;

    return unless looks_like_number $number;
    return 'ala' if $number eq 'NaN';

    my $negative = $number =~ s{^ - }{}xms;

    return do {
        if    ($number ==  0) { 'ala'  }
        elsif ($number <=  1) { 'wan'  }
        elsif ($number <=  2) { 'tu'   }
        elsif ($number < 100) { 'mute' }
        else                  { 'ale'  }
    } . ( $negative ? q{ ala} : q{} );
}

sub num2tokipona_ordinal {
    my ($number) = @_;
    my $name = num2tokipona($number);
    return $name ? "nanpa $name" : undef;
}

1;

__END__

=head1 NAME

Lingua::TokiPona::Numbers - Convert numbers to Toki Pona words

=head1 SYNOPSIS

  use Lingua::TokiPona::Numbers;

  say 'mi jo e kili ', num2tokipona(int rand 4), '.';

=head1 DESCRIPTION

The Lingua::TokiPona::Numbers module provides one function, C<num2tokipona>,
which converts numbers to words in Toki Pona.

=over 4

=item num2tokipona
X<num2tokipona>

The C<num2tokipona> function ...

=back

=head1 SEE ALSO

L<Lingua::EN::Numbers>, L<Lingua::Any::Numbers>, L<http://en.tokipona.org/wiki/Numbers>

=head1 AUTHOR

Nick Patch, E<lt>n@atemoya.netE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2010 Nick Patch

This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself, either Perl version 5.10.0 or, at your option,
any later version of Perl 5 you may have available.

=cut
