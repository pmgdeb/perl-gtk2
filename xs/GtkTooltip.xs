/*
 * Copyright (c) 2007 by the gtk2-perl team (see the file AUTHORS)
 *
 * Licensed under the LGPL, see LICENSE file for more information.
 *
 * $Id$
 */

#include "gtk2perl.h"

MODULE = Gtk2::Tooltip	PACKAGE = Gtk2::Tooltip	PREFIX = gtk_tooltip_

void gtk_tooltip_set_markup (GtkTooltip *tooltip, const gchar_ornull *markup);

void gtk_tooltip_set_icon (GtkTooltip *tooltip, GdkPixbuf_ornull *pixbuf);

void gtk_tooltip_set_icon_from_stock (GtkTooltip *tooltip, const gchar_ornull *stock_id, GtkIconSize size);

void gtk_tooltip_set_custom (GtkTooltip *tooltip, GtkWidget_ornull *custom_widget);

=for apidoc __function__
=cut
void gtk_tooltip_trigger_tooltip_query (GdkDisplay *display);
