package t::Bridge;
use strict;
use warnings;
use Lingua::EO::Numbers       qw( num2eo       num2eo_ordinal       );
use Lingua::JBO::Numbers      qw( num2jbo      num2jbo_ordinal      );
use Lingua::TLH::Numbers      qw( num2tlh      num2tlh_ordinal      );
use Lingua::TokiPona::Numbers qw( num2tokipona num2tokipona_ordinal );

sub to_eo {
    my ($this) = shift;
    return num2eo($this);
}

sub to_eo_ord {
    my ($this) = shift;
    return num2eo_ordinal($this);
}

sub to_jbo {
    my ($this) = shift;
    return num2jbo($this);
}

sub to_jbo_ord {
    my ($this) = shift;
    return num2jbo_ordinal($this);
}

sub to_tlh {
    my ($this) = shift;
    return num2tlh($this);
}

sub to_tlh_ord {
    my ($this) = shift;
    return num2tlh_ordinal($this);
}

sub to_tokipona {
    my ($this) = shift;
    return num2tokipona($this);
}

sub to_tokipona_ord {
    my ($this) = shift;
    return num2tokipona_ordinal($this);
}

1;
