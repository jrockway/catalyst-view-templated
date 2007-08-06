#!/usr/bin/env perl

use strict;
use warnings;
use Test::More tests => 13;
use Test::MockObject;
use Storable qw/thaw/;

use FindBin qw($Bin);
use lib "$Bin/lib";
use ok 'TestApp::View::Something';

my $stash = {something => 'here'};
my $catalyst = Test::MockObject->new;
my $args = { CATALYST_VAR => 'CatTest',
             TEMPLATE_EXTENSION => '.ttFoo',
           };
my $view = TestApp::View::Something->COMPONENT($catalyst, $args);
my $body;

$catalyst->mock(stash => sub { 
                    if ($_[1]) { $stash->{$_[1]} = $_[2] };
                    return $stash;
                });
$catalyst->mock(view => sub { $view->ACCEPT_CONTEXT($_[0]) });
$catalyst->set_always(action => 'test');
$catalyst->{for} = 'testing';
$catalyst->set_always(response => 
                      Test::MockObject->new->mock(body => 
                                                  sub { $body = $_[1] }));

isa_ok($view, 'Catalyst::View::Templated', 'view');

# try _render first
my $output = $view->_render('foo', {some => 'hash', or => 'whatever'});
$output = thaw($output);

is_deeply $output, { foo => { some => 'hash', or => 'whatever' } }, 
  '_render works';

# now test template()

is($catalyst->view->template, 'test.ttFoo', 'action + EXTENSION');

$catalyst->stash->{template} = 'something_else';
is($catalyst->view->template, 'something_else', 'stash->template');

$catalyst->view->template('a_test');
is($catalyst->view->template, 'a_test', 'got expected template');
is($view->template, 'a_test', 'same object both times');

$stash = {};

# see if process works
$catalyst->view->template('foo.bar');
$catalyst->view->process;
$body = thaw($body);
is_deeply $body, { 'foo.bar' => { CatTest => $catalyst, %$stash } }, 
  'process works';

$stash = {the => 'stash', is => 'cool'};
$body = '';

$catalyst->view->template('template');
my $a = $catalyst->view->render($catalyst, 'template', { args => 'here' });
my $b = $catalyst->view->render('template', { args => 'here' });
my $c = $catalyst->view->render('template');
my $d = $catalyst->view->render;

is($a, $b, 'a == b');
is($b, $c, 'b == c');
is($c, $d, 'c == d');
is_deeply thaw($a), { template => { %$stash } }, 'correct data';

# now try with a fresh view
$view = TestApp::View::Something->COMPONENT($catalyst);
$stash = { foo => 'bar' };
my $e = $catalyst->view->render;
is_deeply thaw($e), { test => $stash}, 'empty config still works';
