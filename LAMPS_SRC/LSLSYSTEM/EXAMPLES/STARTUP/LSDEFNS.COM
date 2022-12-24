$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1994-08-03 15:43:52.000000000 +0100
$! *
$! * This program is free software: you can redistribute it and/or modify
$! * it under the terms of the GNU General Public License as published by
$! * the Free Software Foundation, version 3.
$! *
$! * This program is distributed in the hope that it will be useful, but
$! * WITHOUT ANY WARRANTY; without even the implied warranty of
$! * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
$! * General Public License for more details.
$! *
$! * You should have received a copy of the GNU General Public License
$! * along with this program. If not, see http://www.gnu.org/licenses/.
$!
$! LSDEFNS.COM - define LSL logicals. Called from LSSTARTUP.COM
$!
$! Copyright Laser-Scan Ltd, Cambridge, England
$! version for LSLINSTALL				PGH	11-Jul-1990
$! Alpha AXP definitions added				PGH	20-Jul-1993
$! Alpha AXP definitions added				PGH	22-Nov-1993
$! LSL$FRTSHR added					CCB	 3-Aug-1994
$!
$! sets up various LSL logical names to point to directories etc.
$!
$	SET NOON
$	WS="WRITE SYS$OUTPUT"
$	WS "LSDEFNS.COM - Defining LSL logical names"
$!
$! Define name for the directory(s) containing the subsequent LSL startup files
$! This will normally have been done in LSSTARTUP.COM, but checked here because
$! LSDEFNS is sometimes run in isolation during LSLINSTALL installation.
$!
$	IF F$TRNLNM("LSL$STARTUP").EQS."" THEN -
	   DEFINE/SYSTEM	LSL$STARTUP	SYS$MANAGER
$! 
$!
$!
$! Set up system logicals for main roots
$!
$	@LSL$STARTUP:LSDEFNS_ROOTS
$!
$! Set up any definitions local to this node
$!
$	IF F$SEARCH("LSL$STARTUP:LSDEFNS_LOCAL.COM").NES."" THEN -
	   @LSL$STARTUP:LSDEFNS_LOCAL
$!
$! Set up customer and site-specific definitions
$!
$	@LSL$STARTUP:LSDEFNS_SITE
$!
$! Set up search lists for public tree directories
$!
$	@LSL$STARTUP:LSDEFNS_SEARCHLISTS
$!
$!
$! Set up system logicals for devices 
$! (other than serial line ones done in LSPORTS.COM and LSTERMS.COM)
$!
$	@LSL$STARTUP:LSDEFNS_DEVICES
$!
$! Now for the package dependent definitions
$! First the central ones
$!
$! Package LSLSYSTEM
$!
$	Define/System	LSL$LSLSHR	LSL$LIBRARY:LSLSHR
$	Define/System	LSL$LSLSHR_TV	LSL$LIBRARY:LSLSHR_TV
$	Define/System	LSL$CMNLSL -
				LSL$PUBLIC_ROOT:[LSLSYSTEM.COMMON.LSLLIB]
$	Define/System	LSL$LSLGOTHICSHR	LSL$LIBRARY:LSLGOTHICSHR
$	Define/System	LSL$LSLGOTHICSHR_TV	LSL$LIBRARY:LSLGOTHICSHR_AXP
$	Define/System	LSL$LSLGOTHICSHR_AXP	LSL$LIBRARY:LSLGOTHICSHR_AXP
$!
$! Package MAPPING
$!
$	Define/System	LSL$IFFSHR	LSL$LIBRARY:IFFSHR
$	Define/System	LSL$IFFSHR_TV	LSL$LIBRARY:IFFSHR_TV
$	Define/System	LSL$FRTSHR	LSL$LIBRARY:FRTSHR
$	Define/System	LSL$FRTSHR_TV	LSL$LIBRARY:FRTSHR_TV
$	Define/System	LSL$CMNFRT	LSL$PUBLIC_ROOT:[MAPPING.COMMON.FRTLIB]
$	Define/System	LSL$CMNIFF	LSL$PUBLIC_ROOT:[MAPPING.COMMON.IFFLIB]
$	Define/System	LSL$IF		LSL$DATA_ROOT:[LSL.IFF]
$	Define/System	IF		'F$LOGICAL("LSL$IF")'
$	Define/System	LSL$FRT		LSL$SITE_ROOT:[LSL.FRT]
$!
$! Package LITES2
$!
$	Define/System	LSL$LITES2JNL	LSL$LOCAL_ROOT:[LITES2.JNL]
$	Define/System	LSL$LITES2SETUP	LSL$LOCAL_ROOT:[LITES2.JNL]
$	Define/System	LSL$LITES2WORK	LSL$LOCAL_ROOT:[LITES2.WORK]
$	Define/System	LSL$MGMT	LSL$SITE_ROOT:[LSL.MGMT]
$!
$! Now for the non-central packages
$!
$!
$! Package PLOTTING
$!
$	Define/System	LSL$FPP		LSL$SITE_ROOT:[LSL.FPP]
$!
$! Package MATRIX
$!
$	Define/System	LSL$DTI		LSL$DATA_ROOT:[LSL.DTI]
$	Define/System	LSL$CMNDTI	LSL$PUBLIC_ROOT:[MATRIX.COMMON.DTILIB]
$!
$! Package VTRAK
$!
$!!!	Define/System	HLP$LIBRARY	LSL$PUBLIC_ROOT:[VTRAK.HELP]DIGITISER
$!
$	EXIT
