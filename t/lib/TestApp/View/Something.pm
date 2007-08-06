package TestApp::View::Something;
use strict;
use warnings;

use base 'Catalyst::View::Templated';
use Storable qw/freeze/;

sub _render {
    my $self = shift;
    my $template = shift;
    my $stash = shift;

    return freeze({ $template => $stash });
}

1;
