#!/usr/bin/env perl

use strict;
use warnings;
use lib '../lib';
use lib '../../lib';
use lib '../../Scot-Internal-Modules/lib';
use v5.18;
use Scot::App::Stretch;
use IO::Prompt;
use Getopt::Long qw(GetOptions);

my $interactive;
my $configfile  = "stretch.app.cfg";
my $maxworkers  = 1;
my $startepoch;
my $endepoch;
my $collection;
my $limit       = 0;

GetOptions(
    'i'         => \$interactive,
    'l=i'       => \$limit,
    'col=s'     => \$collection,
    'conf=s'    => \$configfile,
    'w=i'       => \$maxworkers,
    'start=i'   => \$startepoch,
    'end=i'     => \$endepoch,
) or die <<EOF

Invalid option!

    usage: $0
        [-i]                interactive mode
        [-conf=filename]    filename of alternative config file
        [-w=3]              max number of workers
EOF
;

my $paths   = [qw(/opt/scot/etc /home/tbruner/Scot-Internal-Modules/etc)];

my $loop    = Scot::App::Stretch->new( 
    paths              => $paths,
    configuration_file => $configfile,
    interactive        => $interactive ? 1 : 0,
    max_workers        => $maxworkers,
);

if (defined $startepoch ) {
    unless ( $collection ) {
        die "You must specify collection!";
    }
    unless (defined $endepoch) {
        $endepoch = time();
    }
    $loop->process_by_date($collection,$startepoch, $endepoch, $limit);
}
else {
    $loop->run();
}
