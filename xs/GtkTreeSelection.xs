#include "gtk2perl.h"

/* descended directly from GObject */

// typedef void (* GtkTreeSelectionForeachFunc) (GtkTreeModel *model, GtkTreePath *path, GtkTreeIter *iter, gpointer data)


MODULE = Gtk2::TreeSelection	PACKAGE = Gtk2::TreeSelection	PREFIX = gtk_tree_selection_


## void gtk_tree_selection_set_mode (GtkTreeSelection *selection, GtkSelectionMode type)
void
gtk_tree_selection_set_mode (selection, type)
	GtkTreeSelection *selection
	GtkSelectionMode type

## GtkSelectionMode gtk_tree_selection_get_mode (GtkTreeSelection *selection)
GtkSelectionMode
gtk_tree_selection_get_mode (selection)
	GtkTreeSelection *selection

## FIXME needs callbacks
### void gtk_tree_selection_set_select_function (GtkTreeSelection *selection, GtkTreeSelectionFunc func, gpointer data, GtkDestroyNotify destroy)
#void
#gtk_tree_selection_set_select_function (selection, func, data, destroy)
#	GtkTreeSelection *selection
#	GtkTreeSelectionFunc func
#	gpointer data
#	GtkDestroyNotify destroy
#
## eh? i thought GObject took care of this 
### gpointer gtk_tree_selection_get_user_data (GtkTreeSelection *selection)
#gpointer
#gtk_tree_selection_get_user_data (selection)
#	GtkTreeSelection *selection

## GtkTreeView* gtk_tree_selection_get_tree_view (GtkTreeSelection *selection)
GtkTreeView*
gtk_tree_selection_get_tree_view (selection)
	GtkTreeSelection *selection

### gboolean gtk_tree_selection_get_selected (GtkTreeSelection *selection, GtkTreeModel **model, GtkTreeIter *iter)
void
gtk_tree_selection_get_selected (selection)
	GtkTreeSelection *selection
    PREINIT:
	GtkTreeModel * model;
	GtkTreeIter iter = {0, };
    PPCODE:
	if (!gtk_tree_selection_get_selected (selection, &model, &iter))
		XSRETURN_EMPTY;
	EXTEND (SP, 2);
	PUSHs (sv_2mortal (newSVGtkTreeIter_copy (&iter)));
	PUSHs (sv_2mortal (newSVGtkTreeModel (model)));

#
### GList * gtk_tree_selection_get_selected_rows (GtkTreeSelection *selection, GtkTreeModel **model)
#GList *
#gtk_tree_selection_get_selected_rows (selection, model)
#	GtkTreeSelection *selection
#	GtkTreeModel **model
#
#
##if GTK_CHECK_VERSION(2,2,0)
#
### gint gtk_tree_selection_count_selected_rows (GtkTreeSelection *selection)
#gint
#gtk_tree_selection_count_selected_rows (selection)
#	GtkTreeSelection *selection
#
##endif /* 2.2.0 */
#
### void gtk_tree_selection_selected_foreach (GtkTreeSelection *selection, GtkTreeSelectionForeachFunc func, gpointer data)
#void
#gtk_tree_selection_selected_foreach (selection, func, data)
#	GtkTreeSelection *selection
#	GtkTreeSelectionForeachFunc func
#	gpointer data

## void gtk_tree_selection_select_path (GtkTreeSelection *selection, GtkTreePath *path)
void
gtk_tree_selection_select_path (selection, path)
	GtkTreeSelection *selection
	GtkTreePath *path

## void gtk_tree_selection_unselect_path (GtkTreeSelection *selection, GtkTreePath *path)
void
gtk_tree_selection_unselect_path (selection, path)
	GtkTreeSelection *selection
	GtkTreePath *path

## void gtk_tree_selection_select_iter (GtkTreeSelection *selection, GtkTreeIter *iter)
void
gtk_tree_selection_select_iter (selection, iter)
	GtkTreeSelection *selection
	GtkTreeIter *iter

## void gtk_tree_selection_unselect_iter (GtkTreeSelection *selection, GtkTreeIter *iter)
void
gtk_tree_selection_unselect_iter (selection, iter)
	GtkTreeSelection *selection
	GtkTreeIter *iter

## gboolean gtk_tree_selection_path_is_selected (GtkTreeSelection *selection, GtkTreePath *path)
gboolean
gtk_tree_selection_path_is_selected (selection, path)
	GtkTreeSelection *selection
	GtkTreePath *path

## gboolean gtk_tree_selection_iter_is_selected (GtkTreeSelection *selection, GtkTreeIter *iter)
gboolean
gtk_tree_selection_iter_is_selected (selection, iter)
	GtkTreeSelection *selection
	GtkTreeIter *iter

## void gtk_tree_selection_select_all (GtkTreeSelection *selection)
void
gtk_tree_selection_select_all (selection)
	GtkTreeSelection *selection

## void gtk_tree_selection_unselect_all (GtkTreeSelection *selection)
void
gtk_tree_selection_unselect_all (selection)
	GtkTreeSelection *selection

## void gtk_tree_selection_select_range (GtkTreeSelection *selection, GtkTreePath *start_path, GtkTreePath *end_path)
void
gtk_tree_selection_select_range (selection, start_path, end_path)
	GtkTreeSelection *selection
	GtkTreePath *start_path
	GtkTreePath *end_path

#if GTK_CHECK_VERSION(2,2,0)

## void gtk_tree_selection_unselect_range (GtkTreeSelection *selection, GtkTreePath *start_path, GtkTreePath *end_path)
void
gtk_tree_selection_unselect_range (selection, start_path, end_path)
	GtkTreeSelection *selection
	GtkTreePath *start_path
	GtkTreePath *end_path

#endif /* >= 2.2.0 */
