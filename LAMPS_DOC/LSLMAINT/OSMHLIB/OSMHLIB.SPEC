! OSMHLIB.SPEC
! specification for the OSMHLIB/OSMHLIBV reference manual
!
auto_title
title		OSMHLIB/OSMHLIBV
title		Technical_ Reference_ Manual
date		11-Jun-1991
author		S Townrow
short_title	OSMHLIB REF
category	Technical
issue		1.1

changes
contents
!index

! Note that the OSMHLIB manual is somewhat strange
! - we want section numbers, and automatically named chapters,
!   but we don't want the chapter title to be on a flag page

section_numbers
auto_name_chapter
flag_page

Chapter		INTRODUCTION	Introduction
Chapter		OSMH		Type 2 OS map header routines
Chapter		OSMH_NEW	Type 3 and 4 OS map header routines
Chapter		OSMH_VIO	VIOLIB versions of OSMHLIB routines for DIGSYS

Appendix	INTERFACE	OSMHLIB/OSMHLIBV interface blocks
Appendix	TABLE		OSMHLIB/OSMHLIBV translation table
Appendix	MESSAGES	OSMHLIB/OSMHLIBV success/error codes

