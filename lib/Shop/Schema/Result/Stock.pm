use utf8;
package Shop::Schema::Result::Stock;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Shop::Schema::Result::Stock

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<stocks>

=cut

__PACKAGE__->table("stocks");

=head1 ACCESSORS

=head2 catalog_id

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
  "catalog_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "store_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "count",
  { data_type => "integer", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</catalog_id>

=item * L</store_id>

=back

=cut

__PACKAGE__->set_primary_key("catalog_id", "store_id");

=head1 RELATIONS

=head2 catalog

Type: belongs_to

Related object: L<Shop::Schema::Result::Catalog>

=cut

__PACKAGE__->belongs_to(
  "catalog",
  "Shop::Schema::Result::Catalog",
  { id => "catalog_id" },
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


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-05-28 22:27:28
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:wzLJGZEHnEqu8BozCM5rcA
# These lines were loaded from './Shop/Schema/Result/Stock.pm' found in @INC.
# They are now part of the custom portion of this file
# for you to hand-edit.  If you do not either delete
# this section or remove that file from @INC, this section
# will be repeated redundantly when you re-create this
# file again via Loader!  See skip_load_external to disable
# this feature.

use utf8;
package Shop::Schema::Result::Stock;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Shop::Schema::Result::Stock

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<stocks>

=cut

__PACKAGE__->table("stocks");

=head1 ACCESSORS

=head2 catalog_id

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
  "catalog_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "store_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "count",
  { data_type => "integer", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</catalog_id>

=item * L</store_id>

=back

=cut

__PACKAGE__->set_primary_key("catalog_id", "store_id");

=head1 RELATIONS

=head2 catalog

Type: belongs_to

Related object: L<Shop::Schema::Result::Catalog>

=cut

__PACKAGE__->belongs_to(
  "catalog",
  "Shop::Schema::Result::Catalog",
  { id => "catalog_id" },
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


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-05-28 18:53:07
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:iNvF/R8oMyFNAU6xKdApGA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
# End of lines loaded from './Shop/Schema/Result/Stock.pm' 


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
