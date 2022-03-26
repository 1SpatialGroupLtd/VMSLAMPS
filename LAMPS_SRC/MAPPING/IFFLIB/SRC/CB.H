/************************************************************************/
/* Copyright Laser-Scan Laboratories Ltd, Cambridge CB4 4FY, England	*/
/* Author    TJ Ibbs, 10 May 1988       				*/
/*									*/
/*		             C B . H  					*/
/*									*/
/* This header file is a C version of the Fortran include file CB.STR	*/
/* It defines the structures and values needed to handle CB entries.	*/
/*									*/
/* The LSL standard header file LSLDEF.H must be include beforehand.	*/
/*									*/
/* Note that the declarations of structure are designed for use in C,	*/
/* and are thus not identical to those in CB.STR			*/
/************************************************************************/ 

/* define a value which later files can test for with #ifndef to see if */
/* this file has already been included					*/

#define  IFF_CB_STRUCTURES_INCLUDED

/* define the maximum number of rows and columns in a single CB entry */

#define  IFF_MAXCBCOL	 20
#define  IFF_MAXCBROW	200

/* the maximum size of a CB entry is thus their product    */
/* (this is the maximum number of longwords in a CB entry) */

#define  IFF_MAXCBDATA	IFF_MAXCBCOL*IFF_MAXCBROW

/* some of the columns may be abstracted as fixed values    */
/* - define the maximum number of fixed values we can store */
/*   for each CB entry					    */

#define  IFF_MAXCBATT	20

/* if a value is absent, then the corresponding position in the */
/* CB will be set to the value IFF_ABSENT (as an unsigned int)  */

#define  IFF_ABSENT	0x80000000

/* lastly, we define the column header codes for X,Y, and Z, */
/* since these are used so often. Note that they must agree  */
/* with the codes in the default ACD tables.		     */

#define  IFF_C_X	91
#define  IFF_C_Y	92
#define  IFF_C_Z	93

/* define a structure for holding a single attribute value */
/* for instance:				           */
/*		IFF_CBitem    row[IFF_MAXCBATT];           */
/*							   */
/* Note that we rely on our knowledge that these will	   */
/*	overlay exactly, and that we can assign any of	   */
/*	them by moving the integer version around	   */

typedef union {
	   INT_4	i;	/* as an integer */
	   REAL_4	r;	/* as a  real	 */
	   char		c[4];	/* as characters */
} IFF_CBitem;

/* define a structure for holding an attribute code/value pair */
/* Note that the names for the fields are different from those */
/* used in the Fortran definition (these are more obvious)     */

typedef struct {
	INT_4	    code;		/* the attribute code  */
	IFF_CBitem  value;		/* the attribute value */
} IFF_CBatt;

/* define a structure for holding the header of a CB entry */
/* Note that 'ncol' does not include the fixed attributes  */

typedef struct {
	INT_4	   flags;		/* flags - penup=0/pendown=1	*/
	INT_4	   gtype;		/* graphical type		*/
	INT_4	   nrow;		/* number of rows in the CB	*/
	INT_4	   ncol;		/* number of data columns	*/
	INT_4	   colh[IFF_MAXCBCOL];	/* column headers		*/
	INT_4	   natt;		/* number of fixed attributes	*/
	IFF_CBatt  att[IFF_MAXCBATT];	/* the fixed attributes		*/
} IFF_CBhead;

/* define a structure to hold the body of a CB entry              */
/* Note that it treats the whole thing as a one-dimensional array, */
/* as we can't know the dimensionality to be imposed on it due to  */
/* the number of rows and columns...				   */

typedef union {
	   INT_4	i[IFF_MAXCBDATA];	/* as an integer */
	   REAL_4	r[IFF_MAXCBDATA];	/* as a  real	 */
	   char		c[IFF_MAXCBDATA][4];	/* as characters */
} IFF_CBdata;

