/*
 * Copyright (C) 2015 Edward Baudrez <edward.baudrez@gmail.com>
 * This file is part of h5gen.
 *
 * h5gen is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * h5gen is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with h5gen; if not, see <http://www.gnu.org/licenses/>.
 */

#ifndef NODE_H_INCLUDED
#define NODE_H_INCLUDED

#include "opt.h"
#include <hdf5.h>

/* forward declarations */
typedef struct node_t node_t;
typedef struct nodelist_t nodelist_t;

typedef enum {
    NODE_FILE,
    NODE_GROUP
} node_type_t;

typedef struct node_t {
    node_type_t type;
    hid_t       id;
    union {
        struct {
            char   *name;
            node_t *root_group;
        } file;

        struct {
            char       *name;
            nodelist_t *members;
        } group;
    } u;
} node_t;

/* root node of the tree */
extern node_t *file;

extern node_t *node_new_file(char *name, node_t *root_group);
extern node_t *node_new_group(char *name, nodelist_t *members);
extern void    node_free(node_t *node);
extern int     node_create(node_t *node, node_t *parent, opt_t *options);

/* node lists */
typedef struct nodelist_t {
    nodelist_t *next;
    node_t     *node;
} nodelist_t;

extern nodelist_t *nodelist_prepend(nodelist_t *list, node_t *node);
extern void        nodelist_free(nodelist_t *list);
extern nodelist_t *nodelist_reverse(nodelist_t *list);

#endif /* NODE_H_INCLUDED */
