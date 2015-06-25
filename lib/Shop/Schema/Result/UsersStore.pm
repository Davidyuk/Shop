use utf8;
package Shop::Schema::Result::UsersStore;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Shop::Schema::Result::UsersStore

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<users_stores>

=cut

__PACKAGE__->table("users_stores");

=head1 ACCESSORS

=head2 user_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 store_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "user_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "store_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</user_id>

=item * L</store_id>

=back

=cut

__PACKAGE__->set_primary_key("user_id", "store_id");

=head1 RELATIONS

=head2 store

Type: belongs_to

Related object: L<Shop::Schema::Result::Store>

=cut

__PACKAGE__->belongs_to(
  "store",
  "Shop::Schema::Result::Store",
  { id => "store_id" },
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
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-26 00:35:46
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:IQkntboiNZIGTqvxmATGIw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
