requires 'parent';
requires 'App::Cmd';
requires 'Plack';
requires 'Plack::Middleware::DirIndex';
requires 'DBIx::Class';
requires 'Data::Domain';
requires 'Data::Printer';

on 'test' => sub {
    requires 'Test::More';
};
