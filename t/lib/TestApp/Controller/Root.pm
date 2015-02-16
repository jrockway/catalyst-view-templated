package TestApp::Controller::Root;
use strict;
use warnings;

use base 'Catalyst::Controller';

__PACKAGE__->config(namespace => q{});

sub template_detach :Local {
    my ($self, $c) = @_;
    
    $c->view('Something')->template('hello_world');
    $c->stash(hello => 'world');
    
    $c->detach($c->view('Something'));
}

sub action_detach :Local {
    my ($self, $c) = @_;
    $c->stash(action => 'detach');    
    $c->detach($c->view('Something'));
}

sub local_config :Local {
    my ($self, $c) = @_;
    $c->detach($c->view('LocalConfig'));
}

1;
