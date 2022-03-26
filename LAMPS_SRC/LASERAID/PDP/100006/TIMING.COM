C
	COMMON/TIMING/TIMGAP,TIMERR,TIMNUM,TIMTAB(3,1)
C
	INTEGER TIMGAP		! unit for timing
	INTEGER TIMERR		! error code
	INTEGER TIMNUM		! number of entries in table
	INTEGER TIMTAB		! table of entries
C
