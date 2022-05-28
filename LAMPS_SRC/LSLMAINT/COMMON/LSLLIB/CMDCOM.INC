C
C Extensions to CMDCOM, the common block holding command arguments and 
C other control, for RDCOMM. This is a private, undocumented part of the
C common block, and is thus separate from the rest, which is available 
C to users.
C
C STARBF has been moved to a private common block, but XXXXXX remains
C as a place keeper to maintain shareable image compatibility
C
	BYTE		CMDNBF(80)	! buffer of command name string
	BYTE		SECNBF(80)	!	    2ndary command name
	BYTE		XXXXXX(80)	!	    place keeper
C
	BYTE		STARBF(256)	!	    string argument
C
	COMMON /LSL_CMDCOM/		CMDNBF,SECNBF,XXXXXX
	COMMON /LSL_CMDCOM_PRIVATE/	STARBF
