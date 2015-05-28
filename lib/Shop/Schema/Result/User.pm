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

=head2 name

  data_type: 'text'
  is_nullable: 1

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

=head2 address

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
  "name",
  { data_type => "text", is_nullable => 1 },
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
  "address",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-05-28 22:27:28
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:I25bsAqR8rVj0L9vVvPnNA
# These lines were loaded from './Shop/Schema/Result/User.pm' found in @INC.
# They are now part of the custom portion of this file
# for you to hand-edit.  If you do not either delete
# this section or remove that file from @INC, this section
# will be repeated redundantly when you re-create this
# file again via Loader!  See skip_load_external to disable
# this feature.

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

=head2 name

  data_type: 'text'
  is_nullable: 1

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

=head2 address

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
  "name",
  { data_type => "text", is_nullable => 1 },
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
  "address",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-05-28 18:53:07
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:s0mXezXOwcE2cB6jAZB4iA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
# End of lines loaded from './Shop/Schema/Result/User.pm' 


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
