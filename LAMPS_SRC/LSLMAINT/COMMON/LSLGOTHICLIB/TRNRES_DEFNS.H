/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1995-03-23 19:21:20.000000000 +0000
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
#ifndef _TRNRES_DEFNS#define _TRNRES_DEFNS#include "goth_config.h"#include "goth_datatypes.h"#include "goth_defns.h"#include "gothic_status_codes.h"#include "goth_streams.h"#include "goth_intrinsics.h"#include "sch_functions.h"#include "tran_defns.h"#include "tran_intrinsics.h"#include "lsr_defns.h"#include "lsr_intrinsics.h"#include "lsr_export.h"#include "lsr_access.h"#define TRN_SMALL  0.000001 #define TRN_CSMALL 0.999999typedef GOTH_REAL TRNRES_COORD_PAIR[2] ;#define SHL(a,b) ((unsigned char)((a)<<(b)))#define SHR(a,b) ((unsigned char)((a)>>(b)))#define SHRL(a,b,c) (SHL(SHR(a,b),c))#define SHLR(a,b,c) (SHR(SHL(a,b),c))#define SHRLR(a,b,c,d) (SHR(SHRL(a,b,c),d))#define SHLRL(a,b,c,d) (SHL(SHLR(a,b,c),d))/*****************************************************************************//*  Data Structures    Data Structures    Data Structures    Data Structures *//*****************************************************************************/typedef struct trn_tabulate_data  {   GOTH_INTEGER     table_dim;   GOTH_INTEGER     table_npts;   GOTH_REAL       *table_vals;  }    TRN_TABULATE_DATA, *TRN_TABULATE_DATA_PTR;/*****************************************************************************//*  Tabulate Function       Tabulate Function         Tabulate Function      *//*****************************************************************************/typedef GOTH_STATUS (*TRN_TABULATE_FN)( GOTH_INTEGER  table_dim,                                        GOTH_INTEGER  table_npts,                                        GOTH_REAL    *table_values );#endif /* $Header: /gothic/hdr/trnreslib/v1-9/RCS/hdr.trnres_defns.h,v 1.10 1995/03/13 13:55:16 clarke Exp $								*//* 									*/