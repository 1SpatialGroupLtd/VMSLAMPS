C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1990-08-16 16:39:16.000000000 +0100
C *
C * This program is free software: you can redistribute it and/or modify
C * it under the terms of the GNU General Public License as published by
C * the Free Software Foundation, version 3.
C *
C * This program is distributed in the hope that it will be useful, but
C * WITHOUT ANY WARRANTY; without even the implied warranty of
C * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
C * General Public License for more details.
C *
C * You should have received a copy of the GNU General Public License
C * along with this program. If not, see http://www.gnu.org/licenses/.
C
	BLOCK DATA MNT_OFF
C
CDEC$	IDENT	'21AU90'
C
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created					ST	24-Jul-1990
C
C Description:
C
C	Block data definition for MNT header and data record byte offsets
C	and field lengths
C
	IMPLICIT NONE
C
C Common blocks
C
	INCLUDE 'LSL$MNT2DTI:COMMANDS.CMN'	! Command switches
	INCLUDE 'LSL$MNT2DTI:MNT_HEADER.CMN'	! MNT header record
	INCLUDE 'LSL$MNT2DTI:MNT_DATA.CMN'	! MNT data record
C
C Command parameters
C
	DATA	BLKSIZ	/ 4096 /		! Default tape blocksize
C
C MNT header record
C
C				offset		element   name
C
	DATA	MNTHOFF(1),MNTHBYT(1)	/ 57,100 /	! (1)	MNTNAM
	DATA	MNTHOFF(2),MNTHBYT(2)	/ 157,4 /	! (2)	MNTSYS
	DATA	MNTHOFF(3),MNTHBYT(3)	/ 161,15 /	! (3)	MNTCORN 
	DATA	MNTHOFF(4),MNTHBYT(4)	/ 281,10 /	! (4)	MNTPTSEP
	DATA	MNTHOFF(5),MNTHBYT(5)	/ 291,10 /	! (5)	MNTPRSEP
	DATA	MNTHOFF(6),MNTHBYT(6)	/ 301,20 /	! (6)	MNTXYUN
	DATA	MNTHOFF(7),MNTHBYT(7)	/ 321,10 /	! (7)	MNTPOINTS
	DATA	MNTHOFF(8),MNTHBYT(8)	/ 331,10 /	! (8)	MNTPROFS
	DATA	MNTHOFF(9),MNTHBYT(9)	/ 351,10 /	! (9)	MNTSIN
	DATA	MNTHOFF(10),MNTHBYT(10)	/ 361,10 /	! (10)	MNTCOS
	DATA	MNTHOFF(11),MNTHBYT(11)	/ 381,10 /	! (11)	MNTZRNG
	DATA	MNTHOFF(12),MNTHBYT(12)	/ 401,10 /	! (12)	MNTZUN
	DATA	MNTHOFF(13),MNTHBYT(13)	/ 411,5 /	! (13)	MNTDSIZE
C
	END
