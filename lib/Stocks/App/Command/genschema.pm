package Stocks::App::Command::genschema;
use strict;
use warnings;
use Stocks::Util qw(do_system dist_root);
use parent qw(Stocks::App::Command);
sub abstract { 're-generate schema classes with dbicdump' }

sub execute {
    my ($self, $opt, $args) = @_;
    my $dist_root = dist_root();
    my $dbname    = $::config->{dbname};
    do_system(join ' ' =>
        'dbicdump',
        "-o dump_directory=$dist_root/lib",
        qq!-o components='["InflateColumn::DateTime"]'!,
        'Stocks::Schema',
        "dbi:Pg:dbname=$dbname"
    );
}
1;
