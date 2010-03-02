package Lingua::TokiPona::Numbers;

use 5.010;
use strict;
use warnings;
use Scalar::Util qw( looks_like_number );

use base qw( Exporter );
our @EXPORT_OK = qw( num2tokipona num2tokipona_ordinal );
our %EXPORT_TAGS = ( all => \@EXPORT_OK );

our $VERSION = '0.02';

sub num2tokipona {
    my ($number) = @_;

    return unless looks_like_number $number;
    return 'ala' if $number eq 'NaN';

    $number =~ s{^ (?<sign> [+-] ) }{}xms;
    my $sign = $+{sign} // q{};

    return do {
        if    ($number eq 'inf') { 'ale'  }
        elsif ($number == 0    ) { 'ala'  }
        elsif ($number <= 1    ) { 'wan'  }
        elsif ($number <= 2    ) { 'tu'   }
        else                     { 'mute' }
    } . ( $sign eq q{-} ? q{ ala} : q{} );
}

sub num2tokipona_ordinal {
    my ($number) = @_;
    my $name = num2tokipona($number);
    return $name ? "nanpa $name" : undef;
}

1;

__END__

=head1 NAME

Lingua::TokiPona::Numbers - Convert numbers into Toki Pona words

=head1 SYNOPSIS

  use 5.010;
  use Lingua::TokiPona::Numbers qw( num2tokipona );

  my $nanpa = 99;

  while ($nanpa >= 0) {
      say 'poki ', num2tokipona( $nanpa-- ), ' pi telo nasa li lon sinpin.';
  }

output:

  poki mute pi telo nasa li lon sinpin.
  poki mute pi telo nasa li lon sinpin.
  poki mute pi telo nasa li lon sinpin.
    ...
  poki ala pi telo nasa li lon sinpin.

=head1 DESCRIPTION

This module provides functions to convert numbers into words in Toki Pona, a
constructed minimal language created by Sonja Elen Kisa and published in 2001.

=head1 FUNCTIONS

The following functions are provided but are not exported by default.

=over 4

=item num2tokipona EXPR

If EXPR looks like a number, the text describing the number is returned.  Both
integers and real numbers are supported, including negatives.  Special values
such as "inf" and "NaN" are also supported.

=item num2tokipona_ordinal EXPR

If EXPR looks like an integer, the text describing the number in ordinal form
is returned.  The behavior when passing a non-integer value is undefined.

=back

If EXPR is a value that does not look like a number or is not currently
supported by this module, C<undef> is returned.

The C<:all> tag can be used to import all functions.

    use Lingua::TokiPona::Numbers qw( :all );

=head1 SEE ALSO

L<http://en.tokipona.org/wiki/Numbers>

=head1 AUTHOR

Nick Patch, E<lt>n@atemoya.netE<gt>

=head1 ACKNOWLEDGEMENTS

Sean M. Burke created the current interface to L<Lingua::EN::Numbers>, which
this module is based on

Matthew Martin provided corrections to the Toki Pona number system

=head1 COPYRIGHT AND LICENSE

Copyright 2010 Nick Patch

This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

=cut
