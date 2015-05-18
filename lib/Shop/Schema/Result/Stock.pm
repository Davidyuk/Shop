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

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'stocks_id_seq'

=head2 catalog_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 store_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 count

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "stocks_id_seq",
  },
  "catalog_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "store_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "count",
  { data_type => "integer", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 catalog

Type: belongs_to

Related object: L<Shop::Schema::Result::Catalog>

=cut

__PACKAGE__->belongs_to(
  "catalog",
  "Shop::Schema::Result::Catalog",
  { id => "catalog_id" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

=head2 store

Type: belongs_to

Related object: L<Shop::Schema::Result::Store>

=cut

__PACKAGE__->belongs_to(
  "store",
  "Shop::Schema::Result::Store",
  { id => "store_id" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-05-10 08:02:22
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:9JEq+i6Rk7+PEOd8YZlqVw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
