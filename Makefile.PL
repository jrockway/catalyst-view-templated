use inc::Module::Install;

use strict;
use warnings;

all_from('lib/Catalyst/View/Templated.pm');
name('Catalyst-View-Templated');

requires 'Catalyst::Component::ACCEPT_CONTEXT' => 0.03;

build_requires 'Catalyst' => '5.7001';
build_requires 'Test::More';
build_requires 'Test::WWW::Mechanize::Catalyst';
build_requires 'ok';
build_requires 'Storable';
build_requires 'Test::MockObject';
build_requires 'Path::Class';

WriteAll();
