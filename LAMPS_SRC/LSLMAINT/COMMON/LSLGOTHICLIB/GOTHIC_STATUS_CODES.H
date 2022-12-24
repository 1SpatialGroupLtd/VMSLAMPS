/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1995-03-23 18:14:18.000000000 +0000
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
#ifndef _GOTHIC_STATUS_CODES
#define _GOTHIC_STATUS_CODES

#include "goth_datatypes.h"
#ifdef GOTH_NO_SCH_TRACING
/* production forms of the SCHLIB macros */
#define SCH_WHERE()
#define SCH_RETURN(st) return (st)
#define SCH_CHECK(status) \
   do\
   {\
      GOTH_STATUS _s_t;\
      _s_t = (status);\
      if((_s_t) != GOTH__NORMAL)\
         SCH_RETURN(_s_t);\
   } while (0)
#define SCH_CHECK_RETURN(st,rt) if ((st) != GOTH__NORMAL) { if ((st) != (rt)) SCH_STACK(st); return (rt);}
#define SCH_STACK sch_stack_message
#define SCH_STACK_STRING sch_stack_string
#define SCH_PRINT sch_print_message
#define SCH_PRINT_STRING sch_print_string
#define SCH_STACK_SYSTEM() sch_stack_system_error()
#define SCH_PRINT_SYSTEM() sch_print_system_error()
#define SCH_REPORT(st) if ((st) != GOTH__NORMAL) sch_print_message_stack(),sch_print_message(st)
#define SCH_CLEAR(st) if ((st) != GOTH__NORMAL) sch_clear_message_stack()
#else
/* development forms of the SCHLIB macros */
#define SCH_WHERE() sch_stack_message(GOTH__WHERE,__FILE__,__LINE__)
#define SCH_RETURN(st) {SCH_WHERE(); return (st);}
#define SCH_CHECK(status) \
   do\
   {\
      GOTH_STATUS _s_t;\
      _s_t = (status);\
      if((_s_t) != GOTH__NORMAL)\
         SCH_RETURN(_s_t);\
   } while (0)
#define SCH_CHECK_RETURN(st,rt) if ((st) != GOTH__NORMAL) { if ((st) != (rt)) SCH_STACK(st); return (rt);}
#define SCH_STACK sch_stack_message(GOTH__WHERE,__FILE__,__LINE__),sch_stack_message
#define SCH_STACK_STRING sch_stack_message(GOTH__WHERE,__FILE__,__LINE__),sch_stack_string
#define SCH_PRINT sch_print_message(GOTH__WHERE,__FILE__,__LINE__),sch_print_message
#define SCH_PRINT_STRING sch_print_message(GOTH__WHERE,__FILE__,__LINE__),sch_print_string
#define SCH_STACK_SYSTEM() sch_stack_message(GOTH__WHERE,__FILE__,__LINE__),sch_stack_system_error()
#define SCH_PRINT_SYSTEM() sch_print_message(GOTH__WHERE,__FILE__,__LINE__),sch_print_system_error()
#define SCH_REPORT(st) if ((st) != GOTH__NORMAL) sch_print_message_stack(),sch_print_message(st)
#define SCH_CLEAR(st) if ((st) != GOTH__NORMAL) sch_clear_message_stack()
#endif
#include "status_codes.h"







/*----------------------------------------------------------------------*/
/* MACRO SCH_FUNC_MESSAGE						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* MACRO outputs a set of messages associated with a function call.	*/
/* Generally intended for outputing error messages.			*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/*									*/
/* status		- Status returned by a function.		*/
/*									*/
/* func_name		- Name of the function or the stringized	*/
/*			  function call. Ignored if NULL.		*/
/*									*/
/* text_string		- Message associated with the function		*/
/*			  call. Ignored if NULL.			*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/*									*/
/*----------------------------------------------------------------------*/

#define SCH_FUNC_MESSAGE(status, func_name, text_string)	\
do								\
{								\
   SCH_STACK(status);						\
   if ((func_name)   != NULL) sch_stack_message(GOTH__CALL, func_name);	\
   if ((text_string) != NULL) sch_stack_string(text_string);	\
} while(0)							\





/*----------------------------------------------------------------------*/
/* MACRO SCH_DO								*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* MACRO executes a generic operation (e.g. function call) which 	*/
/* returns a status code. If the returned status code is not 		*/
/* GOTH__NORMAL, the macro outputs a set of error messages. 		*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* status	- Exterior status code. If <<GOTH__NORMAL>> on extry,	*/
/*		  it will be set to the status code returned by		*/
/*		  <<op()>>, otherwise it will be left unchanged.	*/
/*									*/
/* op		- Generic operation returning a status code.		*/
/*									*/
/* txt		- Error message associated with the operation. 		*/
/*		  Ignored if NULL.					*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/*									*/
/*----------------------------------------------------------------------*/

#define SCH_DO(status, op, txt)						\
do									\
{									\
   GOTH_STATUS _local_status;						\
   if ((status) == GOTH__NORMAL)	/* Good exterior code */	\
   {									\
      _local_status = (op);						\
      if (_local_status != GOTH__NORMAL)				\
      {									\
	 SCH_FUNC_MESSAGE(_local_status, "unknown", (txt));			\
	 (status) = _local_status;					\
      }									\
   }      								\
   else					/* Bad exterior code */		\
   {									\
      (void) sch_protect_stack();					\
      _local_status = (op);						\
      (void) sch_unprotect_stack();					\
      if (_local_status != GOTH__NORMAL)				\
      {									\
	 SCH_FUNC_MESSAGE(_local_status, "unknown", (txt));			\
      }									\
   }									\
} while(0)								\







/*----------------------------------------------------------------------*/
/* MACRO SCH_DO_IF_STATUS						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* MACRO executes a generic operation (e.g. function call), which 	*/
/* returns a status code, if an existing status code <<status>>		*/
/* is the same as that specified by the argument <<required>>.	 	*/
/*									*/
/* Note, if the operation is executed and returns a bad status code,	*/
/* the macro will output a set of error messages and set <<status>> to 	*/
/* the bad code value.							*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* status	- Exterior status code which may be updated.		*/
/*									*/
/* required	- Required value of <<status>> for the operation <<op>>	*/
/*		  to be executed.					*/
/*									*/
/* op		- Generic operation returning a status code.		*/
/*									*/
/* txt		- Error message associated with the operation. 		*/
/*		  Ignored if NULL.					*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/*									*/
/*----------------------------------------------------------------------*/

#define SCH_DO_IF_STATUS(status, required, op, txt)	\
do							\
{							\
   if ((status) == (required))				\
      SCH_DO(status, op, txt);				\
} while(0)						\





/*----------------------------------------------------------------------*/
/* MACRO SCH_DO_IF_NOT_STATUS						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* MACRO executes a generic operation (e.g. function call), which 	*/
/* returns a status code, if an existing status code <<status>>		*/
/* is not the same as that specified by the argument <<required>>.	*/
/*									*/
/* Note, if the operation is executed and returns a bad status code,	*/
/* the macro will output a set of error messages and set <<status>> to 	*/
/* the bad code value.							*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* status	- Exterior status code which may be updated.		*/
/*									*/
/* required	- Required value of <<status>> for the operation <<op>>	*/
/*		  not to be executed.					*/
/*									*/
/* op		- Generic operation returning a status code.		*/
/*									*/
/* txt		- Error message associated with the operation. 		*/
/*		  Ignored if NULL.					*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/*									*/
/*----------------------------------------------------------------------*/

#define SCH_DO_IF_NOT_STATUS(status, required, op, txt)	\
do							\
{							\
   if ((status) != (required))				\
      SCH_DO(status, op, txt);				\
} while(0)						\




/*----------------------------------------------------------------------*/
/* MACRO SCH_DO_ALT							*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* MACRO executes the generic operation <<op_1>> if an existing 	*/
/* status code <<status>> is the same as that specified by the argument */
/* <<required>>. If this is not the case, the function executes the	*/
/* operation <<op_2>>.							*/
/*									*/
/* Note, if the executed operation returns a bad status code,		*/
/* the macro will output a set of error messages and set <<status>> to 	*/
/* the returned bad code value.						*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* status	- Exterior status code which may be updated.		*/
/*									*/
/* required	- Required value of <<status>> for the first operation	*/
/*		  <<op_1>> to be executed.				*/
/*									*/
/* op_1		- First generic operation returning a status code.	*/
/*									*/
/* txt_1	- Error message associated with the first operation. 	*/
/*		  Ignored if NULL.					*/
/*									*/
/* op_2		- Second generic operation returning a status code.	*/
/*									*/
/* txt_2	- Error message associated with the second operation. 	*/
/*		  Ignored if NULL.					*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/*									*/
/*----------------------------------------------------------------------*/

#define SCH_DO_ALT(status, required, op_1, txt_1, op_2, txt_2)	\
do								\
{								\
   if ((status) == (required))					\
   {								\
      SCH_DO(status, op_1, txt_1);				\
   }								\
   else								\
   {								\
      SCH_DO(status, op_2, txt_2);				\
   }								\
} while(0)							\





/*----------------------------------------------------------------------*/
/* MACRO SCH_DO_IF_OKAY							*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* MACRO executes a generic operation (e.g. function call), which 	*/
/* returns a status code, if an existing status code <<status>>		*/
/* is GOTH__NORMAL.	 						*/
/*									*/
/* Note, if the operation is executed and returns a bad status code,	*/
/* the macro will output a set of error messages and set <<status>> to 	*/
/* the bad code value.							*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* status	- Exterior status code which may be updated.		*/
/*									*/
/* op		- Generic operation returning a status code.		*/
/*									*/
/* txt		- Error message associated with the operation. 		*/
/*		  Ignored if NULL.					*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/*									*/
/*----------------------------------------------------------------------*/

#define SCH_DO_IF_OKAY(status, op, txt)			\
   SCH_DO_IF_STATUS(status, GOTH__NORMAL, op, txt)	\





/*----------------------------------------------------------------------*/
/* MACRO SCH_DO_IF_NOT_OKAY						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* MACRO executes a generic operation (e.g. function call), which 	*/
/* returns a status code, if an existing status code <<status>>		*/
/* is not GOTH__NORMAL.	 						*/
/*									*/
/* Note, if the operation is executed and returns a bad status code,	*/
/* the macro will output a set of error messages and set <<status>> to 	*/
/* the bad code value.							*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* status	- Exterior status code which may be updated.		*/
/*									*/
/* op		- Generic operation returning a status code.		*/
/*									*/
/* txt		- Error message associated with the operation. 		*/
/*		  Ignored if NULL.					*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/*									*/
/*----------------------------------------------------------------------*/

#define SCH_DO_IF_NOT_OKAY(status, op, txt)		\
   SCH_DO_IF_NOT_STATUS(status, GOTH__NORMAL, op, txt)	\




/*----------------------------------------------------------------------*/
/* MACRO SCH_COND							*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* MACRO executes a generic operation (e.g. function call), which 	*/
/* returns a status code, if an existing status code <<status>>		*/
/* is GOTH__NORMAL.	 						*/
/*									*/
/* Note, if the operation is executed and returns a bad status code,	*/
/* the macro will output a set of error messages and set <<status>> to 	*/
/* the bad code value.							*/
/* Note, this MACRO is a wrapper for SCH_DO_IF_NOT_OKAY()		*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* status	- Exterior status code which may be updated.		*/
/*									*/
/* op		- Generic operation returning a status code.		*/
/*									*/
/* txt		- Error message associated with the operation. 		*/
/*		  Ignored if NULL.					*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/*									*/
/*----------------------------------------------------------------------*/

#define SCH_COND(status, op, txt) SCH_DO_IF_OKAY(status, op, txt)





/*----------------------------------------------------------------------*/
/* MACRO SCH_CHECK_IS_STATUS						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* MACRO executes a generic operation (e.g. function call) which 	*/
/* returns a status code. If returned status code is not the same as 	*/
/* that specified by <<required>>, the macro outputs some error 	*/
/* messages to the message stack and exits the enclosing function,	*/
/* returning the invalid status code. 					*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* required	- Required status the function is to return.		*/
/*									*/
/* op		- Generic operation returning a status code.		*/
/*									*/
/* txt		- Error message associated with the operation. 		*/
/*		  Ignored if NULL.					*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* Status returned by <<op>> if not <<required>>.			*/
/*									*/
/*----------------------------------------------------------------------*/

#define SCH_CHECK_IS_STATUS(required, op, txt)		\
do							\
{							\
   GOTH_STATUS _local_required = (op);		\
   if (_local_required != (required))			\
   {							\
      SCH_FUNC_MESSAGE(_local_required, "unknown", txt);	\
      return _local_required;				\
   }							\
} while(0)						\




/*----------------------------------------------------------------------*/
/* MACRO SCH_CHECK_IS_NOT_STATUS					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* MACRO executes a generic operation (e.g. function call) which 	*/
/* returns a status code. If returned status code is the same as 	*/
/* that specified by <<required>>, the macro outputs some error 	*/
/* messages to the message stack and exits the enclosing function,	*/
/* returning the invalid status code (if not GOTH__NORMAL) or		*/
/* GOTH__ERROR (if the invalid code is GOTH__NORMAL). 			*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* required	- The status the function should not return.		*/
/*									*/
/* op		- Generic operation returning a status code.		*/
/*									*/
/* txt		- Error message associated with the operation. 		*/
/*		  Ignored if NULL.					*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* <<required>> if <<op>> returns <<required>>				*/
/*									*/
/*----------------------------------------------------------------------*/

#define SCH_CHECK_IS_NOT_STATUS(required, op, txt)	\
do							\
{							\
   GOTH_STATUS _local_required = (op);		\
   if (_local_#required == (required))			\
   {							\
      SCH_FUNC_MESSAGE(_local_required, "unknown", txt);	\
      return _local_required;				\
   }							\
} while(0)						\




/*----------------------------------------------------------------------*/
/* MACRO SCH_CHECK2							*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* MACRO executes a generic operation (e.g. function call) which 	*/
/* returns a status code. If the returned code is not GOTH__NORMAL, the	*/
/* MACRO outputs some error messages to the message stack and then 	*/
/* exits the enclosing function, returning the bad status code.		*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* op		- Generic operation returning a status code.		*/
/*									*/
/* txt		- Error message associated with the operation. 		*/
/*		  Ignored if NULL.					*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* Status returned by <<op>> if not GOTH__NORMAL.			*/
/*									*/
/*----------------------------------------------------------------------*/

#define SCH_CHECK2(op, txt) SCH_CHECK_IS_STATUS(GOTH__NORMAL, op, txt)



/*----------------------------------------------------------------------*/
/*  MACRO SCH_CHECK_DED_DEFINED						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Macro checks if a descriptor exists, is the required type, the SOD	*/
/* exists (i.e. not NULL) and the reference count is non-negative.	*/
/* If this is the case, the MACRO returns the SOD pointer. If not, the	*/
/* MACRO exits the enclosing function with a GOTH__DESC return code	*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* desc	-in-		Descriptor to be tested.			*/
/*									*/
/* ddt	-in-		Required descriptor type.			*/
/*									*/
/* obj	-out-		Pointer to the descriptor sod, if defined.	*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__DESC	If either the descriptor is non-existent, of incorrect	*/
/*		type, the SOD is non-existent, or the reference count	*/
/*		is negative.						*/
/*									*/
/*----------------------------------------------------------------------*/

#define SCH_CHECK_DED_DEFINED(desc, ddt, obj)	\
do						\
{						\
   if ((desc)                == NULL && 	\
       (desc)->type          != ddt  &&		\
       (desc)->refs           < 0    &&		\
       ((obj) = (desc)->sod) == NULL)		\
   {						\
      SCH_RETURN(GOTH__DESC);			\
   }						\
} while(0)					\






/* $Header: /usr/users/jon/RCS/hdr.gothic_status_codes.h,v 1.14 1995/01/15 21:41:37 jon Exp $								*/
/* 									*/


#endif



