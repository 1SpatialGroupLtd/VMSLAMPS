/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1995-03-23 19:06:22.000000000 +0000
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
#ifndef _PLATE_DEFNS#define _PLATE_DEFNS#include "goth_config.h"#include "goth_datatypes.h"#include "goth_defns.h"#include "gothic_status_codes.h"#include "goth_streams.h"#include "goth_intrinsics.h"typedef enum _plate_comb_type{   PLATE_TRANSPARENT,   PLATE_MERGE,   PLATE_OPAQUE} PLATE_COMB_TYPE ;typedef enum _plate_print_style{   PLATE_PRINT_LSRPROCESS,   PLATE_PRINT_INPUT,   PLATE_PRINT_OUTPUT} PLATE_PRINT_STYLE ;#endif /* $Header: /gothic/hdr/platelib/v1-0/RCS/hdr.plate_defns.h,v 1.1 1994/05/03 15:11:35 davidm Exp $								*//* 									*//* $Log: hdr.plate_defns.h,v $ * Revision 1.1  1994/05/03  15:11:35  davidm * Version v1-0 derived from root * Initial development. * WICC 284. *								*/