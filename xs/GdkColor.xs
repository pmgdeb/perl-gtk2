#include "gtk2perl.h"

/*
GdkColormap is a direct GObject subclass; be sure to use GdkColormap_noinc in the
proper places.

GdkColor is a plain structure treated as a boxed type.  use GdkColor_own and
GdkColor_copy in all the right places.
*/

MODULE = Gtk2::Gdk::Color	PACKAGE = Gtk2::Gdk::Colormap	PREFIX = gdk_colormap_

 ## GdkColormap* gdk_colormap_new (GdkVisual *visual, gboolean allocate)
GdkColormap_noinc*
gdk_colormap_new (visual, allocate)
	GdkVisual *visual
	gboolean allocate

 ## deprecated
 ## GdkColormap* gdk_colormap_ref (GdkColormap *cmap)
 ## deprecated
 ## void gdk_colormap_unref (GdkColormap *cmap)

 ## GdkColormap* gdk_colormap_get_system (void)
GdkColormap*
gdk_colormap_get_system (class)
	SV * class
    C_ARGS:


 ## deprecated
 ## gint gdk_colormap_get_system_size (void)

 ## gint gdk_colormap_alloc_colors (GdkColormap *colormap, GdkColor *colors, gint ncolors, gboolean writeable, gboolean best_match, gboolean *success)
## success becomes an array of TRUE or FALSE corresponding to each input
## color, telling whether each one was successfully allocated.  the return
## value is the number that were NOT allocated.
 ##gint
 ##gdk_colormap_alloc_colors (colormap, colors, ncolors, writeable, best_match, success)
 ##	GdkColormap *colormap
 ##	GdkColor *colors
 ##	gint ncolors
 ##	gboolean writeable
 ##	gboolean best_match
 ##	gboolean *success

 ## gboolean gdk_colormap_alloc_color (GdkColormap *colormap, GdkColor *color, gboolean writeable, gboolean best_match)
gboolean
gdk_colormap_alloc_color (colormap, color, writeable, best_match)
	GdkColormap *colormap
	GdkColor *color
	gboolean writeable
	gboolean best_match

 ## void gdk_colormap_free_colors (GdkColormap *colormap, GdkColor *colors, gint ncolors)
 ##void
 ##gdk_colormap_free_colors (colormap, colors, ncolors)
 ##	GdkColormap *colormap
 ##	GdkColor *colors
 ##	gint ncolors
 ##
 ## void gdk_colormap_query_color (GdkColormap *colormap, gulong pixel, GdkColor *result)
 ##void
 ##gdk_colormap_query_color (colormap, pixel, result)
 ##	GdkColormap *colormap
 ##	gulong pixel
 ##	GdkColor *result

MODULE = Gtk2::Gdk::Color	PACKAGE = Gtk2::Gdk::Color	PREFIX = gdk_color_

GdkColor_own *
gdk_color_new (class, red, green, blue)
	SV * class
	int red
	int green
	int blue
    CODE:
	RETVAL = g_new0 (GdkColor, 1);
	RETVAL->red = red;
	RETVAL->green = green;
	RETVAL->blue = blue;
    OUTPUT:
	RETVAL

 # unnecessary, taken care of by the GBoxed::DESTROY method
 ## void gdk_color_free (GdkColor *color)

 # can return undef if the color isn't properly parsed
 ## gint gdk_color_parse (const gchar *spec, GdkColor *color)
GdkColor_own *
gdk_color_parse (class, spec)
	SV * class
	const gchar *spec
    CODE:
	RETVAL = g_new0 (GdkColor, 1);
	if (!gdk_color_parse (spec, RETVAL)) {
		g_free (RETVAL);
		XSRETURN_UNDEF;
	}
    OUTPUT:
	RETVAL

 ## guint gdk_color_hash (const GdkColor *colora)
guint
gdk_color_hash (colora)
	GdkColor *colora

 ## gboolean gdk_color_equal (const GdkColor *colora, const GdkColor *colorb)
gboolean
gdk_color_equal (colora, colorb)
	GdkColor *colora
	GdkColor *colorb

 ## deprecated
 ## gint gdk_color_white (GdkColormap *colormap, GdkColor *color)
 ## deprecated
 ## gint gdk_color_black (GdkColormap *colormap, GdkColor *color)
 ## deprecated
 ## gint gdk_color_alloc (GdkColormap *colormap, GdkColor *color)
 ## deprecated
 ## gint gdk_color_change (GdkColormap *colormap, GdkColor *color)
 ## deprecated
 ## void gdk_colors_free (GdkColormap *colormap, gulong *pixels, gint npixels, gulong planes)

