$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1991-02-06 14:40:04.000000000 +0000
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
$! This command file, LSL$COM:COLOUR_TABLE.COM, plots out an example
$! colour table, for use mainly on colour electrostatic plotters.
$! The data files are all taken from their directories on the
$! LSL$PUBLIC_ROOT search list. The plot shows an example of a solid
$! area, and a section of line drawn in each of 217 colours. Colour tables
$! are usually allowed to contain colours 0-255, so if you want to add
$! other colours, make a copy and change colours 218 and higher.
$!
$! A LITES2 command file,
$!    LSL$PUBLIC_ROOT:[PLOTTING.EXAMPLES.LCM]COLOUR_TABLE.LCM defines the
$! same colours using LITES2 overlay commands. If LITES2 is used to
$! experiment with the colours, then SAVE COLOURS and SAVE LUT may be
$! used to write out altered versions of the colour tables.
$!
$! The command file expects 4 parameters:
$! (1) the filename of the version of FPP to use, e.g. FPPCAL5800. Directory
$!     LSL$PUBLIC_ROOT:[PLOTTING.EXE] is used by default.
$! (2) the logical name used by this FPP to read its colour table,
$!     e.g. LSL$CALCOMP_COLOUR for FPPCAL5800
$! (3) the ENLARGE factor to use. Using 1.0, the plot will be 380x400mm.
$!     Using 2.0, for example, the plot would be 190x200mm.
$! (4) (optional) any other FPP commands required, e.g. WORKSTATION -
$!     enclose in quotes if it contains spaces.
$!
$! You should already have defined whatever logical names are required
$! to run the version of FPP concerned, and then either @ or submit this
$! file as required:
$!
$! @LSL$COM:COLOUR_TABLE FPPCAL5800 LSL$CALCOMP_COLOUR 1.0
$!  or for batch:
$! SUBMIT/QUEUE=CAL5800BATCH/PARAMS=(FPPCAL5800,LSL$CALCOMP_COLOUR,1.0) -
$!              LSL$COM:COLOUR_TABLE
$!
$ fppver = "$"+f$parse(p1,"LSL$PUBLIC_ROOT:[PLOTTING.EXE].EXE")
$ define/user 'p2' lsl$public_root:[plotting.lookup]colour_table.col
$ fppver enlarge 'p3' 'p4' @sys$input:
frt lsl$public_root:[plotting.examples.frt]colour_table
sri lsl$public_root:[mapping.examples.frt]os
tri lsl$public_root:[mapping.examples.frt]os
enable height
disable psize
scale factor 1
position 0
offset 10 10
iff lsl$public_root:[plotting.examples.iff]colour_table
$exit
