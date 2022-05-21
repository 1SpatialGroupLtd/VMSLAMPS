$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1992-05-06 14:26:10.000000000 +0100
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
$ inquire DSR "Compile DSR"
$ inquire SPOT "Compile DSRSPOT"
$ inquire KRISS "Compile KRISS"
$ inquire LDSR "Link DSR"
$ inquire LSPOT "Link DSRSPOT"
$ inquire LKRISS "Link KRISS"
$ sd obj
$ if DSR
$ then
$   open/write tr spot.tr
$   write tr "SPOT = 0"
$   close tr
$   adc xdsr=spot.tr/tr,lsl$source_root:[lites2.uis.kern]dsr
$   fortran xdsr
$   pvv xdsr
$   delete spot.tr;*,adc.ide;*,xdsr.for;*
$   pl xdsr.obj
$ endif
$!
$ if SPOT
$ then
$   open/write tr spot.tr
$   write tr "SPOT = 1"
$   close tr
$   adc xdsrspot=spot.tr/tr,lsl$source_root:[lites2.uis.kern]dsr
$   fortran xdsrspot
$   pvv xdsrspot
$   delete spot.tr;*,adc.ide;*,xdsrspot.for;*
$   pl xdsrspot.obj
$ endif
$!
$ if KRISS
$ then
$   adc xkriss=lsl$source_root:[lites2.uis.kern]kriss
$   fortran xkriss
$   pvv xkriss
$   delete adc.ide;*,xkriss.for;*
$   pl xkriss.obj
$ endif
$!
$ if LDSR
$ then
$   link/share/exe=exe:lites2dsrshr/map=lites2dsrshr/full -
	sys$input:/opt
UNSUPPORTED=1
XDSR
	LSL$SOURCE_ROOT:[LITES2.UIS.KERN]P2PUTI/LIB,-
	LSL$SOURCE_ROOT:[LITES2.UIS.KERN]P2PLIB/LIB,-
	LSL$SOURCE_ROOT:[LITES2.UIS.KERN]MLIB/LIB,-
	LSL$SOURCE_ROOT:[LITES2.UIS.KERN]VT100/LIB
!
universal = DSR_INIT
universal = DSR_READ
universal = DSR_MOVE
universal = DSR_START
universal = DSR_TRN
!
psect_attr=BASE_OUT,noshr
psect_attr=GROUND_TO_MODEL_MATRIX,noshr
psect_attr=GROUND_TO_MODEL_SHIFT,noshr
psect_attr=IO_PAGE,noshr
psect_attr=LEFT_FIDUCIAL_TO_MEASURING_MATR,noshr
psect_attr=LEFT_FIDUCIAL_TO_MODEL_MATRIX,noshr
psect_attr=LEFT_MEASURING_TO_FIDUCIAL_MATR,noshr
psect_attr=LEFT_PRINCIPAL_DISTANCE,noshr
psect_attr=LEFT_PROJECTION_CENTER,noshr
psect_attr=LOWER_STAGE_CALIBRATION_MATRIX,noshr
psect_attr=MODEL_TO_GROUND_MATRIX,noshr
psect_attr=MODEL_TO_GROUND_SHIFT,noshr
psect_attr=P2,noshr
psect_attr=P2_IO,noshr
psect_attr=P3_IO,noshr
psect_attr=P4_IO,noshr
psect_attr=RIGHT_FIDUCIAL_TO_MEASURING_MAT,noshr
psect_attr=RIGHT_FIDUCIAL_TO_MODEL_MATRIX,noshr
psect_attr=RIGHT_MEASURING_TO_FIDUCIAL_MAT,noshr
psect_attr=RIGHT_PRINCIPAL_DISTANCE,noshr
psect_attr=RIGHT_PROJECTION_CENTER,noshr
psect_attr=TT_IO,noshr
psect_attr=UPPER_STAGE_CALIBRATION_MATRIX,noshr
$   sd exe:
$   patch @dsr.pat
$   delete lites2dsrshr.jnl;*
$   purge lites2dsrshr.exe,obj:lites2dsrshr.map
$ endif
$!
$ if LSPOT
$ then
$   sd obj:
$   link/share/exe=exe:lites2dsrspotshr/map=lites2dsrspotshr/full -
	sys$input:/opt
UNSUPPORTED=1
XDSRSPOT
	LSL$SOURCE_ROOT:[LITES2.UIS.KERN]P2PUTI/LIB,-
	LSL$SOURCE_ROOT:[LITES2.UIS.KERN]P2PLIB/LIB,-
	LSL$SOURCE_ROOT:[LITES2.UIS.KERN]MLIB/LIB,-
	LSL$SOURCE_ROOT:[LITES2.UIS.KERN]VT100/LIB
!
universal = DSR_INIT
universal = DSR_READ
universal = DSR_MOVE
universal = DSR_START
universal = DSR_TRN
!
psect_attr=BASE_OUT,noshr
psect_attr=GROUND_TO_MODEL_MATRIX,noshr
psect_attr=GROUND_TO_MODEL_SHIFT,noshr
psect_attr=IO_PAGE,noshr
psect_attr=LEFT_FIDUCIAL_TO_MEASURING_MATR,noshr
psect_attr=LEFT_FIDUCIAL_TO_MODEL_MATRIX,noshr
psect_attr=LEFT_MEASURING_TO_FIDUCIAL_MATR,noshr
psect_attr=LEFT_PRINCIPAL_DISTANCE,noshr
psect_attr=LEFT_PROJECTION_CENTER,noshr
psect_attr=LOWER_STAGE_CALIBRATION_MATRIX,noshr
psect_attr=MODEL_TO_GROUND_MATRIX,noshr
psect_attr=MODEL_TO_GROUND_SHIFT,noshr
psect_attr=P2,noshr
psect_attr=P2_IO,noshr
psect_attr=P3_IO,noshr
psect_attr=P4_IO,noshr
psect_attr=RIGHT_FIDUCIAL_TO_MEASURING_MAT,noshr
psect_attr=RIGHT_FIDUCIAL_TO_MODEL_MATRIX,noshr
psect_attr=RIGHT_MEASURING_TO_FIDUCIAL_MAT,noshr
psect_attr=RIGHT_PRINCIPAL_DISTANCE,noshr
psect_attr=RIGHT_PROJECTION_CENTER,noshr
psect_attr=TT_IO,noshr
psect_attr=UPPER_STAGE_CALIBRATION_MATRIX,noshr
$   sd exe:
$   patch @dsrspot.pat
$   delete lites2dsrspotshr.jnl;*
$   purge lites2dsrspotshr.exe,obj:lites2dsrspotshr.map
$ endif
$!
$ if LKRISS
$ then
$   sd obj:
$   link/share/exe=exe:lites2krissshr/map=lites2krissshr/full -
	sys$input:/opt, -
	lsl$library:lslshr/opt
UNSUPPORTED=1
XDSR,XKRISS
	LSL$SOURCE_ROOT:[LITES2.UIS.KERN]P2PUTI/LIB,-
	LSL$SOURCE_ROOT:[LITES2.UIS.KERN]BETALIB/LIB,-
	LSL$SOURCE_ROOT:[LITES2.UIS.KERN]P2PLIB/LIB,-
	LSL$SOURCE_ROOT:[LITES2.UIS.KERN]MLIB/LIB,-
	LSL$SOURCE_ROOT:[LITES2.UIS.KERN]VT100/LIB,-
	LSL$SOURCE_ROOT:[LITES2.UIS.KERN]FORCOMLIB/LIB,-
	LSL$SOURCE_ROOT:[LITES2.UIS.KERN]GEMLIB3/LIB,-
	LSL$SOURCE_ROOT:[LITES2.UIS.KERN]MDLIBI4/LIB
!
! Create cluster for GEMS system
CLUSTER=GEMSYS,,,-
	SYS$SHARE:GEMSYS/SHARE
!
universal = DSR_INIT
universal = DSR_READ
universal = DSR_MOVE
universal = DSR_START
universal = DSR_TRN
universal = KRISS_INIT
universal = KRISS_DISMOD
universal = KRISS_GPL
universal = KRISS_UPDATE
universal = KRISS_REFRSH
universal = KRISS_RFSTOP
universal = KRISS_VISIBLE
universal = KRISS_VECT
universal = KRISS_RECT
universal = KRISS_TRACK
universal = KRISS_STOP
universal = KRISS_SIDE
universal = KRISS_SUSPEND
universal = KRISS_REGIST
!
psect_attr=BASE_OUT,noshr
psect_attr=GL3CB0,noshr
psect_attr=GL3CB1,noshr
psect_attr=GROUND_TO_MODEL_MATRIX,noshr
psect_attr=GROUND_TO_MODEL_SHIFT,noshr
psect_attr=GVCB,noshr
psect_attr=IO_PAGE,noshr
psect_attr=KRISS,noshr
psect_attr=LEFT_FIDUCIAL_TO_MEASURING_MATR,noshr
psect_attr=LEFT_FIDUCIAL_TO_MODEL_MATRIX,noshr
psect_attr=LEFT_MEASURING_TO_FIDUCIAL_MATR,noshr
psect_attr=LEFT_PRINCIPAL_DISTANCE,noshr
psect_attr=LEFT_PROJECTION_CENTER,noshr
psect_attr=LOWER_STAGE_CALIBRATION_MATRIX,noshr
psect_attr=MODEL_TO_GROUND_MATRIX,noshr
psect_attr=MODEL_TO_GROUND_SHIFT,noshr
psect_attr=P2,noshr
psect_attr=P2_IO,noshr
psect_attr=P3_IO,noshr
psect_attr=P4_IO,noshr
psect_attr=RIGHT_FIDUCIAL_TO_MEASURING_MAT,noshr
psect_attr=RIGHT_FIDUCIAL_TO_MODEL_MATRIX,noshr
psect_attr=RIGHT_MEASURING_TO_FIDUCIAL_MAT,noshr
psect_attr=RIGHT_PRINCIPAL_DISTANCE,noshr
psect_attr=RIGHT_PROJECTION_CENTER,noshr
psect_attr=TT_IO,noshr
psect_attr=UPPER_STAGE_CALIBRATION_MATRIX,noshr
$   sd exe:
$   patch @kriss.pat
$   delete lites2krissshr.jnl;*
$   purge lites2krissshr.exe,obj:lites2krissshr.map
$ endif
$!
