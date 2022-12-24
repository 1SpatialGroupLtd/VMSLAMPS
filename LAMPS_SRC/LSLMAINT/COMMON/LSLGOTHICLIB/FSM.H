/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1995-03-23 17:51:40.000000000 +0000
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
#ifndef _FSM
#define _FSM
/* $Header: /gothic/hdr/fsmlib/v1-12a-5/RCS/hdr.fsm.h,v 1.18.2.1 1995/02/23 17:52:17 clarke Exp $								*/
/* 									*/
/* $Log: hdr.fsm.h,v $
 * Revision 1.18.2.1  1995/02/23  17:52:17  clarke
 * Version v1-12a-5 derived from v1-12a-4
 * Fix bug in conversion of VAX to IEEE where output bits are not
 * set to zero.
 * WICC 371.
 *
 * Revision 1.18  1994/05/24  17:52:10  jon
 * Version v1-12a-4 derived from v1-12a-3
 * Changes to ensure compilation on VMS.
 * WICC 284
 * Moved fsm_free_fac and fsm_fix_fac to fsm_channel from fsm_lock. Seems a
 * better place for them to be and fsm_lock has many system depenedent features
 * which these two routines do not need.
 *
 * Revision 1.17  1994/02/16  19:11:25  olivia
 * Version v1-12a-3 derived from v1-12a-2
 * WICC 239
 * Update fsm_fast_extend_alloc to work for file
 * structure types other than FS_CONTIGOUS.
 *
 * Fix 32-bit signed integer overflow calculating spam file
 * offsets.  Use a temporary variable to ensure that the calculations are
 * done in the correct order.  Add new function
 * spam_get_data_offset_from_index().  See Gothic error log 20.
 *
 * Fix bug in fsm_get_spam_long_runlength() by ensuring that a run is not
 * continued across SPAM pages unless it should be (don't continue if a
 * different run starts on the next page.
 *
 * Revision 1.16  1993/09/15  15:55:22  stevewi
 * Version v1-12a-2 derived from v1-12a-1
 * See Gothic WICC 126.
 *
 * Increase FSM_FD_MARGIN to allow more files to be opened outside FSMLIB's control.
 * Opening of UID files, password files etc was failing.
 * Undo part of previous modification to fsm_read_line().
 * PSLIB checks for FSMREADERROR on end of file, but FSMLIB
 * was returning GOTH__FSM. This has been changed back to
 * GOTH__FSMREADERROR.
 * See WICC GOTHIC 134.
 * Frozen for BNSC IGIS Analysis integration testing.
 *
 * Revision 1.15  1993/09/09  15:11:55  davida
 * Version v1-12a-1 derived from v1-12
 * WICC 127
 * Make fsm_read_line() and fsm_write_line() ensure that the file
 * is open before accessing it.
 *
 * Revision 1.14  1993/08/10  21:52:53  jon
 * Version v1-12 derived from v1-11
 * See Gothic WICC 1.
 *
 * Develop a method of writing a block of data representing a single
 * transaction.
 *
 * Develop compression of spam files with reading and writing of compressed data.
 *
 * Develop routine `fsm_get_size()' and `fsm_get_size_from_fac()'.
 *
 * Fix bug in `fsm_convert_double()' where VMS real is converted to IEEE.
 * The output real should be set to zero before bitwise operations are
 * performed in conversion. (See also Gothic WICC 87).
 *
 * Fix bug in `fsm_clear_spam_bit_run()'. Clearing a run at the end of one spam
 * page could result in the run at the start of the next page also being cleared.
 * If the second run is later explicitly cleared, a GOTH__SPAMNOTALLOC error
 * occurs.
 *
 * Modified `fsm_sos_wildcard_delete()' and `fsm_spam_initialise()' to fix leaks.
 *
 * Revision 1.13  1993/04/22  10:15:55  davidm
 * Version v1-11 derived from v1-10
 * added prototypes for fsm_channel routines to enable HP compilation
 *
 * Revision 1.12  1993/03/30  13:20:00  jon
 * Version v1-10 derived from v1-9
 * SOS translation modified such that undefined fields in a sos are translated
 * as environment variables
 *
 * Modified `fsm_lock()' and `fsm_inquire_remote_lock()' so that a start offset
 * of zero (when specified in conjunction with a length of zero) does not have
 * a file header size correction added to it prior to the lock being requested.
 * This ensures that the entire file, including any FSMLIB header is locked.
 * On the SUN, this also avoids an apparent bug in `fcntl()', which always
 * returns an error if a zero length is specified with a non-zero start
 * offset.
 *
 * Added macro `FSM_CORRECTION()' to `fsm_internals.h' and replaced all other
 * code in FSMLIB for calculating header size corrections with the macro.
 *
 * Revision 1.11  1993/02/04  16:23:06  jon
 * Version v1-9 derived from v1-8
 * addition of NFS file locking (using 'fcntl')
 *
 * Revision 1.10  1992/10/22  10:36:19  davidr
 * Version v1-8 derived from v1-7
 * changed 'fsm_sos_wildcard_delete' to use individual 'unlink's rather than
 * 'system' to delete files
 *
 * Revision 1.9  1992/09/06  20:01:17  jon
 * Version v1-7 derived from v1-6
 * fixed bug (log 44 in Xlate testing) whereby 'fsm_sos_to_sys_spec' was
 * crashing if the sos is a simple filename (e.g "test" )
 *
 * Revision 1.8  1992/08/26  20:19:15  jon
 * Version v1-6 derived from v1-5
 * added function 'fsm_sos_to_dir' to translate an SOS to its directory
 * component
 *
 * Revision 1.7  1992/08/10  17:48:47  adrian
 * Version v1-5 derived from v1-4
 * Addition of a routine which allows the machine type of a file to be
 * extracted from a FAC.
 *
 * Revision 1.6  1992/07/11  12:58:08  jon
 * Version v1-4 derived from v1-3
 * FO_WRITE_TEXT mode added
 * Added jacket routine for `fsm_sos_default_to_sys_spec()'
 *
 * Revision 1.5  1992/06/05  15:20:54  jon
 * Version v1-3 derived from v1-2-1
 * Extracted to allow implementation of `fsm_fast_extend_alloc()'.
 * Added `fsm_test.lull' program to allow testing of SPAM and
 * CONTIGUOUS file structures.
 * Substantially modified routine which writes out free space list for
 * contiguous file and slightly changed routine which extends contiguous
 * file to fix file corruption problem which resulted in part of free
 * space being lost, and the rest being written over data held in the file.
 * Modified sos deletion and spam sos deletion routines to return specific
 * status codes to indicate that file deletion has failed or that spam bitmap
 * file deletion has failed.
 * Modified `morefile()' routine used to extend contiguous allocation files
 * so that it combines the free space added to the end of the file with any
 * existing block of free space at the end of the file. This solves a problem
 * which could result in excessive fragmentation of space in contiguous files.
 * File structure parameter initialised for raw and text files within fsm_build_fac
 * so that files are readable when asked to store integers or reals.
 * Fixed bug in fsm_seek preventing seeks to end of FS_TEXT files.
 *
 * Revision 1.4  1992/05/12  14:41:57  davidm
 * Version v1-2-1 derived from v1-2
 * Extracted to fix bug which ensures that all unstructured files have their
 * file structure set to FS_RAW in the DED - due to an `=' instead of an `==' in
 * an if-statement.
 *
 * Revision 1.3  1992/04/28  17:37:13  jon
 * Version v1-2 derived from v1-1
 * Correct status code checking bugs and continue with development of new
 * file structures.
 * Completed SPAM file structure.
 * Improved contiguous allocation algorithms.
 * Removed debugging printouts.
 *
 * Revision 1.2  1992/03/16  17:30:04  jon
 * Version v1-1 derived from v1-0
 * Version containing `test' alternative (SPAM files etc) copied over from original system
 *								*/

#include "fsm_defns.h"

#endif 






