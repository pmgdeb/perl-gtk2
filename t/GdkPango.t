#!/usr/bin/perl
use strict;
use warnings;
use Gtk2::TestHelper
  at_least_version => [2, 6, 0, "GdkPango is new in 2.6"],
  tests => 2;

# $Header$

my $screen = Gtk2::Gdk::Screen -> get_default();

my $renderer = Gtk2::Gdk::PangoRenderer -> new($screen);
isa_ok($renderer, "Gtk2::Gdk::PangoRenderer");

$renderer = Gtk2::Gdk::PangoRenderer -> get_default($screen);
isa_ok($renderer, "Gtk2::Gdk::PangoRenderer");

my $window = Gtk2::Window -> new();
$window -> realize();
$renderer -> set_drawable(undef);
$renderer -> set_drawable($window -> window);

my $gc = Gtk2::Gdk::GC -> new($window -> window);
$renderer -> set_gc(undef);
$renderer -> set_gc($gc);

$renderer -> activate();

# Stolen from examples/color_snooper.pl
my $data = pack 'C*',
     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
     0x00, 0x00, 0x00, 0x1c, 0x00, 0x00, 0x00, 0x22, 0x00, 0x00, 0x00, 0x41,
     0x00, 0x00, 0xc0, 0xa1, 0x00, 0x00, 0x20, 0xbc, 0x00, 0x00, 0x40, 0xbb,
     0x00, 0x00, 0x80, 0x44, 0x00, 0x00, 0x40, 0x34, 0x00, 0x00, 0x20, 0x13,
     0x00, 0x00, 0x90, 0x15, 0x00, 0x00, 0xc8, 0x00, 0x00, 0x00, 0x64, 0x00,
     0x00, 0x00, 0x32, 0x00, 0x00, 0x00, 0x19, 0x00, 0x00, 0x80, 0x0c, 0x00,
     0x00, 0x40, 0x06, 0x00, 0x00, 0x40, 0x03, 0x00, 0x00, 0xe0, 0x01, 0x00,
     0x00, 0x20, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00;
my $bitmap = Gtk2::Gdk::Bitmap -> create_from_data($window -> window, $data,
                                                   32, 32);
$renderer -> set_stipple("foreground", undef);
$renderer -> set_stipple("foreground", $bitmap);

my $color = Gtk2::Gdk::Color -> new(0xffff, 0xffff, 0xffff);
$renderer -> set_override_color("background", undef);
$renderer -> set_override_color("background", $color);

__END__

Copyright (C) 2005 by the gtk2-perl team (see the file AUTHORS for the full
list).  See LICENSE for more information.
