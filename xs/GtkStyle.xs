#include "gtk2perl.h"

MODULE = Gtk2::Style	PACKAGE = Gtk2::Style	PREFIX = gtk_style_

SV *
stateless_member (style)
	GtkStyle * style
    ALIAS:
	Gtk2::Style::black = 1
	Gtk2::Style::white = 2
	Gtk2::Style::font_desc = 3
	Gtk2::Style::xthickness = 4
	Gtk2::Style::ythickness = 5
	Gtk2::Style::black_gc = 6
	Gtk2::Style::white_gc = 7
    CODE:
	switch (ix) {
	    /* FIXME: is it correct to _copy these */
	    case 1: RETVAL = newSVGdkColor_copy (&(style->black)); break;
	    case 2: RETVAL = newSVGdkColor_copy (&(style->white)); break;
	    case 3: RETVAL = newSVPangoFontDescription_copy (&(style->font_desc)); break;
	    case 4: RETVAL = newSViv (style->xthickness); break;
	    case 5: RETVAL = newSViv (style->ythickness); break;
	    case 6: RETVAL = newSVGdkGC (style->black_gc); break;
	    case 7: RETVAL = newSVGdkGC (style->white_gc); break;
	    default: croak ("augh! unhandled stateless style member");
	}
    OUTPUT:
	RETVAL

## FIXME: is it correct to _copy these
GdkColor_copy *
state_color (style, state)
	GtkStyle * style
	GtkStateType state
    ALIAS:
	Gtk2::Style::fg = 1
	Gtk2::Style::bg = 2
	Gtk2::Style::light = 3
	Gtk2::Style::dark = 4
	Gtk2::Style::mid = 5
	Gtk2::Style::text = 6
	Gtk2::Style::base = 7
	Gtk2::Style::text_aa = 8
    CODE:
	switch (ix) {
	    case 1: RETVAL = &(style->fg[state]); break;
	    case 2: RETVAL = &(style->bg[state]); break;
	    case 3: RETVAL = &(style->light[state]); break;
	    case 4: RETVAL = &(style->dark[state]); break;
	    case 5: RETVAL = &(style->mid[state]); break;
	    case 6: RETVAL = &(style->text[state]); break;
	    case 7: RETVAL = &(style->base[state]); break;
	    case 8: RETVAL = &(style->text_aa[state]); break;
	    default: croak ("augh! unhandled style state color");
	}
    OUTPUT:
	RETVAL

# legitimate reference, not a copy
GdkGC *
state_gc (style, state)
	GtkStyle * style
	GtkStateType state
    ALIAS:
	Gtk2::Style::fg_gc = 1
	Gtk2::Style::bg_gc = 2
	Gtk2::Style::light_gc = 3
	Gtk2::Style::dark_gc = 4
	Gtk2::Style::mid_gc = 5
	Gtk2::Style::text_gc = 6
	Gtk2::Style::base_gc = 7
	Gtk2::Style::text_aa_gc = 8
    CODE:
	switch (ix) {
	    case 1: RETVAL = style->fg_gc[state]; break;
	    case 2: RETVAL = style->bg_gc[state]; break;
	    case 3: RETVAL = style->light_gc[state]; break;
	    case 4: RETVAL = style->dark_gc[state]; break;
	    case 5: RETVAL = style->mid_gc[state]; break;
	    case 6: RETVAL = style->text_gc[state]; break;
	    case 7: RETVAL = style->base_gc[state]; break;
	    case 8: RETVAL = style->text_aa_gc[state]; break;
	    default: croak ("augh! unhandled style state color");
	}
    OUTPUT:
	RETVAL


# legitimate reference, not a copy
GdkPixmap *
bg_pixmap (style, state)
	GtkStyle * style
	GtkStateType state
    CODE:
	RETVAL = style->bg_pixmap[state];
    OUTPUT:
	RETVAL


 ## GtkStyle* gtk_style_new (void)
GtkStyle_noinc*
gtk_style_new (class)
	SV * class
    C_ARGS:


 ## GtkStyle* gtk_style_copy (GtkStyle *style)
GtkStyle_noinc*
gtk_style_copy (style)
	GtkStyle *style

 ## GtkStyle* gtk_style_attach (GtkStyle *style, GdkWindow *window)
GtkStyle_noinc*
gtk_style_attach (style, window)
	GtkStyle *style
	GdkWindow *window

 ## void gtk_style_detach (GtkStyle *style)
void
gtk_style_detach (style)
	GtkStyle *style

# deprecated
 ## GtkStyle* gtk_style_ref (GtkStyle *style)
 ## void gtk_style_unref (GtkStyle *style)

 ## GdkFont * gtk_style_get_font (GtkStyle *style)
GdkFont *
gtk_style_get_font (style)
	GtkStyle *style

 ## void gtk_style_set_font (GtkStyle *style, GdkFont *font)
void
gtk_style_set_font (style, font)
	GtkStyle *style
	GdkFont *font

 ## void gtk_style_set_background (GtkStyle *style, GdkWindow *window, GtkStateType state_type)
void
gtk_style_set_background (style, window, state_type)
	GtkStyle *style
	GdkWindow *window
	GtkStateType state_type

 ## void gtk_style_apply_default_background (GtkStyle *style, GdkWindow *window, gboolean set_bg, GtkStateType state_type, GdkRectangle *area, gint x, gint y, gint width, gint height)
void
gtk_style_apply_default_background (style, window, set_bg, state_type, area, x, y, width, height)
	GtkStyle *style
	GdkWindow *window
	gboolean set_bg
	GtkStateType state_type
	GdkRectangle *area
	gint x
	gint y
	gint width
	gint height

 ## GtkIconSet* gtk_style_lookup_icon_set (GtkStyle *style, const gchar *stock_id)
GtkIconSet*
gtk_style_lookup_icon_set (style, stock_id)
	GtkStyle *style
	const gchar *stock_id

## ## GdkPixbuf* gtk_style_render_icon (GtkStyle *style, const GtkIconSource *source, GtkTextDirection direction, GtkStateType state, GtkIconSize size, GtkWidget *widget, const gchar *detail)
##GdkPixbuf*
##gtk_style_render_icon (style, source, direction, state, size, widget, detail)
##	GtkStyle *style
##	const GtkIconSource *source
##	GtkTextDirection direction
##	GtkStateType state
##	GtkIconSize size
##	GtkWidget *widget
##	const gchar *detail

 ## void gtk_draw_hline (GtkStyle *style, GdkWindow *window, GtkStateType state_type, gint x1, gint x2, gint y)
void
gtk_draw_hline (style, window, state_type, x1, x2, y)
	GtkStyle *style
	GdkWindow *window
	GtkStateType state_type
	gint x1
	gint x2
	gint y

 ## void gtk_draw_vline (GtkStyle *style, GdkWindow *window, GtkStateType state_type, gint y1_, gint y2_, gint x)
void
gtk_draw_vline (style, window, state_type, y1_, y2_, x)
	GtkStyle *style
	GdkWindow *window
	GtkStateType state_type
	gint y1_
	gint y2_
	gint x

 ## void gtk_draw_shadow (GtkStyle *style, GdkWindow *window, GtkStateType state_type, GtkShadowType shadow_type, gint x, gint y, gint width, gint height)
void
gtk_draw_shadow (style, window, state_type, shadow_type, x, y, width, height)
	GtkStyle *style
	GdkWindow *window
	GtkStateType state_type
	GtkShadowType shadow_type
	gint x
	gint y
	gint width
	gint height

## ## void gtk_draw_polygon (GtkStyle *style, GdkWindow *window, GtkStateType state_type, GtkShadowType shadow_type, GdkPoint *points, gint npoints, gboolean fill)
##void
##gtk_draw_polygon (style, window, state_type, shadow_type, points, npoints, fill)
##	GtkStyle *style
##	GdkWindow *window
##	GtkStateType state_type
##	GtkShadowType shadow_type
##	GdkPoint *points
##	gint npoints
##	gboolean fill

 ## void gtk_draw_arrow (GtkStyle *style, GdkWindow *window, GtkStateType state_type, GtkShadowType shadow_type, GtkArrowType arrow_type, gboolean fill, gint x, gint y, gint width, gint height)
void
gtk_draw_arrow (style, window, state_type, shadow_type, arrow_type, fill, x, y, width, height)
	GtkStyle *style
	GdkWindow *window
	GtkStateType state_type
	GtkShadowType shadow_type
	GtkArrowType arrow_type
	gboolean fill
	gint x
	gint y
	gint width
	gint height

 ## void gtk_draw_diamond (GtkStyle *style, GdkWindow *window, GtkStateType state_type, GtkShadowType shadow_type, gint x, gint y, gint width, gint height)
void
gtk_draw_diamond (style, window, state_type, shadow_type, x, y, width, height)
	GtkStyle *style
	GdkWindow *window
	GtkStateType state_type
	GtkShadowType shadow_type
	gint x
	gint y
	gint width
	gint height

 ## void gtk_draw_box (GtkStyle *style, GdkWindow *window, GtkStateType state_type, GtkShadowType shadow_type, gint x, gint y, gint width, gint height)
void
gtk_draw_box (style, window, state_type, shadow_type, x, y, width, height)
	GtkStyle *style
	GdkWindow *window
	GtkStateType state_type
	GtkShadowType shadow_type
	gint x
	gint y
	gint width
	gint height

 ## void gtk_draw_flat_box (GtkStyle *style, GdkWindow *window, GtkStateType state_type, GtkShadowType shadow_type, gint x, gint y, gint width, gint height)
void
gtk_draw_flat_box (style, window, state_type, shadow_type, x, y, width, height)
	GtkStyle *style
	GdkWindow *window
	GtkStateType state_type
	GtkShadowType shadow_type
	gint x
	gint y
	gint width
	gint height

 ## void gtk_draw_check (GtkStyle *style, GdkWindow *window, GtkStateType state_type, GtkShadowType shadow_type, gint x, gint y, gint width, gint height)
void
gtk_draw_check (style, window, state_type, shadow_type, x, y, width, height)
	GtkStyle *style
	GdkWindow *window
	GtkStateType state_type
	GtkShadowType shadow_type
	gint x
	gint y
	gint width
	gint height

 ## void gtk_draw_option (GtkStyle *style, GdkWindow *window, GtkStateType state_type, GtkShadowType shadow_type, gint x, gint y, gint width, gint height)
void
gtk_draw_option (style, window, state_type, shadow_type, x, y, width, height)
	GtkStyle *style
	GdkWindow *window
	GtkStateType state_type
	GtkShadowType shadow_type
	gint x
	gint y
	gint width
	gint height

 ## void gtk_draw_tab (GtkStyle *style, GdkWindow *window, GtkStateType state_type, GtkShadowType shadow_type, gint x, gint y, gint width, gint height)
void
gtk_draw_tab (style, window, state_type, shadow_type, x, y, width, height)
	GtkStyle *style
	GdkWindow *window
	GtkStateType state_type
	GtkShadowType shadow_type
	gint x
	gint y
	gint width
	gint height

 ## void gtk_draw_shadow_gap (GtkStyle *style, GdkWindow *window, GtkStateType state_type, GtkShadowType shadow_type, gint x, gint y, gint width, gint height, GtkPositionType gap_side, gint gap_x, gint gap_width)
void
gtk_draw_shadow_gap (style, window, state_type, shadow_type, x, y, width, height, gap_side, gap_x, gap_width)
	GtkStyle *style
	GdkWindow *window
	GtkStateType state_type
	GtkShadowType shadow_type
	gint x
	gint y
	gint width
	gint height
	GtkPositionType gap_side
	gint gap_x
	gint gap_width

 ## void gtk_draw_box_gap (GtkStyle *style, GdkWindow *window, GtkStateType state_type, GtkShadowType shadow_type, gint x, gint y, gint width, gint height, GtkPositionType gap_side, gint gap_x, gint gap_width)
void
gtk_draw_box_gap (style, window, state_type, shadow_type, x, y, width, height, gap_side, gap_x, gap_width)
	GtkStyle *style
	GdkWindow *window
	GtkStateType state_type
	GtkShadowType shadow_type
	gint x
	gint y
	gint width
	gint height
	GtkPositionType gap_side
	gint gap_x
	gint gap_width

 ## void gtk_draw_extension (GtkStyle *style, GdkWindow *window, GtkStateType state_type, GtkShadowType shadow_type, gint x, gint y, gint width, gint height, GtkPositionType gap_side)
void
gtk_draw_extension (style, window, state_type, shadow_type, x, y, width, height, gap_side)
	GtkStyle *style
	GdkWindow *window
	GtkStateType state_type
	GtkShadowType shadow_type
	gint x
	gint y
	gint width
	gint height
	GtkPositionType gap_side

 ## void gtk_draw_focus (GtkStyle *style, GdkWindow *window, gint x, gint y, gint width, gint height)
void
gtk_draw_focus (style, window, x, y, width, height)
	GtkStyle *style
	GdkWindow *window
	gint x
	gint y
	gint width
	gint height

 ## void gtk_draw_slider (GtkStyle *style, GdkWindow *window, GtkStateType state_type, GtkShadowType shadow_type, gint x, gint y, gint width, gint height, GtkOrientation orientation)
void
gtk_draw_slider (style, window, state_type, shadow_type, x, y, width, height, orientation)
	GtkStyle *style
	GdkWindow *window
	GtkStateType state_type
	GtkShadowType shadow_type
	gint x
	gint y
	gint width
	gint height
	GtkOrientation orientation

 ## void gtk_draw_handle (GtkStyle *style, GdkWindow *window, GtkStateType state_type, GtkShadowType shadow_type, gint x, gint y, gint width, gint height, GtkOrientation orientation)
void
gtk_draw_handle (style, window, state_type, shadow_type, x, y, width, height, orientation)
	GtkStyle *style
	GdkWindow *window
	GtkStateType state_type
	GtkShadowType shadow_type
	gint x
	gint y
	gint width
	gint height
	GtkOrientation orientation

 ## void gtk_draw_expander (GtkStyle *style, GdkWindow *window, GtkStateType state_type, gint x, gint y, GtkExpanderStyle expander_style)
void
gtk_draw_expander (style, window, state_type, x, y, expander_style)
	GtkStyle *style
	GdkWindow *window
	GtkStateType state_type
	gint x
	gint y
	GtkExpanderStyle expander_style

 ## void gtk_draw_layout (GtkStyle *style, GdkWindow *window, GtkStateType state_type, gboolean use_text, gint x, gint y, PangoLayout *layout)
void
gtk_draw_layout (style, window, state_type, use_text, x, y, layout)
	GtkStyle *style
	GdkWindow *window
	GtkStateType state_type
	gboolean use_text
	gint x
	gint y
	PangoLayout *layout

 ## void gtk_draw_resize_grip (GtkStyle *style, GdkWindow *window, GtkStateType state_type, GdkWindowEdge edge, gint x, gint y, gint width, gint height)
void
gtk_draw_resize_grip (style, window, state_type, edge, x, y, width, height)
	GtkStyle *style
	GdkWindow *window
	GtkStateType state_type
	GdkWindowEdge edge
	gint x
	gint y
	gint width
	gint height

 ## void gtk_paint_hline (GtkStyle *style, GdkWindow *window, GtkStateType state_type, GdkRectangle *area, GtkWidget *widget, const gchar *detail, gint x1, gint x2, gint y)
void
gtk_paint_hline (style, window, state_type, area, widget, detail, x1, x2, y)
	GtkStyle *style
	GdkWindow *window
	GtkStateType state_type
	GdkRectangle *area
	GtkWidget *widget
	const gchar *detail
	gint x1
	gint x2
	gint y

 ## void gtk_paint_vline (GtkStyle *style, GdkWindow *window, GtkStateType state_type, GdkRectangle *area, GtkWidget *widget, const gchar *detail, gint y1_, gint y2_, gint x)
void
gtk_paint_vline (style, window, state_type, area, widget, detail, y1_, y2_, x)
	GtkStyle *style
	GdkWindow *window
	GtkStateType state_type
	GdkRectangle *area
	GtkWidget *widget
	const gchar *detail
	gint y1_
	gint y2_
	gint x

 ## void gtk_paint_shadow (GtkStyle *style, GdkWindow *window, GtkStateType state_type, GtkShadowType shadow_type, GdkRectangle *area, GtkWidget *widget, const gchar *detail, gint x, gint y, gint width, gint height)
void
gtk_paint_shadow (style, window, state_type, shadow_type, area, widget, detail, x, y, width, height)
	GtkStyle *style
	GdkWindow *window
	GtkStateType state_type
	GtkShadowType shadow_type
	GdkRectangle *area
	GtkWidget *widget
	const gchar *detail
	gint x
	gint y
	gint width
	gint height

## ## void gtk_paint_polygon (GtkStyle *style, GdkWindow *window, GtkStateType state_type, GtkShadowType shadow_type, GdkRectangle *area, GtkWidget *widget, const gchar *detail, GdkPoint *points, gint npoints, gboolean fill)
##void
##gtk_paint_polygon (style, window, state_type, shadow_type, area, widget, detail, points, npoints, fill)
##	GtkStyle *style
##	GdkWindow *window
##	GtkStateType state_type
##	GtkShadowType shadow_type
##	GdkRectangle *area
##	GtkWidget *widget
##	const gchar *detail
##	GdkPoint *points
##	gint npoints
##	gboolean fill

 ## void gtk_paint_arrow (GtkStyle *style, GdkWindow *window, GtkStateType state_type, GtkShadowType shadow_type, GdkRectangle *area, GtkWidget *widget, const gchar *detail, GtkArrowType arrow_type, gboolean fill, gint x, gint y, gint width, gint height)
void
gtk_paint_arrow (style, window, state_type, shadow_type, area, widget, detail, arrow_type, fill, x, y, width, height)
	GtkStyle *style
	GdkWindow *window
	GtkStateType state_type
	GtkShadowType shadow_type
	GdkRectangle *area
	GtkWidget *widget
	const gchar *detail
	GtkArrowType arrow_type
	gboolean fill
	gint x
	gint y
	gint width
	gint height

 ## void gtk_paint_diamond (GtkStyle *style, GdkWindow *window, GtkStateType state_type, GtkShadowType shadow_type, GdkRectangle *area, GtkWidget *widget, const gchar *detail, gint x, gint y, gint width, gint height)
void
gtk_paint_diamond (style, window, state_type, shadow_type, area, widget, detail, x, y, width, height)
	GtkStyle *style
	GdkWindow *window
	GtkStateType state_type
	GtkShadowType shadow_type
	GdkRectangle *area
	GtkWidget *widget
	const gchar *detail
	gint x
	gint y
	gint width
	gint height

 ## void gtk_paint_box (GtkStyle *style, GdkWindow *window, GtkStateType state_type, GtkShadowType shadow_type, GdkRectangle *area, GtkWidget *widget, const gchar *detail, gint x, gint y, gint width, gint height)
void
gtk_paint_box (style, window, state_type, shadow_type, area, widget, detail, x, y, width, height)
	GtkStyle *style
	GdkWindow *window
	GtkStateType state_type
	GtkShadowType shadow_type
	GdkRectangle *area
	GtkWidget *widget
	const gchar *detail
	gint x
	gint y
	gint width
	gint height

 ## void gtk_paint_flat_box (GtkStyle *style, GdkWindow *window, GtkStateType state_type, GtkShadowType shadow_type, GdkRectangle *area, GtkWidget *widget, const gchar *detail, gint x, gint y, gint width, gint height)
void
gtk_paint_flat_box (style, window, state_type, shadow_type, area, widget, detail, x, y, width, height)
	GtkStyle *style
	GdkWindow *window
	GtkStateType state_type
	GtkShadowType shadow_type
	GdkRectangle *area
	GtkWidget *widget
	const gchar *detail
	gint x
	gint y
	gint width
	gint height

 ## void gtk_paint_check (GtkStyle *style, GdkWindow *window, GtkStateType state_type, GtkShadowType shadow_type, GdkRectangle *area, GtkWidget *widget, const gchar *detail, gint x, gint y, gint width, gint height)
void
gtk_paint_check (style, window, state_type, shadow_type, area, widget, detail, x, y, width, height)
	GtkStyle *style
	GdkWindow *window
	GtkStateType state_type
	GtkShadowType shadow_type
	GdkRectangle *area
	GtkWidget *widget
	const gchar *detail
	gint x
	gint y
	gint width
	gint height

 ## void gtk_paint_option (GtkStyle *style, GdkWindow *window, GtkStateType state_type, GtkShadowType shadow_type, GdkRectangle *area, GtkWidget *widget, const gchar *detail, gint x, gint y, gint width, gint height)
void
gtk_paint_option (style, window, state_type, shadow_type, area, widget, detail, x, y, width, height)
	GtkStyle *style
	GdkWindow *window
	GtkStateType state_type
	GtkShadowType shadow_type
	GdkRectangle *area
	GtkWidget *widget
	const gchar *detail
	gint x
	gint y
	gint width
	gint height

 ## void gtk_paint_tab (GtkStyle *style, GdkWindow *window, GtkStateType state_type, GtkShadowType shadow_type, GdkRectangle *area, GtkWidget *widget, const gchar *detail, gint x, gint y, gint width, gint height)
void
gtk_paint_tab (style, window, state_type, shadow_type, area, widget, detail, x, y, width, height)
	GtkStyle *style
	GdkWindow *window
	GtkStateType state_type
	GtkShadowType shadow_type
	GdkRectangle *area
	GtkWidget *widget
	const gchar *detail
	gint x
	gint y
	gint width
	gint height

 ## void gtk_paint_shadow_gap (GtkStyle *style, GdkWindow *window, GtkStateType state_type, GtkShadowType shadow_type, GdkRectangle *area, GtkWidget *widget, gchar *detail, gint x, gint y, gint width, gint height, GtkPositionType gap_side, gint gap_x, gint gap_width)
void
gtk_paint_shadow_gap (style, window, state_type, shadow_type, area, widget, detail, x, y, width, height, gap_side, gap_x, gap_width)
	GtkStyle *style
	GdkWindow *window
	GtkStateType state_type
	GtkShadowType shadow_type
	GdkRectangle *area
	GtkWidget *widget
	gchar *detail
	gint x
	gint y
	gint width
	gint height
	GtkPositionType gap_side
	gint gap_x
	gint gap_width

 ## void gtk_paint_box_gap (GtkStyle *style, GdkWindow *window, GtkStateType state_type, GtkShadowType shadow_type, GdkRectangle *area, GtkWidget *widget, gchar *detail, gint x, gint y, gint width, gint height, GtkPositionType gap_side, gint gap_x, gint gap_width)
void
gtk_paint_box_gap (style, window, state_type, shadow_type, area, widget, detail, x, y, width, height, gap_side, gap_x, gap_width)
	GtkStyle *style
	GdkWindow *window
	GtkStateType state_type
	GtkShadowType shadow_type
	GdkRectangle *area
	GtkWidget *widget
	gchar *detail
	gint x
	gint y
	gint width
	gint height
	GtkPositionType gap_side
	gint gap_x
	gint gap_width

 ## void gtk_paint_extension (GtkStyle *style, GdkWindow *window, GtkStateType state_type, GtkShadowType shadow_type, GdkRectangle *area, GtkWidget *widget, gchar *detail, gint x, gint y, gint width, gint height, GtkPositionType gap_side)
void
gtk_paint_extension (style, window, state_type, shadow_type, area, widget, detail, x, y, width, height, gap_side)
	GtkStyle *style
	GdkWindow *window
	GtkStateType state_type
	GtkShadowType shadow_type
	GdkRectangle *area
	GtkWidget *widget
	gchar *detail
	gint x
	gint y
	gint width
	gint height
	GtkPositionType gap_side

 ## void gtk_paint_focus (GtkStyle *style, GdkWindow *window, GtkStateType state_type, GdkRectangle *area, GtkWidget *widget, const gchar *detail, gint x, gint y, gint width, gint height)
void
gtk_paint_focus (style, window, state_type, area, widget, detail, x, y, width, height)
	GtkStyle *style
	GdkWindow *window
	GtkStateType state_type
	GdkRectangle *area
	GtkWidget *widget
	const gchar *detail
	gint x
	gint y
	gint width
	gint height

 ## void gtk_paint_slider (GtkStyle *style, GdkWindow *window, GtkStateType state_type, GtkShadowType shadow_type, GdkRectangle *area, GtkWidget *widget, const gchar *detail, gint x, gint y, gint width, gint height, GtkOrientation orientation)
void
gtk_paint_slider (style, window, state_type, shadow_type, area, widget, detail, x, y, width, height, orientation)
	GtkStyle *style
	GdkWindow *window
	GtkStateType state_type
	GtkShadowType shadow_type
	GdkRectangle *area
	GtkWidget *widget
	const gchar *detail
	gint x
	gint y
	gint width
	gint height
	GtkOrientation orientation

 ## void gtk_paint_handle (GtkStyle *style, GdkWindow *window, GtkStateType state_type, GtkShadowType shadow_type, GdkRectangle *area, GtkWidget *widget, const gchar *detail, gint x, gint y, gint width, gint height, GtkOrientation orientation)
void
gtk_paint_handle (style, window, state_type, shadow_type, area, widget, detail, x, y, width, height, orientation)
	GtkStyle *style
	GdkWindow *window
	GtkStateType state_type
	GtkShadowType shadow_type
	GdkRectangle *area
	GtkWidget *widget
	const gchar *detail
	gint x
	gint y
	gint width
	gint height
	GtkOrientation orientation

 ## void gtk_paint_expander (GtkStyle *style, GdkWindow *window, GtkStateType state_type, GdkRectangle *area, GtkWidget *widget, const gchar *detail, gint x, gint y, GtkExpanderStyle expander_style)
void
gtk_paint_expander (style, window, state_type, area, widget, detail, x, y, expander_style)
	GtkStyle *style
	GdkWindow *window
	GtkStateType state_type
	GdkRectangle *area
	GtkWidget *widget
	const gchar *detail
	gint x
	gint y
	GtkExpanderStyle expander_style

 ## void gtk_paint_layout (GtkStyle *style, GdkWindow *window, GtkStateType state_type, gboolean use_text, GdkRectangle *area, GtkWidget *widget, const gchar *detail, gint x, gint y, PangoLayout *layout)
void
gtk_paint_layout (style, window, state_type, use_text, area, widget, detail, x, y, layout)
	GtkStyle *style
	GdkWindow *window
	GtkStateType state_type
	gboolean use_text
	GdkRectangle *area
	GtkWidget *widget
	const gchar *detail
	gint x
	gint y
	PangoLayout *layout

 ## void gtk_paint_resize_grip (GtkStyle *style, GdkWindow *window, GtkStateType state_type, GdkRectangle *area, GtkWidget *widget, const gchar *detail, GdkWindowEdge edge, gint x, gint y, gint width, gint height)
void
gtk_paint_resize_grip (style, window, state_type, area, widget, detail, edge, x, y, width, height)
	GtkStyle *style
	GdkWindow *window
	GtkStateType state_type
	GdkRectangle *area
	GtkWidget *widget
	const gchar *detail
	GdkWindowEdge edge
	gint x
	gint y
	gint width
	gint height

 ## void gtk_border_free ( GtkBorder *border_)
void
gtk_border_free (border_)
	 GtkBorder *border_

 ## void _gtk_style_init_for_settings (GtkStyle *style, GtkSettings *settings)
 ## void gtk_paint_string (GtkStyle *style, GdkWindow *window, GtkStateType state_type, GdkRectangle *area, GtkWidget *widget, const gchar *detail, gint x, gint y, const gchar *string)
 ## void _gtk_draw_insertion_cursor (GtkWidget *widget, GdkDrawable *drawable, GdkGC *gc, GdkRectangle *location, GtkTextDirection direction, gboolean draw_arrow)

# deprecated
void gtk_draw_string (GtkStyle *style, GdkWindow *window, GtkStateType state_type, gint x, gint y, const gchar *string)

