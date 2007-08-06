package Catalyst::View::Templated;
use strict;
use warnings;
use Class::C3;

use base qw/Catalyst::Component::ACCEPT_CONTEXT Catalyst::View/;

our $VERSION = '0.00_00'; # beta!

=head1 NAME

Catalyst::View::Templated - generic base class for template-based views

=head1 SYNOPSIS

View::Templated makes all (template-based) Catalyst views work the same way:

   # setup the config
   MyApp::View::SomeEngine->config(TEMPLATE_EXTENSION => '.tmpl');
   MyApp::View::SomeEngine->config(CATALYST_VAR       => 'c');
 
   # set the template in your action
   $c->view('View::SomeEngine')->template('the_template_name');
   # or let it guess the template name from the action name and EXTENSION

   # capture the text of the template
   my $output = $c->view('View::Engine')->render;

   # process a template (in an end action)
   $c->detach('View::Name');
   $c->view('View::Name')->process;


=head1 METHODS

=cut

=head2 template([$template])

Set the template to C<$template>, or return the current template
is C<$template> is undefined.

=cut

sub template {
    my ($self, $template) = @_;
    
    if ($template) {
        # store in _<self>_template
        $self->context->stash($self->_ident() => $template);
        return $template;
    }

    # hopefully they're using the new $c->view->template
    $template ||= $self->context->stash->{$self->_ident()};
    
    # if that's empty, get the template the old way, $c->stash->{template}
    $template ||= $self->context->stash->{template};
    
    # if those aren't set, try $c->action and the TEMPLATE_EXTENSION
    $template ||= $self->context->action . ($self->{TEMPLATE_EXTENSION}||q{});
    
    return $template;
}
sub _ident {
    my $self = shift;
    return "_${self}_template";
}

=head2 process

Forward to from Catalyst.  Renders the template as returned by C<<
$self->template >> and sets the response body to the output.

=cut

sub process {
    my $self = shift;
    my $output = $self->_do_render;
    $self->context->response->body($output);
}

=head2 render([$template])

Renders the named template and returns the output.  If C<$template>
is omitted, it is determined by calling C<< $self->template >>.q

=cut

sub render {
    my $self     = shift;
    my $template = shift;
    return $self->_do_render($template);
}

sub _do_render {
    my $self     = shift;
    my $template = shift || $self->template;
    my $stash    = $self->context->stash;
    my $catalyst = $self->config->{CATALYST_VAR} || 'c';
    $stash->{$catalyst} = $self->context;
    
    return $self->_render($template, $stash);
}

=head1 AUTHOR

Jonathan Rockway C<< jrockway AT cpan.org >>.

=head1 LICENSE

Copyright (c) 2007 Jonathan Rockway.  You may distribute this module
under the same terms as Perl itself.

=cut

1;
