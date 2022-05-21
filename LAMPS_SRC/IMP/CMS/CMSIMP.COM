$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1993-07-27 17:06:30.000000000 +0100
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
$util="IWINDOW"
$package="IMP"
$set noon
$SD LSL$SOURCE_ROOT:['PACKAGE'.'UTIL']
$CREATE/DIR [.CMSLIB]
$CREATE/DIR [.SRC]
$CMS CREATE LIBRARY [.CMSLIB]
$CMS SET LIBRARY [.CMSLIB]
$CMS CREATE ELEMENT *.F    "Fortran source for LAMPS V4.2 version"
$CMS CREATE ELEMENT *.UPD  "Update file for LAMPS V4.2 version"
$CMS CREATE ELEMENT *.SRC  "Fortran source for LAMPS V4.2 version"
$CMS CREATE ELEMENT *.MAR  "Macro source for LAMPS V4.2 version"
$CMS CREATE ELEMENT *.COM  "Procedure for LAMPS V4.2 version"
$CMS CREATE ELEMENT *.CMN  "Common block for LAMPS V4.2 version"
$CMS CREATE ELEMENT *.PAR  "Parameters for LAMPS V4.2 version"
$CMS CREATE ELEMENT *.OPT  "Linker options for LAMPS V4.2 version"
$CMS CREATE ELEMENT *.CLD  "Command line definition for LAMPS V4.2 version"
$CMS CREATE ELEMENT *.MES  "Message definitions for LAMPS V4.2 version"
$CMS CREATE ELEMENT *.MAPID "Map ID listing for LAMPS V4.2 version"
$CMS CREATE ELEMENT *.TREE  "Program structure tree created from mapid"
