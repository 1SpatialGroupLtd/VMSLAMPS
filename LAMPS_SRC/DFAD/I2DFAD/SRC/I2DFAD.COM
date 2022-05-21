$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1988-07-14 19:06:34.000000000 +0100
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
$	ver='f$verify(0)'
$	set noon
$!
$	inquire DBG "With Debug"
$	if .not.DBG then DBG=""
$	if      DBG then MLDBG="/DEBUG"
$	inquire COMPILE "Compile"
$	if .not.COMPILE then goto NOC
$	  if      DBG then DBG="/DEBUG/NOOPT/CHECK=(BOUNDS,OVERFLOW)"
$!
$	  A1="M.I2DCMD,I2DCMD"
$	  A2="F.I2DFAD,I2DFAD"
$	  A3="F.GETCMD,GETCMD"
$	  A4="F.MAG,WRTMAG,WTPMKS,BLKPOS,RDMAG"
$	  A5="F.OUTHDR,OUTHDR,COMPLT,PRTHDR,STRTIF,OBTNAC"
$	  A6="F.OUTDSI,OUTDSI"
$	  A7="F.OUTACC,OUTACC,SUBACC,GETSAC"
$	  A8="F.OUTFTR,OUTFTR,PADFTR,OUTTLR"
$	  A9="F.MISC,FIND_LOCAL_ORIGIN"
$!
$	  TIMES=9
$	  COUNT=0
$ NXTASK:
$	  COUNT=COUNT+1
$	  OUT=f$extract(2,F$LOCATE(",",A'COUNT')-2,A'COUNT')
$	  FILES=f$extract(F$LOCATE(",",A'COUNT')+1,100,A'COUNT')
$	  inquire YES "''OUT' (''FILES')"
$	  if .NOT.YES then A'COUNT'=""
$	  if COUNT.lt.TIMES then goto NXTASK
$!
$ NOC:	inquire BUILD "Link"
$	if .not.BUILD then goto NOB
$!
$ NOB:
$	ERROR=""
$	if .not.COMPILE then goto DOBLD
$!
$	  set verify
$	  newmsg/number=1694/name=I2D/prefix=I2D__/parameter=for -
			i2dfad.mes
$	  @i2dfad.temp_com
$!
$	  adc i2dfad.tmp = i2dfad_cld.cld
$	  set command/object =i2dfad_cld i2dfad.tmp
$	  pvv i2dfad_cld
$	  delete i2dfad.tmp;*
$	  delete adc.ide;*
$	  purge i2dfad_cld.obj
$	  set noverify
$!
$	  COUNT=0
$ NXTC:
$	  COUNT=COUNT+1
$	    CMP=f$extract(0,1,A'COUNT')
$	    OUT=f$extract(2,f$locate(",",A'COUNT')-2,A'COUNT')
$	    FILES=f$extract(F$LOCATE(",",A'COUNT')+1,100,A'COUNT')
$	    if CMP.eqs."M" then goto MAC
$	    if CMP.nes."F" then goto SKIPC
$	      set verify
$	adc 'OUT'/co='FILES'
$	FORT/LIST'DBG' 'OUT'
$	      OK=$STATUS			!'f$verify(0)
$	      if .not.OK then ERROR=ERROR+" "+OUT
$	      set verify
$	if OK then pvv 'OUT'
$	if OK then DELETE 'OUT'.LIS;*
$	delete ADC.IDE;*
$	      goto skipc			!'f$verify(0)
$!
$ MAC:
$!
$	set verify
$	macro'MLDBG'/OBJECT='OUT' 'FILES'
$	OK=$STATUS				!'f$verify(0)
$	if .not.OK then ERROR=ERROR+" "+OUT
$	set verify
$ SKIPC:					!'f$verify(0)
$!
$	if count.lt.times then goto NXTC
$!
$DOBLD: if .not.BUILD.or.(ERROR.nes."") then goto tidy	! 'f$verify(0)'
$	set verify
$!
$	LINK/MAP/CROSS'MLDBG' I2DFAD,GETCMD,MAG,OUTHDR,OUTDSI,MISC,-
		OUTACC,OUTFTR,I2DCMD,-
		I2DFAD_CLD,-
		I2DFAD.PROMSG_OBJ,-
		LSL$LIBRARY:LSLDLMSLIB/LIB,-
		LSL$LIBRARY:IFFSHR/OPT,-
		LSL$LIBRARY:LSLSHR/OPT
$!
$tidy:	! 'f$verify(0)'
$	if error.nes."" then write sys$output "Errors in ",error
$	purge *.obj,*.lis,*.for,*.promsg_obj,*.map
$	if ver then set verify
