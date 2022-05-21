$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1993-08-09 15:31:30.000000000 +0100
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
$! command file to check differences between CMS file and actual file
$! Expects P1=element, P2=group, P3 (optionally) = D to delete files
$!
$ set noon
$ file = "LSL$FPP_ROOT:["+P2+"]"+P1
$ if f$search(file).eqs.""
$ then
$    write sys$output "File ",file," does not exist"
$    exit
$ endif
$ CMS diff/nooutput/nolog 'P1'/gen 'file'
$ if $severity.ne.1
$ then
$    if $severity.eq.3
$    then
$       write sys$output "*** File ",file," differs from CMS"
$    else
$       write sys$output "*** Problem with file ",file
$    endif
$    write sys$output "********************************************************************************"
$ else
$    if P3.eqs."D" .or. P3.eqs."d"
$    then
$       delete 'file';0
$    endif
$ endif
