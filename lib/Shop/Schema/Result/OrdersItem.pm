use utf8;
package Shop::Schema::Result::OrdersItem;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Shop::Schema::Result::OrdersItem

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<orders_items>

=cut

__PACKAGE__->table("orders_items");

=head1 ACCESSORS

=head2 order_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 item_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 count

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "order_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "item_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "count",
  { data_type => "integer", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</order_id>

=item * L</item_id>

=back

=cut

__PACKAGE__->set_primary_key("order_id", "item_id");

=head1 RELATIONS

=head2 item

Type: belongs_to

Related object: L<Shop::Schema::Result::Item>

=cut

__PACKAGE__->belongs_to(
  "item",
  "Shop::Schema::Result::Item",
  { id => "item_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

=head2 order

Type: belongs_to

Related object: L<Shop::Schema::Result::Order>

=cut

__PACKAGE__->belongs_to(
  "order",
  "Shop::Schema::Result::Order",
  { id => "order_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-01 10:12:38
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:0tws69eEM8DThW6gucv5NQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
