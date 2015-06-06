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


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-05 20:16:36
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:SPqEEVss9ipPdH2TPQiIAg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
