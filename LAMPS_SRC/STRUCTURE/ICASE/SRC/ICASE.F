	PROGRAM ICASE
C
CDEC$	IDENT	'12SE91'
C
C
C	Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C	Created					ST	25-Sep-1991
C
C Description
C       Main program ICASE which is kept simple and calls routines which
C       decode the command line, opens files, reads the parameter file and
C       calls the main routine which processes the IFF file.
C
	IMPLICIT NONE
C
	INCLUDE 'LSL$ICASE:ICASE.CMN'
	INCLUDE 'LSL$CMNIFF:IFFHAN.CMN'
C
C Functions called
C
	LOGICAL		GET_COMMAND	! get and decode command line
	LOGICAL		OPEN_FILES	! open in,out file
	LOGICAL		RDPAR		! open and read parameter file
	LOGICAL		FIRST_PASS	! perform initial pass of IFF file
	LOGICAL		SCAN_IFF	! scan IFF file node structure
	LOGICAL		CLOSE_FILES	! close any open files
C
	INTEGER*4	STATUS
C
C------------------------------------------------------------------------------
C
C Initialise libraries
C
	CALL LSL_INIT(.TRUE.)
C
C Get and decode the command line
C
	STATUS = GET_COMMAND()
	IF (.NOT.STATUS) GOTO 999
C
C Open input, output annd FRT files
C
	STATUS = OPEN_FILES()
	IF (.NOT.STATUS) GOTO 800
C
C Read in a check parameter file
C
	STATUS = RDPAR()
	IF (.NOT.STATUS) GOTO 800
C
C Perform initial pass of IFF file
C
	STATUS = FIRST_PASS()
	IF (.NOT.STATUS) GOTO 800
C
C Main routine which processes IFF file
C
	STATUS = SCAN_IFF()
	IF (.NOT.STATUS) GOTO 800
C
C Close any open files
C
800	IF (STATUS) CALL WRITEF('Operation successful.')
	STATUS = CLOSE_FILES()
	IF (.NOT.STATUS) GOTO 999
C

C
C Set the return status and finish up
C
999	CALL LSL_EXIT()
	END
