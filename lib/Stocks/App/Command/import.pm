package Stocks::App::Command::import;
use strict;
use warnings;
use Stocks::Util qw(:all);
use parent qw(Stocks::App::Command);

sub validate {
    my ($self, $opt, $args) = @_;

    # We need at least one argument beyond the options; die with that message
    # and the complete "usage" text describing switches, etc.
    $self->usage_error('specify one or more data files to import')
      unless @$args;
}
sub abstract { 'import historical stock data' }

sub execute {
    my ($self, $opt, $args) = @_;
    for my $arg (@$args) {
        open my $fh, '<', $arg or die "can't open $arg: $!\n";
        my @populate = ([ qw(day ticker open high low close volume) ]);
        while (<$fh>) {
            chomp;
            push @populate, [ split /,/ ];
        }
        close $fh or die "can't close $arg: $!\n";
        get_schema()->resultset('Stock')->populate(\@populate);
    }
}
1;
