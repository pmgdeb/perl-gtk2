#
# $Header$
#

use Gtk2::TestHelper
	# FIXME 2.4
	at_least_version => [2, 3, 0, "Action-based menus are new in 2.4"],
	tests => 4;

my $button = Gtk2::ToggleToolButton->new;
isa_ok ($button, 'Gtk2::ToggleToolButton');

$button = Gtk2::ToggleToolButton->new_from_stock ('gtk-ok');
isa_ok ($button, 'Gtk2::ToggleToolButton');

$button->set_active (TRUE);
ok ($button->get_active);

$button->set_active (FALSE);
ok (!$button->get_active);
