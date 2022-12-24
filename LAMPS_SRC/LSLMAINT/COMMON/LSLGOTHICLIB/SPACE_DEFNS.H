/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1995-03-23 18:15:24.000000000 +0000
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
#ifndef _SPACE_DEFNS
#define _SPACE_DEFNS
/* $Header: /lslhome/gothic/hdr/spacelib/v1-14/RCS/hdr.space_defns.h,v 1.13.1.3 1993/03/10 20:03:22 jon Exp $								*/
/* 									*/
/* $Log: hdr.space_defns.h,v $
 * Revision 1.13.1.3  1993/03/10  20:03:22  jon
 * Version v1-14 derived from v1-13
 * Extracted to fix a bug at line 261 of space_query.c. The routine should
 * perform a SCH_CLEAR(status) when GOTH__EXISTS is found.
 *
 * Removed earlier memory leak fixes which involved freeing copies of arrays
 * returned by TRANLIB. This caused problems because version v1-3 and later of
 * TRANLIB returns pointers to the arrays not copies of thos arrays - this
 * resulted in tramples.
 *
 * Fixed bug which resulted in `space_test_trans()' returning GOTH__NOSUCHTRANS
 * if the transformation did not exist. This routine now sets the
 * `ret_trans_exists' parameter to false and returns GOTH__NORMAL if the
 * transformation does not exist.
 *
 * Revision 1.13.1.2  1992/10/26  15:44:48  jon
 * Version v1-13 derived from v1-12
 * A space route is considered unique if there is no space connected to more
 * than one other space. Fix this to test that there is also not more than
 * one transformation between the spaces as well.
 *
 * Revision 1.13.1.1  1992/10/19  21:32:54  jon
 * Version v1-12 derived from v1-11
 * Inclusion of a routine to map forward an MBR in the source space to an
 * MBR in the destination space.
 *
 * Fixed bug in 'space_tree_transform_coord()' which could result in incorrect
 * results for transformations with normalisation enabled. (* instead of +).
 *
 * Revision 1.13  1992/09/27  19:47:43  jon
 * Version v1-11 derived from v1-10
 * Extracted to fix ORACLE specific bug. ORACLE stores zero length strings
 * as null valued strings. SPACELIB produces an 'Object is nameless' message
 * when it attempts to retrieve a name which had been set to a zero
 * length string.
 *
 * Modifed name retrieval routine `space_fetch_name()' to return a zero
 * length string when it encounters a null valued name property.
 *
 * Modified `space_fetch_space_kinds()' so that it does not return the
 * space kind with a zero length string as its name. This space kind has
 * special internal significance within SPACELIB.
 *
 * Revision 1.12  1992/09/24  14:44:38  davidr
 * Version v1-10 derived from v1-9
 * Fixed argument lists for various callback routines which had been
 * scrambling x1,y1,x2,y2
 *
 * Revision 1.11  1992/09/16  14:36:00  davem
 * Version v1-9 derived from v1-8
 *
 * Enhancements to space_init.lull to improve error handling and space
 * dataset selection.
 *
 *
 * Also (while it was out):
 * 1) Corrected small bug where, when a transformation was not properly
 * registered, a misleading message about `wrong number of arguments' was
 * given.
 * 2) Build default transformations for transformation kinds with no arguments
 * correctly. NOTE source and destination spaces now set to NULL.
 * 3) Return GOTH__NOTIMPLEMENTED, when spacelib tries to return a transformation
 * of a kind with no arguments. This requires a bit more thought.
 * 4) Imposed the following restrictions on transformation kinds with no
 * arguments:
 * a) Source and destination space kinds must must not be wildcards ("")
 * b) Source and/or destination space kind must have some paramaters.
 * 5) Added new routine `space_measurement_set_copy'
 * ,
 *
 * 6) Corrected bug in `space_get_named_connections' that was thrown up by
 * purify. A read was made off the start of an array (but in fact the result
 * was never used)
 *
 * Modified `space_destroy_trans()' to decrement the count of the number of
 * transformations attached to the relevant transformation kind when the
 * transformation is removed from its kind. Resulted in memory access errors, d
 * detected using Purify.
 *
 * Revision 1.10  1992/08/26  20:11:13  jon
 * Version v1-8 derived from v1-7
 * Introduce a space-kind with name "" at startup. Allow a transformation kind
 * to be setup between any pair of space-kinds, including "", where "" can
 * stand for any space-kind.
 * Add routines to convert between a string and a simple route-tree (a space tree
 * without any branches).
 * Add routine to copy measurement sets.
 * On line 170 of space_query.c in function get_trans_k_from_object() corrected
 * an incorrected use of coln_get_marked_element(). A collpection id was being passed instead of a mark id.
 * Purify leak fix.
 *
 * Revision 1.9  1992/08/18  12:41:59  adrian
 * Version v1-7 derived from v1-6
 * Update lull files
 * Fix bug in calculation of rms residuals in calculate_fit()
 *
 * Revision 1.8  1992/08/06  19:55:18  adrian
 * Version v1-6 derived from v1-5
 * Extracted to speed up the registering of transformation functions with
 * spacelib. At the moment each call of space_register_trans`space_register_trans_func' loads the
 * transformation kind ( and associated space kinds ) from the data base. This
 * will be changed, so that `space_register_trans_func' will simply remember the
 * names it has been passed, and the registration will be done as and when
 * necessary.
 *
 * Also made error messages more verbose. Added a few new return codes and
 * stacked the names of the entities that could not be found, or were already
 * there.
 *
 * Revision 1.7  1992/08/03  10:13:31  ron
 * Version v1-5 derived from v1-4
 * Extracted to provide further routines for the Registration Application:
 *
 * Revision 1.6  1992/07/22  09:14:22  ron
 * Version v1-4 derived from v1-3
 * Extracted to supply an additional routine `space_fetch_measurement_set_names'
 * to get all the measurement sets in the database.
 * Removal of lsr_defns.h and trnlib header files and functions from space_test.c
 * since they were not needed and caused a circular dependency with rasterlib.
 * Opportunity taken to make sure library compiles on IBM. Altered NULLs to
 * 0, where it was not a pointer.
 *
 * Revision 1.5  1992/07/07  12:04:42  ron
 * Version v1-3 derived from v1-2
 * Version extracted to implement a more accurate transformation mechanism. This
 * involves normalising all coordinates in the input space before transforming
 * them, applying the transformation, and then rescaling the coordinates to the
 * output space. This type of transformation will only be able to be added
 * with the `space_add_named_trans' routine and computed using the measurement
 * set mechanism. Note: THESE ROUTINES (introduced in v1-2) WILL HAVE THEIR
 * ARGUMENT LISTS ALTERED, so beware!!!
 *
 * Also added some utility routines like `space_get_space_kind_name' and
 * `space_get_trans_kind_name'
 *
 * Revision 1.4  1992/06/26  08:54:29  ron
 * Version v1-2 derived from v1-1-1
 * Extracted to provide Extensions for Registration Application
 * Also added support for named transformations and route plans. This work
 * involved changes to the space-tree mechanism to allow it to use named
 * transformations and also to the automatic building of space trees
 * (`space_rebuild_tree') which previously only got data from the database,
 * not from the data in dynamic memory. While doing this, it was discovered
 * that the routine `space_fetch_trans_kinds_of_space' did not perform
 * according to its description - the BOOLEAN `trans_to_request' operated
 * in the wrong sense. This was corrected to conform with the description.
 * Users of this routine should check that their code gives the expected
 * result. Where this call is used within spacelib, the sense of the flag
 * has been altered, so no other routines are affected.
 *
 * Stopped `space_add_trans' and `space_add_named_trans' accepting a
 * transformation kind with no parameters. There is an implicit transformation
 * available between the spaces.
 *
 * Modified `space_init.lull' so that it works with multiple spaces, prompting
 * user for required space dataset, rather than simply picking one automatically.
 *
 * Revision 1.3  1992/04/28  09:22:01  jon
 * Version v1-1-1 derived from v1-1
 * Extracted to recreate space_init.lull and to test configuration management system.
 *
 * Revision 1.2  1992/04/27  21:09:50  jon
 * Version v1-1 derived from v1-0
 * Replace explicit calls to P*S libraries with generic object manager
 * property manipulation routines.
 *
 * Revision 1.1  1992/03/16  22:49:43  jon
 * Version v1-0 derived from root
 * Version containing `test' alternative from old system
 *								*/
/************************************************************************/
/* Copyright Laser-Scan Ltd, Cambridge CB4 4FY, England			*/
/* Author    Ron Russell, 29-Nov-1991					*/
/************************************************************************/

/************************************************************************/
/*									*/
/*		       S P A C E _ D E F N S . H 			*/
/*									*/
/* Part of GOTHIC module SPACELIB					*/
/* Version 0.1, Ron Russell 29-Nov-1991					*/
/************************************************************************/




#endif
