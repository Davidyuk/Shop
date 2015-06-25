use utf8;
package Shop::Schema::Result::Status;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Shop::Schema::Result::Status

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<statuses>

=cut

__PACKAGE__->table("statuses");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'statuses_id_seq'

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
    sequence          => "statuses_id_seq",
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

=head2 orders

Type: has_many

Related object: L<Shop::Schema::Result::Order>

=cut

__PACKAGE__->has_many(
  "orders",
  "Shop::Schema::Result::Order",
  { "foreign.status_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-26 00:35:46
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:SLN4cXphO7Kc/G5FaUmvxQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
