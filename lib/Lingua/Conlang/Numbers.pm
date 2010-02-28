package Lingua::Conlang::Numbers;

use 5.010;
use strict;
use warnings;
use Lingua::EO::Numbers       qw( :all );
use Lingua::JBO::Numbers      qw( :all );
use Lingua::TokiPona::Numbers qw( :all );

use base qw( Exporter );
our @EXPORT_OK = qw( num2conlang num2conlang_ordinal num2conlang_languages );
our %EXPORT_TAGS = ( all => \@EXPORT_OK );

our $VERSION = '0.01';

my @languages = qw< eo jbo tokipona >;
my %aliases = (
    esperanto => 'eo',
    lojban    => 'jbo',
);

sub num2conlang           { _num2conlang(q{},         @_) }
sub num2conlang_ordinal   { _num2conlang(q{_ordinal}, @_) }
sub num2conlang_languages { @languages                }

sub _num2conlang {
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

Lingua::Conlang::Numbers - Convert numbers into words in various constructed languages

=head1 SYNOPSIS

  use Lingua::Conlang::Numbers qw( num2conlang );

=head1 DESCRIPTION

The Lingua::Conlang::Numbers module provides one function, C<num2conlang>,
which converts numbers into words in various constructed languages.

=over 4

=item num2conlang
X<num2conlang>

The C<num2conlang> function ...

=item num2conlang_ordinal
X<num2conlang_ordinal>

The C<num2conlang_ordinal> function ...

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
