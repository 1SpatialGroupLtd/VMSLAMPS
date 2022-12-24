/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1994-04-19 18:25:04.000000000 +0100
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
#ifndef _TEST_MAIN
#define _TEST_MAIN

#ifndef OBJLIB
extern GOTH_STATUS obj_initialise();

extern GOTH_STATUS obj_detach_database();

extern GOTH_STATUS obj_attach_database(GOTH_ID		db_id);

extern GOTH_STATUS obj_set_total_pool_size(GOTH_INTEGER	pool_size);

#endif

#endif /* _TEST_MAIN */
