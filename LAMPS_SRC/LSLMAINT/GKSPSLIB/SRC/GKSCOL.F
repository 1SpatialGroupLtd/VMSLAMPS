	LOGICAL FUNCTION LSG_SET_LUT(WKID,FILENAME)
C
CDEC$	IDENT	'23FE91'
C
C	Copyright LaserScan Laboratories Ltd., Cambridge, England
C
C Author Clarke Brunt					17-Mar-1986
C
C To read a colour table file for VAXStation
C Table has same format as for Sigma ARGS just for compatibility
C See [LIB.VSLIB]RDSYSC.SRC
C All blink stuff is ignored (and need not be present)
C
C The system constants file has the following format...
C
C    <colour_number>     [; <comment>]
C                                                             N
C  { <red>   <green>   <blue>   [<blink>|;]      [<comment>] }
C
C where a line is in curly brackets ( { and } ) it is repeated the
C number of times given by the superscript. A parameter in square
C brackets ( [ and ] ) is optional.
C
C spaces and tabs are equivalent, and serve merely as field separators-
C they are otherwise ignored.
C
C N is equal to the <colour_number>
C
C Comment lines are preceded by a semi-colon, and may be interspersed
C at will.
C
	IMPLICIT NONE
C
C arguments
	INTEGER		WKID		! unused
	CHARACTER*(*)	FILENAME	! filename or logical name
C
	INCLUDE 'LSL$CMNLSL:LSLLIBMSG.PAR'
	INCLUDE 'HERE:GKSDAT1.CMN'
C
C functions used
	LOGICAL		FLROPN
	LOGICAL		FLRCLO
	INTEGER*4	FLRLIN
	LOGICAL		RDCHS
	LOGICAL		RDLONG
	LOGICAL		RDLHEX
	LOGICAL*4	LIB$GET_LUN
	LOGICAL*4	LIB$FREE_LUN
C
	LOGICAL*4	OK
	INTEGER*4	ERROR
	INTEGER		I			! count variable
	BYTE		CH			! character read
	INTEGER*4	CNUM			! number of colours
	INTEGER*4	LUN
	INTEGER		LINTYP			! type of line
	INTEGER		INDEX			! colour index
	INTEGER		CVAL			! colour value
	REAL		COL(3)
C
	LSG_SET_LUT = .FALSE.			! assume success
C
C get a LUN to read the file on
	OK = LIB$GET_LUN(LUN)
	IF (.NOT.OK) THEN		! failed
	   CALL LSL_PUTMSG(OK)
	   GOTO 10000
	ENDIF
C
C open up the file (just give up on error)
	OK = FLROPN(LUN,FILENAME)	! open file
	IF (.NOT.OK) THEN
	   LSG_SET_LUT = .TRUE.		! indicate file not found
	   GOTO 999
	ENDIF
C
	LINTYP = 1			! want number of colours
	INDEX = 0			! start with colour 0
C
50	OK =  FLRLIN(,,,ERROR) 	! read into TXTBUF
	IF (.NOT.OK) THEN
	   IF (OK.EQ.LSL__EOF) GOTO 998		! end of file
	   CALL LSL_PUTMSG(OK)
	   CALL LSL_ADDMSG(ERROR)
	   GOTO 999
	ENDIF
C
C we have a line - what is it ?
	CALL BSLN				! start of line
	IF (RDCHS(CH)) GOTO 50			! empty line
	IF (CH.EQ.';') GOTO 50			! comment line
	CALL BSCH
C
	GOTO (1000,2000) LINTYP
C
C the first line contains a single integer which says how many colours
C are being defined
1000	IF (RDLONG(CNUM) ) GOTO 998	! read the (decimal) number
	IF (CNUM.LE.0.OR.CNUM.GT.256) GOTO 998	! out of range
	LINTYP = LINTYP+1
	GOTO 50				! next line
C
C data lines are 3 hex numbers, specifying Red, Green, Blue values in
C the video transformation table, optionally followed by a 4th hex
C value defining the blink byte in the table (which is zero by default)
C
2000	CONTINUE
C
	DO 2010 I = 1,3
	   IF (RDLHEX(CVAL)) GOTO 998
	   IF (CVAL.LT.0.OR.CVAL.GT.255) GOTO 998
	   COL(I) = CVAL/255.0
2010	CONTINUE
	CALL GSCR(WKID,INDEX,COL(1),COL(2),COL(3))
C
	INDEX = INDEX+1		! next colour index
	IF (INDEX.LT.CNUM.AND.INDEX.LE.MAXCOL) GOTO 50
C
C Ignore blink generator stuff
998	OK = FLRCLO(LUN,ERROR)
	IF (.NOT.OK) THEN
	   CALL LSL_PUTMSG(OK)
	   CALL LSL_ADDMSG(ERROR)
	ENDIF
C
999	OK = LIB$FREE_LUN(LUN)	! free LUN
	IF (.NOT.OK) CALL LSL_PUTMSG(OK)
C
10000	RETURN
C
	END
