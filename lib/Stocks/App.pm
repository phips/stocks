package Stocks::App;
use strict;
use warnings;
use App::Cmd::Setup -app;

sub should_ignore {
    my ($self, $command_class) = @_;
    return 1 unless $command_class->isa('App::Cmd::Command');
    return 1 if $command_class =~ /::genschema$/ && !$ENV{STOCKS_DEV};
    return;
}
1;
