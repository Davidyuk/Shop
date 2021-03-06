use utf8;
package Shop::Schema::Result::Item;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Shop::Schema::Result::Item

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<items>

=cut

__PACKAGE__->table("items");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'items_id_seq'

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
    sequence          => "items_id_seq",
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

=head2 items_stores

Type: has_many

Related object: L<Shop::Schema::Result::ItemsStore>

=cut

__PACKAGE__->has_many(
  "items_stores",
  "Shop::Schema::Result::ItemsStore",
  { "foreign.item_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-26 00:35:46
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:FL/QmoL+JOygNEhqNSKvPA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
