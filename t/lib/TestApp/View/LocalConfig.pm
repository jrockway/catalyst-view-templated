package TestApp::View::LocalConfig;
use strict;
use warnings;
use base 'Catalyst::View::Templated';
use Storable qw/freeze/;

__PACKAGE__->config(
    CATALYST_VAR => 'local_config_catalyst_var',
    INCLUDE_PATH => ['foo', 'bar/baz'],
    CONTENT_TYPE => 'text/plain',
);

sub _render {
    my ($self, $template, $stash) = @_;

    my $data = { map { $_ => $self->{$_} } grep { /^[A-Z]/ } keys %$self };
    return freeze({ $template => $data });
}
