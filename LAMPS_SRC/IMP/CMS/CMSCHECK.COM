$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1993-07-27 17:56:00.000000000 +0100
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
$sd srt:[imp.ICHECK]
$setlib
$cms sh class 
$!
$sd srt:[imp.ICUT]
$setlib
$cms sh class 
$!
$sd srt:[imp.IDIFFERENCE]
$setlib
$cms sh class 
$!
$sd srt:[imp.IFILTER]
$setlib
$cms sh class 
$!
$sd srt:[imp.IFIXAREA]
$setlib
$cms sh class 
$!
$sd srt:[imp.IFROMTEXT]
$setlib
$cms sh class 
$!
$sd srt:[imp.IINFO]
$setlib
$cms sh class 
$!
$sd srt:[imp.ILAYFC]
$setlib
$cms sh class 
$!
$sd srt:[imp.IMEND]
$setlib
$cms sh class 
$!
$sd srt:[imp.IMERGE]
$setlib
$cms sh class 
$!
$sd srt:[imp.IPATCH]
$setlib
$cms sh class 
$!
$sd srt:[imp.IRECODE]
$setlib
$cms sh class 
$!
$sd srt:[imp.IRENUMBER]
$setlib
$cms sh class 
$!
$sd srt:[imp.IREPORT]
$setlib
$cms sh class 
$!
$sd srt:[imp.ISELAC]
$setlib
$cms sh class 
$!
$sd srt:[imp.ISELECT]
$setlib
$cms sh class 
$!
$sd srt:[imp.ISORT]
$setlib
$cms sh class 
$!
$sd srt:[imp.ISTART]
$setlib
$cms sh class 
$!
$sd srt:[imp.ITOTEXT]
$setlib
$cms sh class 
$!
$sd srt:[imp.ITRANS]
$setlib
$cms sh class 
$!
$sd srt:[imp.IWINDOW]
$setlib
$cms sh class 
$sd srt:[imp.IWINDOW.POLY]
$setlib
$cms sh class 
$!
