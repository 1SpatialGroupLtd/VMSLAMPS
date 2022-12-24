$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1996-09-24 16:12:52.000000000 +0100
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
$ @check_diff AEGBLK.SRC DEV 
$ @check_diff BEN1600BLK.SRC DEV 
$ @check_diff BEN3000BLK.SRC DEV 
$ @check_diff BENBLK.SRC DEV 
$ @check_diff BENMETBLK.SRC DEV 
$ @check_diff BENOFF3000BLK.SRC DEV 
$ @check_diff CAL5800BLK.SRC DEV 
$ @check_diff CAL5800_1BLK.SRC DEV 
$ @check_diff CAL5800_LINEBLK.SRC DEV 
$ @check_diff CAL907BLK.SRC DEV 
$ @check_diff CAL925BLK.SRC DEV 
$ @check_diff CALAIDUBLK.SRC DEV 
$ @check_diff CALGEOGBLK.SRC DEV 
$ @check_diff FERBLK.SRC DEV 
$ @check_diff FPP.OPT DEV 
$ @check_diff FPPAEG.OPT DEV 
$ @check_diff FPPBEN.OPT DEV 
$ @check_diff FPPBEN1600.OPT DEV 
$ @check_diff FPPBEN3000.OPT DEV 
$ @check_diff FPPBENMET.OPT DEV 
$ @check_diff FPPBENOFF3000.OPT DEV 
$ @check_diff FPPCAL5800.OPT DEV 
$ @check_diff FPPCAL5800_1.OPT DEV 
$ @check_diff FPPCAL5800_LINE.OPT DEV 
$ @check_diff FPPCAL907.OPT DEV 
$ @check_diff FPPCAL925.OPT DEV 
$ @check_diff FPPCALAIDU.OPT DEV 
$ @check_diff FPPCALGEOG.OPT DEV 
$ @check_diff FPPFER.OPT DEV 
$ @check_diff FPPGERB.OPT DEV 
$ @check_diff FPPHCBS.OPT DEV 
$ @check_diff FPPHP.OPT DEV 
$ @check_diff FPPHPGL2.OPT DEV 
$ @check_diff FPPHRD.OPT DEV 
$ @check_diff FPPHRD_NOHIACC.OPT DEV 
$ @check_diff FPPHRP.OPT DEV 
$ @check_diff FPPKERNGP1.OPT DEV 
$ @check_diff FPPKONG.OPT DEV 
$ @check_diff FPPLP.OPT DEV 
$ @check_diff FPPLVU.OPT DEV 
$ @check_diff FPPLWS.OPT DEV 
$ @check_diff FPPMOTIF.OPT DEV 
$ @check_diff FPPMP.OPT DEV 
$ @check_diff FPPPI448.OPT DEV 
$ @check_diff FPPPOSTSCRIPT.OPT DEV 
$ @check_diff FPPPRIM.OPT DEV 
$ @check_diff FPPSHR.OPT DEV 
$ @check_diff FPPSIG6000.OPT DEV 
$ @check_diff FPPTEK_ARGS.OPT DEV 
$ @check_diff FPPUIS.OPT DEV 
$ @check_diff FPPVERS.OPT DEV 
$ @check_diff FPPVRSC2V1.OPT DEV 
$ @check_diff FPPVRSVGS.OPT DEV 
$ @check_diff FPPWILD.OPT DEV 
$ @check_diff FPPXYNETICS.OPT DEV 
$ @check_diff GERBBLK.SRC DEV 
$ @check_diff GKSSHR.OPT DEV 
$ @check_diff HCBSBLK.SRC DEV 
$ @check_diff HPBLK.SRC DEV 
$ @check_diff HPGL2BLK.SRC DEV 
$ @check_diff HRDBLK.SRC DEV 
$ @check_diff HRD_NOHIACCBLK.SRC DEV 
$ @check_diff HRPBLK.SRC DEV 
$ @check_diff KERNGP1BLK.SRC DEV 
$ @check_diff KONGBLK.SRC DEV 
$ @check_diff LPBLK.SRC DEV 
$ @check_diff LVUBLK.SRC DEV 
$ @check_diff LWSBLK.SRC DEV 
$ @check_diff MOTIFBLK.SRC DEV 
$ @check_diff MPBLK.SRC DEV 
$ @check_diff PI448BLK.SRC DEV 
$ @check_diff POSTSCRIPTBLK.SRC DEV 
$ @check_diff PRIMBLK.SRC DEV 
$ @check_diff SHRBLK.SRC DEV 
$ @check_diff SIG6000BLK.SRC DEV 
$ @check_diff TEK_ARGSBLK.SRC DEV 
$ @check_diff UISBLK.SRC DEV 
$ @check_diff VERSBLK.SRC DEV 
$ @check_diff VRSC2V1BLK.SRC DEV 
$ @check_diff VRSVGSBLK.SRC DEV 
$ @check_diff WILDBLK.SRC DEV 
$ @check_diff XYNETICSBLK.SRC DEV 
