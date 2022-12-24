/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1988-08-09 10:15:22.000000000 +0100
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, version 3.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see http://www.gnu.org/licenses/.
 */
/*
 These logicals are set by IFFNXT or IFFPKE onto a ST,ZS, or CB
 SIMPLE_XY is set true if the entry is really an ST, or it is a CB
 with only X and Y columns (in that order) so that it's data part
 is identical to that of an ST, otherwise it is set false.
 SIMPLE_XYZ is similar, but for ZS, or CB resembling a ZS.
 Both are always set.
*/

struct iffstr_tag {
	unsigned int
		simple_xy,
		simple_xyz;
	} iffstr;
