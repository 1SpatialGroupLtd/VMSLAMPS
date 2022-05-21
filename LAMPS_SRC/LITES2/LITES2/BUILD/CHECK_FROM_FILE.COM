$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1994-03-24 12:06:04.000000000 +0000
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
$! To check a series of disk files against the CMS
$! Expects P1 = filespec (optionally wildcarded)
$!         P2 (optionally) = a CMS class or generation number
$!     and P3 (optionally) = D to delete files
$!
$ set noon
$ if P2.nes."" then P2 = "="+P2
$ file = f$search("")
$ next_file:
$ file = f$search(P1)
$ if file.eqs."" then exit
$ name = f$parse(file,,,"NAME","SYNTAX_ONLY")
$ type = f$parse(file,,,"TYPE","SYNTAX_ONLY")
$ if type.eqs.".DIR" then goto next_file
$ element = name+type
$ CMS diff/nooutput/nolog 'element'/gen'P2' 'file'
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
$       delete 'file'
$    endif
$ endif
$ goto next_file
