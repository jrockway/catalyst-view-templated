#!/usr/bin/env perl

use strict;
use warnings;
use Test::More tests => 2;
use Storable qw/thaw/;

use FindBin qw($Bin);
use lib "$Bin/lib";
use Test::WWW::Mechanize::Catalyst 'TestApp';

no warnings 'once';
local $Storable::Deparse = 1; 
local $Storable::Eval = 1;

my $mech = Test::WWW::Mechanize::Catalyst->new;

$mech->get_ok('http://localhost/template_detach');
my $content = $mech->content;

is thaw($content)->{hello_world}{hello}, 'world',
  'got correct content when calling template via detach';

