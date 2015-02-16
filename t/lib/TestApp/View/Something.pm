package TestApp::View::Something;
use strict;
use warnings;

use base 'Catalyst::View::Templated';
use Storable qw/freeze/;

$Storable::forgive_me = 1;

sub _render {
    my $self = shift;
    my $template = shift;
    my $stash = shift;
    
    $self->context->response->content_type('application/octet-stream');
    
    # Because Storable
    my %safe_stash = %$stash;
    delete $safe_stash{c} if defined $safe_stash{c} && $safe_stash{c}->isa('Catalyst');

    return freeze({ $template => \%safe_stash });
}

1;
