use utf8;
package Shop::Schema::Result::ItemJoined;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Shop::Schema::Result::ItemJoined

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';
__PACKAGE__->table_class("DBIx::Class::ResultSource::View");

=head1 TABLE: C<items_joined>

=cut

__PACKAGE__->table("items_joined");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_nullable: 1

=head2 name

  data_type: 'text'
  is_nullable: 1

=head2 price

  data_type: 'integer'
  is_nullable: 1

=head2 category_id

  data_type: 'integer'
  is_nullable: 1

=head2 category_name

  data_type: 'text'
  is_nullable: 1

=head2 category_location

  data_type: 'text'
  is_nullable: 1

=head2 stores_id

  data_type: 'text'
  is_nullable: 1

=head2 stores_name

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_nullable => 1 },
  "name",
  { data_type => "text", is_nullable => 1 },
  "price",
  { data_type => "integer", is_nullable => 1 },
  "category_id",
  { data_type => "integer", is_nullable => 1 },
  "category_name",
  { data_type => "text", is_nullable => 1 },
  "category_location",
  { data_type => "text", is_nullable => 1 },
  "stores_id",
  { data_type => "text", is_nullable => 1 },
  "stores_name",
  { data_type => "text", is_nullable => 1 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-26 00:35:46
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:As3mo1xjvFj+SNWznbfJgw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
