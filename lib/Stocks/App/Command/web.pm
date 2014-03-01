package Stocks::App::Command::web;
use strict;
use warnings;
use Plack::Runner;
use Stocks::Web;
use parent qw(Stocks::App::Command);

sub abstract { 'run a web server for the UI and REST API' }

sub execute {
    my ($self, $opt, $args) = @_;
    my $runner = Plack::Runner->new;
    $runner->parse_options(@$args);
    $runner->run(Stocks::Web->psgi_app);
}
1;
