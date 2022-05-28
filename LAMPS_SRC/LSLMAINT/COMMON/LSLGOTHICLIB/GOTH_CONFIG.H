/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1995-03-23 18:57:14.000000000 +0000
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
#ifndef _GOTH_CONFIG
#define _GOTH_CONFIG
/* $Header: /usr/users/jon/RCS/hdr.goth_config.h,v 1.9 1995/01/22 20:01:01 jon Exp $								*/
/************************************************************************/
/* Copyright Laser-Scan Ltd, Cambridge CB4 4FY, England			*/
/* Author    Jonathan Billing,  8-Mar-1990				*/
/************************************************************************/

/************************************************************************/
/*									*/
/*			    C O N F I G . H 				*/
/*									*/
/* Part of GOTHIC module ALL						*/
/* Version 0.1, Jonathan Billing  8-Mar-1990				*/
/*									*/
/* Operating system and hardware dependent configuration file, 		*/
/* used to specify as many of the system dependencies within the	*/
/* Gothic platform as possible.						*/
/*									*/
/* This module defines values for symbols which indicate the		*/
/* following:								*/
/* 									*/
/* 	USE_PLATFORM	Operating system and hardware platform		*/
/* 	USE_COMPILER	Nature of the compiler (ANSI or otherwise)	*/
/*									*/
/* The USE_PLATFORM symbol is defined to be one of the following:	*/
/* 									*/
/* 	PLAT_VMS		VAX hardware with VMS 			*/
/* 	PLAT_VAXULTRIX		VAX hardware, with ULTRIX	 	*/
/* 	PLAT_DECULTRIX		DEC MIPS RISC hardware, with ULTRIX	*/
/* 	PLAT_SPARC		SUN Sparcstation, UNIX operating system	*/
/*	PLAT_HP			HP 9000,HP-UX operating system		*/
/*	PLAT_UNKNOWN		Operating system and hardware unknown	*/
/* 									*/
/* The USE_COMPILER symbol is defined to be one of the following:	*/
/* 									*/
/* 	COMP_ANSI		"Close" to ANSI				*/
/* 	COMP_NONANSI		Nowhere near ANSI			*/
/* 									*/
/* In this module, the use of "#else" with "#ifdef" or "#ifndef"	*/
/* has been avoided, as much as possible, because of doubts about 	*/
/* whether it works in some compilers.					*/
/************************************************************************/


/*----------------------------------------------------------------------*/
/* Define an easy to use symbol which indicates which operating		*/
/* system and hardware platform is being used.				*/
/*									*/
/* The symbol indicating the platform being used is:			*/
/* 									*/
/* 	USE_PLATFORM							*/
/* 									*/
/* The USE_PLATFORM symbol is defined to be one of the following:	*/
/* 									*/
/* 	PLAT_VMS		VAX hardware with VMS 			*/
/* 	PLAT_VAXULTRIX		VAX hardware, with ULTRIX	 	*/
/* 	PLAT_DECULTRIX		DEC MIPS RISC hardware, with ULTRIX	*/
/* 	PLAT_SPARC		SUN Sparcstation, UNIX operating system	*/
/*	PLAT_HP			HP 9000,HP-UX operating system		*/
/*      PLAT_DG                 DG AViiON,DG-UX operating system        */
/*      PLAT_RS                 IBM RS/6000 ,AIX operating system       */
/*	PLAT_A3                 DEC ALPHA,OSF/1 operating system	*/
/*	PLAT_SOL                SUN sparc, Solaris 2 operating system	*/
/*	PLAT_UNKNOWN		Operating system and hardware unknown	*/
/*----------------------------------------------------------------------*/

/* Define macro indicating the most restrictive alignment on any of the	*/
/* platforms dealt with */

#define GOTH_ALIGNMENT 4

/* Define value for PLAT_ symbols */

#define PLAT_UNKNOWN	20
#define PLAT_VMS	21
#define	PLAT_VAXULTRIX	22
#define PLAT_DECULTRIX	23
#define PLAT_SPARC	24
#define PLAT_HP		25
#define PLAT_DG         26
#define PLAT_RS		27
#define PLAT_A3		28
#define PLAT_SOL	29

/* Symbols defined when not using GNU C compiler */

#ifndef __GNUC__

/* VAX VMS */

#ifdef VMS
#ifndef USE_PLATFORM
#define USE_PLATFORM	PLAT_VMS
#endif
#endif

/* DEC MIPS ULTRIX */

#ifdef mips
#ifndef USE_PLATFORM
#define USE_PLATFORM	PLAT_DECULTRIX
#endif
#endif


#endif


/* Symbols defined when using GNU C compiler */

#ifdef __GNUC__

/* VAX ULTRIX and VMS */

#ifdef __vax__
#ifdef __unix__
#ifndef USE_PLATFORM
#define USE_PLATFORM	PLAT_VAXULTRIX
#endif
#else
#ifndef USE_PLATFORM
#define USE_PLATFORM	PLAT_VMS
#endif
#endif
#endif

/* DEC MIPS ULTRIX */

#ifdef __mips__
#ifdef __unix__
#ifndef USE_PLATFORM
#define USE_PLATFORM	PLAT_DECULTRIX
#endif
#endif
#endif

/* SPARC Solaris 1, SunOS 4 */

#ifdef __sparc__
#ifndef __svr4__
#ifndef USE_PLATFORM
#define USE_PLATFORM	PLAT_SPARC
#endif
#endif
#endif

/* SPARC Solaris 2, SunOS 5 */

#ifdef __sparc__
#ifdef __svr4__
#ifndef USE_PLATFORM
#define USE_PLATFORM	PLAT_SOL
#endif
#endif
#endif

#endif

/* HP HP-UX */
#ifdef __hpux
#ifndef USE_PLATFORM
#define USE_PLATFORM	PLAT_HP
#endif
#endif

/* DG DH-UX */
#ifdef __DGUX__
#ifndef USE_PLATFORM
#define USE_PLATFORM	PLAT_DG
#endif
#endif

/* IBM */
#ifdef _IBMR2
#ifndef USE_PLATFORM
#define USE_PLATFORM	PLAT_RS
#endif
#endif

/* ALPHA */
#ifdef __alpha
#ifndef USE_PLATFORM
#define USE_PLATFORM    PLAT_A3
#endif
#endif

/* Check that platform has been identified */

#ifndef USE_PLATFORM
#define USE_PLATFORM	PLAT_UNKNOWN
#endif


/*----------------------------------------------------------------------*/
/* Define a symbol which indicates the nature of the compiler being	*/
/* used.								*/
/* 									*/
/* This definition can be overridden by definitions on the C compiler	*/
/* command line.							*/
/*									*/
/* The symbol indicating the nature of the compiler is:			*/
/* 									*/
/* 	USE_COMPILER							*/
/* 									*/
/* The USE_COMPILER symbol is defined to be one of the following:	*/
/* 									*/
/* 	COMP_ANSI		"Close" to ANSI				*/
/* 	COMP_NONANSI		Nowhere near ANSI			*/
/*									*/
/* "Close" means with "void *", prototyping, and structure passing.	*/
/*									*/
/* Although the compiler may pretend to be ANSI, the C		 	*/
/* libraries on some systems may be less close to the standard.		*/
/*----------------------------------------------------------------------*/

/* Define value for COMP_ symbols */

#define COMP_ANSI	31
#define COMP_NONANSI	32

/* VAX VMS has the DEC VAX C compiler */

#if (USE_PLATFORM == PLAT_VMS)
#ifndef USE_COMPILER
#define USE_COMPILER	COMP_ANSI
#endif
#endif

/* VAX ULTRIX has the GNU C compiler */

#if (USE_PLATFORM == PLAT_VAXULTRIX)
#ifdef __GNUC__
#ifndef USE_COMPILER
#define USE_COMPILER	COMP_ANSI
#endif
#endif
#endif

/* DEC MIPS ULTRIX is now assumed to use the GNU C compiler */

#if (USE_PLATFORM == PLAT_DECULTRIX)
#ifndef USE_COMPILER
#define USE_COMPILER	COMP_ANSI
#endif
#endif

/* SPARC Solaris 1 has the GNU C compiler */

#if (USE_PLATFORM == PLAT_SPARC)
#ifdef __GNUC__
#ifndef USE_COMPILER
#define USE_COMPILER	COMP_ANSI
#endif
#endif
#endif

/* DG AViiON has the GNU C compiler */

#if (USE_PLATFORM == PLAT_DG)
#ifdef __GNUC__
#ifndef USE_COMPILER
#define USE_COMPILER	COMP_ANSI
#endif
#endif
#endif

/* HP HP-UX has a native ANSI C compiler */

#if (USE_PLATFORM == PLAT_HP)
#ifndef USE_COMPILER
#define USE_COMPILER	COMP_ANSI
#endif
#endif

/* IBM AIX has a native ANSI C compiler */

#if (USE_PLATFORM == PLAT_RS)
#ifndef USE_COMPILER
#define USE_COMPILER	COMP_ANSI
#endif
#endif

/* DEC ALPHA has a native ANSI C compiler */

#if (USE_PLATFORM == PLAT_A3)
#ifndef USE_COMPILER
#define USE_COMPILER	COMP_ANSI
#endif
#endif

/* SPARC Solaris 2 has the GNU C compiler */

#if (USE_PLATFORM == PLAT_SOL)
#ifdef __GNUC__
#ifndef USE_COMPILER
#define USE_COMPILER	COMP_ANSI
#endif
#endif
#endif

/* With unknown platforms, assume close to ANSI if using the GNU C */
/* compiler */

#if (USE_PLATFORM == PLAT_UNKNOWN)
#ifdef __GNUC__
#ifndef USE_COMPILER
#define USE_COMPILER	COMP_ANSI
#endif
#endif
#endif

/* If the compiler is unknown, assume it is not ANSI */

#ifndef USE_COMPILER
#define USE_COMPILER	COMP_NONANSI
#endif


/*----------------------------------------------------------------------*/
/* Setup the following to be the closest available to the required	*/
/* ANSI definitions:							*/
/* 									*/
/* 	VOID			void					*/
/* 	VOID_P			void *					*/
/*									*/
/* Provide replacements for the following ANSI definitions on systems	*/
/* where they are absent:						*/
/* 									*/
/* 	size_t			should be in <stddef.h>			*/
/*									*/
/* 	labs 			should be in <math.h>			*/
/*									*/
/* 	isodigit 		should be in <ctype.h>			*/
/*									*/
/* 	todigit			should be in <ctype.h>			*/
/*									*/
/*	malloc 			include <stdlib.h> if available, or	*/
/*				declare as VOID_P			*/
/*									*/
/*	goth_free		only does free if pointer is not NULL	*/
/* 									*/
/*	goth_safe_free		only does free if pointer is not NULL,	*/
/*				then sets the freed pointer to NULL.	*/
/* 									*/
/* 	goth_realloc		to have the behaviour of "realloc"	*/
/* 				as defined for the the draft ANSI	*/
/* 				standard.				*/
/*									*/
/* 	fmod			should be in <math.h>			*/
/*									*/
/* 	RAND_MAX		should be in <stdlib.h>			*/
/*									*/
/*	raise()			should be on Sparc but isn't		*/
/*									*/
/* 	difftime()		not defined on SPARC			*/
/*									*/
/* Some of the above are declared as macros rather than functions,	*/
/* so the programmer should beware of side effects.			*/
/* 									*/
/*----------------------------------------------------------------------*/

/* Specify MEMLIB debugging if required */

#ifdef GOTH_USE_DB_MALLOC
#include "malloc.h"
#endif
#include <limits.h>		/* in case not already included.	*/

/* Generic definitions - common to all platforms at present */

#define goth_free(p) { if ((p) != NULL) free(p); } 
   
#define goth_safe_free(p) do{ if ((p) != NULL) {free(p); p = NULL;} } while(0)


/* ((void) ((p) != NULL ? free(p) : (void) NULL)) */

#define GOTH_PI		3.14159265358979323846
#define GOTH_PIBY2	1.57079632679489661923
#define GOTH_PIBY4	0.78539816339744830962

/* VMS platform, for which DEC VAX C compiler is assumed */

#if (USE_PLATFORM == PLAT_VMS)

#include <stdlib.h>

#define VOID    void
#define VOID_P  void*

/* Commented out 'labs', because it appears to be declared in stdlib.h	*/

#define	labs(x)		( ((long)(x)) > 0 ? ((long)(x)) : (-(long)(x)) )

#define	isodigit(d)	( (d)>='0' && (d)<='7' )

#define	toint(d)	( (d)>='0' && (d)<='9' ? (int)((d)-'0') : \
			  (d)>='A' && (d)<='F' ? (int)((d)-'A'+10) : \
			  (int)-1 )

/* VMS use  optimised VAXC library */

#define malloc  VAXC$MALLOC_OPT
#define calloc  VAXC$CALLOC_OPT
#define free    VAXC$FREE_OPT
#define cfree   VAXC$CFREE_OPT
#define realloc VAXC$REALLOC_OPT

/* Definition of "goth_realloc" to have behaviour of ANSI "realloc" */

#define goth_realloc(ptr,size) \
(VOID_P)( (VOID_P)(ptr) == (VOID_P)NULL	? (VOID_P) malloc(size) 		: \
	 (size) == 0 			? free(ptr),(VOID_P)NULL 	: \
	 (VOID_P) realloc(ptr,size))


#endif


/* DEC MIPS ULTRIX platform, for which GNU C compiler is assumed */

#if (USE_PLATFORM == PLAT_DECULTRIX)

#include <stdlib.h>

#define VOID    void
#define VOID_P  void*	

#define	labs(x)		( ((long)(x)) > 0 ? ((long)(x)) : (-(long)(x)) )

#define	isodigit(d)	( (d)>='0' && (d)<='7' )

#define	toint(d)	( (d)>='0' && (d)<='9' ? (int)((d)-'0') : \
			  (d)>='A' && (d)<='F' ? (int)((d)-'A'+10) : \
			  (int)-1 )

/* Definition of "goth_realloc" to have behaviour of ANSI "realloc" */

#define goth_realloc(ptr,size) \
(VOID_P)( (VOID_P)(ptr) == (VOID_P)NULL	? malloc(size) 		: \
	 (size) == 0 			? free(ptr),(VOID_P)NULL 	: \
	 realloc(ptr,size))

/* define goth_realloc(ptr,size) realloc(ptr,size) */

#endif


/* SUN SPARC Solaris 1 platform, for which GNU C compiler is assumed */

#if (USE_PLATFORM == PLAT_SPARC)

#include <stdlib.h>
#include <values.h>

#include <signal.h>		/* included for raise() definition	*/
#include <unistd.h>

#define VOID    void
#define VOID_P  void*	

/* #define size_t	int */

/* VOID_P malloc(size_t); */

#define	labs(x)		( ((long)(x)) > 0 ? ((long)(x)) : (-(long)(x)) )

#define	isodigit(d)	( (d)>='0' && (d)<='7' )

#define	toint(d)	( (d)>='0' && (d)<='9' ? (int)((d)-'0') : \
			  (d)>='A' && (d)<='F' ? (int)((d)-'A'+10) : \
			  (int)-1 )

#define RAND_MAX (0x7FFFFFFF)	/* ie (2**31)-1 */

#define memmove(d,s,l) bcopy(s,d,l)

/* Definition of "goth_realloc" to have behaviour of ANSI "realloc" */

#define goth_realloc(ptr,size) \
((VOID_P) ((VOID_P)(ptr) == (VOID_P)NULL       	? malloc(size) 		 : \
	   (size) == 0 				? free(ptr),(VOID_P)NULL : \
	   realloc(ptr,size)))

/* The Sparc does not yet support an Ansii compliant realloc, to ensure 	*/
/* compatibility with libraries built against older versions of GOTHLIB, and 	*/
/* to prevent the overhead of a function call we redefine realloc   		*/

#ifndef realloc
#define realloc(ptr,size) \
((VOID_P) ((VOID_P)(ptr) == (VOID_P)NULL       	? malloc(size) 		 : \
	   (size) == 0 				? free(ptr),(VOID_P)NULL : \
	   realloc(ptr,size)))
#endif

#define raise(sig) kill(getpid(), sig)

#define	difftime(now, then)	((double)((now) - (then)))

/* prototypes for functions unaccountably missing from ctype.h */
#ifndef toupper
extern int toupper(int c);
#endif
#ifndef tolower
extern int tolower(int c);
#endif
#ifndef toascii
extern int toascii(int c);
#endif

#endif

/* HP HP-UX platform							*/

#if (USE_PLATFORM == PLAT_HP)

#include <stdlib.h>

#define VOID    void
#define VOID_P  void*	

#define	labs(x)		( ((long)(x)) > 0 ? ((long)(x)) : (-(long)(x)) )

#define	isodigit(d)	( (d)>='0' && (d)<='7' )

#define	toint(d)	( (d)>='0' && (d)<='9' ? (int)((d)-'0') : \
			  (d)>='A' && (d)<='F' ? (int)((d)-'A'+10) : \
			  (int)-1 )

/* Definition of "goth_realloc" to have behaviour of ANSI "realloc" */

#define goth_realloc(ptr,size) \
(VOID_P) ((VOID_P)(ptr) == (VOID_P)NULL	? (VOID_P)malloc(size)		 : \
	  (size) == 0 			? free(ptr),(VOID_P)NULL	 : \
	  (VOID_P)realloc(ptr,size))

/* undefine 'index' (defined in <string.h>) so that it can be used */
/* as a variable (as most of us want to do )                       */

#ifdef index
#undef index
#endif

#endif

/* DG DG-UX platform							*/

#if (USE_PLATFORM == PLAT_DG)

#include <stdlib.h>
#include <values.h>

#define VOID    void
#define VOID_P  void*	

#define	labs(x)		( ((long)(x)) > 0 ? ((long)(x)) : (-(long)(x)) )

#define	isodigit(d)	( (d)>='0' && (d)<='7' )

#define	toint(d)	( (d)>='0' && (d)<='9' ? (int)((d)-'0') : \
			  (d)>='A' && (d)<='F' ? (int)((d)-'A'+10) : \
			  (int)-1 )

/* Definition of "goth_realloc" to have behaviour of ANSI "realloc" */

#define goth_realloc(ptr,size) realloc(ptr,size)

#endif
/* IBM AIX platform							*/

#if (USE_PLATFORM == PLAT_RS)

#include <sys/types.h>
#include <stdlib.h>
#include <values.h>

#define VOID    void
#define VOID_P  void*	

#define	isodigit(d)	( (d)>='0' && (d)<='7' )

#define	toint(d)	( (d)>='0' && (d)<='9' ? (int)((d)-'0') : \
			  (d)>='A' && (d)<='F' ? (int)((d)-'A'+10) : \
			  (int)-1 )

/* Definition of "goth_realloc" to have behaviour of ANSI "realloc" */

#define goth_realloc(ptr,size) realloc(ptr,size)

#ifndef malloc
#define malloc(nbytes) malloc((nbytes) != 0 ? (nbytes) : 1)
#endif

#endif
/* DEC ALPHA platform							*/

#if (USE_PLATFORM == PLAT_A3)

#include <stdlib.h>
#include <values.h>

#define VOID    void
#define VOID_P  void*	

#define	isodigit(d)	( (d)>='0' && (d)<='7' )

#define	toint(d)	( (d)>='0' && (d)<='9' ? (int)((d)-'0') : \
			  (d)>='A' && (d)<='F' ? (int)((d)-'A'+10) : \
			  (int)-1 )

/* Definition of "goth_realloc" to have behaviour of ANSI "realloc" */

#define goth_realloc(ptr,size) realloc(ptr,size)

#ifndef malloc
#define malloc(nbytes) malloc((nbytes) != 0 ? (nbytes) : 1)
#endif

#endif

/* SUN SPARC Solaris 2 platform, for which GNU C compiler is assumed */

#if (USE_PLATFORM == PLAT_SOL)

#include <stdlib.h>
#include <values.h>

#include <signal.h>		/* included for raise() definition	*/
#include <unistd.h>

#define VOID    void
#define VOID_P  void*	

#define	isodigit(d)	( (d)>='0' && (d)<='7' )

#define	toint(d)	( (d)>='0' && (d)<='9' ? (int)((d)-'0') : \
			  (d)>='A' && (d)<='F' ? (int)((d)-'A'+10) : \
			  (int)-1 )

/* Definition of "goth_realloc" to have behaviour of ANSI "realloc" */

#define goth_realloc(ptr,size)  realloc(ptr,size)

#endif

/* If the platform is unknown, check the sort of compiler being used */

#if (USE_PLATFORM == PLAT_UNKNOWN)

/* ANSI compiler, with unknown platform */

#if (USE_COMPILER == COMP_ANSI)

#define VOID	void
#define VOID_P	void*

#endif

/* Non-ANSI compiler, with unknown platform */

#if (USE_COMPILER == COMP_NONANSI)


#define VOID    int
#define VOID_P  char*

#define size_t	int

VOID_P malloc(size_t);

#define	labs(x)		( ((long)(x)) > 0 ? ((long)(x)) : (-(long)(x)) )

#define	isodigit(d)	( (d)>='0' && (d)<='7' )

#define	toint(d)	( (d)>='0' && (d)<='9' ? (int)((d)-'0') : \
			  (d)>='A' && (d)<='F' ? (int)((d)-'A'+10) : \
			  (int)-1 )

#endif

#endif


/*----------------------------------------------------------------------*/
/* Maximum value of reals, integers etc..				*/
/*									*/
/* Maximum integer => GOTH_MAX_INT					*/
/* Maximum real    => GOTH_MAX_REAL					*/
/*----------------------------------------------------------------------*/


#if (USE_PLATFORM == PLAT_VMS)

#include <float.h>
#define GOTH_INT_MAX INT_MAX
#define GOTH_INT_MIN INT_MIN
#define GOTH_REAL_MAX DBL_MAX
#define GOTH_REAL_MIN DBL_MIN

#endif

#if (USE_PLATFORM == PLAT_VAXULTRIX)

#include <float.h>
#define GOTH_INT_MAX INT_MAX	/* not sure about these..	*/
#define GOTH_INT_MIN INT_MIN
#define GOTH_REAL_MAX FLT_MAX	/* not sure about these..	*/
#define GOTH_REAL_MIN DBL_MIN

#endif

#if (USE_PLATFORM == PLAT_DECULTRIX)

#include <float.h>
#define GOTH_INT_MAX INT_MAX
#define GOTH_INT_MIN INT_MIN
#define GOTH_REAL_MAX DBL_MAX
#define GOTH_REAL_MIN DBL_MIN

#endif

#if (USE_PLATFORM == PLAT_SPARC)

#include <values.h>		/* ???!!! - what is the difference between */
                                /* float.h and values.h - some OS have both*/
#define GOTH_INT_MAX INT_MAX
#define GOTH_INT_MIN INT_MIN
#define GOTH_REAL_MAX MAXDOUBLE
#define GOTH_REAL_MIN MINDOUBLE

#endif

#if (USE_PLATFORM == PLAT_HP)

#include <float.h>
#define GOTH_INT_MAX INT_MAX
#define GOTH_INT_MIN INT_MIN
#define GOTH_REAL_MAX DBL_MAX
#define GOTH_REAL_MIN DBL_MIN

#endif

#if (USE_PLATFORM == PLAT_DG)

#include <float.h>
#define GOTH_INT_MAX INT_MAX
#define GOTH_INT_MIN INT_MIN
#define GOTH_REAL_MAX DBL_MAX
#define GOTH_REAL_MIN DBL_MIN

#endif

#if (USE_PLATFORM == PLAT_RS)

#include <float.h>
#define GOTH_INT_MAX INT_MAX
#define GOTH_INT_MIN INT_MIN
#define GOTH_REAL_MAX DBL_MAX
#define GOTH_REAL_MIN DBL_MIN

#endif

#if (USE_PLATFORM == PLAT_A3)

#include <float.h>
#define GOTH_INT_MAX INT_MAX
#define GOTH_INT_MIN INT_MIN
#define GOTH_REAL_MAX DBL_MAX
#define GOTH_REAL_MIN DBL_MIN

#endif

#if (USE_PLATFORM == PLAT_SOL)

#include <float.h>
#define GOTH_INT_MAX INT_MAX
#define GOTH_INT_MIN INT_MIN
#define GOTH_REAL_MAX MAXDOUBLE
#define GOTH_REAL_MIN MINDOUBLE

#endif

#if (USE_PLATFORM == PLAT_UNKNOWN)

#include <float.h>
#define GOTH_INT_MAX INT_MAX
#define GOTH_INT_MIN INT_MIN
#define GOTH_REAL_MAX DBL_MAX
#define GOTH_REAL_MIN DBL_MIN

#endif


/*----------------------------------------------------------------------*/
/*  Status Code used by signal to indicate failure. Is called BADSIG    */
/*  on VMS.                                                      	*/
/*----------------------------------------------------------------------*/


#ifndef SIG_ERR

#if (USE_PLATFORM == PLAT_VMS)
#define SIG_ERR BADSIG
#endif

#if (USE_PLATFORM != PLAT_VMS)
#define SIG_ERR ((VOID_P) -1)
#endif

#endif

/*----------------------------------------------------------------------*/
/* Add the definitions of the macros used for memory debugging.		*/
/*									*/
/* stdlib.h is included explicitly before these definitions to ensure	*/
/* that, if it contains any prototypes for malloc() etc, these		*/
/* are included before the macros are defined.				*/
/*----------------------------------------------------------------------*/

#include <stdlib.h>

#ifdef GOTH_DO_MEMORY_DEBUG

#if (USE_PLATFORM == PLAT_VMS)

#undef calloc
#undef free
#undef cfree
#undef realloc

#endif 

#undef malloc
#define malloc(size) \
   goth_dbg_malloc(size,__FILE__,__LINE__)

#define calloc(e_count,e_size) \
   goth_dbg_calloc(e_count,e_size,__FILE__,__LINE__)

#define realloc(ptr, size) \
   goth_dbg_realloc(ptr, size, __FILE__, __LINE__)

#define free(ptr) \
   goth_dbg_free(ptr, __FILE__, __LINE__)

#define cfree(ptr) \
   goth_dbg_free(ptr, __FILE__, __LINE__)

#endif


/*----------------------------------------------------------------------*/
/* Can only compile for DisplayPostscript on certain platforms. Define	*/
/* GOTH_HAS_DISPLAY_POSTSCRIPT on a per-platform basis. This is used in	*/
/* INTERLIB, PLOTLIB, PSLIB, DISPLIB.			      		*/
/*----------------------------------------------------------------------*/

#if (USE_PLATFORM == PLAT_A3)

#define GOTH_HAS_DISPLAY_POSTSCRIPT

#endif

#endif

