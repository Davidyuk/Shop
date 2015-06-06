use utf8;
package Shop::Schema::Result::ItemsStore;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Shop::Schema::Result::ItemsStore

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<items_stores>

=cut

__PACKAGE__->table("items_stores");

=head1 ACCESSORS

=head2 item_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 store_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 count

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "item_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "store_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "count",
  { data_type => "integer", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</item_id>

=item * L</store_id>

=back

=cut

__PACKAGE__->set_primary_key("item_id", "store_id");

=head1 RELATIONS

=head2 item

Type: belongs_to

Related object: L<Shop::Schema::Result::Item>

=cut

__PACKAGE__->belongs_to(
  "item",
  "Shop::Schema::Result::Item",
  { id => "item_id" },
  { is_deferrable => 0, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 store

Type: belongs_to

Related object: L<Shop::Schema::Result::Store>

=cut

__PACKAGE__->belongs_to(
  "store",
  "Shop::Schema::Result::Store",
  { id => "store_id" },
  { is_deferrable => 0, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-05 20:16:36
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:FnXbFYRr4Er4C8RasSh52A


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
