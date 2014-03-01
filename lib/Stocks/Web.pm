package Stocks::Web;
use strict;
use warnings;
use Plack::App::File;
use Plack::Builder;
use Plack::Middleware::DirIndex;
use Web::Machine;
use Stocks::Web::Resource::Stocks;
use Stocks::Util qw(get_absolute_path);

sub psgi_app {
    builder {
        enable 'Plack::Middleware::DirIndex', dir_index => 'index.html';
        mount '/' =>
          Plack::App::File->new(root => get_absolute_path($::config->{htdocs}))
          ->to_app;
        mount '/components' =>
          Plack::App::File->new(root => get_absolute_path('bower_components'))
          ->to_app;
        mount '/api/v1/stocks' =>
          Web::Machine->new(resource => 'Stocks::Web::Resource::Stocks')
          ->to_app;
    };
}
1;
