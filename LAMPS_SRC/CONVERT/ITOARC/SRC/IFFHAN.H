extern struct iffhan_tag {
	int
		lpose,	/* current EOF word number (next free word) */
		lposr,	/* current reading position */
		lposw,	/* current writing position */
		lposh,	/* position of entry-in-hand (0 if none) */
		lposm,	/* position of marked entry (0 if none) */
		lposf,	/* position of start of current feature (0 if none) */
		iercd,	/* latest error code (0 if no error) */
		ierad,	/* locates latest call to IFF  error handler */
		iernm;	/* VMS numerical error code (for non-internal errors) */
	short
		iforel;
	unsigned short
		wateof;	/* is TRUE if writing at EOF */
	int
		irvlev,	/* current input revision level */
		orvlev;	/* current output revision level */
	} iffhan;
