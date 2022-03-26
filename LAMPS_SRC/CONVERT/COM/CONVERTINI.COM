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
$! Allow for differences for OpenVMS Alpha AXP
$!
$	ARCH_NAME=F$GETSYI("ARCH_NAME")
$	SUFFIX=""
$	AXP_SUFFIX=""
$	IF ARCH_NAME.EQS."Alpha" THEN SUFFIX="_TV"
$	IF ARCH_NAME.EQS."Alpha" THEN AXP_SUFFIX="_AXP"
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
$ ws "IFFARCINFO  I2ARC, ARC2I                                                        "
$ ws "IFFCEDD     I2CEDD, CEDD2I                                                      "
$ ws "IFFDCW      DCW2I                                                               "
$ ws "IFFDIGIT    I2DIGIT                                                             "
$ ws "IFFDLG      I2DLG                                                               "
$ ws "IFFDXF      I2DXF, DXF2I                                                        "
$ ws "IFFGDB      I2GDB                                                               "
$ ws "IFFIMAP     I2IMAP, IMAP2I                                                      "
$ ws "IFFKERNCAM  I2KERNCAM, KERNCAM2I                                                "
$ ws "IFFMAPDATA  I2MAPDATA, MAPDATA2I                                                "
$ ws "IFFMGD      I2MGD, MGD2I                                                        "
$ ws "IFFMOSS     I2MOSS                                                              "
$ ws "IFFMSDS     MSDS2I                                                              "
$ ws "IFFNTF      I2NTF, NTF2I                                                        "
$ ws "IFFOSTF     I2OSTF, OSTF2I, OSMHED, OSPIF                                       "
$ ws "IFFSIF      IFF2SIF,IFF2SCI,SIF2IFF                                             "
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
$	I2ARC :== $LSL$EXE:I2ARC'SUFFIX'	! IFF to ARC/INFO converter
$	ARC2I :== $LSL$EXE:ARC2I'SUFFIX'	! ARC/INFO to IFF converter
$!
$! module IFFCEDD
$!                                                    
$	I2CEDD :== $LSL$EXE:I2CEDD'SUFFIX'	! IFF to CEDD converter
$	CEDD2I :== $LSL$EXE:CEDD2I'SUFFIX'	! CEDD to IFF converter
$!
$! module IFFDCW
$!
$	DCW2I :== $LSL$EXE:DCW2I'SUFFIX'	! DCW to IFF converter
$!
$! module IFFDIGIT
$!
$	I2DIGIT :== $LSL$EXE:I2DIGIT'SUFFIX'	! IFF to DIGIT converter
$!
$! module IFFDLG
$!
$	I2DLG :== $LSL$EXE:I2DLG'SUFFIX'	! IFF to DLG converter
$!
$! module IFFDXF
$!
$	I2DXF :== $LSL$EXE:I2DXF'SUFFIX'	! IFF to DXF converter
$	DXF2I :== $LSL$EXE:DXF2I'SUFFIX'	! DXF to IFF converter
$!
$	define	LSL$DXF		LSL$DATA_ROOT:[LSL.DXF]
$!
$! module IFFGDB
$!
$	I2GDB :== $LSL$EXE:I2GDB'SUFFIX'	! IFF to GDB converter
$!
$! module IFFIMAP
$!
$	I2IMAP :== $LSL$EXE:I2IMAP'AXP_SUFFIX'	! IFF to IMAP converter
$	IMAP2I :== $LSL$EXE:IMAP2I'AXP_SUFFIX'	! IMAP to IFF converter
$!
$! module IFFKERNCAM
$!               
$	I2KERNCAM :== $LSL$EXE:I2KERNCAM'SUFFIX'    ! IFF to KERNCAM converter
$	KERNCAM2I :== $LSL$EXE:KERNCAM2I'SUFFIX'    ! KERNCAM to IFF converter
$!
$! module IFFMAPDATA
$!           
$	I2MAPDATA :== $LSL$EXE:I2MAPDATA'SUFFIX'    ! IFF to MAPDATA converter
$	MAPDATA2I :== $LSL$EXE:MAPDATA2I'SUFFIX	    ! MAPDATA to IFF converter
$!
$! module IFFMGD
$!           
$	I2MGD :== $LSL$EXE:I2MGD'SUFFIX'	! IFF to MGD converter
$	MGD2I :== $LSL$EXE:MGD2I'SUFFIX'	! MGD to IFF converter
$!
$! module IFFMOSS
$!
$	I2MOSS :== $LSL$EXE:I2MOSS'SUFFIX'	! IFF to MOSS converter
$!
$! module IFFMSDS
$!
$	MSDS2I :== $LSL$EXE:MSDS2I'SUFFIX'	! MSDS to IFF converter
$!
$	define	LSL$MSDS	LSL$DATA_ROOT:[LSL.MSDS]
$!
$! module IFFNTF
$!
$	I2NTF :== $LSL$EXE:I2NTF'SUFFIX'	! IFF to NTF converter
$	NTF2I :== $LSL$EXE:NTF2I'AXP_SUFFIX'	! NTF to IFF converter
$!
$! module IFFOSTF
$!
$	I2OSTF :== $LSL$EXE:I2OSTF'SUFFIX'/CONTR=n  ! IFF to OSTF converter
$!	I2OSTF :== $LSL$EXE:I2OSTF/SERIAL/CONTR=n
$	OSTF2I :== $LSL$EXE:OSTF2I'SUFFIX'	! OSTF to IFF converter
$!	OSTF2I :== $LSL$EXE:OSTF2I/SERIAL
$	OSMHED :== $LSL$EXE:OSMHED'SUFFIX'	! OS map header editor
$	OSPIF :== $LSL$EXE:OSPIF'SUFFIX'	! OS print IFF file
$!
$	define	LSL$OS_CODES	LSL$LOOKUP:OSCODES.DAT	! FC names for OSPIF
$	IF F$TRNLNM("LSL$OS_MH_TABLE").EQS."" THEN -
	   DEFINE LSL$OS_MH_TABLE LSL$LOOKUP:OSMH_NEW_TABLE.DAT
$!
$! module IFFSIF
$!
$	IFF2SIF :== $LSL$EXE:IFF2SIF'SUFFIX'	! IFF to SIF converter
$	IFF2SCI :== $LSL$EXE:IFF2SIF'SUFFIX'/SCITEX ! IFF to SCITEX SIF converter
$	SIF2IFF :== $LSL$EXE:SIF2IFF'SUFFIX'	! SIF to IFF converter
$!
$	define 	LSL$SIF2IFF_MAX_PATTERN 100 ! Maximum SIF line pattern number
$	define 	LSL$IFF2SIF_SCITEX  LSL$EXE:SCITEX_LICENCE.EXE	! licence
$	define 	LSL$SIF		    LSL$DATA_ROOT:[LSL.SIF]	! SIF files
$!
$! module IFFTDST
$!
$	I2TDST :== $LSL$EXE:I2TDST'SUFFIX'	! IFF to TDST converter
$	TDST2I :== $LSL$EXE:TDST2I'SUFFIX'	! TDST to IFF converter
$!
$	define	LSL$DST		LSL$DATA_ROOT:[LSL.DST]
$	define	LSL$BNT		LSL$SITE_ROOT:[LSL.BNT]
$!
$	if ver_status then set verify
$!
