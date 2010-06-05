package Net::SimpleGrid::States;

=head1 NAME

Net::SimpleGrid::States - Constants representing the state values in the nodes.state column in the database.

=head1 DESCRIPTION

Constants representing the state values in the nodes.state column in the database.  Used with Grid::Manager and Grid::Node.

=head1 CONSTANTS

=head2 ENABLED

=head2 CLEANUP

=head2 DISABLED

=head2 INVALID

=head2 RESERVED

=cut

sub ENABLED { "enabled"; }
sub CLEANUP { "cleanup"; }
sub DISABLED { "disabled"; }
sub INVALID { "invalid"; }
sub RESERVED { "reserved"; }

1;

=head1 AUTHOR

Charles Woerner E<lt>charleswoerner@gmail.comE<gt>, 2008-02-14

=cut
