/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1992-08-20 17:28:04.000000000 +0100
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, version 3.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see http://www.gnu.org/licenses/.
 */
struct edge_type {
  coordinate_type *st_ptr;
  coordinate_type *end_ptr;
  int 	reverse;
  int 	npts;
  struct edge_type *next;
};

struct check_type {
  int 	edge;
  struct check_type *next;
};

typedef struct check_type check_element;
typedef check_element     *check_ptr;
typedef struct edge_type edge_element;
typedef edge_element     *edge_ptr;
