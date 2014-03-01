use utf8;
package Stocks::Schema::Result::Stock;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Stocks::Schema::Result::Stock

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<stocks>

=cut

__PACKAGE__->table("stocks");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'stocks_id_seq'

=head2 day

  data_type: 'date'
  is_nullable: 0

=head2 ticker

  data_type: 'text'
  is_nullable: 0

=head2 open

  data_type: 'numeric'
  is_nullable: 0
  size: [5,2]

=head2 high

  data_type: 'numeric'
  is_nullable: 0
  size: [5,2]

=head2 low

  data_type: 'numeric'
  is_nullable: 0
  size: [5,2]

=head2 close

  data_type: 'numeric'
  is_nullable: 0
  size: [5,2]

=head2 volume

  data_type: 'integer'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "stocks_id_seq",
  },
  "day",
  { data_type => "date", is_nullable => 0 },
  "ticker",
  { data_type => "text", is_nullable => 0 },
  "open",
  { data_type => "numeric", is_nullable => 0, size => [5, 2] },
  "high",
  { data_type => "numeric", is_nullable => 0, size => [5, 2] },
  "low",
  { data_type => "numeric", is_nullable => 0, size => [5, 2] },
  "close",
  { data_type => "numeric", is_nullable => 0, size => [5, 2] },
  "volume",
  { data_type => "integer", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07039 @ 2014-03-01 22:13:41
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:4KFQj6LVhykvLw+cH8FwOA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
