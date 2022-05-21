C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1991-10-22 12:26:24.000000000 +0100
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
	SUBROUTINE 	SET_ASCII
CDEC$	IDENT	'22OC91'
C
C	Copyright (C)				Laser-Scan Ltd., Cambridge
C	Auth					01-Oct-1991	Jon Barber
C
C Description:
C
C Set up the accent code/ASCII conversion table
C
	IMPLICIT NONE
C
	INCLUDE 'CMN:FILE.CMN'
C
C-------------------------------------------------------------------------------
C Acute; CAPITAL
C
	ASCII_CODE(1,65) = 193		!A
	ASCII_CODE(1,69) = 201		!E
	ASCII_CODE(1,73) = 205		!I
	ASCII_CODE(1,79) = 211		!O
	ASCII_CODE(1,85) = 218		!U
	ASCII_CODE(1,89) = 221		!Y
C
C Acute; lower
C
	ASCII_CODE(1,97)  = 225		!a
	ASCII_CODE(1,101) = 233		!e
	ASCII_CODE(1,105) = 237		!i
	ASCII_CODE(1,111) = 243		!o
	ASCII_CODE(1,117) = 250		!u
	ASCII_CODE(1,121) = 253		!y
C
C Circumflex; CAPITAL
C
	ASCII_CODE(2,65) = 194		!A
	ASCII_CODE(2,69) = 202		!E
	ASCII_CODE(2,73) = 206		!I
	ASCII_CODE(2,79) = 212		!O
	ASCII_CODE(2,85) = 219		!U
C
C Circumflex; lower
C
	ASCII_CODE(2,97)  = 226		!a
	ASCII_CODE(2,101) = 234		!e
	ASCII_CODE(2,105) = 238		!i
	ASCII_CODE(2,111) = 244		!o
	ASCII_CODE(2,117) = 251		!u
C
C Grave; CAPITAL
C
	ASCII_CODE(3,65) = 192		!A
	ASCII_CODE(3,69) = 200		!E
	ASCII_CODE(3,73) = 204		!I
	ASCII_CODE(3,79) = 210		!O
	ASCII_CODE(3,85) = 217		!U
C
C Grave; lower
C
	ASCII_CODE(3,97)  = 224		!a
	ASCII_CODE(3,101) = 232		!e
	ASCII_CODE(3,105) = 236		!i
	ASCII_CODE(3,111) = 242		!o
	ASCII_CODE(3,117) = 249		!u
C
C Umlaut; CAPITAL
C
	ASCII_CODE(4,65) = 196		!A
	ASCII_CODE(4,69) = 203		!E
	ASCII_CODE(4,73) = 207		!I
	ASCII_CODE(4,79) = 214		!O
	ASCII_CODE(4,85) = 220		!U
C
C Umlaut; lower
C
	ASCII_CODE(4,97)  = 228		!a
	ASCII_CODE(4,101) = 235		!e
	ASCII_CODE(4,105) = 239		!i
	ASCII_CODE(4,111) = 246		!o
	ASCII_CODE(4,117) = 252		!u
C
C Boll (ring); CAPITAL
C
	ASCII_CODE(7,65) = 197		!A
C
C Boll (ring); lower
C
	ASCII_CODE(7,97) = 229		!a
C
C Hacek; CAPITAL
C
C	ASCII_CODE(10,83) = ?	!S
C
C Hacek; lower
C
C	ASCII_CODE(10,115) = ?	!s
C
C Inferior macron; lower
C
	ASCII_CODE(12,97)  = 170	!a
	ASCII_CODE(12,111) = 186	!o
C
C Superior point (ring); CAPITAL
C
	ASCII_CODE(13,65) = 197		!A
C
C Superior point (ring); lower
C
	ASCII_CODE(13,97) = 229		!a
C
C Breve (caron); CAPITAL
C
C	ASCII_CODE(14,83) = ?	!S
C	ASCII_CODE(14,90) = ?	!Z
C
C Breve (caron); lower
C
C	ASCII_CODE(14,115) = ?	!s
C	ASCII_CODE(14,122) = ?	!z
C
C Cedilla; CAPITAL
C
	ASCII_CODE(17,67) = 199		!C
C
C Cedilla; lower
C
	ASCII_CODE(17,99) = 231		!c
C
C Slash-L; CAPITAL
C
C	ASCII_CODE(18,76)  = ?	!L
C
C Slash-l; lower
C
C	ASCII_CODE(18,108) = ?	!l
C
C Diphthong-O; CAPITAL
C
C	ASCII_CODE(19,79)  = ?	!O
C
C Diphthong-o; lower
C
C	ASCII_CODE(19,111) = ?	!o
C
C Icelandic-D; CAPITAL
C
	ASCII_CODE(21,68)  = 208	!D
	ASCII_CODE(21,73)  = 208	!I
	ASCII_CODE(21,85)  = 208	!U
C
C Icelandic-d; lower
C
	ASCII_CODE(21,100) = 240	!d
	ASCII_CODE(21,105) = 240	!i
	ASCII_CODE(21,117) = 240	!u

C
C Dotless-I; CAPITAL
C
C	ASCII_CODE(22,73)  = ?	!I
C
C Dotless-i; lower
C
C	ASCII_CODE(22,105) = ?	!i
C
C Diphthong-A; CAPITAL
C
	ASCII_CODE(24,65) = 198		!A
C
C Diphthong-a; lower
C
	ASCII_CODE(24,97) = 230		!a
C
C Cedilla; CAPITAL
C
	ASCII_CODE(50,67) = 199		!C
C
C Cedilla; lower
C
	ASCII_CODE(50,99) = 231		!c
C
C Tilde; CAPITAL
C
	ASCII_CODE(60,65) = 195		!A
	ASCII_CODE(60,78) = 209		!N
	ASCII_CODE(60,79) = 213		!O
C
C Tilde; lower
C
	ASCII_CODE(60,97)  = 227	!a
	ASCII_CODE(60,110) = 241	!n
	ASCII_CODE(60,111) = 245	!o
C
C Slash-O; CAPITAL
C
	ASCII_CODE(80,79)  = 216	!O
C
C Slash-o; lower
C
	ASCII_CODE(80,111) = 248	!o
C
C *****************************************************
C
	RETURN
	END
C
