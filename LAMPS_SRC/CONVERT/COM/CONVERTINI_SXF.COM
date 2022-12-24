$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1990-05-10 17:33:00.000000000 +0100
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
$	ver_status=f$verify(0)
$	on control then continue
$	on error then continue
$!
$! Command file to initialise Laser-Scan IFF Package 'CONVERT'
$!
$! ************************** Installation notes **************************
$! *                                                                      *
$! * 1) All references within this command file to CONVERT modules not    *
$! *    installed at a particular site should be removed.                 *
$! * 2) In module IFFOSTF, symbol I2OSTF requires a contractor ID number  *
$! *    in place of the dummy 'n' specified with /CONTR                   *
$! * 3) Also in module IFFOSTF, symbols I2OSTF and OSTF2I should be       *
$! *    defined with /SERIAL if the site normally outputs data via a DIL  *
$! *    serial port magnetic tape driver.                                 *
$! *                                                                      *
$! ************************************************************************
$!
$! if we are not interactive, then don't output the explanation of what
$! CONVERT is and does
$!
$	if f$mode().nes."INTERACTIVE" then goto no_explanation
$!
$! and if they have used CONVERTINI Q then they want Quiet, so we will also
$! skip the informational bit
$!                                
$	if p1.eqs."Q" then goto no_explanation
$!
$! and lastly if they are on a non VT100 type terminal the reverse video
$! etc. may cause problems. Skip the informational bit.
$!
$	if (.not.f$getdvi("TT:","TT_AVO")) then goto no_explanation
$!
$	ws="write sys$output"
$!
$! Introduce the package with any relevant warnings of changes etc.
$!
$ ws "[0m[1m"+ -
"==========  Initialising IFF conversion package 'CONVERT' Version 2.0  ========="
$ ws " "
$!
$ ws "[0m[7m"
$ ws "The CONVERT package contains:                                                   "
$ ws "                                                                                "
$ ws "Module      Utilities                                                           "
$ ws "                                                                                "
$ ws "IFFARCINFO  I2ARC                                                               "
$ ws "IFFCEDD     I2CEDD, CEDD2I                                                      "
$ ws "IFFDLG      I2DLG                                                               "
$ ws "IFFDXF      I2DXF, DXF2I                                                        "
$ ws "IFFGDB      I2GDB                                                               "
$ ws "IFFIMAP     I2IMAP, IMAP2I                                                      "
$ ws "IFFKERNCAM  I2KERNCAM, KERNCAM2I                                                "
$ ws "IFFMGD      I2MGD, MGD2I                                                        "
$ ws "IFFMOSS     I2MOSS                                                              "
$ ws "IFFMSDS     MSDS2I                                                              "
$ ws "IFFNTF      I2NTF, NTF2I                                                        "
$ ws "IFFOSTF     I2OSTF, OSTF2I, OSMHED, OSPIF                                       "
$ ws "IFFSIF      IFF2SIF,IFF2SCI,SIF2IFF                                             "
$ ws "IFFSXF      I2SXF                                                               "
$ ws "IFFTDST     I2TDST,TDST2I                                                       "
$ ws "                                                                                "
$ ws "[0m"
$!
$! Define symbols for image activation, and logical names
$!
$no_explanation:
$!
$! module IFFARCINFO
$!
$	I2ARC	== "$LSL$EXE:I2ARC"		! IFF to ARC/INFO converter
$!
$! module IFFCEDD
$!                                                    
$	I2CEDD	== "$LSL$EXE:I2CEDD"		! IFF to CEDD converter
$	CEDD2I	== "$LSL$EXE:CEDD2I"		! CEDD to IFF converter
$!
$! module IFFDLG
$!
$	I2DLG == "$LSL$EXE:I2DLG"		! IFF to DLG converter
$!
$! module IFFDXF
$!
$	I2DXF == "$LSL$EXE:I2DXF"		! IFF to DXF converter
$	DXF2I == "$LSL$EXE:DXF2I"		! DXF to IFF converter
$!
$	define	LSL$DXF		LSL$DATA_ROOT:[LSL.DXF]
$!
$! module IFFGDB
$!
$	I2GDB == "$LSL$EXE:I2GDB"		! IFF to GDB converter
$!
$! module IFFIMAP
$!
$	I2IMAP	== "$LSL$EXE:I2IMAP"		! IFF to IMAP converter
$	IMAP2I	== "$LSL$EXE:IMAP2I"		! IMAP to IFF converter
$!
$! module IFFKERNCAM
$!               
$	I2KERNCAM == "$LSL$EXE:I2KERNCAM"	! IFF to KERNCAM converter
$	KERNCAM2I == "$LSL$EXE:KERNCAM2I"	! KERNCAM to IFF converter
$!
$! module IFFMGD
$!           
$	I2MGD	== "$LSL$EXE:I2MGD"		! IFF to MGD converter
$	MGD2I	== "$LSL$EXE:MGD2I"		! MGD to IFF converter
$!
$! module IFFMOSS
$!
$	I2MOSS	== "$LSL$EXE:I2MOSS"		! IFF to MOSS converter
$!
$! module IFFMSDS
$!
$	MSDS2I	== "$LSL$EXE:MSDS2I"		! MSDS to IFF converter
$!
$	define	LSL$MSDS	LSL$DATA_ROOT:[LSL.MSDS]
$!
$! module IFFNTF
$!
$	I2NTF	== "$LSL$EXE:I2NTF"		! IFF to NTF converter
$	NTF2I	== "$LSL$EXE:NTF2I"		! NTF to IFF converter
$!
$! module IFFOSTF
$!
$	I2OSTF	== "$LSL$EXE:I2OSTF/CONTR=n"	! IFF to OSTF converter
$!	I2OSTF	== "$LSL$EXE:I2OSTF/SERIAL/CONTR=n"
$	OSTF2I	== "$LSL$EXE:OSTF2I"		! OSTF to IFF converter
$!	OSTF2I	== "$LSL$EXE:OSTF2I/SERIAL"
$	OSMHED	== "$LSL$EXE:OSMHED"		! OS map header editor
$	OSPIF	== "$LSL$EXE:OSPIF"		! OS print IFF file
$!
$	define	LSL$OS_CODES	LSL$LOOKUP:OSCODES.DAT	! FC names for OSPIF
$!
$! module IFFSIF
$!
$	IFF2SIF	== "$LSL$EXE:IFF2SIF"		! IFF to SIF converter
$	IFF2SCI	== "$LSL$EXE:IFF2SIF/SCITEX"	! IFF to SCITEX SIF converter
$	SIF2IFF	== "$LSL$EXE:SIF2IFF"		! SIF to IFF converter
$!
$	define 	LSL$IFF2SIF_SCITEX  LSL$EXE:SCITEX_LICENCE.EXE	! licence
$	define 	LSL$SIF		    LSL$DATA_ROOT:[LSL.SIF]	! SIF files
$!
$! module IFFTDST
$!
$	I2TDST == "$LSL$EXE:I2TDST"		! IFF to TDST converter
$	TDST2I == "$LSL$EXE:TDST2I"		! TDST to IFF converter
$!
$	define	LSL$DST		LSL$DATA_ROOT:[LSL.DST]
$	define	LSL$BNT		LSL$SITE_ROOT:[LSL.BNT]
$!
$! module IFFSXF
$!
$	I2SXF == "$LSL$EXE:I2SXF"		! IFF to SXF converter
$!
$	define	LSL$SXF		LSL$DATA_ROOT:[LSL.SXF]
$!
$	if ver_status then set verify
$!
