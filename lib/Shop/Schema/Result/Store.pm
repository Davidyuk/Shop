use utf8;
package Shop::Schema::Result::Store;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Shop::Schema::Result::Store

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<stores>

=cut

__PACKAGE__->table("stores");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'stores_id_seq'

=head2 name

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "stores_id_seq",
  },
  "name",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 items_stores

Type: has_many

Related object: L<Shop::Schema::Result::ItemsStore>

=cut

__PACKAGE__->has_many(
  "items_stores",
  "Shop::Schema::Result::ItemsStore",
  { "foreign.store_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-05 20:16:36
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:fFAKKualpccZLBEff/b4Eg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
