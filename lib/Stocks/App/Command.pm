package Stocks::App::Command;
use strict;
use warnings;
use App::Cmd::Setup -command;
use Stocks::Util qw(read_config);

sub opt_spec {
    my ($class, $app) = @_;
    return (
        [ 'verbose|v', 'log additional output' ],
        [   'config|c:s',
            'path to config file',
            { default => $ENV{STOCKS_CONF} }
        ],
        $class->options($app),
    );
}

sub options {}

sub validate_args {
    my ($self, $opt, $args) = @_;
    $::config = read_config($opt->{config});
    $self->validate($opt, $args);
    $::opt = $opt;
}

sub validate {}

1;
