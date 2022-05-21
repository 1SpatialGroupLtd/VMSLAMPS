$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1991-08-25 19:57:52.000000000 +0100
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
$i2ntf/wat/ou=test2/lo -
/par=here:test.par -
 here:collect_test1.iff ntfspr2.ntf
$!/dbname="jmcdb" -
$!/fix -
$!/fr=here:nww  
$!/att=nww_ntf.ntf_attr -
$!/FEAT=X.CLS
$!/xy_l=15/xy_m=1.0/z_m=1.0/z_le=10/z_u=3/z_d=888
