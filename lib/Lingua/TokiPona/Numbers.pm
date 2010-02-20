package Lingua::TokiPona::Numbers;

use 5.010;
use strict;
use warnings;
use Scalar::Util qw( looks_like_number );

use base qw( Exporter );
our @EXPORT = qw( num2toki_pona );

our $VERSION = '0.01';

sub num2toki_pona {
    my ($number) = @_;
    my $name;

    return unless defined $number && looks_like_number $number;

    my $negative = $number =~ s{^ - }{}xms;

    given ($number) {
        when ($_ ==   0 || $_ eq 'NaN') { $names = 'ala'  }
        when ($_ >    0 && $_ <=    1 ) { $names = 'wan'  }
        when ($_ >    1 && $_ <=    2 ) { $names = 'tu'   }
        when ($_ >    2 && $_ <   100 ) { $names = 'mute' }
        when ($_ >= 100 || $_ eq 'inf') { $names = 'ale'  }
    }

    return "$number ala" if $negative;
    return $number;
}

1;

__END__

=head1 NAME

Lingua::TokiPona::Numbers - Convert numbers to Toki Pona words

=head1 SYNOPSIS

  use Lingua::TokiPona::Numbers;

  say num2toki_pona(int rand 1000);

=head1 DESCRIPTION

The Lingua::TokiPona::Numbers module provides one function, C<num2toki_pona>,
which converts numbers to words in Toki Pona.

=over 4

=item num2toki_pona
X<num2toki_pona>

The C<num2toki_pona> function ...

=back

=head1 SEE ALSO

L<Lingua::EN::Numbers>, L<Lingua::Any::Numbers>

=head1 AUTHOR

Nick Patch, E<lt>n@atemoya.netE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2010 Nick Patch

This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself, either Perl version 5.10.0 or, at your option,
any later version of Perl 5 you may have available.

=cut
