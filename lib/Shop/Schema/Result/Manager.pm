use utf8;
package Shop::Schema::Result::Manager;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Shop::Schema::Result::Manager

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<managers>

=cut

__PACKAGE__->table("managers");

=head1 ACCESSORS

=head2 user_id

  data_type: 'integer'
  is_nullable: 0

=head2 store_id

  data_type: 'integer'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "user_id",
  { data_type => "integer", is_nullable => 0 },
  "store_id",
  { data_type => "integer", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</user_id>

=item * L</store_id>

=back

=cut

__PACKAGE__->set_primary_key("user_id", "store_id");


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-05-28 22:27:28
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:PX/13xU5B16eIGqduvyD7g
# These lines were loaded from './Shop/Schema/Result/Manager.pm' found in @INC.
# They are now part of the custom portion of this file
# for you to hand-edit.  If you do not either delete
# this section or remove that file from @INC, this section
# will be repeated redundantly when you re-create this
# file again via Loader!  See skip_load_external to disable
# this feature.

use utf8;
package Shop::Schema::Result::Manager;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Shop::Schema::Result::Manager

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<managers>

=cut

__PACKAGE__->table("managers");

=head1 ACCESSORS

=head2 user_id

  data_type: 'integer'
  is_nullable: 0

=head2 store_id

  data_type: 'integer'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "user_id",
  { data_type => "integer", is_nullable => 0 },
  "store_id",
  { data_type => "integer", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</user_id>

=item * L</store_id>

=back

=cut

__PACKAGE__->set_primary_key("user_id", "store_id");


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-05-28 18:53:07
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:yQ+RiOIzeRE3WNBzZGrhpQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
# End of lines loaded from './Shop/Schema/Result/Manager.pm' 


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
