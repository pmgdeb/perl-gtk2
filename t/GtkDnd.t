#!/usr/bin/perl -w
use strict;
use Gtk2::TestHelper tests => 4;

my $button = Gtk2::Button -> new("Bla");
my $window = Gtk2::Window -> new();

$window -> add($button);
$window -> realize();
$button -> realize();

$button -> drag_dest_set("all", "copy",
  { target => "BITMAP", info => 23 },
  { target => "STRING", flags => ["same-app", "same-widget"], info => 42 }
);

my $list = $button -> drag_dest_get_target_list();
$button -> drag_dest_set_target_list($list);

is($list -> find(Gtk2::Gdk -> TARGET_BITMAP), 23);
is($list -> find(Gtk2::Gdk -> TARGET_STRING), 42);

my $pixbuf = Gtk2::Gdk::Pixbuf -> new("rgb", 0, 8, 10, 10);

SKIP: {
  skip("Gtk2::Gdk::Event::new is new in 2.2", 1)
    if (Gtk2 -> check_version(2, 2, 0));

  # my $context = Gtk2::Gdk::DragContext -> begin($window -> window(), Gtk2::Gdk -> TARGET_STRING);
  my $context = Gtk2::Drag -> begin($button, $list, "default", 1, Gtk2::Gdk::Event -> new("button-press"));
  isa_ok($context, "Gtk2::Gdk::DragContext");

  # warn $button -> drag_dest_find_target($context, $list);
  # $context -> finish(1, 0, 0);
  # $button -> drag_get_data($context, Gtk2::Gdk -> TARGET_STRING, 0);
  # warn $context -> get_source_widget();

  $context -> set_icon_widget($window, 5, 5);
  # $context -> set_icon_pixmap(...);
  $context -> set_icon_pixbuf($pixbuf, 5, 5);
  $context -> set_icon_stock("gtk-add", 5, 5);
  $context -> set_icon_default();
}

is($button -> drag_check_threshold(5, 5, 100, 100), 1);

$button -> drag_highlight();
$button -> drag_unhighlight();

$button -> drag_dest_set_proxy($window -> window(), "xdnd", 0);
$button -> drag_dest_unset();

$button -> drag_source_set("shift-mask", "copy",
  { target => "BITMAP", info => 23 },
  { target => "STRING", flags => ["same-app", "same-widget"], info => 42 }
);

# $button -> drag_source_set_icon(...);
$button -> drag_source_set_icon_pixbuf($pixbuf);
$button -> drag_source_set_icon_stock("gtk-quit");

$button -> drag_source_unset();

__END__

Copyright (C) 2003 by the gtk2-perl team (see the file AUTHORS for the
full list).  See LICENSE for more information.