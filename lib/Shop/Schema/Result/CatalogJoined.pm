use utf8;
package Shop::Schema::Result::CatalogJoined;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Shop::Schema::Result::CatalogJoined

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';
__PACKAGE__->table_class("DBIx::Class::ResultSource::View");

=head1 TABLE: C<catalog_joined>

=cut

__PACKAGE__->table("catalog_joined");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_nullable: 1

=head2 name

  data_type: 'text'
  is_nullable: 1

=head2 price

  data_type: 'integer'
  is_nullable: 1

=head2 category_id

  data_type: 'integer'
  is_nullable: 1

=head2 category_name

  data_type: 'text'
  is_nullable: 1

=head2 category_location

  data_type: 'text'
  is_nullable: 1

=head2 stores_id

  data_type: 'text'
  is_nullable: 1

=head2 stores_name

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_nullable => 1 },
  "name",
  { data_type => "text", is_nullable => 1 },
  "price",
  { data_type => "integer", is_nullable => 1 },
  "category_id",
  { data_type => "integer", is_nullable => 1 },
  "category_name",
  { data_type => "text", is_nullable => 1 },
  "category_location",
  { data_type => "text", is_nullable => 1 },
  "stores_id",
  { data_type => "text", is_nullable => 1 },
  "stores_name",
  { data_type => "text", is_nullable => 1 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-05-28 22:27:28
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Sn6emiLfAGjN/4sXOx74nw
# These lines were loaded from './Shop/Schema/Result/CatalogJoined.pm' found in @INC.
# They are now part of the custom portion of this file
# for you to hand-edit.  If you do not either delete
# this section or remove that file from @INC, this section
# will be repeated redundantly when you re-create this
# file again via Loader!  See skip_load_external to disable
# this feature.

use utf8;
package Shop::Schema::Result::CatalogJoined;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Shop::Schema::Result::CatalogJoined

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';
__PACKAGE__->table_class("DBIx::Class::ResultSource::View");

=head1 TABLE: C<catalog_joined>

=cut

__PACKAGE__->table("catalog_joined");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_nullable: 1

=head2 name

  data_type: 'text'
  is_nullable: 1

=head2 price

  data_type: 'integer'
  is_nullable: 1

=head2 category_id

  data_type: 'integer'
  is_nullable: 1

=head2 category_name

  data_type: 'text'
  is_nullable: 1

=head2 category_location

  data_type: 'text'
  is_nullable: 1

=head2 stores_id

  data_type: 'text'
  is_nullable: 1

=head2 stores_name

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_nullable => 1 },
  "name",
  { data_type => "text", is_nullable => 1 },
  "price",
  { data_type => "integer", is_nullable => 1 },
  "category_id",
  { data_type => "integer", is_nullable => 1 },
  "category_name",
  { data_type => "text", is_nullable => 1 },
  "category_location",
  { data_type => "text", is_nullable => 1 },
  "stores_id",
  { data_type => "text", is_nullable => 1 },
  "stores_name",
  { data_type => "text", is_nullable => 1 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-05-28 18:53:07
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ZyHukhvnCFSVyYQnzWsG9w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
# End of lines loaded from './Shop/Schema/Result/CatalogJoined.pm' 


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
