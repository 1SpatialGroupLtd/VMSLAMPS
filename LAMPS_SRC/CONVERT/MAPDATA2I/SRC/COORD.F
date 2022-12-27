	SUBROUTINE COORD( X, Y, Z )
CDEC$	IDENT	'25JL94'
C
C Copyright (C) Laser-Scan Ltd, Cambridge, England
C
C	Created					JMC	12-Jan-1990
C	Mod					JB	11-Apr-1991
C
C	CONVERT MAPDATA2I Utility
C
C Description 
C
C Add coordinate points to the output list 
C
	IMPLICIT NONE
C
C arguments
C
	REAL*8		X	! X coordinate
	REAL*8		Y	! Y coordinate
	REAL*8		Z	! Z coordinate
C
C common blocks
C
	INCLUDE	'CMN:IFF.CMN'	
C
C local variables
C
	REAL*4	XNEW, YNEW ,ZNEW	! co-ords relative to new origin
C
C *********************************************************************
C do we have room for this point?
C
	IF ( ZSPTR.GE.200 ) CALL FLUSH
C
C subtract the origin offset
C
	XNEW = X*SCALE_FACTOR - XOFF
	YNEW = Y*SCALE_FACTOR - YOFF
	ZNEW = Z - ZOFF
C
C Use first coordinate to start off the range
C
	IF (.NOT.HAD_RANGE_SET) THEN
	   RANGE(X_MIN) = XNEW
	   RANGE(X_MAX) = XNEW
	   RANGE(Y_MIN) = YNEW
	   RANGE(Y_MAX) = YNEW
C
	   HAD_RANGE_SET = .TRUE.
	ENDIF
C
C so we can now add this new point to our output list
C
	ZSPTR = ZSPTR+1
C
	ZSBUF(1,ZSPTR) = XNEW
	ZSBUF(2,ZSPTR) = YNEW
	ZSBUF(3,ZSPTR) = ZNEW
C
C and check the range
C
	IF (XNEW.GT.RANGE(X_MAX)) THEN
	   RANGE(X_MAX) = XNEW
	ELSEIF (XNEW.LT.RANGE(X_MIN)) THEN
	   RANGE(X_MIN) = XNEW
	ENDIF
C
	IF (YNEW.GT.RANGE(Y_MAX)) THEN
	   RANGE(Y_MAX) = YNEW
	ELSEIF (YNEW.LT.RANGE(Y_MIN)) THEN
	   RANGE(Y_MIN) = YNEW
	ENDIF
C
C that's all
C
999	RETURN
	END
C
	SUBROUTINE 	FLUSH
CDEC$	IDENT	'25JL94'
C
C	Copyright (C)				Laser-Scan Ltd., Cambridge
C	Created			12-Jan-1990			J.M. Cadogan
C
C Description:
C
C	Flush the coordinate buffer
C
	IMPLICIT	NONE
C
C common blocks
C
	INCLUDE	'CMN:IFF.CMN'
C
C workspace
C
	INTEGER*2	IENDS
	INTEGER		I,J			! loop counters
C
C-------------------------------------------------------------------------------
C if the buffer is empty, then RETURN at once, doing nothing
C
	IF ( ZSPTR.LE.0 ) GOTO 999
C
C if we have not yet output the information that goes before the
C first ZS, output it now
C
	IF (.NOT.DONE_START_FEATURE) CALL START_FEATURE
C
C and work out whether we are drawing through the ZS break
C
	IF ( PEN_UP ) THEN
	   IENDS = 0		! pen up to the ZS
	ELSE
	   IENDS = 1		! pen down to the ZS
	ENDIF
C
C output any data we may have in our buffer
C
	CALL IFFZS( ZSBUF(1,1), ZSPTR, IENDS )
C
C set the continuity point
C
	ZSPTR = 0
C
C and signal that we've output a ZS for this feature
C
	DONE_ZS = .TRUE.
C
C assume that we will be drawing through the next ZS break
C
	PEN_UP = .FALSE.
C
999	RETURN
	END
C
	SUBROUTINE 	IFF_START
CDEC$	IDENT	'25JL94'
C
C	Copyright (C)			Laser-Scan Ltd., Cambridge
C	Created				12-Jun-1990	John Cadogan
C	Mod				11-Apr-1991	Jon Barber
C
C Description:
C
C	Write the start of the IFF file
C
	IMPLICIT NONE
C
C Common Blocks
	INCLUDE 'LSL$CMNIFF:IFFHAN.CMN'		! current position in IFF file
	INCLUDE 'LSL$CMNIFF:MHDEF.CMN'
	INCLUDE 'LSL$CMNIFF:MD2DES.CMN'
	INCLUDE	'LSL$CMNLSL:FILENAME.CMN'   	! LSLLIB file names
C
	INCLUDE 'CMN:FILE.CMN'
	INCLUDE 'CMN:IFF.CMN'			! IFF map data
	INCLUDE 'CMN:MAPDATA.CMN'		! MAPDATA map data
C
C Local Variables
	INTEGER		I,J,K		! DO loop/date variables
	CHARACTER*9	DAT		! date
	CHARACTER*8	TIM		! time
	BYTE		NEW_SECTION(42)	! for NS entry
C
	DATA CPS/0.0,1000.0,0.0,1000.0,0.0,0.0,0.0,0.0,
     &           1000.0,0.0,1000.0,0.0,1000.0,1000.0,1000.0,1000.0/
C
C-------------------------------------------------------------------------------
C Initialise FSN's
C
	FSN = 0
C
C Initialise our cubic coefficients array 
C
	DO 20 I = 1,10
	   DO 10 J = 1,2
	      CC(I,J) = 0.0
10	   CONTINUE
20	CONTINUE
C
C Set up the unit matrix for the cubic coefficients
C
	CC(2,1) = 1.0
	CC(3,2) = 1.0
C
C Leave the map header unset by default
C
	MHDESC(1) = 0
	MHDESC(2) = 0
	MHDESC(3) = 0
	MHDESC(4) = 0
C
C Set up a type 2 map descriptor
C
	SCALE = 200000
	XOFF = 0
	YOFF = 0
	ZOFF = 0
C
	MD2SCL = SCALE
	MATV2 = 2		! type 2 will be set
	MD2LOC(1) = XOFF
	MD2LOC(2) = YOFF
C
C Now assemble an NS entry
C
	CALL DATE( DAT )
	CALL TIME( TIM )
	CALL EXPAND('%WCreated by MAPDATA2I on %S at %S',NEW_SECTION,DAT,TIM)
C
C Assume that the range is something silly
C
	RANGE(X_MIN) =  XMIN - XOFF
	RANGE(X_MAX) =  XMAX - XOFF
	RANGE(Y_MIN) =  YMIN - YOFF
	RANGE(Y_MAX) =  YMAX - YOFF
C
C Now output all the stuff before the first feature
C
	LPOSRA = LPOSE			! remember where the RAnge is
	CALL IFFRA( RANGE )		! return & correct this later
	CALL IFFHI			! HI as new type IFF file
	CALL IFFMH( MHARR,MHLEN )	! output OS style map header
	CALL IFFMD( MD2ARR,MD2LEN )	! type 2 MD
	CALL IFFNS( NEW_SECTION, 42 )	! new section
	CALL IFFCC( CC )		! unit matrix cubic coefficients
	CALL IFFCP( CPS )		! sheet corners as corner pts
	LPOSNO = LPOSE			! remember where our NO is going
C
C Header data now written successfully
C
	DONE_START_MAP = .TRUE.
C
C Return
C
	RETURN
	END
C
	PROGRAM MAPDATA2I
CDEC$	IDENT	'25JL94'
C
C	Copyright (C)				Laser-Scan Ltd., Cambridge
C	Created					11-Jun-1990	John Cadogan
C	Mod					09-Apr-1991	Jon Barber
C
C Description:
C
C	Conversion for AA MAP format - AA ASCII format to IFF
C
	IMPLICIT	NONE
C
	INCLUDE 'LSL$CMNLSL:FILENAME.CMN'
	INCLUDE 'CMN:FILE.CMN'
C
	INTEGER		OBEY
	INTEGER		STATUS
C
C-------------------------------------------------------------------------------
C
	CALL LSL_INIT		! Initialise LSLLIB
C
	STATUS = OBEY()		! decode command line
	IF (.NOT.STATUS) GOTO 999
C
	CALL PROCESS		! do the conversion
C
999	CALL LSL_EXIT(STATUS)
	END
C
	INTEGER FUNCTION OBEY
CDEC$	IDENT	'25JL94'
C
C	Copyright (C)				Laser-Scan Ltd., Cambridge
C	Created					A.P.Brown 13-Nov-1989
C
C	Add /LOG and /MULTIPLY 			J Barber   5-Apr-1993
C       
C Description:
C
C	Read the CCG SIF AA file
C
	IMPLICIT	NONE
C
	INCLUDE	'LSL$CMNLSL:LSLLIBMSG.PAR'	! LSLLIB messages
	INCLUDE	'CMN:MAPDATA2IMSG.PAR'		! MAPDATA2I messages
C
C Common Blocks
C
	INCLUDE 'LSL$CMNLSL:CLD.CMN'	    	! LSLLIB command language
	INCLUDE	'LSL$CMNLSL:FILENAME.CMN'   	! LSLLIB file names
	INCLUDE	'CMN:FILE.CMN'      		! 
	INCLUDE	'CMN:IFF.CMN'      		! 
C
C External functions
C
	EXTERNAL	MAPDATA2I_CLD		! Command language definition
C
C Functions
C
	LOGICAL		DCL_STARTUP		! Command line read and parse
	LOGICAL		DCL_FILE		! Get file name
	LOGICAL		DCL_QUAL		! Get a qualifier 
	LOGICAL		DCL_INT			! Get an integer
C
	INTEGER		FLROPN			! Open MAPDATA file
	INTEGER		IFFCREATE		! Start IFF
	LOGICAL		RDPAR			! Read PAR file
C
C Local Variables
C
	INTEGER		STATUS			! Return error status
	LOGICAL		ABSENT			! Flag for absent params/quals
	LOGICAL		LOCAL
	LOGICAL		LOCNEG
C
C------------------------------------------------------------------------------
C Initialise
C
	HAD_LOG  = .FALSE.
	HAD_MULT = .FALSE.
	HAD_PAR  = .FALSE.
	HAD_FRT  = .FALSE.
C
C Read and parse the command line
C
	STATUS = DCL_STARTUP( 'MAPDATA2I',.FALSE.,MAPDATA2I_CLD,.TRUE. )
	IF (.NOT.STATUS) GOTO 999
C
C Get the MAPDATA input filename (P1) 
C
	STATUS = DCL_FILE( 'MAPDATA_FILESPEC','LSL$MAPDATA:MAPDATA.MAP',
     &					ABSENT,.FALSE.,.TRUE. )
	IF (.NOT.STATUS) GOTO 999
C
C Store MAPDATA file length and name
C
	MAPDATALEN  = FIL_LEN(1)
	MAPDATAFILE = FILARY(1)(1:MAPDATALEN)
C
C Get the IFF output filename (P2)
C
	STATUS = DCL_FILE( 'IFF_FILESPEC','LSL$IF:IFF.IFF',
     &					ABSENT,.FALSE.,.TRUE. )
	IF ( .NOT.STATUS ) GOTO 999
C
C Store IFF file length and name
C
	IFFLEN  = FIL_LEN(1)
	IFFFILE = FILARY(1)(1:IFFLEN)
C
C Get FRT file
C
	STATUS = DCL_QUAL('FRT', HAD_FRT, LOCAL, LOCNEG, .TRUE.)
	IF (.NOT.STATUS) GOTO 999
C
	IF (HAD_FRT) THEN
	   STATUS = DCL_FILE('FRT','LSL$FRT:MAPDATA.FRT',
     &					ABSENT,.FALSE.,.TRUE.)
	   IF (.NOT.STATUS) GOTO 999
C
	   FRTLEN  = FIL_LEN(1)
	   FRTFILE = FILARY(1)(1:FRTLEN)
	ENDIF
C
C Get PAR file
C
	STATUS = DCL_QUAL('PARAMETER_FILE', HAD_PAR, LOCAL, LOCNEG, .TRUE.)
	IF (.NOT.STATUS) GOTO 999
C
	IF (HAD_PAR) THEN
	   STATUS = DCL_FILE('PARAMETER_FILE','LSL$LOOKUP:MAPDATA.PAR',
     &					ABSENT,.FALSE.,.TRUE.)
	   IF (.NOT.STATUS) GOTO 999
C
	   PARLEN  = FIL_LEN(1)
	   PARFILE = FILARY(1)(1:PARLEN)
	ENDIF
C
C Get LOG
C
	STATUS = DCL_QUAL('LOG', HAD_LOG, LOCAL, LOCNEG, .TRUE.)
	IF (.NOT.STATUS) GOTO 999
C
C Get MULTIPLY
C
	SCALE_FACTOR = 1
C
	STATUS = DCL_QUAL('MULTIPLY', HAD_MULT, LOCAL, LOCNEG, .TRUE.)
	IF (.NOT.STATUS) GOTO 999
C
	IF (HAD_MULT) THEN
	   STATUS= DCL_INT ('MULTIPLY', .TRUE.)
           IF (.NOT.STATUS) GOTO 999
C
	   MULTIPLY = IARRAY(1)
	   SCALE_FACTOR = MULTIPLY
        ENDIF
C
C Open input MAPDATA file
C
	STATUS = FLROPN(MAPDATALUN,MAPDATAFILE(1:MAPDATALEN))
	IF (.NOT.STATUS) THEN
	   CALL LSL_PUTMSG(MD2I__UNAOPN,MAPDATAFILE(1:MAPDATALEN))
	   CALL LSL_PUTMSG(STATUS)
	   GOTO 999
	ENDIF
C
C Open, read and close PAR file and FRT file (required for PAR file)
C
	IF (HAD_PAR) THEN
	   STATUS = RDPAR()
	   IF (.NOT.STATUS) GOTO 999
	ENDIF
C
C Open IFF file
C
	STATUS = IFFCREATE(IFFLUN,IFFFILE(1:IFFLEN))
	IF (.NOT.STATUS) THEN
	   CALL LSL_PUTMSG(MD2I__UNACREIFF,IFFFILE(1:IFFLEN))
	   CALL LSL_PUTMSG(STATUS)
	   GOTO 999
	ENDIF
C
C All done
C
999	OBEY = STATUS				! Return status to caller
C
	RETURN
	END
C
	SUBROUTINE 	PROCESS
CDEC$	IDENT	'25JL94'
C
C	Copyright (C)				Laser-Scan Ltd., Cambridge
C	Created					11-Jun-1990	John Cadogan
C	Mod					09-Apr-1991	Jon Barber
C
C Description:
C
C	Process the MAPDATA file
C
	IMPLICIT NONE
C
	INCLUDE 'LSL$CMNIFF:IFFHAN.CMN'	! current position in IFF file
C
	INCLUDE 'LSL$CMNLSL:TXTC.CMN'		! LSLLIB text buffer
	INCLUDE 'LSL$CMNLSL:READSTR.PAR'
	INCLUDE	'LSL$CMNLSL:FILENAME.CMN'   	! LSLLIB file names
C
	INCLUDE	'LSL$CMNLSL:LSLLIBMSG.PAR'	! LSLLIB messages
	INCLUDE	'CMN:MAPDATA2IMSG.PAR'		! MAPDATA2I messages
C
	INCLUDE 'CMN:MAPDATA.CMN'
	INCLUDE 'CMN:FILE.CMN'
	INCLUDE 'CMN:IFF.CMN'
C
	INTEGER		EOLN
	INTEGER		STATUS
	INTEGER*2	IECODE		! IFF entry type
	INTEGER*2	IELEN		! IFF entry length
C
	LOGICAL		FLRLIN
	LOGICAL		FLRCLO
	LOGICAL		READSTR
	LOGICAL		RDCHS
	LOGICAL		RDCH
	LOGICAL		RDINT
	LOGICAL		RDLONG
	LOGICAL		RDREAL
	LOGICAL		RDDBLE
C
	INTEGER		LEN
	INTEGER*2	ACLEN
	INTEGER		I
	BYTE		ICH
	BYTE		ACBYTE(80)
	BYTE		STAR
C
	INTEGER*2	FC_PART1
	INTEGER*2	FC_PART2
	INTEGER*2	OLDLAYER
	INTEGER*2	LAYER
C
	INTEGER		XYVAL
	REAL*8		X,Y,Z
	LOGICAL		FIRST_FEATURE
	LOGICAL		HAD_H_OR_L
	LOGICAL		HAD_AC
C
	BYTE		CHARBYTE
	INTEGER*4	CHARINT
	EQUIVALENCE	(CHARINT,CHARBYTE)
C
C Record types
C
	CHARACTER*7	RECTYPE
	CHARACTER*7	SEGMENT
	CHARACTER*4	CODE
	CHARACTER*1	CHARVAL
	CHARACTER*1	CHARNUM
	CHARACTER*80	ACTEXT
	CHARACTER*32	ACODE
C
C------------------------------------------------------------------------------
C
	text_ac = 1001
	curve_ac = 1002
	priority_ac = 1003
C
	FIRST_FEATURE = .TRUE.
	HAD_RANGE_SET = .FALSE.
	HAD_H_OR_L    = .FALSE.
C
	SEGMENT = 'SEGMENT'
	CODE    = 'CODE'
C
C Read and discard the first two header lines
C
	CALL FLRSEL(MAPDATALUN)
C
	RECNUM = 0
	STATUS = FLRLIN()
	RECNUM = RECNUM + 1
	STATUS = FLRLIN()
	RECNUM = RECNUM + 1
	STAR   = '*'
C
C Read the range record
C
	CALL SET_TXTLIM(80)
	STATUS = FLRLIN()
	RECNUM = RECNUM + 1
C
	CALL BSLN
	STATUS = RDREAL(XMAX)
	STATUS = RDREAL(YMAX)
	XMIN = XMAX
	YMIN = YMAX
C
	CALL IFF_START			! Write start of IFF file
C
	IF (HAD_PAR) CALL IFFNO(1,0,0)	! start new single layer
C	
C Now read the data for real
C
	CALL SET_TXTLIM(80)
C
C Read next line
C
500	STATUS = FLRLIN()
	RECNUM = RECNUM + 1
	IF (STATUS .EQ. LSL__EOF) THEN
	   STATUS = LSL__NORMAL			! not an error
	   GOTO 999
	ENDIF
C
501	CALL BSLN
	HAD_H_OR_L = .FALSE.
	LEN = READSTR(RECTYPE,,ON_SPACE)
C	CALL WRITEF( 'Record #%^L%I0 is type %S',RECNUM,RECTYPE(1:LEN) )
C
C SEGMENT command
C
	IF ( RECTYPE(1:LEN) .EQ. SEGMENT) THEN
	   STATUS = RDINT(FSN)
C	   CALL WRITEF( 'FSN #%^W%I0', FSN)
C
	   ZSPTR = 0
	   PEN_UP  = .TRUE.
	   DONE_ZS = .FALSE.
	   HAD_AC  = .FALSE.
	   IS_SYMBOL = .FALSE.
	   DONE_START_FEATURE = .FALSE.
C
	   STATUS = RDCHS(ICH)
	   IF (STATUS) GOTO 500		! no char found
C
	   IF (ICH.NE.'*') GOTO 500	! no '*' found
C
C Found first '*', get second
C
	   STATUS = RDCHS(ICH)
	   IF (STATUS) GOTO 500		! no char found
C
	   IF (ICH.NE.'*') GOTO 500	! no '*' found
C
C Found second '*', get text string for AC
C
	   STATUS = RDCHS(ICH)
	   IF (STATUS) GOTO 500		! no char found
C
	   IF (ICH.EQ.'*') GOTO 500	! '*' found, no text present
C
C Get text string
C
	   CALL BSCH
	   LEN = READSTR(ACTEXT,STAR,ON_CHAR) - 2
	   ACLEN = LEN
C
C Prevent an integer overflow by first assigning the result of ICHAR to a
C 4 byte int since this can be negative for composite characters and use an
C equivalenced byte when copying the character to the ACBYTE array.
C
	   DO 11 I = 1,LEN
	      CHARINT = ICHAR(ACTEXT(I:I))
	      ACBYTE(I) = CHARBYTE
11	   CONTINUE
	   HAD_AC = .TRUE.
C
	   GOTO 500
C
C CODE command
C
	ELSEIF( RECTYPE(1:LEN) .EQ. CODE) THEN
C
C Store line number of code
C
	   CODENUM = RECNUM
C
C Get first part of real MAPDATA FC
C
	   IF (HAD_PAR) THEN
	      DEFAULT_FC = .FALSE.
	      LEN = READSTR(ACODE,,ON_SPACE)
C
	      DO 99 I = 1,FC_CNT
		 IF (ACODE(1:LEN).EQ.MAPDATA_CODE(I)(1:MAPDATA_LEN(I)) ) THEN
		    FC = IFF_FC(I)
		    GOTO 500
		 ENDIF
99	      CONTINUE
C
C No FC matching found, use default of 0
C
	      if (had_log) CALL LSL_PUTMSG
     &			(MD2I__FCDEFAULT,ACODE(1:LEN),CODENUM)
C
C Set default FC flag to set depending on no. of coords found later
C
	      DEFAULT_FC = .TRUE.
	      GOTO 500
	   ELSE
C
C read 1st digit - first part of FC ** SHOULD BE RDCHS? **
C
	      STATUS = RDCH(ICH)
	      STATUS = RDCH(ICH)
	      CHARNUM = CHAR(ICH)
	      READ(CHARNUM,*) FC_PART1
C	      CALL WRITEF( 'FC_PART1 #%^W%I0',FC_PART1 )
C
C read 2nd digit - layer number
C
	      STATUS = RDCH(ICH)
	      CHARNUM = CHAR(ICH)
	      READ(CHARNUM,*) LAYER
	      IF (FIRST_FEATURE) THEN
	         CALL IFFNO(LAYER,0,0)		! start new layer
	         OLDLAYER = LAYER
C	         CALL WRITEF( 'LAYER #%^W%I0',LAYER )
	      ENDIF   
C
	      IF (OLDLAYER.NE.LAYER) THEN
	         CALL IFFUNO(LPOSNO)		! update NO/EO pointer
	         CALL IFFEO			! end the layer
C
	         LPOSNO = LPOSE
	         CALL IFFNO(LAYER,0,0)		! start new layer
	         OLDLAYER = LAYER
C	         CALL WRITEF( 'LAYER #%^W%I0',LAYER )
	      ENDIF
C
C read 3rd digit - skip the point
C
	      STATUS = RDCH(ICH)
C
C read last two digits as a number - second part of FC
C
	      STATUS = RDINT(FC_PART2)
C
	      FC = (FC_PART1*1000) + FC_PART2
C	      CALL WRITEF( 'FC_PART2 #%^W%I0',FC_PART2 )
C
	      IF (FIRST_FEATURE) FIRST_FEATURE = .FALSE.
C
	      GOTO 500
	   ENDIF
C
C Read block of coords.
C
	ELSE
	   CALL BSLN
	   STATUS = RDDBLE(X)
	   IF (STATUS) THEN				! no coord
	      CALL LSL_PUTMSG(MD2I__NOCOORD,RECNUM)
	      GOTO 501					! go back and re-read
	   ENDIF
C
C Set ISQ to 0 to count ISN and start feature
C
	   ISQ = 0
	   CALL IFFNF(FSN, ISQ)
C
	   STATUS = RDDBLE(Y)
	   STATUS = RDDBLE(Z)
C	   CALL WRITEF( 'Coordinate (%F10.1,%F10.1,%F10.1)',X,Y,Z )
	   CALL COORD( X,Y,Z )
C
	   STATUS = FLRLIN()
	   RECNUM = RECNUM + 1
	   IF ( STATUS .EQ. LSL__EOF ) THEN
	      STATUS = LSL__NORMAL
C
C Output any points remaining unflushed
C
	      IF (ZSPTR.GT.0) CALL FLUSH
	      CALL IFFEF
	      GOTO 999
	   ENDIF
C
C Try to read second line as coord 
C
	   CALL BSLN
	   STATUS = RDDBLE(X)
C
	   IF (STATUS) THEN		! not a second coord - Symbol
	      IS_SYMBOL = .TRUE.
	      IF (DEFAULT_FC) FC = 999
	   ELSE
	      IS_SYMBOL = .FALSE.
	      IF (DEFAULT_FC) FC = 0
	   ENDIF
C
	   CALL START_FEATURE
	   I = ACLEN
	   IF (HAD_AC) CALL IFFAC(TEXT_AC,0,ACBYTE,ACLEN)
C
	   IF (STATUS) THEN		! not a second coord
C
C Output any points remaining unflushed
C
	      IF (ZSPTR.GT.0) CALL FLUSH
	      CALL IFFEF
	      GOTO 501			! go back and re-read the line
	   ENDIF
C
C Was a second coord line, continue reading y,z
C
	   STATUS = RDDBLE(Y)
	   STATUS = RDDBLE(Z)
C	   CALL WRITEF( 'Coordinate (%F10.1,%F10.1,%F10.1)',X,Y,Z )
	   CALL COORD( X,Y,Z )
C
C Cycle round further coord lines
C
20	   STATUS = FLRLIN()
	   RECNUM = RECNUM + 1
	   IF (STATUS .EQ. LSL__EOF) THEN
	      STATUS = LSL__NORMAL
C
C Output any points remaining unflushed
C
	      IF (ZSPTR.GT.0) CALL FLUSH
	      CALL IFFEF
	      GOTO 999
	   ENDIF
C
	   CALL BSLN
	   STATUS = RDDBLE(X)
	   IF (STATUS) THEN		! not a coord
C
C Output any points remaining unflushed
C
	      IF (ZSPTR.GT.0) CALL FLUSH
C	      CALL IFFEF
	      GOTO 501			! go back and re-read the line
	   ENDIF
C
C Was a second coord line, continue reading y,z
C
	   STATUS = RDDBLE(Y)
	   STATUS = RDDBLE(Z)
C	   CALL WRITEF( 'Coordinate (%F10.1,%F10.1,%F10.1)',X,Y,Z )
	   CALL COORD( X,Y,Z )
C
	   GOTO 20
	ENDIF
C
C
C	   IF (.NOT.HAD_H_OR_L) THEN
C	      STATUS = RDCHS(ICH)
C	      EOLN = RDCHS(ICH)
C	      IF (.NOT.EOLN) THEN
C		 CHARVAL = CHAR(ICH)
C		 IF (CHARVAL.NE.'C') THEN
C		    CALL IFFAC(2,1)
C		    HAD_H_OR_L = .TRUE.
C		 ELSE
C		    STATUS = RDCHS(ICH)
C	            EOLN = RDCHS(ICH)
C		    IF (.NOT.EOLN) THEN
C		       CALL IFFAC(2,1)
C		       HAD_H_OR_L = .TRUE.
C		    ENDIF
C		 ENDIF
C	      ENDIF
C	   ENDIF
C
C
C Tidy up
C
999	CONTINUE
C
C Finish off the IFF file
C
	CALL IFFUNO(LPOSNO)		! update NO/EO pointer
	CALL IFFEO			! end the layer
	CALL IFFEM			! end the map
	CALL IFFEJ			! end the 'job'
C
C Now go back and set the RA entry
C
	CALL IFFPKE( IECODE, IELEN, LPOSRA )
	CALL EIHWR( RANGE, 4, 1 )
C
	CALL IFFCLO(IFFLUN)
C
C and close the MAPDATA file
C
	STATUS = FLRCLO(MAPDATALUN)
C
	RETURN
	END
C
	LOGICAL FUNCTION RDPAR
CDEC$	IDENT	'25JL94'
C
C	Copyright Laser-Scan Ltd., Cambridge, England.
C
C	Author:	 Jon Barber				21-Mar-1991
C	Ripped off from DSTPARLIB
C
C	CONVERT MAPDATA2I Utility - to read parameter file 
C
C Description
C
C	This function reads the parameter file which relates MAPDATA
C	feature codes (and optional curved line flags) to IFF 
C	feature codes
C
	IMPLICIT NONE
C
C Included Parameter Files
C
	INCLUDE 'LSL$CMNLSL:LSLLIBMSG.PAR'	! LSLLIB message definitions
	INCLUDE 'LSL$CMNLSL:READSTR.PAR'	! LSLLIB READSTR definitions
	INCLUDE 'CMN:MAPDATA2IMSG.PAR'		! MAPDATA2I messages
C
C Common Blocks
C
	INCLUDE 'CMN:FILE.CMN'
C
C Local Parameters
C
	BYTE		PLING			! comment delimiter
	PARAMETER	(PLING = '!')
C
C Functions called
C
	INTEGER*4	FLROPN		! open file
	INTEGER*4	FLRCLO		! close file
	INTEGER*4	FLRLIN		! read in a line from file
	INTEGER		READSTR
	LOGICAL		RDCHS		! read next character
	LOGICAL		RDINT		! read next integer
	LOGICAL		RDLONG		! read next integer
	LOGICAL		FRTINI		! open FRT file
C
C Local Variables
C
	INTEGER		LEN
	INTEGER*4	RESULT		! command read result
	INTEGER*4	RETCOD		! system error code
	BYTE		SINGCHAR	! character read
	INTEGER		LINE		! line number
	INTEGER*2	FCODE		! FC
	CHARACTER*32	ACODE
	LOGICAL		OK
C
C---------------------------------------------------------------------
C Initialise FRT file for the GT's of the FC's in the parameter file
C
	OK = FRTINI(FRTFILE(1:FRTLEN))
	IF (OK) THEN
	   CALL LSL_PUTMSG(MD2I__ERROPNFRT, FRTFILE(1:FRTLEN))
	   RDPAR = MD2I__ERROPNFRT
	   GOTO 999
	ENDIF
C
C	IF (HAD_LOG) CALL LSL_PUTMSG(MD2I__OPNFRT,FRTFILE(1:FRTLEN))
C
C Open PARAMETER file, read only
C
	RDPAR = FLROPN(PARLUN,PARFILE(1:PARLEN),RETCOD)
C
C If unsuccessful, output message and leave
C
	IF (.NOT.RDPAR) THEN
	   CALL LSL_PUTMSG(MD2I__ERROPNPAR,PARFILE(1:PARLEN))
	   RDPAR = MD2I__ERROPNPAR
	   GOTO 999
	ENDIF
C
C	IF (HAD_LOG) CALL LSL_PUTMSG(DSTPAR__OPNPAR,PARFIL(1:PARLEN))
C
	LINE = 0
	FC_CNT = 0
C
C Get a line
C
8000	CONTINUE
	LINE = LINE + 1
C
	RDPAR = FLRLIN(,,,RETCOD)
C
	IF (RDPAR.EQ.LSL__EOF) THEN
	   RDPAR = LSL__NORMAL		! not an error
	   GOTO 9998
	ENDIF
C
C If unsuccessful, output message, and leave
C
	IF (.NOT.RDPAR) THEN
	   CALL LSL_PUTMSG(MD2I__ERRRDPAR,LINE)
	   CALL LSL_ADDMSG(RDPAR)
	   GOTO 9998
	ENDIF
C
C Now reset the decoding pointer to the start of the line
C
	CALL BSLN
C
C Check for a comment delimiter - ignore an empty line
C
	IF (RDCHS(SINGCHAR)) GOTO 8000
	IF (SINGCHAR.EQ.PLING) THEN
	   GOTO 8000			! ignore line
	ELSE
	   CALL BSCH			! unread non-pling
	ENDIF
C
C Read MAPDATA code
C
	LEN = READSTR(ACODE,,ON_SPACE)
C
	OK = RDINT(FCODE)
	IF (OK .OR. FCODE.LT.0) THEN
	   CALL LSL_PUTMSG(MD2I__ERRRDPAR, LINE)
	   GOTO 8000
	ENDIF
C
C Get 'C' if present
C
C	OK = RDCHS(SINGCHAR)
C
C If char found, check for 'c' OR 'C'
C
C	IF (.NOT.OK .AND. SINGCHAR.NE.'C' .AND. SINGCHAR.NE.'c') THEN
C	   CALL LSL_PUTMSG(MD2I__ERRRDPAR, LINE)
C	   GOTO 8000
C	ENDIF
C
C C found for curved line
C
	FC_CNT = FC_CNT + 1
C
	MAPDATA_LEN(FC_CNT)  = LEN
	MAPDATA_CODE(FC_CNT) = ACODE(1:LEN)
	IFF_FC(FC_CNT)  = FCODE
C
C	IF (OK) THEN			! no char found
C	   HAD_C(FC_CNT) = .FALSE.
C	ELSE				! found 'c' or 'C'
C	   HAD_C(FC_CNT) = .TRUE.
C	ENDIF
C
	GOTO 8000
C
C Close the PARAMETER file
C
9998	CONTINUE
C
	IF (FC_CNT.LE.0) THEN
	   CALL LSL_PUTMSG(MD2I__NOPARFC)
	   RDPAR = MD2I__NOPARFC
	   GOTO 1000
	ENDIF
C
C report statistics
C
C	IF (HAD_LOG) THEN
C	   CALL LSL_PUTMSG(MD2I__FCFND,FC_CNT)
C	ENDIF
C
1000	CALL FLRCLO(PARLUN,RETCOD)
C
999	RETURN
	END
C
	SUBROUTINE	START_FEATURE
CDEC$	IDENT	'25JL94'
C
C	Copyright (C)			Laser-Scan Ltd., Cambridge
C	Created				9-Nov-1989	A.P.Brown
C	Mod				9-Apr-1991	J Barber
C
C Description:
C
C	Start a new feature.
C
C	MAPDATA2I:
C 	This routine is called by MAPDATA2I before all the coords have been
C	read, so the default of 0 may give a line FC for a one point symbol
C
C
	IMPLICIT	NONE
C
C parameter files
C
	INCLUDE	'LSL$CMNFRT:FRTCOM.CMN'	! FRT definitions
C
C common blocks
C
	INCLUDE 'CMN:MAPDATA2IMSG.PAR'
	INCLUDE 'CMN:FILE.CMN'
	INCLUDE 'CMN:IFF.CMN'
C
C functions
	LOGICAL		FRTFND
C
C workspace
C
	INTEGER*2	ISTAT(4)	! for the FS entry
	LOGICAL		OK
C
	DATA	HEIGHT  / 6 /		! Fixed pointsize
C
C-------------------------------------------------------------------------------
C calculate all the bits of the FS entry
C
	ISTAT(1) = FC
C
	ISTAT(2) = 0
	ISTAT(3) = 0
C
C MAPDATA2I feature codes are linear by default, unles the parameter file 
C specifies a symbol FC for single coordinate entries
C AAGAZ2IFF feature codes are always texts and IS_TEXT .TRUE.
C
C Check FRT file for supplied FC's to get GT 
C
	IF (HAD_PAR) THEN
	   IF (DEFAULT_FC) THEN
	      IF (IS_SYMBOL .OR. IS_TEXT) THEN
	         FC = 999
	      ELSE
	         FC = 0
	      ENDIF
	   ENDIF
C
	   OK = FRTFND(FC,.FALSE.)
	   IF (OK) THEN				! FC not found
	      CALL LSL_PUTMSG(MD2I__ERRFNDFC, FC)
	      GOTO 99
	   ENDIF
C
	   IF (IS_SYMBOL) THEN
	      IF (FRTGT.NE.UNOTYP .AND. FRTGT.NE.ORITYP .AND.
     &	          FRTGT.NE.SCATYP .AND. HAD_LOG) CALL LSL_PUTMSG
     &				(MD2I__NOTSYMBFTR,FC,CODENUM)
C
	   ELSEIF (IS_TEXT) THEN
	      IF (FRTGT.NE.TEXTYP .AND. HAD_LOG) CALL LSL_PUTMSG
     &				(MD2I__NOTTEXTFTR,FC,CODENUM)
C
	   ELSE
	      IF (FRTGT.NE.LINTYP .AND. FRTGT.NE.CURTYP .AND.
     &	          FRTGT.NE.STRTYP .AND. FRTGT.NE.ARETYP .AND. 
     &			HAD_LOG) CALL LSL_PUTMSG
     &				(MD2I__NOTLINEFTR,FC,CODENUM)
	   ENDIF
	ENDIF
C
C for texts (set in AAGAZ2IFF), assume we have the digitised position
C
99	IF (IS_TEXT) THEN
	   CALL LIB$INSV( JUSTIF,   0, 4, ISTAT(3) )
	   CALL LIB$INSV( STYLE,    4, 2, ISTAT(3) )
	   CALL LIB$INSV( CATEGORY, 6, 6, ISTAT(3) )
	   ISTAT(3) = ISTAT(3).OR.'8000'X   ! bits 14-15 = 2 (text)
	ELSEIF ( IS_SYMBOL ) THEN
	   ISTAT(3) = ISTAT(3).OR.'4000'X   ! bits 14-15 = 1 (symbol)
	ENDIF
C
C so write the FS entry
C
	CALL IFFFS( ISTAT )
C
C Write a fixed Text Height (pointsize 6)
C
 	IF (IS_TEXT) CALL IFFTH(HEIGHT)
C
C signal pen up for the first ST
C
	PEN_UP = .TRUE.
C
C and we haven't output any ZS/ST's for this feature yet
C
	DONE_ZS = .FALSE.
C
C so we've finished START_FEATURE
C
	DONE_START_FEATURE = .TRUE.
C
C and that's it
C
	RETURN
	END
C
