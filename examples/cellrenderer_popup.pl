#!/usr/bin/perl -w

=doc

This is an example of creating a custom cell renderer.  The code isn't
terribly pretty, but you should be able to get the gist.  If you want
to use this object, then go ahead, but remember the gpl.

=cut

#
# Copyright (C) 2003 by muppet
# 
# This library is free software; you can redistribute it and/or modify it under
# the terms of the GNU Library General Public License as published by the Free
# Software Foundation; either version 2.1 of the License, or (at your option)
# any later version.
# 
# This library is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the GNU Library General Public License for
# more details.
# 
# You should have received a copy of the GNU Library General Public License
# along with this library; if not, write to the Free Software Foundation, Inc.,
# 59 Temple Place - Suite 330, Boston, MA  02111-1307  USA.
#
# $Header$
#

use Gtk2 -init;

package Mup::CellRendererPopup;

use Glib::Object::Subclass
	Gtk2::CellRenderer::,
	signals => {
		edited => {
			flags => [qw/run-last/],
			#                  path         index
			param_types => [qw/Glib::String Glib::Int/],
		},
	},
	properties => [
		Glib::ParamSpec->boolean ('show_box', 'Show Box',
		                          'If true, draw an option menu-looking background on the cell',
					  1, ['readable', 'writable']),
		Glib::ParamSpec->boolean ('editable', 'Editable',
		                          'Can i change that?',
					  0, ['readable', 'writable']),
		Glib::ParamSpec->int ('index', 'Index',
		                      'Index of selected list item',
				      0, 65535, 0, [qw/readable writable/]),
		Glib::ParamSpec->boxed ('list', 'List',
		                        'List of possible values',
					'Glib::Scalar',
				        [qw/readable writable/]),
	],
	;

# !!!! very important !!!!
__PACKAGE__->_install_overrides;

use Data::Dumper;

use constant xpad => 3;
use constant ypad => 2;
# arrow will use text height
use constant arrow_width => 15;

sub INIT_INSTANCE {
	my $self = shift;
	$self->{show_box} = 1;
}

sub calc_size {
	my ($cell, $layout) = @_;
	my ($w, $h) = $layout->get_pixel_size;
	return (0, 0, $w + xpad * 2 + arrow_width, $h + ypad * 2);
}

sub on_get_size {
	my ($cell, $widget, $area) = @_;
	if ($area) {
		return (3, 3, $area->width - arrow_width - 2*xpad - 4, $area->height - 6);
	}
	my $layout = $cell->get_layout ($widget);
	$layout->set_text ($cell->{list}[$cell->{index}] || "");
	return $cell->calc_size ($layout);
}

sub get_layout {
	my ($cell, $widget) = @_;
	return $cell->{layout} if defined $cell->{layout};
	return $cell->{layout} = $widget->create_pango_layout ("");
}

sub on_render {
	my ($cell, $window, $widget, $background_area, $cell_area, $expose_area, $flags) = @_;
	my $state = 'normal';

	if ($cell->{show_box}) {
		$widget->get_style->paint_box ($window, $widget->state,
					 'out', $cell_area,
					 undef, "optionmenu",
					 $cell_area->x,
					 $cell_area->y,
					 $cell_area->width,
					 $cell_area->height);
	} else {
		if (grep {/selected/} @$flags) {
			$state = $widget->has_focus
			       ? 'selected'
			       : 'active';
		} else {
			$state = $widget->state eq 'insensitive'
			       ? 'insensitive'
			       : 'normal';
		}
	}

	my $layout = $cell->get_layout ($widget);
	$layout->set_text ($cell->{list}[$cell->{index}] || "");
	my ($xoff, $yoff, $width, $height) = $cell->calc_size ($layout);

	$widget->get_style->paint_layout ($window,
				 $state,
			         1, $cell_area,
				 $widget, "cellrenderertext",
                                 $cell_area->x + $xoff + xpad,
                                 $cell_area->y + $yoff + ypad,
				 $layout);
	$widget->get_style->paint_arrow ($window, $state, 'none',
				$cell_area, $widget, "",
				'down', 0,
				$cell_area->x+$cell_area->width - arrow_width,
                                $cell_area->y+$cell_area->height - ($cell_area->height - 2),
				arrow_width - 3, $cell_area->height - 2);
}

sub menu_pos_func {
	my ($menu, $x, $y, $data) = @_;
	my ($treeview, $cell_area) = @$data;
	my ($wx, $wy) = $treeview->get_bin_window->get_origin;
        my ($tx, $ty) = $treeview->tree_to_widget_coords($cell_area->x, $cell_area->y);
	$x = $wx + $tx + xpad;
	$y = $wy + $ty + $cell_area->height / 2 - 2;
	# center the menu vertically around the selected item.
	# this is inspired heavily by GtkOptionMenu.
	my $active = $menu->get_active;
	$y -= $active->get_child_requisition->height / 2 if $active;
	foreach my $i ($menu->get_children) {
		last if $i == $active;
		$y -= $i->get_child_requisition->height if $i->visible;
	}
	# play nicely with rtl languages
	if ($treeview->get_direction eq 'rtl') {
		$x = $wx + $tx + $cell_area->width -
			$menu->get_child_requisition->width;
	}
	return ($x, $y, 1);
}




sub editing_done {
	warn Dumper(\@_);
	my ($item, $cell) = @_;
	$cell->signal_emit ('edited', $item->{path}, $item->{index});
}

sub on_start_editing {
	my ($cell, $event, $widget, $path, $background_area, $cell_area, $flags) = @_;
	my $menu = Gtk2::Menu->new;
	my @data = @{ $cell->{list} };
	for (my $i = 0 ; $i < @data ; $i++) {
		my $item = Gtk2::MenuItem->new ($data[$i]);
		$item->show;
		$menu->append ($item);
		$item->{path} = $path;
		$item->{index} = $i;
		$item->{text} = $data[$i];
		$item->signal_connect (activate => \&editing_done, $cell);
	}
	$menu->set_active ($cell->{index});
	$menu->popup (undef, undef,
	              \&menu_pos_func, [$widget, $cell_area],
	              $event ? $event->button : 0, 0);
	$item = $menu->get_active;
	$menu->select_item ($item) if $item;
	undef;
}


##########################################################################
# driver code
package main;

$window = Gtk2::Window->new;
$window->set_title ('cell renderer test');
$window->signal_connect (delete_event => sub { Gtk2->main_quit; 0; });

$vbox = Gtk2::VBox->new;
$window->add ($vbox);

$label = Gtk2::Label->new;
$label->set_markup ('<big>F-Words</big>');
$vbox->pack_start ($label, 0, 0, 0);

# create and load the model
$model = Gtk2::ListStore->new ('Glib::String', 'Glib::Scalar', 'Glib::Int');
foreach ([ 'foo',        [qw/foo bar baz/]],
         [ 'fluffy',     [qw/muffy tuffy buffy willow/]],
         [ 'flurble',    [qw/murble swurble curble/]],
         [ 'frob',       [qw/blob clob plob mob rob gob glob wob dob/]],
         [ 'frobnitz',   [qw/fronbination that's sweepin' the nation/]],
	 [ 'repeated',   [qw/fronbination that's sweepin' the nation the the the the/]],
#	 [ 'none',       []],
#	 [ 'verymany',   [(1..50)]],
         [ 'ftang',      [qw/quisinart/]],
         [ 'fire truck', [qw/red white green yellow polka-dot/]]) {
	my $iter = $model->append;
	$model->set ($iter, 0, $_->[0], 1, $_->[1], 2, rand (@{$_->[1]}));
}


# now a view
$treeview = Gtk2::TreeView->new ($model);

#
# regular editable text column for column 0, the string
#
$renderer = Gtk2::CellRendererText->new;
$renderer->set (editable => 1);;
$column = Gtk2::TreeViewColumn->new_with_attributes ('something', $renderer,
                                                     text => 0);
# this commits changes from the user's editing to the model.  compare and
# contrast with the one for the popup, below.
$renderer->signal_connect (edited => sub {
		my ($cell, $text_path, $new_text, $model) = @_;
		my $path = Gtk2::TreePath->new_from_string ($text_path);
		my $iter = $model->get_iter ($path);
		$model->set ($iter, 0, $new_text);
	}, $model);
$treeview->append_column ($column);

#
# text for col[1]
#
$renderer = Gtk2::CellRendererText->new;
$column = Gtk2::TreeViewColumn->new_with_attributes ('list', $renderer,);
# custom data func to show the list items from the scalar.
$column->set_cell_data_func ($renderer, sub {
		my ($tree_column, $cell, $model, $iter) = @_;
		my ($info) = $model->get ($iter, 1);
		$cell->set (text => "[".join(", ", @$info)."]");
	});
$treeview->append_column ($column);

#
# text for col[2]
#
$renderer = Gtk2::CellRendererText->new;
$column = Gtk2::TreeViewColumn->new_with_attributes ('index', $renderer,
                                                     text => 2);
$treeview->append_column ($column);

#
# custom cell renderer for cols 1 and 2, an editable popup menu
#
$renderer = Mup::CellRendererPopup->new;
$renderer->set (mode => 'editable');
$column = Gtk2::TreeViewColumn->new_with_attributes ('selector', $renderer,
                                                     list => 1,
						     'index' => 2,
						     );
# this handler commits the user's selection to the model.  compare with
# the one for the typical text renderer -- the only difference is a var name.
$renderer->signal_connect (edited => sub {
		my ($cell, $text_path, $new_index, $model) = @_;
		my $path = Gtk2::TreePath->new_from_string ($text_path);
		my $iter = $model->get_iter ($path);
		$model->set ($iter, 2, $new_index);
	}, $model);
$treeview->append_column ($column);


$vbox->pack_start ($treeview, 1, 1, 0);

$window->show_all;

Gtk2->main;
