#ifndef _GTK2PERL_H_
#define _GTK2PERL_H_

#include <gperl.h>
#include <gtk/gtk.h>
#include "gtk2perl-autogen.h"

/**
 * gtk2perl_new_gtkobject:
 * @object: object to wrap.
 * 
 * create a new or return an existing wrapper around a C object descended 
 * from $GtkObject.  calls gtk_object_sink() after calling gperl_new_object().
 *
 * #GtkObjects are created with an initial refcount of 0, and a "floating"
 * flag set.  code which wishes to assume ownership of a new #GtkObject
 * sinks the floating ref by calling gtk_object_sink(); this converts the
 * floating ref into a "real" ref.
 *
 * since the perl code which called a #GtkObject-constructing function
 * owns the object, at least until it's taken over by something else,
 * gtk2perl_new_gtkobject() *always* refs (via gperl_new_object()) and sinks
 * (via gtk_object_sink()) the object.  if the object was owned by someone
 * else it simply gets a second ref which is removed by G::Object::DESTROY.
 *
 * returns: scalar wrapper for @object.
 *
 * in xs/GtkObject.xs 
 */
SV * gtk2perl_new_gtkobject (GtkObject * object);

/*
custom handling for GdkBitmaps, since there are no typemacros for them.
*/
/* GObject derivative GdkBitmap */
#define SvGdkBitmap(sv)       ((GdkBitmap*)gperl_get_object_check (sv, GDK_TYPE_DRAWABLE))
#define newSVGdkBitmap(val)   (gperl_new_object (G_OBJECT (val), FALSE))
typedef GdkBitmap GdkBitmap_ornull;
#define SvGdkBitmap_ornull(sv)        (((sv) == &PL_sv_undef) ? NULL : SvGdkBitmap(sv))

SV * newSVGdkBitmap_noinc (GdkBitmap * bitmap);

#endif /* _GTK2PERL_H_ */
