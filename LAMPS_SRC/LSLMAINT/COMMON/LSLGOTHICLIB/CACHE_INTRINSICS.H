/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1995-03-23 18:43:16.000000000 +0000
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
#ifndef _CACHE_INTRINSICS
#define _CACHE_INTRINSICS
/* $Header: /gothic/hdr/cachelib/v1-9a-1/RCS/hdr.cache_intrinsics.h,v 1.3.1.1 1995/02/23 15:37:36 clarke Exp $								*/
/* 									*/
/* $Log: hdr.cache_intrinsics.h,v $
 * Revision 1.3.1.1  1995/02/23  15:37:36  clarke
 * Version v1-9a-1 derived from v1-9
 * Used by vms_prog options file - need to ensure fozen version is used.
 * WICC 479. Includes traverse-fix changes which went into v1-10, but
 * not other changes.
 *
 * Revision 1.3  1994/04/21  15:41:11  jon
 * Version v1-9 derived from v1-8
 * Change occurences of "readonly" to "read_only" as readonly is
 * a keyword for VAX C.
 * Turning multiline comments into single line comments where lines end in
 * double quotes to ensure code compiles under VAXC.
 *
 * Revision 1.1.1.9  1994/02/16  17:44:45  davida
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
 * Revision 1.1.1.8  1993/12/13  19:16:51  jon
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
 * Revision 1.1.1.6  1993/01/15  15:30:21  olivia
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
 * Revision 1.1.1.5  1992/10/14  13:41:39  jon
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
 * Revision 1.1.1.4  1992/09/24  14:52:12  davidr
 * Version v1-4 derived from v1-3
 * fixed bug whereby 'enable_timing' was not initialised to FALSE.
 * Converted makefile to new format
 * lock an item while it is being flushed to prevent nasty recursive flushing
 * in RASTERLIB.
 *
 * Revision 1.1.1.3  1992/08/10  18:04:42  adrian
 * Version v1-3 derived from v1-2
 * Extracted to alter `cache_delete_value()' so that it flags deleted items
 * as modified in the cache, thus ensuring that any destroy etc callbacks
 * which are passed the item will see it as modified, and act accordingly.
 *
 * Revision 1.1.1.2  1992/04/28  17:32:19  jon
 * Version v1-2 derived from v1-1
 * Extracted to change remaining instances of CHECK_ERROR to SCH_CHECK.
 * The use of CHECK_ERROR prevented linking (got an undefined symbol).
 *
 * Revision 1.1.1.1  1992/03/17  14:19:37  davidr
 * Version v1-1 derived from v1-0
 * saved 'test' alternative from old system
 *								*/

/************************************************************************/
/* Copyright Laser-Scan Ltd, Cambridge CB4 4FY, England			*/
/* Author    DJ Allen,  1-Dec-1993					*/
/************************************************************************/

/************************************************************************/
/*									*/
/*		  C A C H E _ I N T R I N S I C S . H 			*/
/*									*/
/*......................................................................*/
/*..INTRODUCTION........................................................*/
/*								        */
/* Cachelib implements a data-independent cache.  A [[cache]] consists  */
/* on a number of [[values]], accessed through a [[key]], each of which */
/* contains a pointer to (presumably) in core data.  When a cache is    */
/* built, the caller provides a number of callback functions for        */
/* operations on cache items.  For example, callbacks are used to read  */
/* and write items---transfer them between disk and memory.  These      */
/* callback functions hide all knowledge of the data in the cache from  */
/* cachelib itself.						        */
/*								        */
/* The cache returns pointers to cache values on receipt of a key.  The */
/* hope is that the value already exists in the cache. If it does not   */
/* then the cache has to [[read]] the value from some persistent        */
/* storage external to the cache. While values are in the cache they    */
/* can be manipulated.  When the cache becomes full and a new value     */
/* needs space to be read into, old values are [[freed]], that is the   */
/* space associated with them is freed up. If the value has been        */
/* altered while in the cache, then the value is first [[flushed]] from */
/* the cache, that is written back to the persistent store so that a    */
/* subsequent read will retrieve it in its new state.  These [[read]],  */
/* [[flush]] and [[free]] operations are handled by routines that       */
/* understand the structure of the values being held, and are	        */
/* downloaded into the cache when it is created.		        */
/*									*/
/* The only aspects of a value relevant to a cache, are:		*/
/* 									*/
/* @ a VOID_P which provides access to it (referred to as the		*/
/* value pointer).							*/
/* @ its size in bytes (referred to as the value size).			*/
/* @ whether it is read-only or read-write.				*/
/* @ whether it has been modified. 					*/
/* @ whether it exists on disk.						*/
/* @ whether it is locked into the cache.				*/
/* @ the transaction level at which the value is held (see later).	*/
/*									*/
/* Cachelib supports cache transactions.  A number of changes may be    */
/* made to values within the cache without any values being flushed.    */
/* These changes may be committed or rolled back at any time.	        */
/*								        */
/* A cache has a user-configurable pool size.  This is the number of    */
/* bytes of memory which may be used by the cache data structures and   */
/* the cache values.  When an item is read into the cache, the current  */
/* pool size is incremented by the cache item size.  If this exceeds    */
/* the maximum pool size, values are discarded from the cache to ensure */
/* that the total memory used by the cache is less than the maximum     */
/* pool size.  If the pool size cannot be reduced because all values    */
/* are locked into the cache or subject to a cache transaction, the     */
/* pool size will grow regardless and a warning message will be	        */
/* printed.							        */
/*									*/
/************************************************************************/


/*>>> EXTERN functions from CACHE.C <<<*/

/*----------------------------------------------------------------------*/
/* EXTERN cache_build2							*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*								        */
/* Creates a new cache which will support transactions.  When the cache */
/* has been built using <<cache_build2>>, all new values must be        */
/* created using <<cache_insert_value_ptr2>> and		        */
/* <<cache_about_to_modify_value>> must be called before an item is     */
/* modified or deleted.						        */
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* cache_id		-out- Returned cache descriptor.		*/
/*									*/
/* key_type		-in-  Datatype for keys.			*/
/*									*/
/* hash_table_size	-in-  Number of slots in the cache hash table.	*/
/*									*/
/* hashing_func		-in-  User supplied hashing function.		*/
/*									*/
/* hashing_arg		-in-  Parameter passed to <<hashing_func>>.	*/
/*									*/
/* max_hash_level	-in-  Maximum number of times to rehash.  Not	*/
/* 			      used in the current implementation.	*/
/*									*/
/* reading_func		-in-  User supplied reading function.		*/
/*									*/
/* reading_arg		-in-  Parameter passed to <<reading_func>>.	*/
/*									*/
/* flushing_func	-in-  User supplied flushing function.		*/
/*									*/
/* flushing_arg		-in-  Parameter passed to <<flushing_func>>.	*/
/*									*/
/* freeing_func		-in-  User supplied freeing function.		*/
/*									*/
/* freeing_arg		-in-  Parameter passed to <<freeing_func>>.	*/
/*									*/
/* deleting_func	-in-  User supplied deletion function.		*/
/*									*/
/* deleting_arg		-in-  Parameter passed to <<deleting_func>>.	*/
/*									*/
/* copying_func		-in-  User supplied copy function.		*/
/*									*/
/* copying_arg		-in-  Parameter passed to <<copying_func>>.	*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__MALLOC		Virtual memory exhausted.			*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS cache_build2(GD_CACHE       *cache_id,
				GOTH_INTEGER 	key_type,
				GOTH_INTEGER	hash_table_size,
				HASH_FUNC	hashing_func,
				VOID_P		hashing_arg,
				GOTH_INTEGER	max_hash_level,
				READ_FUNC	reading_func,
				VOID_P		reading_arg,
				FLUSH_FUNC	flushing_func,
				VOID_P		flushing_arg,
				FREE_FUNC	freeing_func,
				VOID_P		freeing_arg,
				DELETE_FUNC	deleting_func,
				VOID_P		deleting_arg,
				COPY_FUNC	copying_func,
				VOID_P		copying_arg);
/*----------------------------------------------------------------------*/
/* EXTERN cache_build							*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*								        */
/* Creates a new cache.  New cachelib users should call		        */
/* <<cache_build2>> instead of <<cache_build>>.			        */
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* cache_id		-out- Returned cache descriptor.		*/
/*									*/
/* key_type		-in-  Datatype for keys.			*/
/*									*/
/* hash_table_size	-in-  Number of slots in the cache hash table.	*/
/*									*/
/* hashing_func		-in-  User supplied hashing function.		*/
/*									*/
/* hashing_arg		-in-  Parameter passed to <<hashing_func>>.	*/
/*									*/
/* max_hash_level	-in-  Maximum number of times to rehash.  Not	*/
/* 			      used in the current implementation.	*/
/*									*/
/* reading_func		-in-  User supplied reading function.		*/
/*									*/
/* reading_arg		-in-  Parameter passed to <<reading_func>>.	*/
/*									*/
/* flushing_func	-in-  User supplied flushing function.		*/
/*									*/
/* flushing_arg		-in-  Parameter passed to <<flushing_func>>.	*/
/*									*/
/* freeing_func		-in-  User supplied freeing function.		*/
/*									*/
/* freeing_arg		-in-  Parameter passed to <<freeing_func>>.	*/
/*									*/
/* deleting_func	-in-  User supplied deletion function.		*/
/*									*/
/* deleting_arg		-in-  Parameter passed to <<deleting_func>>.	*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__MALLOC		Virtual memory exhausted.			*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS cache_build(GD_CACHE        *cache_id,
			       GOTH_INTEGER 	key_type,
			       GOTH_INTEGER	hash_table_size,
			       HASH_FUNC	hashing_func,
			       VOID_P		hashing_arg,
			       GOTH_INTEGER	max_hash_level,
			       READ_FUNC	reading_func,
			       VOID_P		reading_arg,
			       FLUSH_FUNC	flushing_func,
			       VOID_P		flushing_arg,
			       FREE_FUNC	freeing_func,
			       VOID_P		freeing_arg,
			       DELETE_FUNC	deleting_func,
			       VOID_P		deleting_arg);
/*----------------------------------------------------------------------*/
/* EXTERN cache_set_pool_size						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*								        */
/* Sets the maximum pool size for the cache - if this size is less than */
/* the total size of the items currently in the cache then sufficient   */
/* items are flushed to make room.  The maximum pool size includes      */
/* cache values and the basic cache data structures, but not cache      */
/* keys.							        */
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* cache_id		-in-  Cache descriptor.				*/
/*									*/
/* cache_size		-in-  New pool size (in bytes) for the cache.	*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The CACHE descriptor is corrupt or of the	*/
/* 			incorrect type.					*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS cache_set_pool_size(GD_CACHE 	cache_id,
				       GOTH_INTEGER	cache_size);
/*----------------------------------------------------------------------*/
/* EXTERN cache_get_pool_size						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*								        */
/* Returns the current total size of the items in the cache.  The value */
/* returned includes all data used in the cache with the exception of   */
/* memory occupied by cache keys.				        */
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* cache_id		-in-  Cache descriptor.				*/
/*									*/
/* cache_size		-out- Returned total size in bytes.		*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The CACHE descriptor is corrupt or of the	*/
/* 			incorrect type.					*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS cache_get_pool_size(GD_CACHE 	cache_id,
				       GOTH_INTEGER    *cache_size);

/*----------------------------------------------------------------------*/
/* EXTERN cache_get_value_ptr						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*								        */
/* Returns the value for a cache item. The item is read into the cache  */
/* if necessary.  A pointer to the cache value is returned - no data is */
/* copied and the caller should not free the data.  The pointer is only */
/* guaranteed to be valid until the next cachelib call using the same   */
/* cache descriptor.  If it is needed for a longer period of time the   */
/* value can be locked using <<cache_lock_value>>.		        */
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* cache_id		-in-  Cache descriptor.				*/
/*									*/
/* key			-in-  The item's key.				*/
/*									*/
/* cache_hint		-out- Cache hint.				*/
/*									*/
/* value_ptr		-out- Pointer to the value's data.		*/
/*									*/
/* readonly_value	-out- Boolean to indicate whether value is	*/
/* 			      read only.				*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The CACHE descriptor is corrupt or of the	*/
/* 			incorrect type.					*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS cache_get_value_ptr(GD_CACHE		cache_id,
				       GOTH_VALUE	key,
				       VOID_P	       *cache_hint,
				       VOID_P	       *value_ptr,
				       GOTH_BOOLEAN    *readonly_value);
/*----------------------------------------------------------------------*/
/* EXTERN cache_get_value_size						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*								        */
/* Returns the size of a cache item's value. This is the size in bytes  */
/* of the value itself, determined from other calls to cachelib:        */
/* <<cache_insert_value_ptr>>, <<cache_insert_value_ptr2>>,	        */
/* <<cache_alter_value>>, <<cache_alter_value_size>>, or		       */
/* <<cache_increment_value_size>>.				        */
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* cache_id		-in-  Cache descriptor.				*/
/*									*/
/* key			-in-  The item's key.				*/
/*									*/
/* cache_hint		-in-  Cache hint.				*/
/*									*/
/* size			-out- Returned size in bytes,			*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The CACHE descriptor is corrupt or of the	*/
/* 			incorrect type.					*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS cache_get_value_size(GD_CACHE	cache_id,
					GOTH_VALUE	key,
					VOID_P		*cache_hint,
					GOTH_INTEGER	*size);
/*----------------------------------------------------------------------*/
/* EXTERN cache_lock_value						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*								        */
/* Locks a cache item in the cache.  The cache item will not be freed   */
/* or flushed until it is unlocked.  Calls to <<cache_lock_value>> and  */
/* <<cache_unlock_value>> may be nested.  The value will not be	        */
/* unlocked until an equal number of calls have been made to each       */
/* routine.							        */
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* cache_id		-in-     Cache descriptor.			*/
/*									*/
/* key			-in-     The item's key.			*/
/*									*/
/* cache_hint		-in/out- Cache hint.				*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The CACHE descriptor is corrupt or of the	*/
/* 			incorrect type.					*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS cache_lock_value(GD_CACHE	cache_id,
				    GOTH_VALUE	key,
				    VOID_P     *cache_hint);
/*----------------------------------------------------------------------*/
/* EXTERN cache_unlock_value						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*								        */
/* Unlocks a cache item.  Calls to <<cache_lock_value>> and	        */
/* <<cache_unlock_value>> may be nested.  The value will not be	        */
/* unlocked until an equal number of calls have been made to each       */
/* routine.							        */
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* cache_id		-in-     Cache descriptor.			*/
/*									*/
/* key			-in-     The item's key.			*/
/*									*/
/* cache_hint		-in/out- Cache hint.				*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The CACHE descriptor is corrupt or of the	*/
/* 			incorrect type.					*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS cache_unlock_value(GD_CACHE		cache_id,
				      GOTH_VALUE	key,
				      VOID_P	       *cache_hint);
/*----------------------------------------------------------------------*/
/* EXTERN cache_unlock_all						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*								        */
/* Unlocks all items in the cache.  Each item is guaranteed to be       */
/* unlocked, even if the lock count is greater than 1.		        */
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* cache_id		-in- Cache descriptor.				*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The CACHE descriptor is corrupt or of the	*/
/* 			incorrect type.					*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS cache_unlock_all(GD_CACHE cache_id);
/*----------------------------------------------------------------------*/
/* EXTERN cache_flush_some						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*								        */
/* Flushes or deletes selected values from the cache.  The callback     */
/* function, <<check_fun>> is applied to each modified value which is   */
/* not part of a cache transaction.  The callback returns a flag which  */
/* determines whether or not the value whould be flushed.	        */
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* cache_id		-in-  Cache descriptor.				*/
/*									*/
/* check_fun		-in-  Callback function for each item.		*/
/* 			      If it returns TRUE the item is flushed.	*/
/*			      If the callback function address is NULL	*/
/* 			      all values will be flushed.		*/
/*									*/
/* arg			-in-  Parameter to pass to callback function.	*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The CACHE descriptor is corrupt or of the	*/
/* 			incorrect type.					*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS cache_flush_some(GD_CACHE	cache_id,
				    CHECK_FN	check_fun,
				    VOID_P	arg);
/*----------------------------------------------------------------------*/
/* EXTERN cache_flush_all						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Flushes all modified items from the cache - items marked for 	*/
/* deletion are also deleted.						*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* cache_id		-in-  Cache descriptor.				*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The CACHE descriptor is corrupt or of the	*/
/* 			incorrect type.					*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS cache_flush_all(GD_CACHE	cache_id);
/*----------------------------------------------------------------------*/
/* EXTERN cache_flush_value						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*								        */
/* Flush a single value, identified by its key, from the cache.  If the */
/* value has been modified the new value will be written to persistent  */
/* storage.  If the value has been deleted the old value will be        */
/* deleted from persistent storage.				        */
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* cache_id		-in- 	 Cache descriptor.			*/
/*									*/
/* key			-in-     The item's key.			*/
/*									*/
/* cache_hint		-in/out- Cache hint.				*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The CACHE descriptor is corrupt or of the	*/
/* 			incorrect type.					*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS cache_flush_value(GD_CACHE	cache_id,
				     GOTH_VALUE	key,
				     VOID_P    *cache_hint);
/*----------------------------------------------------------------------*/
/* EXTERN cache_free_all						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Frees every item in the cache, flushing modified items and deleting	*/
/* items marked for delete.						*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* cache_id		-in- Cache descriptor.				*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The CACHE descriptor is corrupt or of the	*/
/* 			incorrect type.					*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS cache_free_all(GD_CACHE	cache_id);
/*----------------------------------------------------------------------*/
/* EXTERN cache_free_some						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*								        */
/* Frees (including flushes or deletes) selected values from the cache. */
/* The callback function, <<check_fun>> is applied to each modified     */
/* value which is not part of a cache transaction.  The callback        */
/* returns a flag which determines whether or not the value whould be   */
/* freed.							        */
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* cache_id		-in-  Cache descriptor.				*/
/*									*/
/* check_fun		-in-  Callback function for each item.		*/
/* 			      If it returns TRUE the item is freed.	*/
/*			      If the callback function address is NULL	*/
/* 			      all values will be freed.			*/
/*									*/
/* arg			-in-  Parameter to pass to callback function.	*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The CACHE descriptor is corrupt or of the	*/
/* 			incorrect type.					*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS cache_free_some(GD_CACHE	cache_id,
				   CHECK_FN	check_fun,
				   VOID_P	arg);
/*----------------------------------------------------------------------*/
/* EXTERN cache_free_value						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*								        */
/* Free a single value, identified by its key, from the cache.  If the  */
/* value has been modified, it will be flushed.  The value will then be */
/* deleted from the value.					        */
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* cache_id		-in-  Cache descriptor.				*/
/*									*/
/* key			-in-  The item's key.				*/
/*									*/
/* cache_hint		-in-  Cache hint.				*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The CACHE descriptor is corrupt or of the	*/
/* 			incorrect type.					*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS cache_free_value(GD_CACHE	cache_id,
				    GOTH_VALUE	key,
				    VOID_P     *cache_hint);
/*----------------------------------------------------------------------*/
/* EXTERN cache_destroy_value						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*								        */
/* Unconditionally removes an item from the cache.  The value will not  */
/* be flushed even if it has been modified.			        */
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* cache_id		-in-     Cache descriptor.			*/
/*									*/
/* key			-in-     The item's key.			*/
/*									*/
/* cache_hint		-in/out- Cache hint.				*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The CACHE descriptor is corrupt or of the	*/
/* 			incorrect type.					*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS cache_destroy_value(GD_CACHE		cache_id,
				       GOTH_VALUE	key,
				       VOID_P	       *cache_hint);
/*----------------------------------------------------------------------*/
/* EXTERN cache_destroy_some						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*								        */
/* Destroys selected items in the cache.  The callback function,        */
/* <<check_fun>> is applied to each modified value which is not part of */
/* a cache transaction.  The callback returns a flag which determines   */
/* whether or not the value whould be destroyed.  Values to be	        */
/* destroyed are removed from the cache without being flushed.	        */
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* cache_id		-in-  Cache descriptor.				*/
/*									*/
/* check_fun		-in-  Callback function for each item.		*/
/* 			      If it returns TRUE the item is destroyed.	*/
/*			      If the callback function address is NULL	*/
/* 			      all values will be destroyed.		*/
/*									*/
/* arg			-in-  Parameter to pass to callback function.	*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The CACHE descriptor is corrupt or of the	*/
/* 			incorrect type.					*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS cache_destroy_some(GD_CACHE	cache_id,
				      CHECK_FN	check_fun,
				      VOID_P	arg);
/*----------------------------------------------------------------------*/
/* EXTERN cache_delete_value						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*								        */
/* Deletes an item from the cache. If the item is present in the cache  */
/* it is marked for deletion and only deleted when space needs to be    */
/* freed.  Otherwise the delete callback is invoked immediately.  A     */
/* value to be deleted inside a transaction will have been read into    */
/* the cache by <<cache_about_to_modify_value>> and cannot be flushed   */
/* until the transaction completes.				        */
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* cache_id 		-in-     Cache descriptor.			*/
/*									*/
/* key			-in-     The item's key.			*/
/*									*/
/* cache_hint		-in/out- Cache hint.				*/
/*									*/
/* param_ptr		-in-     Data to pass to delete callback.	*/
/*									*/
/* param_size		-in-     Size (in bytes) of data to pass to 	*/
/*				 delete callback.			*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The CACHE descriptor is corrupt or of the	*/
/* 			incorrect type.					*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS cache_delete_value(GD_CACHE		cache_id,
				      GOTH_VALUE	key,
				      VOID_P	       *cache_hint,
				      VOID_P		param_ptr,
				      GOTH_INTEGER	param_size);
/*----------------------------------------------------------------------*/
/* EXTERN cache_delete_all						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*								        */
/* Deletes all the values in the cache, including values modified in a  */
/* transaction.							        */
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* cache_id		-in- Cache descriptor.				*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The CACHE descriptor is corrupt or of the	*/
/* 			incorrect type.					*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS cache_delete_all(GD_CACHE	cache_id);
/*----------------------------------------------------------------------*/
/* EXTERN cache_delete_some						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*								        */
/* Deletes selected cache values.  The callback function, <<check_fun>> */
/* is applied to each modified value.  The callback returns a flag      */
/* which determines whether or not the value whould be deleted.	        */
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* cache_id		-in- Cache descriptor.				*/
/*									*/
/* check_fun		-in- Callback function for each item.		*/
/* 			     If it returns TRUE the item is deleted.	*/
/*			     If the callback function address is NULL	*/
/* 			     all values will be flushed.		*/
/*									*/
/* arg			-in- Supplies information to callback function.	*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The CACHE descriptor is corrupt or of the	*/
/* 			incorrect type.					*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS cache_delete_some(GD_CACHE	cache_id,
				     CHECK_FN	check_fun,
				     VOID_P	arg);
/*----------------------------------------------------------------------*/
/* EXTERN cache_destroy							*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Flushes all modified items and then destroys the cache.		*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* cache_id		-in- Cache descriptor.				*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The CACHE descriptor is corrupt or of the	*/
/* 			incorrect type.					*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS cache_destroy(GD_CACHE	cache_id);
/*----------------------------------------------------------------------*/
/* EXTERN cache_value_altered 						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*								        */
/* Flags a cache item as modified.  This function should not be used on */
/* a transaction cache since <<cache_about_to_modify_value>> must have  */
/* been called before the item was modified.			        */
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* cache_id		-in-     Cache descriptor.			*/
/*									*/
/* key			-in-     Key for this item.			*/
/*									*/
/* cache_hint		-in/out- Cache hint.				*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL			Normal, successful completion.		*/
/*									*/
/* GOTH__DESC			The CACHE descriptor is corrupt or of 	*/
/* 				the incorrect type.			*/
/*									*/
/* GOTH__NOTTRANSACTIONOP	This operation is not supported on a	*/
/* 				transaction cache.			*/
/*									*/
/* GOTH__NOSUCHVALUE		The cache does not contain an item	*/
/* 				with this key.				*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS cache_value_altered(GD_CACHE		cache_id,
				       GOTH_VALUE	key,
				       VOID_P	       *cache_hint);
/*----------------------------------------------------------------------*/
/* EXTERN cache_alter_value_size					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*								        */
/* Notifies cachelib that the size (but not value pointer) of a cache   */
/* item has changed.  The value size in the cache and the current pool  */
/* size are updated.						        */
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* cache_id		-in-     Cache descriptor.			*/
/*									*/
/* key			-in-     Key for this value.			*/
/*									*/
/* cache_hint		-in/out- Cache hint.				*/
/*									*/
/* new_size		-in-     New size of the value in bytes.	*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The CACHE descriptor is corrupt or of the	*/
/* 			incorrect type.					*/
/*									*/
/* GOTH__NOSUCHVALUE	The cache does not contain an item		*/
/* 			with this key.					*/
/*									*/
/* GOTH__READONLYVALUE	The value is read only and should not have	*/
/* 			been altered.					*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS cache_alter_value_size(GD_CACHE	cache_id,
					  GOTH_VALUE	key,
					  VOID_P       *cache_hint,
					  GOTH_INTEGER	new_size);
/*----------------------------------------------------------------------*/
/* EXTERN cache_increment_value_size					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*								        */
/* Modifies the size of a value stored in the cache - the value's       */
/* address remains unchanged.  The value size in the cache and the      */
/* current pool size are updated.				        */
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* cache_id		-in-     Cache descriptor.			*/
/*									*/
/* key			-in-     Key for this value.			*/
/*									*/
/* cache_hint		-in/out- Cache hint.				*/
/*									*/
/* delta_size		-in-     Change in value's size.		*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The CACHE descriptor is corrupt or of the	*/
/* 			incorrect type.					*/
/*									*/
/* GOTH__NOSUCHVALUE	The cache does not contain an item		*/
/* 			with this key.					*/
/*									*/
/* GOTH__READONLYVALUE	The value was read only and should not have	*/
/* 			been altered.					*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS cache_increment_value_size(GD_CACHE		cache_id,
					      GOTH_VALUE	key,
					      VOID_P	       *cache_hint,
					      GOTH_INTEGER	delta_size);
/*----------------------------------------------------------------------*/
/* EXTERN cache_alter_value_ptr						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Replace a value in the cache -- the previous value is freed.		*/
/* 									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* cache_id		-in-     Cache descriptor.			*/
/*									*/
/* key			-in-     Key for this value.			*/
/*									*/
/* cache_hint		-in/out- Cache hint.				*/
/*									*/
/* value_ptr		-in-     Pointer to new value.			*/
/*									*/
/* size			-in-     Size of the new value in bytes.	*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The CACHE descriptor is corrupt or of the	*/
/* 			incorrect type.					*/
/*									*/
/* GOTH__NOSUCHVALUE	The cache does not contain an item		*/
/* 			with this key.					*/
/*									*/
/* GOTH__READONLYVALUE	The value is read only and should not 		*/
/* 			be altered.					*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS cache_alter_value_ptr(GD_CACHE	cache_id,
					 GOTH_VALUE	key,
					 VOID_P	       *cache_hint,
					 VOID_P		value_ptr,
					 GOTH_INTEGER	size);
/*----------------------------------------------------------------------*/
/* EXTERN cache_insert_value_ptr					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*								        */
/* Inserts a new key, value pair into the cache. The key is copied into */
/* the cache whereas only the value's address is copied.	        */
/* <<cache_insert_value_ptr2>> should be used for a transaction cache.  */
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* cache_id		-in-     Cache descriptor.			*/
/*									*/
/* create_new		-in-     If true the routine will fail if a 	*/
/*				 value already exists for the specified */
/*				 key. If false, any existing value will */
/*				 be overwritten.			*/
/*									*/
/* key			-in-     Key for this value.			*/
/*									*/
/* cache_hint		-in/out- Cache hint.				*/
/*									*/
/* value_ptr		-in-     Pointer to value.			*/
/*									*/
/* size			-in-     Size of value in bytes.		*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The CACHE descriptor is corrupt or of the	*/
/* 			incorrect type.					*/
/*									*/
/* GOTH__ITEMEXISTS	An item with this key already exists in the	*/
/* 			cache.						*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS cache_insert_value_ptr(GD_CACHE		cache_id,
					  GOTH_BOOLEAN		create_new,
					  GOTH_VALUE		key,
					  VOID_P	       *cache_hint,
					  VOID_P		value_ptr,
					  GOTH_INTEGER		size);
/*----------------------------------------------------------------------*/
/* EXTERN cache_insert_value_ptr2					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Inserts a new key, value pair into the cache. The key is copied into	*/
/* the cache whereas only the value's address is copied.		*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* cache_id		-in-     Cache descriptor.			*/
/*									*/
/* create_new		-in-     If true the routine will fail if a 	*/
/*				 value already exists for the specified */
/*				 key. If false, any existing value will */
/*				 be overwritten.			*/
/*									*/
/* key			-in-     Key for this value.			*/
/*									*/
/* cache_hint		-in/out- Cache hint.				*/
/*									*/
/* value_ptr		-in-     Pointer to value.			*/
/*									*/
/* size			-in-     Size of value in bytes.		*/
/*									*/
/* transaction_level	-in-	 The current transaction level.		*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The CACHE descriptor is corrupt or of the	*/
/* 			incorrect type.					*/
/*									*/
/* GOTH__ITEMEXISTS	An item with this key already exists in the	*/
/* 			cache.						*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS 
   cache_insert_value_ptr2(GD_CACHE		cache_id,
			   GOTH_BOOLEAN		create_new,
			   GOTH_VALUE		key,
			   VOID_P	       *cache_hint,
			   VOID_P		value_ptr,
			   GOTH_INTEGER		size,
			   GOTH_INTEGER		transaction_level);
/*----------------------------------------------------------------------*/
/* EXTERN cache_get_statistics						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Returns statistics relating to cache operations.			*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* cache_id		-in-  Cache descriptor.				*/
/*									*/
/* n_request		-out- Number of requests made to the cache.	*/
/*									*/
/* n_miss		-out- Number of requests resulting in reads 	*/
/*			      from backing store.			*/
/*									*/
/* n_flush		-out- Number of flushes to backing store.	*/
/*									*/
/* n_free		-out- Number of frees from the cache.		*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The CACHE descriptor is corrupt or of the	*/
/* 			incorrect type.					*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS cache_get_statistics(GD_CACHE	cache_id,
					GOTH_INTEGER   *n_request,
					GOTH_INTEGER   *n_miss,
					GOTH_INTEGER   *n_flush,
					GOTH_INTEGER   *n_free);
/*----------------------------------------------------------------------*/
/* EXTERN cache_get_sizes						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*								        */
/* Returns statistics relating to the numbers and sizes of cache        */
/* values.							        */
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* cache_id		-in-  Cache descriptor.				*/
/*									*/
/* n_items		-out- Number of items currently in cache.	*/
/*									*/
/* current_average 	-out- Average size in bytes of items in the 	*/
/*			      cache.					*/
/*									*/
/* running_average 	-out- Cumulative average size of all items 	*/
/*			      throughout the lifetime of this cache.	*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The CACHE descriptor is corrupt or of the	*/
/* 			incorrect type.					*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS cache_get_sizes(GD_CACHE		cache_id,
				   GOTH_INTEGER	       *n_items,
				   GOTH_INTEGER	       *current_average,
				   GOTH_INTEGER	       *running_average);
/*----------------------------------------------------------------------*/
/* EXTERN cache_enable_timing						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Enables or disables collection of timing statistics for the given    */
/* cache.							        */
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* cache_id		-in- Cache descriptor.				*/
/*									*/
/* enable_it   		-in- TRUE to enable collection of timing 	*/
/*			     statistics, FALSE to disable collection of */
/*			     timing statistics.				*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The CACHE descriptor is corrupt or of the	*/
/* 			incorrect type.					*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS cache_enable_timing(GD_CACHE		cache_id,
				       GOTH_BOOLEAN  	enable_it);
/*----------------------------------------------------------------------*/
/* EXTERN cache_get_times						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Returns the total elapsed times (measured in seconds) taken by 	*/
/* the read, flush, free and delete callbacks.				*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* cache_id		-in-  Cache descriptor.				*/
/*									*/
/* enabled		-out- Returns the state of the timing enabled	*/
/* 			      flag.					*/
/* 									*/
/* reading_secs  	-out- Returns total seconds spent in read 	*/
/*			      callbacks.				*/
/*									*/
/* flushing_secs 	-out- Returns total seconds spent in flush 	*/
/*			      callbacks.				*/
/*									*/
/* freeing_secs  	-out- Returns total seconds spent in free 	*/
/*			      callbacks.				*/
/*									*/
/* deleting_secs 	-out- Returns total seconds spent in delete 	*/
/*			      callbacks.				*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The CACHE descriptor is corrupt or of the	*/
/* 			incorrect type.					*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS cache_get_times(GD_CACHE		cache_id,
				   GOTH_BOOLEAN	       *enabled,
				   GOTH_REAL	       *reading_secs,
				   GOTH_REAL	       *flushing_secs,
				   GOTH_REAL	       *freeing_secs,
				   GOTH_REAL	       *deleting_secs);
/*----------------------------------------------------------------------*/
/* EXTERN cache_get_modified_flag_ptr					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*								        */
/* Returns the address of the modification flag for a cache value.      */
/* This routine must be used with extreme care since the address will   */
/* be invalidated if the item is freed from the cache.  This function   */
/* is not supported by a transaction cache.			        */
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* cache_id		-in-     Cache descriptor.			*/
/*									*/
/* key			-in-     Key for this value.			*/
/*									*/
/* cache_hint		-in/out- Cache hint.				*/
/*									*/
/* flagptr		-out-    Returned address of modification flag.	*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL			Normal, successful completion.		*/
/*									*/
/* GOTH__DESC			The CACHE descriptor is corrupt or of 	*/
/* 				the incorrect type.			*/
/*									*/
/* GOTH__NOTTRANSACTIONOP	This operation is not supported on a	*/
/* 				transaction cache.			*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS cache_get_modified_flag_ptr(GD_CACHE 	cache_id,
					       GOTH_VALUE 	key,
					       VOID_P 	       *cache_hint,
					       GOTH_BOOLEAN   **flagptr);

/*----------------------------------------------------------------------*/
/* EXTERN cache_is_value_modified					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*								        */
/* Returns the modified state of a cache value.  The value must be      */
/* present in the cache.					        */
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* cache_id		-in-     Cache descriptor.			*/
/*									*/
/* key			-in-     Key for this value.			*/
/*									*/
/* cache_hint		-in/out- Cache hint.				*/
/*									*/
/* modified		-out-    Modified flag.				*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL			Normal, successful completion.		*/
/*									*/
/* GOTH__DESC			The CACHE descriptor is corrupt or of 	*/
/* 				the incorrect type.			*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS cache_is_value_modified(GD_CACHE 		cache_id,
					   GOTH_VALUE 		key,
					   VOID_P 	       *cache_hint,
					   GOTH_BOOLEAN	       *modified);

/*----------------------------------------------------------------------*/
/* EXTERN cache_get_value_transaction_level				*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*								        */
/* Returns the transaction level at which a cache value is held.  This  */
/* is used by PASLIB when handling volatile views in a transaction.     */
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* cache_id		-in-     Cache descriptor.			*/
/*									*/
/* key			-in-     Key for this value.			*/
/*									*/
/* cache_hint		-in/out- Cache hint.				*/
/*									*/
/* transaction_level	-out-    Transaction level.			*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL			Normal, successful completion.		*/
/*									*/
/* GOTH__DESC			The CACHE descriptor is corrupt or of 	*/
/* 				the incorrect type.			*/
/*									*/
/* GOTH__NOSUCHVALUE		The cache does not contain an item	*/
/* 				with this key.				*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS 
   cache_get_value_transaction_level(GD_CACHE 		cache_id,
				     GOTH_VALUE 	key,
				     VOID_P 	       *cache_hint,
				     GOTH_INTEGER      *transaction_level);
/*----------------------------------------------------------------------*/
/* EXTERN cache_enable_debug						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*								        */
/* Enable or disable cache debugging on a cache.  When cache debugging  */
/* is enabled, cache operations print messages to goth_stdout.  Cache   */
/* debugging can only be enabled when cachelib is compiled with the     */
/* preprocessor variable DEBUG defined.				        */
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* cache_id		-in- Cache descriptor.				*/
/*									*/
/* on			-in- TRUE to enable cache debugging.		*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The CACHE descriptor is corrupt or of the	*/
/* 			incorrect type.					*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS cache_enable_debug(GD_CACHE		cache_id,
				      GOTH_BOOLEAN	on);
/*----------------------------------------------------------------------*/
/* EXTERN cache_enable_verify						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*								        */
/* Enable or disable cache verification on a cache.  Cahe verification  */
/* can only be enabled when cachelib is compiled with the preprocessor  */
/* macro CACHE_VERIFY set to verify the cache.  Verification is MUCH    */
/* slower.							        */
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* cache_id		-in- Cache descriptor.				*/
/*									*/
/* on			-in- TRUE to enable cache debugging.		*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The CACHE descriptor is corrupt or of the	*/
/* 			incorrect type.					*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS cache_enable_verify(GD_CACHE		cache_id,
				       GOTH_BOOLEAN	on);
/*----------------------------------------------------------------------*/
/* EXTERN cache_enable_warnings						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*								        */
/* Enable or disable cache warning messages on a cache.  When cache     */
/* warnings are enabled, a message will be printed if the cache is      */
/* forced to expand beyond the maxium pool size (CACHETOOSMALL or       */
/* CACHEHUGEOBJECT).  By default, warnings are enabled.		        */
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* cache_id		-in- Cache descriptor.				*/
/*									*/
/* on			-in- TRUE to enable cache warnings.		*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The CACHE descriptor is corrupt or of the	*/
/* 			incorrect type.					*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS cache_enable_warnings(GD_CACHE	cache_id,
					 GOTH_BOOLEAN	on);
/*----------------------------------------------------------------------*/
/* EXTERN cache_about_to_modify_value					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*								        */
/* Informs cachelib that an item in the cache is about to be modified   */
/* or deleted. This function [[must]] be called before each	        */
/* modification [[if]] the cache was built using <<cache_build2>>.      */
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* cache_id		-in-     Cache descriptor.			*/
/*									*/
/* key			-in-     Key for this value.			*/
/*									*/
/* cache_hint		-in/out- Cache hint.				*/
/*									*/
/* transaction_level	-in-     The transaction level for the 		*/
/*				 modification (0 if not in a 		*/
/*				 transaction).				*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL			Normal, successful completion.		*/
/*									*/
/* GOTH__DESC			The CACHE descriptor is corrupt or of 	*/
/* 				the incorrect type.			*/
/*									*/
/*									*/
/* GOTH__TRANSACTIONOP		This function is only supported for a 	*/
/* 				transaction cache.			*/
/* 									*/
/* GOTH__BADTRANSACTIONLEVEL	This item is already being modified at 	*/
/* 				a higher transaction level.		*/
/* 									*/
/* GOTH__NOSUCHVALUE		The cache does not contain an item	*/
/* 				with this key.				*/
/*									*/
/* GOTH__READONLYVALUE		The value is read only and should not 	*/
/* 				be altered.				*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS 
   cache_about_to_modify_value(GD_CACHE		cache_id,
			       GOTH_VALUE	key,
			       VOID_P	       *cache_hint,
			       GOTH_INTEGER	transaction_level)
	;
/*----------------------------------------------------------------------*/
/* EXTERN cache_commit_value						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*								        */
/* Commit a single value in a cache transaction.  This is seldom a good */
/* idea.  Normally, cache_commit_all() or cache_commit_some() should be */
/* used.							        */
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* cache_id		-in- 	 Cache descriptor.			*/
/*									*/
/* key			-in-     The item's key.			*/
/*									*/
/* cache_hint		-in/out- Cache hint.				*/
/*									*/
/* transaction_level	-in-     The transaction level at which the	*/
/* 				 value should be committed.		*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL			Normal, successful completion.		*/
/*									*/
/* GOTH__DESC			The CACHE descriptor is corrupt or of 	*/
/* 				the incorrect type.			*/
/*									*/
/* GOTH__NOSUCHVALUE		The cache does not contain an item	*/
/* 				with this key.				*/
/*									*/
/* GOTH__BADTRANSACTIONLEVEL	There are no cache items at this	*/
/* 				transaction level.			*/
/* 									*/
/* GOTH__NOTINTRANSACTION	The current value of this item is not	*/
/* 				at this transaction level.		*/
/* 									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS cache_commit_value(GD_CACHE		cache_id,
				      GOTH_VALUE	key,
				      VOID_P           *cache_hint,
				      GOTH_INTEGER	transaction_level);
/*----------------------------------------------------------------------*/
/* EXTERN cache_commit_some						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*								        */
/* Commit selected values from the cache at a particular transaction    */
/* level.  The callback function, <<check_fun>> is applied to each      */
/* modified value which is not part of a cache transaction.  The        */
/* callback returns flags which determine whether or not the value      */
/* whould be commit and flushed.				        */
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* cache_id		-in-  Cache descriptor.				*/
/*									*/
/* transaction_level	-in-  The transaction level at which the	*/
/* 			      value should be committed.		*/
/*									*/
/* check_fun		-in-  Callback function for each item.		*/
/* 			      This function determines whether each	*/
/* 			      item in the transaction is to be 		*/
/* 			      committed and whether the committed item	*/
/* 			      should be flushed.			*/
/*			      If the callback function address is NULL	*/
/* 			      all values will be flushed.		*/
/*									*/
/* arg			-in-  Parameter to pass to callback function.	*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The CACHE descriptor is corrupt or of the	*/
/* 			incorrect type.					*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS cache_commit_some(GD_CACHE		cache_id,
				     GOTH_INTEGER	transaction_level,
				     COMMIT_CHECK_FN	check_fun,
				     VOID_P		arg);
/*----------------------------------------------------------------------*/
/* EXTERN cache_commit_all						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*								        */
/* Commit all values at a particular transaction level.		        */
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* cache_id		-in-  Cache descriptor.				*/
/*									*/
/* transaction_level	-in-  The transaction level at which the	*/
/* 			      value should be committed.		*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The CACHE descriptor is corrupt or of the	*/
/* 			incorrect type.					*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS cache_commit_all(GD_CACHE		cache_id,
				    GOTH_INTEGER	transaction_level);
/*----------------------------------------------------------------------*/
/* EXTERN cache_rollback_value						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*								        */
/* Rollback a single value in a cache transaction.  This is seldom a    */
/* good idea.  Normally, cache_rollback_all() or cache_rollback_some()  */
/* should be used.						        */
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* cache_id		-in- 	 Cache descriptor.			*/
/*									*/
/* key			-in-     The item's key.			*/
/*									*/
/* cache_hint		-in/out- Cache hint.				*/
/*									*/
/* transaction_level	-in-     The transaction level at which the	*/
/* 				 value should be rollbacked.		*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL			Normal, successful completion.		*/
/*									*/
/* GOTH__DESC			The CACHE descriptor is corrupt or of 	*/
/* 				the incorrect type.			*/
/*									*/
/* GOTH__NOSUCHVALUE		The cache does not contain an item	*/
/* 				with this key.				*/
/*									*/
/* GOTH__BADTRANSACTIONLEVEL	There are no cache items at this	*/
/* 				transaction level.			*/
/* 									*/
/* GOTH__NOTINTRANSACTION	The current value of this item is not	*/
/* 				at this transaction level.		*/
/* 									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS cache_rollback_value(GD_CACHE	cache_id,
					GOTH_VALUE	key,
					VOID_P         *cache_hint,
					GOTH_INTEGER	transaction_level);
/*----------------------------------------------------------------------*/
/* EXTERN cache_rollback_some						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*								        */
/* Rollback selected values from the cache at a particular transaction  */
/* level.  The callback function, <<check_fun>> is applied to each      */
/* modified value which is not part of a cache transaction.  The        */
/* callback returns a flag which determines whether or not the value    */
/* whould be rolled back.					        */
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* cache_id		-in-  Cache descriptor.				*/
/*									*/
/* transaction_level	-in-  The transaction level at which the	*/
/* 			      value should be rollbacked.		*/
/*									*/
/* check_fun		-in-  Callback function for each item.  If	*/
/* 			      it returns TRUE the item is rolled back.	*/
/*									*/
/* arg			-in-  Parameter to pass to callback function.	*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The CACHE descriptor is corrupt or of the	*/
/* 			incorrect type.					*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS cache_rollback_some(GD_CACHE		cache_id,
				       GOTH_INTEGER	transaction_level,
				       CHECK_FN		check_fun,
				       VOID_P		arg);
/*----------------------------------------------------------------------*/
/* EXTERN cache_rollback_all						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*								        */
/* Rollback all values at a particular transaction level.	        */
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* cache_id		-in-  Cache descriptor.				*/
/*									*/
/* transaction_level	-in-  The transaction level at which the	*/
/* 			      values should be rolled back.		*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The CACHE descriptor is corrupt or of the	*/
/* 			incorrect type.					*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS cache_rollback_all(GD_CACHE		cache_id,
				      GOTH_INTEGER	transaction_level);
/*----------------------------------------------------------------------*/
/* EXTERN cache_traverse_modified_values				*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*								        */
/* Traverse all modified items in the cache at a transaction level up   */
/* to and including <<transaction_level>>.  A callback function is      */
/* invoked on each modified item.  The callback should not modify the   */
/* cache.  The callback is passed values marked for deletion, together  */
/* with flags to identify the value as deleted and as newly created     */
/* (not resident on disk).					        */
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* cache_id		-in- Cache descriptor.				*/
/*									*/
/* traverse_fn		-in- Pointer to callback function to be		*/
/* 			     invoked on each modified item.		*/
/* 									*/
/* arg			-in- Argument to be passed to the callback.	*/
/* 									*/
/* transaction_level	-in- Items at transaction levels upto or	*/
/* 			     including this transaction level will	*/
/* 			     be included.				*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL			Normal, successful completion.		*/
/*									*/
/* GOTH__DESC			The CACHE descriptor is corrupt or of 	*/
/* 				the incorrect type.			*/
/*									*/
/* GOTH__TRANSACTIONOP		This function is only supported for a 	*/
/* 				transaction cache.			*/
/* 									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS 
   cache_traverse_modified_values(GD_CACHE	cache_id,
				  TRAVERSE_FN	traverse_fn,
				  VOID_P	arg,
				  GOTH_INTEGER	transaction_level);
/*----------------------------------------------------------------------*/
/* EXTERN cache_get_hash_statistics					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Return statistics on the hash table used to access cache items.	*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* cache_id		-in-  Cache descriptor.				*/
/*									*/
/* hashtable_size	-out- The number of buckets in the hash table.	*/
/* 									*/
/* buckets_used		-out- The number of buckets which contain	*/
/* 			      at least one cache item.			*/
/* 									*/
/* num_entries		-out- The number of cache items in the cache.	*/
/* 									*/
/* max_chain_length	-out- The maximum number of cache items which	*/
/* 			      hash to the same value.			*/
/* 									*/
/* num_unmodified	-out- The number of unmodified items in the	*/
/* 			      cache.					*/
/*									*/
/* num_modified		-out- The number of modified items in the	*/
/* 			      cache.					*/
/*									*/
/* num_free		-out- The number of items on the cache free	*/
/* 			      list.					*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The CACHE descriptor is corrupt or of the	*/
/* 			incorrect type.					*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS 
   cache_get_hash_statistics(GD_CACHE		cache_id,
			     GOTH_INTEGER      *hashtable_size,
			     GOTH_INTEGER      *buckets_used,
			     GOTH_INTEGER      *num_entries,
			     GOTH_INTEGER      *max_chain_length,
			     GOTH_INTEGER      *num_unmodified,
			     GOTH_INTEGER      *num_modified,
			     GOTH_INTEGER      *num_free);
/*----------------------------------------------------------------------*/
/* EXTERN cache_verify_cache					        */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*								        */
/* Routine to attempt to verify the contents of a cache.  Verifies the  */
/* free list and the modified and unmodified lists.  Also checks that   */
/* the stored locked pool size matches the sum of the sizes of all      */
/* locked items.  This is very slow on a large cache - for debugging    */
/* only.							        */
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* cache_id		-in-  Cache descriptor.				*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__ERROR		An inconsistency was detected.			*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS cache_verify_cache(GD_CACHE	cache_id);



/*>>> EXTERN functions from CACHE_TEST.C <<<*/

/*----------------------------------------------------------------------*/
/* EXTERN cache_test_build						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*								        */
/* Test function to build a cache using the standard simple callbacks   */
/* defined here.						        */
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* cache_id	-out-	Cache descriptor.				*/
/*									*/
/* hash_size	-in-	Hash table size (number of entries).		*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS cache_test_build(GD_CACHE   	       *cache_id,
				    GOTH_INTEGER	hash_size);
/*----------------------------------------------------------------------*/
/* EXTERN cache_test_insert						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*								        */
/* Add or update an entry in the test cache.			        */
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* cache_id		-in- Cache descriptor.				*/
/*									*/
/* create_new		-in- Create a new entry in the cache?		*/
/*									*/
/* key			-in- The key string for this value.		*/
/*									*/
/* value		-in- The value string.				*/
/*									*/
/* transaction_level	-in- The transaction level.			*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__MALLOC		Virtual memory exhausted.			*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS cache_test_insert(GD_CACHE		cache_id,
				     GOTH_BOOLEAN	create_new,
				     GOTH_STRING	key,
				     GOTH_STRING	value,
				     GOTH_INTEGER	transaction_level);
/*----------------------------------------------------------------------*/
/* EXTERN cache_test_delete						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*								        */
/* Delete an entry in the test cache.				        */
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* cache_id		-in- Cache descriptor.				*/
/*									*/
/* key			-in- The key string to delete.			*/
/*									*/
/* transaction_level	-in- The transaction level.			*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS cache_test_delete(GD_CACHE		cache_id,
				     GOTH_STRING	key,
				     GOTH_INTEGER	transaction_level);
/*----------------------------------------------------------------------*/
/* EXTERN cache_test_get						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*								        */
/* Get an entry from the test cache.				        */
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* cache_id		-in-  Cache descriptor.				*/
/*									*/
/* key			-in-  The key string to lookup.			*/
/*									*/
/* string		-out- The value of the item in the cache.	*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__MALLOC		Virtual memory exhausted.			*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS cache_test_get(GD_CACHE	cache_id,
				  GOTH_STRING	key,
				  GOTH_STRING  *string);
/*----------------------------------------------------------------------*/
/* EXTERN cache_test_print						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Print the contents of the test "persistent" storage.			*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS cache_test_print();
/*----------------------------------------------------------------------*/
/* EXTERN cache_test_wipe						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*								        */
/* Delete the "persistent" storage for the test cache.		        */
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS cache_test_wipe();
/*----------------------------------------------------------------------*/
/* EXTERN cache_test_commit_some				        */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Test interface to cache_commit_some() which sets up a Lull callback.	*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* cache_id		-in- Cache descriptor.				*/
/* 									*/
/* transaction_level	-in- The transaction level which is to be	*/
/* 			     committed.					*/
/* 									*/
/* lull_fn		-in- The name of a Lull function which is to	*/
/* 			     be invoked as the check function.		*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS cache_test_commit_some(GD_CACHE	cache_id,
					  GOTH_INTEGER	transaction_level,
					  GOTH_STRING	lull_fn);
/*----------------------------------------------------------------------*/
/* EXTERN cache_test_rollback_some				        */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*								        */
/* Test interface to cache_rollback_some() which sets up a Lull	        */
/* callback.							        */
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* cache_id		-in- Cache descriptor.				*/
/* 									*/
/* transaction_level	-in- The transaction level which is to be	*/
/* 			     rolled back.				*/
/* 									*/
/* lull_fn		-in- The name of a Lull function which is to	*/
/* 			     be invoked as the check function.		*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS 
   cache_test_rollback_some(GD_CACHE		cache_id,
			    GOTH_INTEGER	transaction_level,
			    GOTH_STRING		lull_fn);
/*----------------------------------------------------------------------*/
/* EXTERN cache_test_trace						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*								        */
/* Enable or disable cache test tracing.  When tracing is on, the cache */
/* callbacks print trace information whenever they are called.	        */
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* on			-in- TRUE to enable cache test tracing.		*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/*									*/
/*----------------------------------------------------------------------*/

extern void cache_test_trace(GOTH_BOOLEAN	on);
/*----------------------------------------------------------------------*/
/* EXTERN cache_test_fill						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Fill the cache with a number of entries using automatically 		*/
/* generated names.							*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* cache_id		-in- Cache descriptor.				*/
/* 									*/
/* key_root		-in- Root string for generated keys.		*/
/*									*/
/* num_items		-in- Number of items to create.			*/
/*									*/
/* create_new		-in- Passed to cache_insert_value_ptr().	*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS cache_test_fill(GD_CACHE	cache_id,
				   GOTH_STRING	key_root,
				   GOTH_INTEGER	num_items,
				   GOTH_BOOLEAN	create_new);
/*----------------------------------------------------------------------*/
/* EXTERN cache_test_alter						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*								        */
/* Update the cache with a number of entries created by		        */
/* cache_test_fill().						        */
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* cache_id		-in- Cache descriptor.				*/
/* 									*/
/* key_root		-in- Root string for generated keys.		*/
/*									*/
/* num_items		-in- Number of items to create.			*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS cache_test_alter(GD_CACHE		cache_id,
				    GOTH_STRING		key_root,
				    GOTH_INTEGER	num_items);
/*----------------------------------------------------------------------*/
/* EXTERN cache_test_retrieve						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*								        */
/* Retrieve from the cache a number of entries created by	        */
/* cache_test_fill().						        */
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* cache_id		-in- Cache descriptor.				*/
/* 									*/
/* key_root		-in- Root string for generated keys.		*/
/*									*/
/* num_items		-in- Number of items to create.			*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS cache_test_retrieve(GD_CACHE		cache_id,
				       GOTH_STRING	key_root,
				       GOTH_INTEGER	num_items);


#endif	/* _CACHE_INTRINSICS */
