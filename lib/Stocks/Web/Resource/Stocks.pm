package Stocks::Web::Resource::Stocks;
use strict;
use warnings;
use v5.16;
use JSON::XS qw(encode_json);
use Digest::SHA qw(sha1_hex);
use Stocks::Util qw(get_schema);
use Web::Machine::Util qw(create_date);
use parent 'Web::Machine::Resource';
sub allowed_methods { [qw(GET)] }

sub resource_exists {
    my $self = shift;

    # we don't support subpaths as in queries/:id
    return $self->request->path_info eq '';
}

sub _is_query_parameter_ok {
    my ($self, $key, $value) = @_;
    if ($key eq 'fields') {

        # value can be like 'groupby:country,groupby:type,sum:count'
        state $re = qr{
            (?(DEFINE)
                (?<OP> groupby | sum)
                (?<FIELD> day | ticker | volume)
                (?<SPEC> (?: (?&OP) : )? (?&FIELD))
            )
            \A (?&SPEC) (?: , (?&SPEC) )* \Z
        }xo;
        return $value =~ $re;
    } elsif ($key eq 'day') {
        return $value =~ /^\d+-\d+-\d+$/;
    } elsif ($key eq 'ticker') {
        return $value =~ /^[A-Z]+$/;
    }
}

sub malformed_request {
    my $self         = shift;
    my $is_malformed = 0;
    my %seen;

    # Check the query parameters
    $self->request->parameters->each(
        sub {
            my ($key, $value) = @_;
            return if $is_malformed;    # no need to check further
            if ($seen{$key}++) {
                $is_malformed++;
                return;
            }
            $is_malformed++ unless $self->_is_query_parameter_ok($key, $value);
        }
    );
    return $is_malformed;
}

sub search_queries {
    my $self = shift;

    # Build a columns list and 'group by' clause from the 'fields' query
    # parameter.
    my (@search_columns, @result_columns, @group_by);
    my $field_spec = $self->request->param('fields')
      // 'day,ticker,open,high,low,close,volume';
    for my $spec (split /,/ => $field_spec) {
        my @parts = split /:/ => $spec;
        unshift @parts, 'select' if @parts == 1;
        my ($action, $field) = @parts;
        push @result_columns, $field;
        if ($action eq 'select') {
            push @search_columns, $field;
        } elsif ($action eq 'groupby') {
            push @search_columns, $field;
            push @group_by,       $field;
        } elsif ($action eq 'sum') {
            push @search_columns, { $field => { sum => $field } };
        }
    }

    # Build a WHERE clause from parameters like 'ticker=A&day=2010-01-01'.
    my %where;
    for my $param (qw(day ticker)) {
        my $value = $self->request->param($param);
        next unless defined $value;
        $where{$param} = $value;
    }

    # Do the actual search
    my $rs = get_schema()->resultset('Stock')->search(
        \%where,
        {   columns => \@search_columns,
            (@group_by ? (group_by => \@group_by) : ()),
        }
    );
    return ($rs, \@result_columns);
}

sub content_types_provided {
    [ { 'application/json' => 'to_json' }, { 'text/csv' => 'to_csv' } ];
}

sub to_json {
    my $self = shift;
    encode_json([ map { +{ $_->get_columns } } $self->search_queries->all ]);
}

sub to_csv {
    my $self = shift;
    my ($rs, $columns) = $self->search_queries;
    return join "\n" => join(',' => @$columns),
      map { join ',' => @{ { $_->get_columns } }{@$columns} } $rs->all;
}

sub generate_etag {

    # FIXME
    sha1_hex(scalar localtime);
}

sub last_modified {

    # FIXME
    create_date(scalar localtime);
}
1;
