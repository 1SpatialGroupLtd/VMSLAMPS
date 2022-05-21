C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1990-03-01 18:35:18.000000000 +0000
C *
C * This program is free software: you can redistribute it and/or modify
C * it under the terms of the GNU General Public License as published by
C * the Free Software Foundation, version 3.
C *
C * This program is distributed in the hope that it will be useful, but
C * WITHOUT ANY WARRANTY; without even the implied warranty of
C * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
C * General Public License for more details.
C *
C * You should have received a copy of the GNU General Public License
C * along with this program. If not, see http://www.gnu.org/licenses/.
C
	PROGRAM SIF_PARGEN
C
CDEC$	IDENT	'23FE90'
C
C	Copyright Laser-Scan Ltd., Cambridge, England.
C
C	Created					JMC	1-Mar-1990
C
C	CONVERT SIF2IFF Utility - Generates a parameter file
C
C Description
C
C	This function Generates a parameter file
C
	IMPLICIT NONE
C
C Included Parameter Files
C
	INCLUDE 'CMN:SIF2IFFMSG.PAR'	    ! message definitions
	INCLUDE 'CMN:LUN.PAR'		    ! logical unit numbers
	INCLUDE 'LSL$CMNLSL:LSLLIBMSG.PAR'  ! LSLLIB message definitions
	INCLUDE 'LSL$CMNLSL:READSTR.PAR'    ! LSLLIB text buffer
C
C Common Blocks
C
	INCLUDE 'CMN:SIF2IFF.CMN'	! globals
	INCLUDE 'CMN:IFF_MAP.CMN'	! MD parameters
	INCLUDE 'CMN:IFF_FEATURE.CMN'	! IFF feature
	INCLUDE 'CMN:LUT.CMN'		! CCSM LUT
	INCLUDE 'CMN:FILES.CMN'		! files
	INCLUDE 'CMN:FLAGS.CMN'		! various flags
	INCLUDE 'LSL$CMNLSL:CMDCOM.CMN'	! command decoding
	INCLUDE 'LSL$CMNLSL:MTIVCM.CMN'	! for reading magtape
	INCLUDE 'LSL$CMNLSL:STATUS.CMN'	! LSLLIB status flag
	INCLUDE 'LSL$CMNLSL:TXTC.CMN'	! text buffer
C
C Functions called
C
	INTEGER*4	MTINIT		! initialise magtape
	INTEGER*4	MTIRWD		! rewind magtape
	INTEGER*4	FLROPN		! open file for reading
	INTEGER*4	FLRCLO		! close file for reading
	INTEGER*4	READLINE	! read line from file or tape
	INTEGER*4	MTIRDB		! read block from tape
	INTEGER*4	FLRLIN		! read line from file
	INTEGER*4	RDCOMM		! read a command
	LOGICAL		RDLONG		! read a longword integer
	LOGICAL		RDCH		! read a character
	LOGICAL		RDCHS		! read a character skipping blanks
	LOGICAL		READSTR		! read a string
	LOGICAL		READ_SEP	! read a longword integer
	INTEGER		TEST_FOREIGN	! test device mounted /FOREIGN
C
	LOGICAL		RDDID		! SIF DID command
	LOGICAL		RDLAC		! SIF LAC command
	LOGICAL		RDLST		! SIF LST command
	LOGICAL		RDTXT		! SIF TXT command
	LOGICAL		RDSYM		! SIF SYM command
	LOGICAL		RDCIR		! SIF CIR command
	LOGICAL		RDARC		! SIF ARC command
	LOGICAL		RDPTN		! SIF PTN command
	LOGICAL		RDTX3		! SIF TX3 command
	LOGICAL		RDTPC		! SIF TPC command
	LOGICAL		RDPG		! SIF PAR command
	LOGICAL		RDPLN		! SIF PLN command
	LOGICAL		RDCLP		! SIF CLP command
	LOGICAL		RDACZ		! SIF ACZ command
	LOGICAL		RDMTX		! SIF MTX command
	LOGICAL		RDPA3		! SIF PA3 command
	LOGICAL		RDOVR		! SIF OVR command
	LOGICAL		RDIDE		! SIF IDE command
C
C Local Variables
C
	INTEGER*4	LEN		! string length
	INTEGER*4	I		! counter
	INTEGER*4	J		! counter
	INTEGER*4	STATUS		! function return status
	INTEGER*4	RESULT		! command read result
	INTEGER*4	ERRCOD		! LSLLIB error code
	INTEGER*4	RETCOD		! system error code
	CHARACTER*12	CCSM		! CCSM code
	CHARACTER*80	DUMSTR		! dummy string
	CHARACTER*20	HDR_FIELD	! CCG file header
	CHARACTER*10	FIELD		! ident field
	INTEGER*4	IDENT		! IDE ident
	INTEGER*4	USER1		! IDE user1
	INTEGER*4	USER2		! IDE user2
	LOGICAL		FOREIGN		! tape mounted foreign flag
	LOGICAL		NOLONG		! longword integer return status
	LOGICAL		OK		! function return status
	BYTE		ICH		! character read
C--------------------------------------------------------------------------
	DO I1
	RETURN
	END
