	PROGRAM I2SXF
C
CDEC$	IDENT	'12JL90'
C
C	Copyright Laser-Scan Ltd., Cambridge, England.
C
C	Created					RJH	09-May-1990
C
C	CONVERT I2SXF Utility - Main Program
C
C Description
C
C	IFF to SXF Conversion
C
	IMPLICIT NONE
C
C Included Parameter Files
C
	INCLUDE 'LSL$CMNI2SXF:I2SXFMSG.PAR'	! message definitions
C
C Common Blocks
C
 	INCLUDE 'LSL$CMNLSL:LSLLIBMSG.PAR'	! LSLLIB message def.
 	INCLUDE 'LSL$CMNLSL:FILENAME.CMN'	! LSLLIB filename parse
	INCLUDE 'LSL$CMNLSL:EXPC.CMN'		! LSLLIB output common
	INCLUDE 'LSL$CMNI2SXF:COMMANDS.CMN'	! command line things
C
C Functions called
C
	LOGICAL		GET_COMMAND	! get and decode command line
	LOGICAL		RDPAR		! read parameter file
	LOGICAL		FRTINI		! read FRT file
	INTEGER*4	IFFOPEN		! open IFF file
	INTEGER*4	FLWOPN		! open SXF file
	INTEGER*4	FLWCLO		! close SXF file
	INTEGER*4	PROCESS		! main loop of program
	LOGICAL		CLOSE_IFF	! close IFF file
C
C Local varables
C
	INTEGER*4	ILEVEL		! input revision level
	INTEGER*4	OK		! SXF file status
	INTEGER*4	IERR		! SXF file status
	INTEGER*4	ALQ		! SXF file size
C
C Initialise LSL libraries
C
	CALL LSL_INIT(.TRUE.)
	ILEVEL = 1			! input revision level
C
C Get and decode the command line
C
	IF (GET_COMMAND()) THEN
	   CALL REPORT
C
C Now for the FRT if it was requested
C
	   IF (HAD_FRT) THEN
	      IF (FRTINI(FRTFIL(1:FRTLEN))) THEN
	         CALL LSL_PUTMSG(I2SXF__ERRRDFRT,FRTFIL(1:FRTLEN))
	         GOTO 9000
	      ENDIF
C
C otherwise set up the standard ACD definitions
C
	   ELSE
	      CALL FRT_ACDINI
	   ENDIF
C
C Read the code table
C
	   IF (RDPAR()) THEN
C
C Open IFF file and SXF file
C
	      IF (IFFOPEN(IFFLUN,IFFFIL(:IFFLEN),,HAD_LOG)) THEN
C
C Set input revision level 1
C
 	      CALL IFFIRV(ILEVEL)

C Open SXF file
C
	      OK = FLWOPN(SXFLUN,SXFFIL(:SXFLEN),IERR,ALQ)
	      IF(OK .NE. LSL__NORMAL) THEN
		 CALL LSL_PUTMSG(I2SXF__ERRSXFOPN,SXFFIL(:SXFLEN),IERR)
                 GO TO 9000
              ENDIF
C
C Process the IFF file
C
	         OK = PROCESS()
		 IF (OK .NE. LSL__NORMAL) THEN
C.. ??		     GO TO 9000
		 ENDIF
C
C Close IFF file and SXF file
C
	         CALL CLOSE_IFF
C
C Close SXF file
		 IF(FLWCLO(SXFLUN)) THEN
		   IF (HAD_LOG) CALL LSL_PUTMSG(I2SXF__SXFCLOSED)
                   GO TO 9000
		 ENDIF
	      ENDIF
	   ENDIF
	ENDIF
C
C Set the return status and finish up
C
9000	CALL LSL_EXIT
	END
