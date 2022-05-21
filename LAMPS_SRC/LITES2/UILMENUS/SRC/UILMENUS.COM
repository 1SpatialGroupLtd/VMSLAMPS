$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1992-04-03 14:43:30.000000000 +0100
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
$inquire comp "Compile"
$inquire mar "Command table"
$inquire lnk "Link"
$inquire dbg "with debug"
$set verify
$if .not.comp then goto nocomp
$ccsw=""
$if dbg then ccsw="/debug/noopt"
$cc'ccsw' uilmenus
$adc uilmen_cld.tmp=uilmen_cld.cld
$set command/object=uilmen_cld uilmen_cld.tmp
$pvv uilmen_cld
$delete uilmen_cld.tmp;*,adc.ide;*
$nocomp:
$if .not.mar then goto nomar
$macro uilcmd
$nomar:
$if .not.lnk then goto nolnk
$lnsw=""
$if dbg then lnsw="/debug"
$link/exe=uilmenusmotif'lnsw' -
	uilmenus,uilcmd,uilmen_cld,lsl$library:lslshr/opt,-
	sys$input:/opt
sys$share:decw$dxmlibshr/shareable ! we don't use DEC Motif extensions
sys$share:decw$xmlibshr/shareable
sys$share:vaxcrtl/shareable
$nolnk:
$pl	! 'f$verify(0)
