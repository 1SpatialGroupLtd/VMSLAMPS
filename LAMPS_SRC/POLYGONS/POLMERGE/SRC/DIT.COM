$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1992-05-14 19:08:56.000000000 +0100
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
$	DEF SYS$INPUT SYS$COMMAND
$!
$	EDT ADJACENT.SRC
$	EDT AMALGAMATE.SRC
$	EDT CALC_AREAS_RATIOS.SRC
$	EDT CHECK_AC_TEXT.SRC
$	EDT CHECK_ISOL.SRC
$	EDT CHECK_NODE_NEIGH.SRC
$	EDT CHECK_NUMERIC_LABEL.SRC
$	EDT CHECK_SEGAC_LABEL.SRC
$	EDT COMPLEX.SRC
$	EDT COMPLEX_PHAN.SRC
$	EDT ELIMINATE.SRC
$	EDT EXTERMINATE.SRC
$	EDT FIND_COMMON.SRC
$	EDT FIND_LARGEST.SRC
$	EDT FIND_OTHERS.SRC
$	EDT FIND_SMALLEST.SRC
$	EDT FLAG_ISOLATIONS.SRC
$	EDT GET_ACTXT.SRC
$	EDT GET_BY_TEXT.SRC
$	EDT GET_MOTHER.SRC
$	EDT GET_NEIGH.SRC
$	EDT GET_POLYGON.SRC
$	EDT GET_SECOND.SRC
$	EDT ISOL_POLY.SRC
$	EDT MERGE.SRC
$	EDT MERGE_FOR_ELIM.SRC
$	EDT NEIGHBOURS.SRC
$	EDT OUTIFJ.SRC
$	EDT TEST_PRIMARY_POLY_LABL.SRC
$	EDT TEST_SECOND_POLY_LABEL.SRC
$	EDT UPDATE_COMPLEX.SRC
$	EDT UPDATE_SEGMENTS.SRC
$	EDT WRITPOL.SRC
$!
$	DEASS SYS$INPUT
