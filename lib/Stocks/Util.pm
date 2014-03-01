package Stocks::Util;
use strict;
use warnings;
use Config::Tiny;
use Data::Printer;
use Data::Domain qw(:all);
use Exporter qw(import);
use v5.14;
our %EXPORT_TAGS = (
    misc   => [qw(do_system dist_root)],
    config => [qw(read_config get_absolute_path)],
    db     => [qw(get_schema destroy_and_create_db)],
);
our @EXPORT_OK = @{ $EXPORT_TAGS{all} = [ map { @$_ } values %EXPORT_TAGS ] };

sub do_system {
    my ($cmd, $ignore_failure) = @_;
    print "$cmd\n" if $::opt->{verbose};
    my $rc = system($cmd);
    return if $ignore_failure;
    die "can't $cmd: $?" if $rc != 0;
}

sub dist_root {
    (my $inc_key = __PACKAGE__ . '.pm') =~ s!::!/!g;
    $INC{$inc_key} =~ s|(/blib)?/lib/\Q$inc_key\E$||r;
}

# Used for config values that are paths. If they're not absolute, they'll be
# treated as relative to the dist root.
sub get_absolute_path {
    my $path = shift;
    return $path if substr($path, 0, 1) eq '/';
    return dist_root() . "/$path";
}

sub read_config {
    my $config_path = shift // $ENV{STOCKS_CONF};
    die "Specify config file.\n" unless defined $config_path;
    my $config = Config::Tiny->read($config_path);
    die "$Config::Tiny::errstr\n" if $Config::Tiny::errstr;
    $config = $config->{_};
    my $domain = Struct(
        -fields => {
            dbname   => String,
            dbhost   => String(-optional => 1),
            dbport   => String(-optional => 1),
            dbuser   => String(-optional => 1),
            dbpass   => String(-optional => 1),
            ddl_file => String,
            htdocs   => String,
        },
        -exclude => '*',
    );
    my $error_messages = $domain->inspect($config);
    die "Config error:\n" . p($error_messages) . "\n" if $error_messages;
    return $config;
}

sub get_schema {
    # don't use() or the genschema command can't run the first time
    require Stocks::Schema;
    our $schema //= do {
        my $connect_string = sprintf "dbi:Pg:dbname=%s", $::config->{dbname};
        $connect_string .= ';host=' . $::config->{dbhost}
          if $::config->{dbhost};
        $connect_string .= ';port=' . $::config->{dbport}
          if $::config->{dbport};
        Stocks::Schema->connect($connect_string, $::config->{dbuser},
            $::config->{dbpass},);
    };
}

sub destroy_and_create_db {
    my $args = $::config->{dbname};
    $args .= " -h $::config->{dbhost}" if $::config->{dbhost};
    $args .= " -U $::config->{dbuser}" if $::config->{dbuser};
    $args .= " -p $::config->{dbport}" if $::config->{dbport};
    my $ddl_file = get_absolute_path($::config->{ddl_file});
    do_system("dropdb $args", 1);
    do_system("createdb -E UTF8 $args");
    do_system("psql $args <$ddl_file");
}
1;
