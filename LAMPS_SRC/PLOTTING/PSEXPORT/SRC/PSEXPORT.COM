$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1994-01-14 14:58:08.000000000 +0000
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
$!
$! Copyright Laser-Scan Laboratories Limited, Cambridge, England.
$!
$!	Created						CCB 12-Jan-1994
$!
$! Command file for building PSEXPORT
$!
$	inq/nop CLD "Compile CLD module? "
$	inq/nop MES "Generate message definitions? "
$	inq/nop COMP "Compile Fortran? "
$	inq/nop LNKIT "Link? "
$!
$	if MES
$	then
$	  NEWMSG psexport/number=1188/prefix=PSEXP__/param=fort/runoff
$	  @psexport.TEMP_COM
$	endif
$!
$	if CLD
$	then
$	  ADC psexport.TMP=psexport.CLD
$	  SET COMMAND/OBJECT=psexport_cld psexport.TMP
$	  PVV psexport_cld
$	  DELETE adc.ide;*
$	  DELETE psexport.TMP;*	
$	  PURGE/NOLOG psexport_cld.OBJ
$	endif
$!
$	if COMP
$	then
$	  FORT/nolist psexport.f
$	  PURGE/NOLOG psexport.OBJ
$	  FORT/nolist process_setup.f
$	  PURGE/NOLOG process_setup.OBJ
$	  FORT/nolist process_plot.f
$	  PURGE/NOLOG process_plot.OBJ
$	endif
$!
$	if LNKIT
$	then
$	  link/map psexport,process_setup,process_plot,-
	    psexport_cld,psexport.PROMSG_OBJ, -
	    LSL$LIBRARY:LSLSHR/OPT
$	endif
$!
