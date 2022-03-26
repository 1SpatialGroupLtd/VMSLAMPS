#define FRTMAX 1000			/* max. no. of FCs */

extern struct frtcom_tag {
	int
			frtcnt,		/* count of defined FCs */
			frtind,		/* index of selected FCs */
			frtfc,		/* the selected FC */
			frtgt,		/* ... it's type */
			frtcol;		/* ... colour *

	float
			frtwid,		/* ... width */
			frtsiz;		/* ... size */

	int
			frtsc,		/* ... Secondary Code */
			frtflg;		/* ... flags word */

	int
			frthw,		/* symbol for hardware line */
			frthwl,		/* hardware line style */
			frtast,		/* fill area internal style */
			frtaix;		/* fill area style index */

	unsigned short 	frthws;		/* true if to use hardware symbol */

	short		frtint[FRTMAX][6];	/* integers */

	float		frtflt[FRTMAX][2];	/* floats (reals) */

	unsigned short
			frthks,		/* true if thick lines supressed */
			frtlin,		/* true if linear */
			frtarc,		/* true if symbol */
			frtcur,		/* true if circle arc */
			frtsym,		/* true if curve */
			frttex,		/* true if text */
			frtare;		/* true if fill area */
} frtcom;
