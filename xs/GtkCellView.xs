/*
 * Copyright (c) 2004 by the gtk2-perl team (see the file AUTHORS)
 *
 * Licensed under the LGPL, see LICENSE file for more information.
 *
 * $Header$
 */

#include "gtk2perl.h"

/* Copied from GObject.xs. */
static void
init_property_value (GObject * object,
		     const char * name,
		     GValue * value)
{
	GParamSpec * pspec;
	pspec = g_object_class_find_property (G_OBJECT_GET_CLASS (object),
	                                      name);
	if (!pspec) {
		const char * classname =
			gperl_object_package_from_type (G_OBJECT_TYPE (object));
		if (!classname)
			classname = G_OBJECT_TYPE_NAME (object);
		croak ("type %s does not support property '%s'",
		       classname, name);
	}
	g_value_init (value, G_PARAM_SPEC_VALUE_TYPE (pspec));
}

MODULE = Gtk2::CellView PACKAGE = Gtk2::CellView PREFIX = gtk_cell_view_

GtkWidget * gtk_cell_view_new (class)
    C_ARGS:
	/* void */

GtkWidget * gtk_cell_view_new_with_text (class, text)
	const gchar * text
    C_ARGS:
	text

GtkWidget * gtk_cell_view_new_with_markup (class, markup)
	const gchar * markup
    C_ARGS:
	markup

GtkWidget * gtk_cell_view_new_with_pixbuf (class, pixbuf)
	GdkPixbuf * pixbuf
    C_ARGS:
	pixbuf

## void gtk_cell_view_set_value (GtkCellView * cell_view, GtkCellRenderer * renderer, gchar * property, GValue * value);
void
gtk_cell_view_set_value (GtkCellView * cell_view, GtkCellRenderer * renderer, gchar * property, SV * sv);
    PREINIT:
	GValue value = {0,};
    CODE:
	init_property_value (G_OBJECT (renderer), property, &value);
	gperl_value_from_sv (&value, sv);
	gtk_cell_view_set_value (cell_view, renderer, property, &value);
	g_value_unset (&value);

=for apidoc
=for signature $cell_view->set_values (renderer, key => value, ...)
=cut
## void gtk_cell_view_set_values (GtkCellView * cell_view, GtkCellRenderer * renderer, ...);
void
gtk_cell_view_set_values (GtkCellView * cell_view, GtkCellRenderer * renderer, ...);
    PREINIT:
	GValue value = {0,};
	int i;
    CODE:
	if (0 != ((items - 2) % 2))
		croak ("set_values expects name => value pairs "
		       "(odd number of arguments detected)");

	for (i = 2; i < items; i += 2) {
		char *name = SvPV_nolen (ST (i));
		SV *sv = ST (i + 1);

		init_property_value (G_OBJECT (renderer), name, &value);
		gperl_value_from_sv (&value, sv);
		gtk_cell_view_set_value (cell_view, renderer, name, &value);
		g_value_unset (&value);
	}

void gtk_cell_view_set_model (GtkCellView * cell_view, GtkTreeModel * model);

void gtk_cell_view_set_displayed_row (GtkCellView * cell_view, GtkTreePath * path);

GtkTreePath_own * gtk_cell_view_get_displayed_row (GtkCellView * cell_view);

## gboolean gtk_cell_view_get_size_of_row (GtkCellView * cell_view, GtkTreePath * path, GtkRequisition * requisition);
GtkRequisition_copy *
gtk_cell_view_get_size_of_row (GtkCellView * cell_view, GtkTreePath * path)
    PREINIT:
	GtkRequisition requisition;
    CODE:
	gtk_cell_view_get_size_of_row (cell_view, path, &requisition);
	RETVAL = &requisition;
    OUTPUT:
	RETVAL

void gtk_cell_view_set_background_color (GtkCellView * cell_view, const GdkColor * color);

void gtk_cell_view_set_cell_data (GtkCellView * cellview);

## GList * gtk_cell_view_get_cell_renderers (GtkCellView * cellview);
void
gtk_cell_view_get_cell_renderers (GtkCellView * cellview);
    PREINIT:
	GList * list;
    PPCODE:
	list = gtk_cell_view_get_cell_renderers (cellview);
	if (list)
	{
		GList * curr;
		
		for (curr = list; curr; curr = g_list_next (curr))
			XPUSHs (sv_2mortal (newSVGtkCellRenderer (curr->data)));
		
		g_list_free (list);
	}
	else
		XSRETURN_EMPTY;
