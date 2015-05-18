use utf8;
package Shop::Schema::Result::Catalog;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Shop::Schema::Result::Catalog

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<catalog>

=cut

__PACKAGE__->table("catalog");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'catalog_id_seq'

=head2 name

  data_type: 'text'
  is_nullable: 1

=head2 price

  data_type: 'integer'
  is_nullable: 1

=head2 category_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "catalog_id_seq",
  },
  "name",
  { data_type => "text", is_nullable => 1 },
  "price",
  { data_type => "integer", is_nullable => 1 },
  "category_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 category

Type: belongs_to

Related object: L<Shop::Schema::Result::Category>

=cut

__PACKAGE__->belongs_to(
  "category",
  "Shop::Schema::Result::Category",
  { id => "category_id" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);

=head2 stocks

Type: has_many

Related object: L<Shop::Schema::Result::Stock>

=cut

__PACKAGE__->has_many(
  "stocks",
  "Shop::Schema::Result::Stock",
  { "foreign.catalog_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-05-10 08:02:22
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ULGoKoF2JfZ64p4XjT8/OA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
