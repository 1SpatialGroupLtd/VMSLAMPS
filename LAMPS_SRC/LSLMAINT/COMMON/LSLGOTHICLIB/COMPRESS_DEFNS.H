/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1995-03-23 18:46:56.000000000 +0000
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
#ifndef _COMPRESS_DEFNS#define _COMPRESS_DEFNS/************************************************************************//* Copyright Laser-Scan Ltd, Cambridge CB4 4FY, England			*//* Author    Adrian Cuthbert, 29-Jul-1992				*//************************************************************************//************************************************************************//*									*//*			  C O M P R E S S_ D E F N S 			*//*									*//* Part of GOTHIC module PACKLIB					*//* Version 0.1, Adrian Cuthbert 29-Jul-1992				*//************************************************************************/#include "goth_defns.h"#include "goth_config.h"#include "goth_datatypes.h"#include "goth_streams.h"#include "goth_intrinsics.h"#include "gothic_status_codes.h"	#include "sch_functions.h"#include <string.h>#if USE_PLATFORM != PLAT_VMS#include <memory.h>#endiftypedef GOTH_STATUS (*COMPRESS_COMP_FN)(VOID_P		decomp_data,					GOTH_INTEGER	decomp_data_size,					GOTH_BOOLEAN	allow_quick_abort,					GOTH_BOOLEAN	allow_realloc,					GOTH_VALUE	*values,					VOID_P		*comp_data,					GOTH_INTEGER	*comp_data_size,					GOTH_INTEGER	*used_comp_data_size,					GOTH_BOOLEAN	*done_quick_abort,					GOTH_BOOLEAN	*has_compressed) ;typedef GOTH_STATUS (*COMPRESS_DECOMP_FN)(VOID_P	comp_data,					  GOTH_INTEGER	comp_data_size,					  GOTH_BOOLEAN	allow_realloc,					  GOTH_INTEGER	decompressed_size,					  GOTH_VALUE	*values,					  VOID_P	*decomp_data,					  GOTH_INTEGER	*decomp_data_size,					  GOTH_INTEGER	*used_decomp_data_size) ;#endif/* $Header: /lslhome/gothic/hdr/compresslib/v1-0/RCS/hdr.compress_defns.h,v 1.1 1993/08/06 15:19:57 davida Exp $								*//* 									*//* $Log: hdr.compress_defns.h,v $ * Revision 1.1  1993/08/06  15:19:57  davida * Version v1-0 derived from root * Initial development *								*/