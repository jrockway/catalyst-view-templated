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
$mech->get_ok('http://localhost/local_config');
my $content = $mech->content;

my $data = {
    CATALYST_VAR => 'local_config_catalyst_var',
    INCLUDE_PATH => ['foo', 'bar/baz'],
    CONTENT_TYPE => 'text/plain',
};
is_deeply thaw($content)->{'local_config'}, $data,
  '__PACKAGE__->config() ok';
