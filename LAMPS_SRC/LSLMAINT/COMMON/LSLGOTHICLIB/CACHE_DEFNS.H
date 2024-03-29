/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1995-03-23 17:43:16.000000000 +0000
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
#ifndef _CACHE_DEFNS
#define _CACHE_DEFNS
/* $Header: /gothic/hdr/cachelib/v1-9a-1/RCS/hdr.cache_defns.h,v 1.3.1.1 1995/02/23 15:37:18 clarke Exp $								*/
/* 									*/
/* $Log: hdr.cache_defns.h,v $
 * Revision 1.3.1.1  1995/02/23  15:37:18  clarke
 * Version v1-9a-1 derived from v1-9
 * Used by vms_prog options file - need to ensure fozen version is used.
 * WICC 479. Includes traverse-fix changes which went into v1-10, but
 * not other changes.
 *
 * Revision 1.3  1994/04/21  15:41:08  jon
 * Version v1-9 derived from v1-8
 * Change occurences of "readonly" to "read_only" as readonly is
 * a keyword for VAX C.
 * Turning multiline comments into single line comments where lines end in
 * double quotes to ensure code compiles under VAXC.
 *
 * Revision 1.1.1.9  1994/02/16  17:44:29  davida
 * Version v1-8 derived from v1-7
 * Gothic WICC 223.
 *
 * 1) Default to not printing CACHETOOSMALL and CACHEHUGEOBJECT errors.
 *
 * 2) cache_get_modified_flag_ptr() and cache_is_value_modified() return
 * the value as modified instead of raising a NOSUCHVALUE error.
 *
 * 3) If an error occurs while flushing a value, ensure that the lock
 * count is set to the correct value.
 *
 * 4) Fix bug in cache_make_room() where an item could be freed by
 * the flush callback and then freed again.  This caused the HASH ERROR
 * problem reading the SsangYong alldata LSLIFF text dataset.
 * Add code, conditionally compiled on -DDEBUG, to check for freeing
 * a cache item which is already free. (SsangYong error 20).
 *
 * 5) cache_alter_value_ptr() sets the EXISTS flag on the cache item.
 *
 * Revision 1.1.1.8  1993/12/13  19:16:40  jon
 * Version v1-7 derived from v1-6
 * Gothic WICC 176
 *
 * Implement cache transactions and overhaul cachelib.  Don't even think
 * of diffing this with the previous version.
 *
 * Add test facilities in new files cache_test.c and __cache_test.lull.
 *
 * Add docgen-style headers for all external functions.
 *
 * Reformat long lines to fit within 80 columns.
 *
 * Add more comments where appropriate, especially in cache_libdefns.h.
 *
 * Add new macro CACHE_GET_DED() for extracting the DED from a cache
 * descriptor.   Add new macro LOKKUP_CHECK() for handling the return
 * from cache_check_item().
 *
 * Change references to GOTH_DESCRIPTOR to the relevent GD_xxx
 * declaration.
 *
 * Removed unused files cache_errors.h and oldcache.h.
 *
 * Use gothlib goth_value functions for handling cache keys so that all
 * possible key types are supported.
 *
 * Added new function cache_build2() which includes a cache copy callback
 * and argument.  This is required to implement transactions.
 *
 * Added new list handling routines cache_move_item() and
 * cache_add_item_to_list() and rationalised existing list handlers.
 *
 * The cache_<op>_some functions now iterate over all cache entries using
 * the traverse function or over modified entries by scanning the
 * appropriate list and call cache_<op>_callback to operate on each
 * entry.  The cache_<op>_all functions now call cache_<op>_some with a
 * NULL check function.
 *
 * Each user supplied callback is now invoked from a wrapper
 * cache_call_<op>_callback which is used to gather the cache statistics.
 *
 * Added new function cache_enable_debug() to allow cache debugging to be
 * enabled for a particular cache.  This only takes effect if cachelib is
 * compiled with the preprocessor variavle DEBUG defined.
 *
 * Added new function cache_enable_warnings() which can be used to enable
 * or disable CACHETOOSMALL and CACHEHUGEOBJECT warnings.
 *
 * Added new function cache_about_to_modify_value() to signal the start
 * of a modification which may form part of a transaction.
 *
 * Added new function cache_insert_value_ptr2() which should be used
 * instead of cache_insert_value_ptr() when creating a cache entry inside
 * a transaction.
 *
 * Added new function cache_traverse_modified_values() to apply a
 * callback to each modified value within the cache.
 *
 * Added support for cache transactions with new functions
 * cache_commit_value(), cache_commit_all(), cache_commit_some(),
 * cache_rollback_value(), cache_rollback_some() and
 * cache_rollback_all().  Further modifications as required throughout
 * the code.
 *
 * Added new intrinsic cache_get_hash_statistics() to return more
 * information about the cache.
 *
 * Added new local functions cache_traverse_all() and
 * cache_traverse_non_transaction_items() which are used by the
 * cache_xxx_some() functions.
 *
 * Fixed cache_double_add() to handle addition of a negative number (as
 * long as the result is positive.  This fixes the problem with vaery
 * large or negative numbers reported for the running average size.
 *
 * Added new external function cache_verify_cache().
 *
 * Revision 1.1.1.6  1993/01/15  15:30:19  olivia
 * Version v1-6 derived from v1-5
 * Extracted to ensure that cache datastructure size is taken into account
 * when calculating the total pool size.
 *
 * Modified cache datastructure so that there is no longer a separate hash item an
 * cache item, each with separate copies of the key for every cache entry.
 * Instead, the cache item list datastructure is used for both purposes. This
 * reduces the overall size of the cache datastructure.
 *
 * Modified all the routines which allocate parts of the cache datastructure so
 * that the amount of memory required for the datastructure is added to the total
 * pool size used for that cache. These routines are:
 * 1) init_cache_list()
 * 2) get_item_from_free_list()
 * 3) init_hashtable()
 * 4) cache_build()
 *
 * Added field `inc_list_size' to the top level cache DED structure. This field
 * holds the number of entries by which the cache item list should be extended
 * whenever more cache items are required. Modified `cache_build()' and
 * `get_item_from_free_list()' to deal with this field. This field is currently
 * set to 1000.
 *
 * Revision 1.1.1.5  1992/10/14  13:42:15  jon
 * Version v1-5 derived from v1-4
 * Extracted to fix bugs in `cache_insert_value_ptr()' and
 * `cache_flush_some()'.
 *
 * No bug found in `cache_insert_value_ptr()'.
 *
 * Added routine `cache_verify()' and macro `CACHE_VERIFY()'.
 * The macro is present in most external routines in CACHELIB,
 * and can be defined to call the function if required. The
 * function attempts to verify the contents of the cache
 * datastructure, calling `cache_verify_report()' if any
 * problems are found.
 *
 * Modified `cache_flush_some()' so that it does not go into a
 * continuous loop when it encounters a locked item.
 *
 * Modified:
 * cache_item->flags ^= CACHE_ITEM_LOCKED
 * to:
 * cache_item->flags &= ~CACHE_ITEM_LOCKED
 * in the routines `cache_make_room()' and `cache_free_some()'.
 * Also moved this unlocking code in `cache_free_some()' so that
 * it does not unlock items which have been deleted.
 *
 * Modified:
 * cache_item->flags |= CACHE_ITEM_EXISTS
 * to:
 * cache_item->flags = CACHE_ITEM_EXISTS
 * in `cache_insert_value_ptr()'.
 *
 * Revision 1.1.1.4  1992/09/24  14:53:00  davidr
 * Version v1-4 derived from v1-3
 * fixed bug whereby 'enable_timing' was not initialised to FALSE.
 * Converted makefile to new format
 * lock an item while it is being flushed to prevent nasty recursive flushing
 * in RASTERLIB.
 *
 * Revision 1.1.1.3  1992/08/10  18:05:11  adrian
 * Version v1-3 derived from v1-2
 * Extracted to alter `cache_delete_value()' so that it flags deleted items
 * as modified in the cache, thus ensuring that any destroy etc callbacks
 * which are passed the item will see it as modified, and act accordingly.
 *
 * Revision 1.1.1.2  1992/04/28  17:32:33  jon
 * Version v1-2 derived from v1-1
 * Extracted to change remaining instances of CHECK_ERROR to SCH_CHECK.
 * The use of CHECK_ERROR prevented linking (got an undefined symbol).
 *
 * Revision 1.1.1.1  1992/03/17  14:20:11  davidr
 * Version v1-1 derived from v1-0
 * saved 'test' alternative from old system
 *								*/
/************************************************************************/
/* Copyright Laser-Scan Ltd, Cambridge CB4 4FY, England			*/
/* Author    David Radcliffe, 20-Aug-1990				*/
/************************************************************************/

/************************************************************************/
/*									*/
/*			 C A C H E _ D E F N S 				*/
/*									*/
/* Public definitions for the cache library.				*/
/*									*/
/* Part of GOTHIC module CACHELIB					*/
/************************************************************************/


/*----------------------------------------------------------------------*/
/* TYPE FUNC HASH_FUNC							*/
/* DESCRIPTION								*/
/*								        */
/* Callback function to calculate a hash value from a cache key.  The   */
/* hash function should return, in <<hash_value>>, an integer between 0 */
/* and <<hash_table_size>> - 1.  The hash values should be evenly       */
/* distributed over this range for a typical set of keys.	        */
/*									*/
/* ARGUMENTS								*/
/*									*/
/* hashing_arg		- A parameter, as passed to <<cache_build>>,	*/
/* 			  which will be passed to every call made to	*/
/* 			  this callback.				*/
/* 									*/
/* hash_table_size	- The number of slots in the hash table.	*/
/* 									*/
/* hash_level		- The hashing level.				*/
/* 									*/
/* key			- The key to hash.				*/
/* 									*/
/* hash_value		- The hash value, returned by the hash		*/
/* 			  function.					*/
/* 									*/
/*----------------------------------------------------------------------*/

/* begin-def */

typedef GOTH_STATUS (*HASH_FUNC)(VOID_P		hashing_arg,
				 GOTH_INTEGER	hash_table_size,
				 GOTH_INTEGER	hash_level,
				 GOTH_VALUE	key,
				 GOTH_INTEGER	*hash_value);

/* end-def */


/*----------------------------------------------------------------------*/
/* TYPE FUNC READ_FUNC							*/
/* DESCRIPTION								*/
/*								        */
/* Callback function to read a value from persistent storage for        */
/* subsequent storage in the cache.				        */
/*									*/
/* ARGUMENTS								*/
/*									*/
/* reading_arg		- A parameter, as passed to <<cache_build>>,	*/
/* 			  which will be passed to every call made to	*/
/* 			  this callback.				*/
/* 									*/
/* key			- The key for the item to read.			*/
/* 									*/
/* value_ptr		- Where to store a pointer to the value which	*/
/* 			  has been read.				*/
/* 									*/
/* value_size		- Where to store the number of bytes of		*/
/*			  memory used by the value.			*/
/* 									*/
/* read_only_value	- Where to store a flag which may mark the	*/
/* 			  value as read-only.  				*/
/* 									*/
/*----------------------------------------------------------------------*/

/* begin-def */

typedef GOTH_STATUS (*READ_FUNC)(VOID_P		reading_arg,
				 GOTH_VALUE	key,
				 VOID_P	       	*value_ptr,
				 GOTH_INTEGER	*value_size,
				 GOTH_BOOLEAN	*read_only_value);

/* end-def */

/*----------------------------------------------------------------------*/
/* TYPE FUNC FLUSH_FUNC							*/
/* DESCRIPTION								*/
/*								        */
/* Callback function to write a value back to persistent storage.	*/
/*									*/
/* ARGUMENTS								*/
/*									*/
/* flushing_arg		- A parameter, as passed to <<cache_build>>,	*/
/* 			  which will be passed to every call made to	*/
/* 			  this callback.				*/
/* 									*/
/* key			- The key for the item to write.		*/
/* 									*/
/* value		- The value to write.				*/
/* 									*/
/*----------------------------------------------------------------------*/

/* begin-def */

typedef GOTH_STATUS (*FLUSH_FUNC)(VOID_P	flushing_arg,
				  GOTH_VALUE	key,
				  VOID_P	value_ptr);

/* end-def */


/*----------------------------------------------------------------------*/
/* TYPE FUNC FREE_FUNC							*/
/* DESCRIPTION								*/
/*								        */
/* Callback function to free the memory associated with a value.	*/
/*									*/
/* ARGUMENTS								*/
/*									*/
/* freeing_arg		- A parameter, as passed to <<cache_build>>,	*/
/* 			  which will be passed to every call made to	*/
/* 			  this callback.				*/
/* 									*/
/* key			- The key for the item to free.			*/
/* 									*/
/* value		- The value to free.				*/
/* 									*/
/*----------------------------------------------------------------------*/

/* begin-def */

typedef GOTH_STATUS (*FREE_FUNC)(VOID_P		freeing_arg,
				 GOTH_VALUE	key,
				 VOID_P		value_ptr);

/* end-def */

/*----------------------------------------------------------------------*/
/* TYPE FUNC DELETE_FUNC						*/
/* DESCRIPTION								*/
/*								        */
/* Callback function to delete a value from persistent storage.	        */
/*									*/
/* ARGUMENTS								*/
/*									*/
/* deleting_arg		- A parameter, as passed to <<cache_build>>,	*/
/* 			  which will be passed to every call made to	*/
/* 			  this callback.				*/
/* 									*/
/* key			- The key for the item to delete.		*/
/* 									*/
/* value		- The value to delete.				*/
/* 									*/
/*----------------------------------------------------------------------*/

/* begin-def */

typedef GOTH_STATUS (*DELETE_FUNC)(VOID_P	deleting_arg,
				   GOTH_VALUE	key,
				   VOID_P	param_ptr);

/* end-def */


/*----------------------------------------------------------------------*/
/* TYPE FUNC COPY_FUNC							*/
/* DESCRIPTION								*/
/*								        */
/* Callback function to copy a cache value.				*/
/*									*/
/* ARGUMENTS								*/
/*									*/
/* arg			- A parameter, as passed to <<cache_build2>>,	*/
/* 			  which will be passed to every call made to	*/
/* 			  this callback.				*/
/* 									*/
/* key			- The key for the item to be copied.		*/
/* 									*/
/* source_ptr		- The value of the item to be copied.		*/
/* 									*/
/* dest_ptr		- Where to store the copy.			*/
/* 									*/
/*----------------------------------------------------------------------*/

/* begin-def */

typedef GOTH_STATUS (*COPY_FUNC)(VOID_P		arg,
				 GOTH_VALUE	key,
				 VOID_P		source_ptr,
				 VOID_P	       *dest_ptr);

/* end-def */
   


/*----------------------------------------------------------------------*/
/* TYPE FUNC CHECK_FN							*/
/* DESCRIPTION								*/
/*								        */
/* Callback function to decide whether to apply an operation to a value */
/* held in the cache.  Used, for example, by <<cache_free_some>>.       */
/*									*/
/* ARGUMENTS								*/
/*									*/
/* arg			- A parameter, as passed to <<cache_build>>,	*/
/* 			  which will be passed to every call made to	*/
/* 			  this callback.				*/
/* 									*/
/* key			- The key for the item which may be processed.	*/
/* 									*/
/* val_ptr		- The value of the item which may be processed.	*/
/* 									*/
/* doaction		- A boolean value to be returned from the 	*/
/*			  callback.  If this value is non-zero the	*/
/* 			  operation will be applied to the item.	*/
/* 									*/
/*----------------------------------------------------------------------*/

/* begin-def */

typedef GOTH_STATUS (*CHECK_FN)(VOID_P		arg,
				GOTH_VALUE	key,
				VOID_P		val_ptr,
				GOTH_BOOLEAN	*doaction);

/* end-def */
   


/*----------------------------------------------------------------------*/
/* TYPE FUNC COMMIT_CHECK_FN						*/
/* DESCRIPTION								*/
/*								        */
/* Callback function to decide whether to apply a commit operation to a */
/* value held in the cache.  For an item which is to be committed, the  */
/* callback returns another flag to determine whether the item should   */
/* be flushed.							        */
/*									*/
/* ARGUMENTS								*/
/*									*/
/* arg			- A parameter, as passed to <<cache_build>>,	*/
/* 			  which will be passed to every call made to	*/
/* 			  this callback.				*/
/* 									*/
/* key			- The key for the item which may be processed.	*/
/* 									*/
/* val_ptr		- The value of the item which may be processed.	*/
/* 									*/
/* do_commit		- A boolean value to be returned from the 	*/
/*			  callback.  If this value is non-zero the	*/
/* 			  the item will be committed.			*/
/* 									*/
/* do_flush		- A boolean value to be returned from the 	*/
/*			  callback.  If this value is non-zero the	*/
/* 			  the item will be flushed.			*/
/* 									*/
/*----------------------------------------------------------------------*/

/* begin-def */

typedef GOTH_STATUS (*COMMIT_CHECK_FN)(VOID_P		arg,
				       GOTH_VALUE	key,
				       VOID_P		val_ptr,
				       GOTH_BOOLEAN    *do_commit,
				       GOTH_BOOLEAN    *do_flush);

/* end-def */


/*----------------------------------------------------------------------*/
/* TYPE FUNC TRAVERSE_FN						*/
/* DESCRIPTION								*/
/*								        */
/* Callback function invoked when traversing items in the cache.	*/
/*									*/
/* ARGUMENTS								*/
/*									*/
/* arg			- A parameter passed to the travers function,	*/
/* 			  which will be passed to every call made to	*/
/* 			  this callback.				*/
/* 									*/
/* key			- The key for the item.				*/
/*									*/
/* new			- A boolean value which is TRUE if the value	*/
/* 			  has never been written to disk.		*/
/* 									*/
/* deleted		- A boolean value which is TRUE if the value	*/
/* 			  is marked as deleted.				*/
/* 									*/
/* val_ptr		- The value of the item.			*/
/* 									*/
/* doaction		- A boolean value to be returned from the 	*/
/*			  callback.  If this value is non-zero the	*/
/* 			  operation will be applied to the item.	*/
/* 									*/
/*----------------------------------------------------------------------*/

/* begin-def */

typedef GOTH_STATUS (*TRAVERSE_FN)(VOID_P		arg,
				   GOTH_VALUE		key,
				   GOTH_BOOLEAN		new,
				   GOTH_BOOLEAN		deleted,
				   VOID_P		val_ptr);

/* end-def */
#endif
