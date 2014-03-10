requires 'parent';
requires 'App::Cmd';
requires 'Config::Tiny';
requires 'JSON::XS';
requires 'Plack';
requires 'Plack::Middleware::DirIndex';
requires 'DBIx::Class';
requires 'Data::Domain';
requires 'Data::Printer';
requires 'Web::Machine';

on 'test' => sub {
    requires 'Test::More';
};
