/*
 * Copyright (c) 2003 by the gtk2-perl team (see the file AUTHORS)
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public
 * License along with this library; if not, write to the 
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330, 
 * Boston, MA  02111-1307  USA.
 *
 * $Header$
 */

#include "gtk2perl.h"

#define newSVGdkRectangle_ornull(r)	\
	((r) ? newSVGdkRectangle(r) : newSVsv (&PL_sv_undef))
#define newSVGdkEvent_ornull(e)	\
	((e) ? newSVGdkEvent(e) : newSVsv (&PL_sv_undef))
#define newSVGChar_ornull(s)	\
	((s) ? newSVGChar(s) : newSVsv (&PL_sv_undef))


static void gtk2perl_cell_renderer_class_init
                                      (GtkCellRendererClass * class);
static void gtk2perl_cell_renderer_get_size
                                      (GtkCellRenderer      * cell,
				       GtkWidget            * widget,
				       GdkRectangle         * cell_area,
				       gint                 * x_offset,
				       gint                 * y_offset,
				       gint                 * width,
				       gint                 * height);
static void gtk2perl_cell_renderer_render
                                      (GtkCellRenderer      * cell,
#if GTK_CHECK_VERSION(2,3,0)
                                       GdkDrawable          * window,
#else
				       GdkWindow            * window,
#endif
				       GtkWidget            * widget,
				       GdkRectangle         * background_area,
				       GdkRectangle         * cell_area,
				       GdkRectangle         * expose_area,
				       GtkCellRendererState   flags);
static gboolean gtk2perl_cell_renderer_activate
                                      (GtkCellRenderer      * cell,
				       GdkEvent             * event,
				       GtkWidget            * widget,
				       const gchar          * path,
				       GdkRectangle         * background_area,
				       GdkRectangle         * cell_area,
				       GtkCellRendererState   flags);
static GtkCellEditable * gtk2perl_cell_renderer_start_editing
                                      (GtkCellRenderer      * cell,
				       GdkEvent             * event,
				       GtkWidget            * widget,
				       const gchar          * path,
				       GdkRectangle         * background_area,
				       GdkRectangle         * cell_area,
				       GtkCellRendererState   flags);

/*
 * this mangles a CellRendererClass to call the local marshallers.
 * you should only ever call this on a new subclass of CellRenderer, never
 * directly on a preexisting CellRendererClass.
 */
static void
gtk2perl_cell_renderer_class_init (GtkCellRendererClass * class)
{
	class->get_size      = gtk2perl_cell_renderer_get_size;
	class->render        = gtk2perl_cell_renderer_render;
	class->activate      = gtk2perl_cell_renderer_activate;
	class->start_editing = gtk2perl_cell_renderer_start_editing;
}

/*
 * the following functions look for WHATEVER in the package belonging
 * to a cell.  this is our custom override, since CellRenderer does not
 * have signals for these virtual methods.
 */

#define GET_METHOD(cell, method, fallback)	\
	HV * stash = gperl_object_stash_from_type (G_OBJECT_TYPE (cell));    \
	GV * slot = gv_fetchmethod (stash, fallback);			     \
									     \
	if (slot && GvCV (slot))					     \
		warn ("%s is deprecated, use %s instead", fallback, method); \
	else								     \
		slot = gv_fetchmethod (stash, method);

static void
gtk2perl_cell_renderer_get_size (GtkCellRenderer      * cell,
				 GtkWidget            * widget,
				 GdkRectangle         * cell_area,
				 gint                 * x_offset,
				 gint                 * y_offset,
				 gint                 * width,
				 gint                 * height)
{
	GET_METHOD (cell, "GET_SIZE", "on_get_size");

	if (slot && GvCV (slot)) {
		int count, i;
		dSP;

		ENTER;
		SAVETMPS;
		PUSHMARK (SP);

		EXTEND (SP, 3);
		PUSHs (newSVGtkCellRenderer (cell));
		PUSHs (newSVGtkWidget (widget));
		PUSHs (sv_2mortal (newSVGdkRectangle_ornull (cell_area)));

		PUTBACK;
		count = call_sv ((SV *)GvCV (slot), G_ARRAY);
//		count = call_method ("GET_SIZE", G_ARRAY);
		SPAGAIN;
		if (count != 4)
			croak ("GET_SIZE must return four values -- "
			       "the x_offset, y_offset, width, and height");

		i = POPi;  if (height)   *height   = i;
		i = POPi;  if (width)    *width    = i;
		i = POPi;  if (y_offset) *y_offset = i;
		i = POPi;  if (x_offset) *x_offset = i;

		PUTBACK;
		FREETMPS;
		LEAVE;
	}
}

static void
gtk2perl_cell_renderer_render (GtkCellRenderer      * cell,
#if GTK_CHECK_VERSION(2,3,0)
			       GdkDrawable          * drawable,
#else
			       GdkWindow            * drawable,
#endif
			       GtkWidget            * widget,
			       GdkRectangle         * background_area,
			       GdkRectangle         * cell_area,
			       GdkRectangle         * expose_area,
			       GtkCellRendererState   flags)
{
	GET_METHOD (cell, "RENDER", "on_render");

	if (slot && GvCV (slot)) {
		dSP;

		ENTER;
		SAVETMPS;
		PUSHMARK (SP);

		EXTEND (SP, 7);
		PUSHs (newSVGtkCellRenderer (cell));
		PUSHs (newSVGdkDrawable_ornull (drawable));
		PUSHs (newSVGtkWidget_ornull (widget));
		PUSHs (sv_2mortal (newSVGdkRectangle_ornull (background_area)));
		PUSHs (sv_2mortal (newSVGdkRectangle_ornull (cell_area)));
		PUSHs (sv_2mortal (newSVGdkRectangle_ornull (expose_area)));
		PUSHs (sv_2mortal (newSVGtkCellRendererState (flags)));

		PUTBACK;
		call_sv ((SV *)GvCV (slot), G_VOID|G_DISCARD);
//		call_method ("RENDER", G_VOID|G_DISCARD);

		FREETMPS;
		LEAVE;
	}
}

static gboolean
gtk2perl_cell_renderer_activate (GtkCellRenderer      * cell,
				 GdkEvent             * event,
				 GtkWidget            * widget,
				 const gchar          * path,
				 GdkRectangle         * background_area,
				 GdkRectangle         * cell_area,
				 GtkCellRendererState   flags)
{
	gboolean retval = FALSE;

	GET_METHOD (cell, "ACTIVATE", "on_activate");

	if (slot && GvCV (slot)) {
		dSP;

		ENTER;
		SAVETMPS;
		PUSHMARK (SP);

		XPUSHs (newSVGtkCellRenderer (cell));
		XPUSHs (sv_2mortal (newSVGdkEvent_ornull (event)));
		XPUSHs (newSVGtkWidget_ornull (widget));
		XPUSHs (sv_2mortal (newSVGChar_ornull (path)));
		XPUSHs (sv_2mortal (newSVGdkRectangle_ornull (background_area)));
		XPUSHs (sv_2mortal (newSVGdkRectangle_ornull (cell_area)));
		XPUSHs (sv_2mortal (newSVGtkCellRendererState (flags)));

		PUTBACK;
		call_sv ((SV*) GvCV (slot), G_SCALAR);
//		call_method ("ACTIVATE", G_SCALAR);
		SPAGAIN;

		retval = POPi;

		PUTBACK;
		FREETMPS;
		LEAVE;
	}

	return retval;
}

static GtkCellEditable *
gtk2perl_cell_renderer_start_editing (GtkCellRenderer      * cell,
				      GdkEvent             * event,
				      GtkWidget            * widget,
				      const gchar          * path,
				      GdkRectangle         * background_area,
				      GdkRectangle         * cell_area,
				      GtkCellRendererState   flags)
{
	GtkCellEditable * editable = NULL;

	GET_METHOD (cell, "START_EDITING", "on_start_editing");

	if (slot && GvCV (slot)) {
		SV * sv;
		dSP;

		ENTER;
		SAVETMPS;
		PUSHMARK (SP);

		EXTEND (SP, 7);
		PUSHs (newSVGtkCellRenderer (cell));
		PUSHs (sv_2mortal (newSVGdkEvent_ornull (event)));
		PUSHs (newSVGtkWidget_ornull (widget));
		PUSHs (sv_2mortal (newSVGChar_ornull (path)));
		PUSHs (sv_2mortal (newSVGdkRectangle_ornull (background_area)));
		PUSHs (sv_2mortal (newSVGdkRectangle_ornull (cell_area)));
		PUSHs (sv_2mortal (newSVGtkCellRendererState (flags)));

		PUTBACK;
		call_sv ((SV*) GvCV (slot), G_SCALAR);
//		call_method ("START_EDITING", G_SCALAR);
		SPAGAIN;

		sv = POPs;
		editable = SvOK (sv)
		         ? GTK_CELL_EDITABLE (SvGObject (sv))
		         : NULL;

		PUTBACK;
		FREETMPS;
		LEAVE;
	}

	return editable;
}



MODULE = Gtk2::CellRenderer	PACKAGE = Gtk2::CellRenderer	PREFIX = gtk_cell_renderer_

=for object Gtk2::CellRenderer - An object that renders a single cell onto a Gtk2::Gdk::Drawable

=head1 DESCRIPTION

The Gtk2::CellRenderer is the base class for objects which render cells
onto drawables.  These objects are used primarily by the Gtk2::TreeView,
though they aren't tied to them in any specific way.

Typically, one cell renderer is used to draw many cells onto the screen.
Thus, the cell renderer doesn't keep state; instead, any state is set
immediately prior to use through the object property system.  The cell
is measured with C<get_size>, and then renderered with C<render>.

=head1 DERIVING NEW CELL RENDERERS

Gtk+ provides three cell renderers: Gtk2::CellRendererText,
Gtk2::CellRendererToggle, and Gtk2::CellRendererPixbuf.
You may derive a new renderer from any of these, or directly from
Gtk2::CellRenderer itself.

The new renderer must be a GObject, so you must follow the normal procedure
for creating a new Glib::Object (i.e., either Glib::Object::Subclass or
Glib::Type::register_object).  The new subclass can customize the object's
behavior by provide new implementations of these four methods:

=over

=item (x_offset, y_offset, width, height) = GET_SIZE ($cell, $widget, $cell_area)

=item RENDER ($cell, $drawable, $widget, $background_area, $cell_area, $expose_area, $flags)

=item boolean = ACTIVATE ($cell, $event, $widget, $path, $background_area, $cell_area, $flags)

=item celleditable = START_EDITING ($cell, $event, $widget, $path, $background_area, $cell_area, $flags)

=back

Note: for backward compatibility, the bizarre and non-standard scheme used
for this in 1.02x is still supported, but is deprecated and should not be
used in new code, and since i don't want people to use it any more i will
not document it here.

=cut

=for flags GtkCellRendererState
=cut

=for enum GtkCellRendererMode
=cut

## void gtk_cell_renderer_get_size (GtkCellRenderer *cell, GtkWidget *widget, GdkRectangle *cell_area, gint *x_offset, gint *y_offset, gint *width, gint *height)
=for apidoc
=for signature (x_offset, y_offset, width, height) = $cell->renderer_get_size ($widget, $cell_area)
=cut
void
gtk_cell_renderer_get_size (cell, widget, cell_area)
	GtkCellRenderer     * cell
	GtkWidget           * widget
	GdkRectangle_ornull * cell_area
    PREINIT:
	gint x_offset;
	gint y_offset;
	gint width;
	gint height;
    PPCODE:
	//cell_area.width = cell_area.height = 0;
	gtk_cell_renderer_get_size(cell, widget, cell_area,
		&x_offset, &y_offset, &width, &height);
	EXTEND(SP,4);
	PUSHs(sv_2mortal(newSViv(x_offset)));
	PUSHs(sv_2mortal(newSViv(y_offset)));
	PUSHs(sv_2mortal(newSViv(width)));
	PUSHs(sv_2mortal(newSViv(height)));

## void gtk_cell_renderer_render (GtkCellRenderer *cell, GdkWindow *window, GtkWidget *widget, GdkRectangle *background_area, GdkRectangle *cell_area, GdkRectangle *expose_area, GtkCellRendererState flags)
void
gtk_cell_renderer_render (cell, drawable, widget, background_area, cell_area, expose_area, flags)
	GtkCellRenderer      * cell
	GdkDrawable          * drawable
	GtkWidget            * widget
	GdkRectangle         * background_area
	GdkRectangle         * cell_area
	GdkRectangle         * expose_area
	GtkCellRendererState   flags

## gboolean gtk_cell_renderer_activate (GtkCellRenderer *cell, GdkEvent *event, GtkWidget *widget, const gchar *path, GdkRectangle *background_area, GdkRectangle *cell_area, GtkCellRendererState flags)
gboolean
gtk_cell_renderer_activate (cell, event, widget, path, background_area, cell_area, flags)
	GtkCellRenderer      * cell
	GdkEvent             * event
	GtkWidget            * widget
	const gchar          * path
	GdkRectangle         * background_area
	GdkRectangle         * cell_area
	GtkCellRendererState   flags

## void gtk_cell_renderer_set_fixed_size (GtkCellRenderer *cell, gint width, gint height)
void
gtk_cell_renderer_set_fixed_size (cell, width, height)
	GtkCellRenderer * cell
	gint              width
	gint              height

## void gtk_cell_renderer_get_fixed_size (GtkCellRenderer *cell, gint *width, gint *height)
void
gtk_cell_renderer_get_fixed_size (GtkCellRenderer * cell, OUTLIST gint width, OUTLIST gint height)

##GtkCellEditable* gtk_cell_renderer_start_editing (GtkCellRenderer *cell, GdkEvent *event, GtkWidget *widget, const gchar *path, GdkRectangle *background_area, GdkRectangle *cell_area, GtkCellRendererState flags)
GtkCellEditable_ornull *
gtk_cell_renderer_start_editing (cell, event, widget, path, background_area, cell_area, flags)
	GtkCellRenderer      * cell
	GdkEvent             * event
	GtkWidget            * widget
	const gchar          * path
	GdkRectangle         * background_area
	GdkRectangle         * cell_area
	GtkCellRendererState   flags


##
## Modify the underlying GObjectClass structure for the given package
## to call Perl methods as virtual overrides for the get_size, render, 
## activate, and start_editing vfuncs.  The overrides will look for 
## methods with all-caps versions of the vfunc names.
##
## This is called automatically by Glib::Type::register_object.
##
## For backward compatibility, we support being called directly as
## _install_overrides; this is deprecated, however.
##
void
_INSTALL_OVERRIDES (const char * package)
    ALIAS:
	_install_overrides = 1
    PREINIT:
	GType gtype;
	GtkCellRendererClass * class;
    CODE:
	//warn ("%s %s", ix == 1 ? "_install_overrides" : "_INSTALL_OVERRIDES",
	//               package);
	gtype = gperl_object_type_from_package (package);
	if (!gtype)
		croak ("package '%s' is not registered with Gtk2-Perl",
		       package);
	if (! g_type_is_a (gtype, GTK_TYPE_CELL_RENDERER))
		croak ("%s(%s) is not a GtkCellRenderer",
		       package, g_type_name (gtype));
	/* peek should suffice, as the bindings should keep this class
	 * alive for us. */
	class = g_type_class_peek (gtype);
	if (! class)
		/* er, didn't work.  leak a reference, then. */
		class = g_type_class_ref (gtype);
	if (! class)
		croak ("internal problem: can't peek at type class for %s(%d)",
		       g_type_name (gtype), gtype);
	gtk2perl_cell_renderer_class_init (class);


##
## here we provide a hokey way to chain up from one of the overrides we
## installed above.  since the class of an object is determined by looking
## at the bottom of the chain, we can't rely on that to give us the
## class of the parent; so we rely on the package returned by caller().
## if caller returns nothing useful, then we assume we need to call the
## base method.
##
## For backward compatibility, we support the old parent_foo syntax, although
## the actual call semantics are slightly different.
##
void
GET_SIZE (GtkCellRenderer * cell, ...)
    ALIAS:
	RENDER               = 1
	ACTIVATE             = 2
	START_EDITING        = 3
	parent_get_size      = 4
	parent_render        = 5
	parent_activate      = 6
	parent_start_editing = 7
    PREINIT:
	GtkCellRendererClass * class;
	GType thisclass, parent_class;
	SV * saveddefsv;
    PPCODE:
	/* may i ask who's calling? */
	saveddefsv = newSVsv (DEFSV);
	eval_pv ("$_ = caller;", 0);
	thisclass = gperl_type_from_package (SvPV_nolen (DEFSV));
	SvSetSV (DEFSV, saveddefsv);
	if (!thisclass)
		thisclass = G_OBJECT_TYPE (cell);
	/* look up his parent */
	parent_class = g_type_parent (thisclass);
	if (! g_type_is_a (parent_class, GTK_TYPE_CELL_RENDERER))
		croak ("parent of %s is not a GtkCellRenderer",
		       g_type_name (thisclass));
	/* that's our boy.  call one of his functions. */
	class = g_type_class_peek (parent_class);
	switch (ix) {
	    case 4: /* deprecated parent_get_size */
	    case 0: /* GET_SIZE */
		if (class->get_size) {
			gint x_offset, y_offset, width, height;
			class->get_size (cell,
			                 SvGtkWidget (ST (1)),
					 SvGdkRectangle_ornull (ST (2)),
					 &x_offset,
					 &y_offset,
					 &width,
					 &height);
			EXTEND (SP, 4);
			PUSHs (sv_2mortal (newSViv (x_offset)));
			PUSHs (sv_2mortal (newSViv (y_offset)));
			PUSHs (sv_2mortal (newSViv (width)));
			PUSHs (sv_2mortal (newSViv (height)));
		}
		break;
	    case 5: /* deprecated parent_render */
	    case 1: /* RENDER */
		if (class->render)
			class->render (cell,
			               SvGdkDrawable_ornull (ST (1)), /* drawable */
				       SvGtkWidget_ornull (ST (2)), /* widget */
				       SvGdkRectangle_ornull (ST (3)), /* background_area */
				       SvGdkRectangle_ornull (ST (4)), /* cell_area */
				       SvGdkRectangle_ornull (ST (5)), /* expose_area */
				       SvGtkCellRendererState (ST (6))); /* flags */
		break;
	    case 6: /* deprecated parent_activate */
	    case 2: /* ACTIVATE */
		if (class->activate) {
			gboolean ret;
			ret = class->activate (cell,
			                       SvGdkEvent (ST (1)),
					       SvGtkWidget (ST (2)),
					       SvGChar (ST (3)),
					       SvGdkRectangle_ornull (ST (4)),
					       SvGdkRectangle_ornull (ST (5)),
					       SvGtkCellRendererState (ST (6)));
			EXTEND (SP, 1);
			PUSHs (sv_2mortal (newSViv (ret)));
		}
		break;
	    case 7: /* deprecated parent_start_editing */
	    case 3: /* START_EDITING */
		if (class->start_editing) {
			GtkCellEditable * editable;
			editable = class->start_editing (cell,
				                         SvGdkEvent_ornull (ST (1)),
						         SvGtkWidget (ST (2)),
						         SvGChar (ST (3)),
						         SvGdkRectangle_ornull (ST (4)),
						         SvGdkRectangle_ornull (ST (5)),
						         SvGtkCellRendererState (ST (6)));
			EXTEND (SP, 1);
			PUSHs (newSVGtkCellEditable_ornull (editable));
		}
		break;
	}


