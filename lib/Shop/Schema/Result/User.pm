use utf8;
package Shop::Schema::Result::User;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Shop::Schema::Result::User

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<users>

=cut

__PACKAGE__->table("users");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'users_id_seq'

=head2 role

  data_type: 'enum'
  extra: {custom_type_name => "role",list => ["admin","manager","user"]}
  is_nullable: 1

=head2 email

  data_type: 'text'
  is_nullable: 1

=head2 passhash

  data_type: 'text'
  is_nullable: 1

=head2 salt

  data_type: 'text'
  is_nullable: 1

=head2 name

  data_type: 'text'
  is_nullable: 1

=head2 sname

  data_type: 'text'
  is_nullable: 1

=head2 address

  data_type: 'text'
  is_nullable: 1

=head2 payment

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "users_id_seq",
  },
  "role",
  {
    data_type => "enum",
    extra => { custom_type_name => "role", list => ["admin", "manager", "user"] },
    is_nullable => 1,
  },
  "email",
  { data_type => "text", is_nullable => 1 },
  "passhash",
  { data_type => "text", is_nullable => 1 },
  "salt",
  { data_type => "text", is_nullable => 1 },
  "name",
  { data_type => "text", is_nullable => 1 },
  "sname",
  { data_type => "text", is_nullable => 1 },
  "address",
  { data_type => "text", is_nullable => 1 },
  "payment",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 orders

Type: has_many

Related object: L<Shop::Schema::Result::Order>

=cut

__PACKAGE__->has_many(
  "orders",
  "Shop::Schema::Result::Order",
  { "foreign.user_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 users_stores

Type: has_many

Related object: L<Shop::Schema::Result::UsersStore>

=cut

__PACKAGE__->has_many(
  "users_stores",
  "Shop::Schema::Result::UsersStore",
  { "foreign.user_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 stores

Type: many_to_many

Composing rels: L</users_stores> -> store

=cut

__PACKAGE__->many_to_many("stores", "users_stores", "store");


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-26 00:35:46
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:eJkHduxgo/2vvEy0OEEPHw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
