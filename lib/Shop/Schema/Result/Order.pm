use utf8;
package Shop::Schema::Result::Order;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Shop::Schema::Result::Order

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<orders>

=cut

__PACKAGE__->table("orders");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'orders_id_seq'

=head2 user_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 items

  data_type: 'text'
  is_nullable: 1

=head2 status_id

  data_type: 'integer'
  default_value: 1
  is_foreign_key: 1
  is_nullable: 0

=head2 comment

  data_type: 'text'
  is_nullable: 1

=head2 createtime

  data_type: 'timestamp with time zone'
  is_nullable: 1

=head2 address

  data_type: 'text'
  is_nullable: 1

=head2 payment

  data_type: 'text'
  is_nullable: 1

=head2 hidden

  data_type: 'boolean'
  default_value: false
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "orders_id_seq",
  },
  "user_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "items",
  { data_type => "text", is_nullable => 1 },
  "status_id",
  {
    data_type      => "integer",
    default_value  => 1,
    is_foreign_key => 1,
    is_nullable    => 0,
  },
  "comment",
  { data_type => "text", is_nullable => 1 },
  "createtime",
  { data_type => "timestamp with time zone", is_nullable => 1 },
  "address",
  { data_type => "text", is_nullable => 1 },
  "payment",
  { data_type => "text", is_nullable => 1 },
  "hidden",
  { data_type => "boolean", default_value => \"false", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 status

Type: belongs_to

Related object: L<Shop::Schema::Result::Status>

=cut

__PACKAGE__->belongs_to(
  "status",
  "Shop::Schema::Result::Status",
  { id => "status_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

=head2 user

Type: belongs_to

Related object: L<Shop::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "user",
  "Shop::Schema::Result::User",
  { id => "user_id" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-26 00:35:46
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:82wNjr/SCU33WcCXry8ufQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
