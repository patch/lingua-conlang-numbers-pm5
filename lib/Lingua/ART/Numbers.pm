package Lingua::ART::Numbers;

use 5.010;
use strict;
use warnings;
use Lingua::EO::Numbers       qw( :all );
use Lingua::JBO::Numbers      qw( :all );
use Lingua::TokiPona::Numbers qw( :all );

use base qw( Exporter );
our @EXPORT_OK = qw( num2art num2art_ordinal num2art_languages );
our %EXPORT_TAGS = ( all => \@EXPORT_OK );

our $VERSION = '0.01';

my @languages = qw< eo jbo tokipona >;
my %aliases = (
    esperanto => 'eo',
    lojban    => 'jbo',
);

sub num2art           { _num2art(q{},         @_) }
sub num2art_ordinal   { _num2art(q{_ordinal}, @_) }
sub num2art_languages { @languages                }

sub _num2art {
    # @_ will be used with goto
    my ($suffix, $language, $number) = (shift, shift, @_);

    return unless $language;
    $language = lc $language;
    $language =~ tr{_}{}d;

    for ($language) {
        when (\@languages) {
            goto &{ 'num2' . $language . $suffix };
        }
        when (\%aliases) {
            goto &{ 'num2' . $aliases{$language} . $suffix };
        }
        default {
            return;
        }
    }
}

1;

__END__

=head1 NAME

Lingua::ART::Numbers - Convert numbers into words in various
artificial/constructed languages

=head1 SYNOPSIS

  use Lingua::ART::Numbers qw( num2art );

=head1 DESCRIPTION

The Lingua::ART::Numbers module provides one function, C<num2eo>, which
converts numbers into words in various artificial (i.e., constructed)
languages.

=over 4

=item num2art
X<num2art>

The C<num2art> function ...

=item num2art_ordinal
X<num2art_ordinal>

The C<num2art_ordinal> function ...

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
