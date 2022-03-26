/*
   CB (co-ordinate block) header file
*/

#define IFF_MAXCBCOL 20
#define IFF_MAXCBROW 200
#define IFF_MAXCBDATA (IFF_MAXCBCOL*IFF_MAXCBROW)
#define IFF_MAXCBATT 20
#define IFF_ABSENT 0x80000000

/*
   Parameters defining column headers for x,y,z for convenience. These must
   agree with those in the default ACDs
*/

#define IFFC_X 91
#define IFFC_Y 92
#define IFFC_Z 93

/*
   Attribute structure.
*/

typedef struct iff_cbatt {
	int	attc;		/* code */
	union {
		int	i;          /* integer */
		float	r;          /* real */
		char	c[4];       /* string */
	} attv;			/* value */
} IFF_CBATT;

/*
   Define the record structure to hold CB header ( the fixed part )
*/

typedef struct iff_cbh {
	int	flags,			/* flags ( cf. iends */
		gtype,			/* graphical type */
		nrow,			/* no. of rows */
		ncol,			/* no. of cols */
		colh[IFF_MAXCBCOL],	/* column headers */
		natt;			/* no. of attributes */
	IFF_CBATT att[IFF_MAXCBATT];
} IFF_CBH;

/*
   ... and a record structure to hold CB data ( treats the whole thing as
   a one-dimensional array.
*/

typedef union iff_cbd {
	int	i[IFF_MAXCBDATA];	/* integer */
	float	r[IFF_MAXCBDATA];	/* real */
	char	c[4][IFF_MAXCBDATA];	/* string ... CHECK ORDER ! */
} IFF_CBD;

/*
   ... and a structure for use in declaring CB row arrays,
   e.g IFF_CBITEM row[IFF_MAXCBATT] 

*/

typedef union iff_cbitem {
	int	i;			/* integer */
	float	r;			/* real */
	char	c[4];			/* string */
} IFF_CBITEM;
