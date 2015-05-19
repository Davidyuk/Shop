use utf8;
package Shop::Schema::Result::CatalogJoined;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Shop::Schema::Result::CatalogJoined

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';
__PACKAGE__->table_class("DBIx::Class::ResultSource::View");

=head1 TABLE: C<catalog_joined>

=cut

__PACKAGE__->table("catalog_joined");

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

=head2 count

  data_type: 'bigint'
  is_nullable: 1

=head2 category_name

  data_type: 'text'
  is_nullable: 1

=head2 category_id

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_nullable => 1 },
  "name",
  { data_type => "text", is_nullable => 1 },
  "price",
  { data_type => "integer", is_nullable => 1 },
  "count",
  { data_type => "bigint", is_nullable => 1 },
  "category_name",
  { data_type => "text", is_nullable => 1 },
  "category_id",
  { data_type => "integer", is_nullable => 1 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-05-19 01:55:23
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:8iwvJPLb5dNoUo/06SuvpQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
