/*
 * Copyright (c) 2003 by the gtk2-perl team (see the file AUTHORS)
 *
 * Licensed under the LGPL, see LICENSE file for more information.
 *
 * $Header$
 */

#include "gtk2perl.h"
#include <gperl_marshal.h>

/* this is just an interface */


static gboolean
gtk2perl_tree_model_foreach_func (GtkTreeModel *model,
                                  GtkTreePath *path,
                                  GtkTreeIter *iter,
                                  gpointer data)
{
	GPerlCallback * callback = (GPerlCallback*)data;
	GValue value = {0,};
	gboolean retval;
	g_value_init (&value, callback->return_type);
	gperl_callback_invoke (callback, &value, model, path, iter);
	retval = g_value_get_boolean (&value);
	g_value_unset (&value);
	return retval;
}

static void
gtk2perl_tree_model_rows_reordered_marshal (GClosure * closure,
                                  	    GValue * return_value,
                                  	    guint n_param_values,
                                  	    const GValue * param_values,
                                  	    gpointer invocation_hint,
                                  	    gpointer marshal_data)
{
	AV * av;
	gint * new_order;
	GtkTreeModel * model;
	GtkTreeIter * iter;
	int n_children, i;
	dGPERL_CLOSURE_MARSHAL_ARGS;

	GPERL_CLOSURE_MARSHAL_INIT (closure, marshal_data);

	PERL_UNUSED_VAR (return_value);
	PERL_UNUSED_VAR (n_param_values);
	PERL_UNUSED_VAR (invocation_hint);

	ENTER;
	SAVETMPS;

	PUSHMARK (SP);

	/* instance */
	GPERL_CLOSURE_MARSHAL_PUSH_INSTANCE (param_values);
	model = SvGtkTreeModel(instance);

	/* treepath */
	XPUSHs (sv_2mortal (gperl_sv_from_value (param_values+1)));

	/* treeiter */
	XPUSHs (sv_2mortal (gperl_sv_from_value (param_values+2)));
	iter = g_value_get_boxed (param_values+2);

	/* gint * new_order */
	new_order = g_value_get_pointer (param_values+3);
	n_children = gtk_tree_model_iter_n_children (model, iter);
	av = newAV ();
	av_extend (av, n_children-1);
	for (i = 0; i < n_children; i++)
		av_store (av, i, newSViv (new_order[i]));
	XPUSHs (sv_2mortal (newRV_noinc ((SV*)av)));

	GPERL_CLOSURE_MARSHAL_PUSH_DATA;

	PUTBACK;

	GPERL_CLOSURE_MARSHAL_CALL (G_DISCARD);

	/*
	 * clean up 
	 */

	FREETMPS;
	LEAVE;
}


MODULE = Gtk2::TreeModel	PACKAGE = Gtk2::TreePath	PREFIX = gtk_tree_path_

GtkTreePath_own_ornull *
gtk_tree_path_new (class, path=NULL)
	const gchar * path
    ALIAS:
	new_from_string = 1
    CODE:
	PERL_UNUSED_VAR (ix);
	if (path)
		RETVAL = gtk_tree_path_new_from_string (path);
	else
		RETVAL = gtk_tree_path_new ();
    OUTPUT:
	RETVAL


## GtkTreePath * gtk_tree_path_new_from_indices (gint first_index, ...)
=for apidoc
=for arg first_index (integer) a non-negative index value
=for arg ... of zero or more index values

The C API reference docs for this function say to mark the end of the list
with a -1, but Perl doesn't need list terminators, so don't do that.

This is specially implemented to be available for all gtk+ versions.

=cut
GtkTreePath_own_ornull *
gtk_tree_path_new_from_indices (class, first_index, ...)
    PREINIT:
	gint i;
	GtkTreePath *path;
    CODE:
	path = gtk_tree_path_new ();

	for (i = 1 ; i < items ; i++) {
		gint index = SvIV (ST (i));
		if (index < 0)
			croak ("Gtk2::TreePath->new_from_indices takes index"
			       " values from the argument stack and therefore"
			       " does not use a -1 terminator value like its"
			       " C counterpart; negative index values are"
			       " not allowed");
		gtk_tree_path_append_index (path, index);
	}

	RETVAL = path;
    OUTPUT:
	RETVAL

gchar_own *
gtk_tree_path_to_string (path)
	GtkTreePath * path

GtkTreePath *
gtk_tree_path_new_first (class)
    C_ARGS:
	/* void */

## gtk_tree_path_new_root is deprecated in 2.2.0

void
gtk_tree_path_append_index (path, index_)
	GtkTreePath *path
	gint index_

void
gtk_tree_path_prepend_index (path, index_)
	GtkTreePath *path
	gint index_

gint
gtk_tree_path_get_depth (path)
	GtkTreePath *path

=for apidoc
Returns a list of integers.
=cut
void
gtk_tree_path_get_indices (path)
	GtkTreePath * path
    PREINIT:
	gint * indices;
	gint depth;
	gint i;
    PPCODE:
	depth = gtk_tree_path_get_depth (path);
	indices = gtk_tree_path_get_indices (path);
	EXTEND (SP, depth);
	for (i = 0 ; i < depth ; i++)
		PUSHs (sv_2mortal (newSViv (indices[i])));

## boxed wrapper stuff handled by Glib::Boxed
## GtkTreePath * gtk_tree_path_copy (GtkTreePath *path)
## void gtk_tree_path_free (GtkTreePath *path)

gint
gtk_tree_path_compare (a, b)
	GtkTreePath *a
	GtkTreePath *b

void
gtk_tree_path_next (path)
	GtkTreePath *path

gboolean
gtk_tree_path_prev (path)
	GtkTreePath *path

gboolean
gtk_tree_path_up (path)
	GtkTreePath *path

void
gtk_tree_path_down (path)
	GtkTreePath *path

gboolean
gtk_tree_path_is_ancestor (path, descendant)
	GtkTreePath *path
	GtkTreePath *descendant

gboolean
gtk_tree_path_is_descendant (path, ancestor)
	GtkTreePath *path
	GtkTreePath *ancestor



MODULE = Gtk2::TreeModel	PACKAGE = Gtk2::TreeRowReference	PREFIX = gtk_tree_row_reference_

 ##
 ## there doesn't seem to be a GType for GtkTreeRowReference in 2.0.x...
 ##

#ifdef GTK_TYPE_TREE_ROW_REFERENCE

##GtkTreeRowReference* gtk_tree_row_reference_new (GtkTreeModel *model, GtkTreePath *path);
#  $row_ref_or_undef = Gtk2::TreeRowReference->new ($model, $path)
GtkTreeRowReference_own_ornull*
gtk_tree_row_reference_new (class, GtkTreeModel *model, GtkTreePath *path)
    C_ARGS:
	model, path

  ## mmmm, the docs say "you do not need to use this function"
##GtkTreeRowReference* gtk_tree_row_reference_new_proxy (GObject *proxy, GtkTreeModel *model, GtkTreePath *path);

GtkTreePath_own_ornull * gtk_tree_row_reference_get_path (GtkTreeRowReference *reference);

## gboolean gtk_tree_row_reference_valid (GtkTreeRowReference *reference)
gboolean
gtk_tree_row_reference_valid (reference)
	GtkTreeRowReference *reference

#### boxed wrapper stuff handled by Glib::Boxed
#### GtkTreeRowReference* gtk_tree_row_reference_copy (GtkTreeRowReference *reference);
#### void gtk_tree_row_reference_free (GtkTreeRowReference *reference)

 ## i gather that you only need these if you created the row reference with
 ## gtk_tree_row_reference_new_proxy...  but they recommend you don't use
 ## the proxy stuff.  i'll hold off until somebody asks for it.
#### void gtk_tree_row_reference_inserted (GObject *proxy, GtkTreePath *path)
##void
##gtk_tree_row_reference_inserted (proxy, path)
##	GObject *proxy
##	GtkTreePath *path
##
#### void gtk_tree_row_reference_deleted (GObject *proxy, GtkTreePath *path)
##void
##gtk_tree_row_reference_deleted (proxy, path)
##	GObject *proxy
##	GtkTreePath *path
##
#### void gtk_tree_row_reference_reordered (GObject *proxy, GtkTreePath *path, GtkTreeIter *iter, gint *new_order)
##void
##gtk_tree_row_reference_reordered (proxy, path, iter, new_order)
##	GObject *proxy
##	GtkTreePath *path
##	GtkTreeIter *iter
##	gint *new_order
##

#endif /* defined GTK_TYPE_TREE_ROW_REFERENCE */

####MODULE = Gtk2::TreeModel	PACKAGE = Gtk2::TreeIter	PREFIX = gtk_tree_iter_

## we get this from Glib::Boxed::copy
## GtkTreeIter * gtk_tree_iter_copy (GtkTreeIter * iter)

## we get this from Glib::Boxed::DESTROY
## void gtk_tree_iter_free (GtkTreeIter *iter)


MODULE = Gtk2::TreeModel	PACKAGE = Gtk2::TreeModel	PREFIX = gtk_tree_model_

BOOT:
	gperl_signal_set_marshaller_for (GTK_TYPE_TREE_MODEL, "rows_reordered",
	                                 gtk2perl_tree_model_rows_reordered_marshal);

=for flags GtkTreeModelFlags
=cut

## GtkTreeModelFlags gtk_tree_model_get_flags (GtkTreeModel *tree_model)
GtkTreeModelFlags
gtk_tree_model_get_flags (tree_model)
	GtkTreeModel *tree_model

## gint gtk_tree_model_get_n_columns (GtkTreeModel *tree_model)
gint
gtk_tree_model_get_n_columns (tree_model)
	GtkTreeModel *tree_model

## GType gtk_tree_model_get_column_type (GtkTreeModel *tree_model, gint index_)
### we hide GType from the perl level.  return the corresponding
### package instead.
=for apidoc
Returns the type of column I<$index_> as a package name.
=cut
const gchar *
gtk_tree_model_get_column_type (tree_model, index_)
	GtkTreeModel *tree_model
	gint index_
    PREINIT:
	GType t;
    CODE:
	t = gtk_tree_model_get_column_type (tree_model, index_);
	RETVAL = gperl_package_from_type (t);
	if (!RETVAL)
		croak ("internal -- type of column %d, %s (%d), is not registered with GPerl",
			index_, g_type_name (t), t);
    OUTPUT:
	RETVAL

## gboolean gtk_tree_model_get_iter (GtkTreeModel *tree_model, GtkTreeIter *iter, GtkTreePath *path)
GtkTreeIter_copy *
gtk_tree_model_get_iter (tree_model, path)
	GtkTreeModel *tree_model
	GtkTreePath *path
    PREINIT:
	GtkTreeIter iter = {0, };
    CODE:
	if (!gtk_tree_model_get_iter (tree_model, &iter, path))
		XSRETURN_UNDEF;
	RETVAL = &iter;
    OUTPUT:
	RETVAL

##### FIXME couldn't we combine get_iter and get_iter_from_string, since we'll
#####       be able to tell at runtime whether the arg is a GtkTreePath or a
#####       plain old string?

## gboolean gtk_tree_model_get_iter_from_string (GtkTreeModel *tree_model, GtkTreeIter *iter, const gchar *path_string)
GtkTreeIter_copy *
gtk_tree_model_get_iter_from_string (tree_model, path_string)
	GtkTreeModel *tree_model
	const gchar *path_string
    PREINIT:
	GtkTreeIter iter = {0, };
    CODE:
	if (!gtk_tree_model_get_iter_from_string (tree_model, &iter, path_string))
		XSRETURN_UNDEF;
	RETVAL = &iter;
    OUTPUT:
	RETVAL

#if GTK_CHECK_VERSION(2,2,0)

## gchar * gtk_tree_model_get_string_from_iter (GtkTreeModel *tree_model, GtkTreeIter *iter)
gchar_own *
gtk_tree_model_get_string_from_iter (tree_model, iter)
	GtkTreeModel *tree_model
	GtkTreeIter *iter

#endif /* 2.2.0 */

## gboolean gtk_tree_model_get_iter_first (GtkTreeModel *tree_model, GtkTreeIter *iter)
GtkTreeIter_copy *
gtk_tree_model_get_iter_first (tree_model)
	GtkTreeModel *tree_model
    PREINIT:
	GtkTreeIter iter = {0, };
    CODE:
	if (!gtk_tree_model_get_iter_first (tree_model, &iter))
		XSRETURN_UNDEF;
	RETVAL = &iter;
    OUTPUT:
	RETVAL

### gtk_tree_model_get_iter_root is deprecated

## GtkTreePath * gtk_tree_model_get_path (GtkTreeModel *tree_model, GtkTreeIter *iter)
GtkTreePath_own *
gtk_tree_model_get_path (tree_model, iter)
	GtkTreeModel *tree_model
	GtkTreeIter *iter


## void gtk_tree_model_get (GtkTreeModel *tree_model, GtkTreeIter *iter, ...)
## void gtk_tree_model_get_value (GtkTreeModel *tree_model, GtkTreeIter *iter, gint column, GValue *value)

=for apidoc get_value
=for arg ... of column indices
Alias for L<get|list = $tree_model-E<gt>get ($iter, ...)>.
=cut

=for apidoc 
=for arg ... of column indices

Fetch and return the model's values in the row pointed to by I<$iter>.
If you specify no column indices, it returns the values for all of the
columns, otherwise, returns just those columns' values (in order).

This overrides overrides Glib::Object's C<get>, so you'll want to use
C<< $object->get_property >> to get object properties.

=cut
void
gtk_tree_model_get (tree_model, iter, ...)
	GtkTreeModel *tree_model
	GtkTreeIter *iter
    ALIAS:
	get_value = 1
    PREINIT:
	int i;
    PPCODE:
	PERL_UNUSED_VAR (ix);
	/* if column id's were passed, just return those columns */
	if( items > 2 )
	{
		for (i = 2 ; i < items ; i++) {
			GValue gvalue = {0, };
			gtk_tree_model_get_value (tree_model, iter, 
			                          SvIV (ST (i)), &gvalue);
			XPUSHs (sv_2mortal (gperl_sv_from_value (&gvalue)));
			g_value_unset (&gvalue);
		}
	}
	else
	{
		/* otherwise return all of the columns */
		for( i = 0; i < gtk_tree_model_get_n_columns(tree_model); i++ )
		{
			GValue gvalue = {0, };
			gtk_tree_model_get_value (tree_model, iter, 
			                          i, &gvalue);
			XPUSHs (sv_2mortal (gperl_sv_from_value (&gvalue)));
			g_value_unset (&gvalue);
		}
	}

 ## va_list means nothing to a perl developer, it's a c-specific thing.
#### void gtk_tree_model_get_valist (GtkTreeModel *tree_model, GtkTreeIter *iter, va_list var_args)


##
## gboolean gtk_tree_model_iter_next (GtkTreeModel *tree_model, GtkTreeIter *iter)
GtkTreeIter_own *
gtk_tree_model_iter_next (tree_model, iter)
	GtkTreeModel *tree_model
	GtkTreeIter *iter
    CODE:
	/* the C version modifies the iter we pass; to make this fit more
	 * with the rest of our Perl interface, we want *not* to modify
	 * the one passed and instead return the modified iter... which
	 * means we have to copy *first*. */
	RETVAL = gtk_tree_iter_copy (iter);
	if (!gtk_tree_model_iter_next (tree_model, RETVAL)) {
		gtk_tree_iter_free (RETVAL);
		XSRETURN_UNDEF;
	}
    OUTPUT:
	RETVAL

#### gboolean gtk_tree_model_iter_children (GtkTreeModel *tree_model, GtkTreeIter *iter, GtkTreeIter *parent)
GtkTreeIter_copy *
gtk_tree_model_iter_children (tree_model, parent)
	GtkTreeModel *tree_model
	GtkTreeIter_ornull *parent
    PREINIT:
	GtkTreeIter iter;
    CODE:
	if (!gtk_tree_model_iter_children (tree_model, &iter, parent))
		XSRETURN_UNDEF;
	RETVAL = &iter;
    OUTPUT:
	RETVAL

## gboolean gtk_tree_model_iter_has_child (GtkTreeModel *tree_model, GtkTreeIter *iter)
gboolean
gtk_tree_model_iter_has_child (tree_model, iter)
	GtkTreeModel *tree_model
	GtkTreeIter *iter

## gint gtk_tree_model_iter_n_children (GtkTreeModel *tree_model, GtkTreeIter *iter)
gint
gtk_tree_model_iter_n_children (tree_model, iter=NULL)
	GtkTreeModel *tree_model
	GtkTreeIter_ornull *iter

## gboolean gtk_tree_model_iter_nth_child (GtkTreeModel *tree_model, GtkTreeIter *iter, GtkTreeIter *parent, gint n)
GtkTreeIter_copy *
gtk_tree_model_iter_nth_child (tree_model, parent, n)
	GtkTreeModel *tree_model
	GtkTreeIter_ornull *parent
	gint n
    PREINIT:
	GtkTreeIter iter;
    CODE:
	if (!gtk_tree_model_iter_nth_child (tree_model, &iter, parent, n))
		XSRETURN_UNDEF;
	RETVAL = &iter;
    OUTPUT:
	RETVAL

## gboolean gtk_tree_model_iter_parent (GtkTreeModel *tree_model, GtkTreeIter *iter, GtkTreeIter *child)
GtkTreeIter_copy *
gtk_tree_model_iter_parent (tree_model, child)
	GtkTreeModel *tree_model
	GtkTreeIter *child
    PREINIT:
	GtkTreeIter iter;
    CODE:
	if (! gtk_tree_model_iter_parent (tree_model, &iter, child))
		XSRETURN_UNDEF;
	RETVAL = &iter;
    OUTPUT:
	RETVAL

#### void gtk_tree_model_ref_node (GtkTreeModel *tree_model, GtkTreeIter *iter)
#### void gtk_tree_model_unref_node (GtkTreeModel *tree_model, GtkTreeIter *iter)

## void gtk_tree_model_foreach (GtkTreeModel *model, GtkTreeModelForeachFunc func, gpointer user_data)
=for apidoc
=for arg func (subroutine)
Call I<$func> on each row in I<$model>.  I<$func> gets the tree path and iter
of the current row; if I<$func> returns true, the tree ceases to be walked,
and C<< $treemodel->foreach >> returns.
=cut
void
gtk_tree_model_foreach (model, func, user_data=NULL)
	GtkTreeModel *model
	SV * func
	SV * user_data
    PREINIT:
	GPerlCallback * callback;
	GType types[] = {
		GTK_TYPE_TREE_MODEL,
		GTK_TYPE_TREE_PATH,
		GTK_TYPE_TREE_ITER
	};
    CODE:
	callback = gperl_callback_new (func, user_data, G_N_ELEMENTS (types), types,
	                               G_TYPE_BOOLEAN);
	gtk_tree_model_foreach (model, gtk2perl_tree_model_foreach_func, callback);
	gperl_callback_destroy (callback);

## void gtk_tree_model_row_changed (GtkTreeModel *tree_model, GtkTreePath *path, GtkTreeIter *iter)
void
gtk_tree_model_row_changed (tree_model, path, iter)
	GtkTreeModel *tree_model
	GtkTreePath *path
	GtkTreeIter *iter

## void gtk_tree_model_row_inserted (GtkTreeModel *tree_model, GtkTreePath *path, GtkTreeIter *iter)
void
gtk_tree_model_row_inserted (tree_model, path, iter)
	GtkTreeModel *tree_model
	GtkTreePath *path
	GtkTreeIter *iter

## void gtk_tree_model_row_has_child_toggled (GtkTreeModel *tree_model, GtkTreePath *path, GtkTreeIter *iter)
void
gtk_tree_model_row_has_child_toggled (tree_model, path, iter)
	GtkTreeModel *tree_model
	GtkTreePath *path
	GtkTreeIter *iter

## void gtk_tree_model_row_deleted (GtkTreeModel *tree_model, GtkTreePath *path)
void
gtk_tree_model_row_deleted (tree_model, path)
	GtkTreeModel *tree_model
	GtkTreePath *path

#### void gtk_tree_model_rows_reordered (GtkTreeModel *tree_model, GtkTreePath *path, GtkTreeIter *iter, gint *new_order)
void
gtk_tree_model_rows_reordered (tree_model, path, iter, ...)
	GtkTreeModel *tree_model
	GtkTreePath *path
	GtkTreeIter_ornull *iter
    PREINIT:
	gint *new_order;
	int n, i;
    CODE:
	n = gtk_tree_model_iter_n_children (tree_model, iter);
	if (items - 3 != n)
		croak ("rows_reordered expects a list of as many indices"
		       " as the selected node of the model has children\n"
		       "   got %d, expected %d", items - 3, n);
	new_order = g_new (gint, n);
	for (i = 0 ; i < n ; i++)
		new_order[i] = SvIV (ST (3+i));
	gtk_tree_model_rows_reordered (tree_model, path, iter, new_order);
	g_free (new_order);

