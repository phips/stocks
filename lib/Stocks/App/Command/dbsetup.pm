package Stocks::App::Command::dbsetup;
use strict;
use warnings;
use Stocks::Util qw(destroy_and_create_db);
use parent qw(Stocks::App::Command);

sub options {
    return (
        [   'yesreally|y',
            'confirm that this command should run',
            { required => 1 }
        ],
    );
}

sub abstract { 'destroy and setup the database' }

sub execute {
    my ($self, $opt, $args) = @_;
    destroy_and_create_db();
}
1;
