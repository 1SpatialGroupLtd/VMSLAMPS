	LOGICAL FUNCTION EXTRACT()
C
CDEC$	IDENT	'21MY92'
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created 				ST	21-May-1992
C
C Description:
C
C       Routine to check device to see if the library given does exist and
C       then deal with each selected coverage in turn.
C
	IMPLICIT NONE
C
C Parameters
C
	INCLUDE 'DCW2IMSG.PAR'
C
C Common blocks
C
	INCLUDE 'TABLES.CMN'
	INCLUDE 'GENERAL.CMN'
	INCLUDE 'SELECTIONS.CMN'
C
C Functions
C
	LOGICAL		EXTRACT_COVER		! extract a coverage
	LOGICAL		FILE_EXISTS		! check for files
	INTEGER*4	LIB$SHOW_VM
C
C Local workspace
C
	INTEGER*4	I		     	! loopy
	CHARACTER*128	LIB_PATH		! working library path name
	INTEGER*4	LIB_PATHLEN	     	! length of the above
	CHARACTER*128	COV_PATH		! working coverage path name
	INTEGER*4	COV_PATHLEN	     	! length of the above
C
C ......................................................................
C
	EXTRACT = .TRUE.		! assume success
C
C Try opening top level of directory structure to see if the library
C given exists on this device
C
	IF (.NOT.FILE_EXISTS(DEVICENAM(1:DEVICELEN)//':[DCW]'//
     &	                     LIB_NAME(LIBRARY)(1:LIB_NAME_LEN(LIBRARY))//
     &	                     '.DIR')) THEN
	   CALL LSL_PUTMSG(DCW2I__NOSUCHLIB,
     &		           LIB_NAME(LIBRARY)(1:LIB_NAME_LEN(LIBRARY)))
	   CALL WRITEF
	   GOTO 999
	ENDIF
C
C Construct library path name
C
	LIB_PATHLEN = DEVICELEN + 6 + LIB_NAME_LEN(LIBRARY) + 1
	LIB_PATH(1:LIB_PATHLEN) = DEVICENAM(1:DEVICELEN)//
     &	                          ':[DCW.'//
     &	                          LIB_NAME(LIBRARY)(1:LIB_NAME_LEN(LIBRARY))//
     &	                          ']'
C
C Initialise various values
C
	CALL INIT_VALUES(%REF(ORIGIN(1)),
     &	                 %REF(ORIGIN(2)),
     &	                 %REF(TEXTGAP),
     &	                 %REF(HAD_ENA_VERB))
C
C Loop through list of selected coverages
C
	DO 50 I = 1,NUM_COV_SEL
C
C Check if coverage exists
C
	   IF (FILE_EXISTS(LIB_PATH(1:LIB_PATHLEN)//
     &		           COV_SEL(I)(1:2)//
     &		           '.DIR')) THEN
C
C Construct coverage name
C
	      COV_PATHLEN = LIB_PATHLEN - 1 + 1 + 2 + 1	     ! will optimize
	      COV_PATH(1:COV_PATHLEN) = LIB_PATH(1:LIB_PATHLEN-1)//'.'//
     &		                        COV_SEL(I)(1:2)//']'
C
C We have found a coverage that we selected so go and deal with it
C
	      COVSEL = I
	      IF (.NOT. EXTRACT_COVER(COV_PATH,COV_PATHLEN)) THEN
		 CALL LSL_ADDMSG(DCW2I__SKIPCOV,COV_SEL(I)(1:2))
	      ENDIF
C
C Free feature tables
C
	      IF (HAD_ENA_VERB) THEN
		 CALL WRITEF
		 CALL WRITEF('Freeing memory allocated to feature tables...')
C		 CALL LIB$SHOW_VM
	      ENDIF
	      CALL FREE_FEATURE_TABLES()
C	      IF (HAD_ENA_VERB) CALL LIB$SHOW_VM
C
	   ELSE
C
C Coverage does not exist
C
	      CALL LSL_PUTMSG(DCW2I__NOSUCHCOV,COV_SEL(I)(1:2),
     &		           LIB_NAME(LIBRARY)(1:LIB_NAME_LEN(LIBRARY)))
	   ENDIF
	   CALL WRITEF
50	CONTINUE
C
C Free Feature Code and Attribute Code tables
C
	IF (HAD_ENA_VERB) THEN
	   CALL WRITEF('Freeing memory allocated to '//
     &		       'feature/attribute code tables...')
C	   CALL LIB$SHOW_VM
	ENDIF
	CALL FREE_FC_TABLE
	CALL FREE_AC_TABLE
C	IF (HAD_ENA_VERB) CALL LIB$SHOW_VM
C
	CALL WRITEF
C
	GOTO 1000
C
C ......................................................................
C
999	EXTRACT = .FALSE.
1000	RETURN
	END
