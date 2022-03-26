! LSLLIB.SPEC
! specification for the LSLLIB reference manual

auto_title
title		LSLLIB
title		Technical_ Reference_ Manual
date		29-Sep-1993
author		J Barber, TJ Ibbs, CC Brunt, RW Russell
short_title	LSLLIB REF
category	Technical
issue		1.13

note
note	The Facility Number Manager is: Paul Hardy
note	Consult him before allocating a new facility number for message definition.
note

changes
contents
index

! Note that the LSLLIB manual is somewhat strange
! - we want section numbers, and automatically named chapters,
!   but we don't want the chapter title to be on a flag page

section_numbers
auto_name_chapter
no_flag_page

Chapter		INTRODUCTION	Introduction
Chapter		LSLINIT		The start and end of programs
Chapter		ERROR_DEFN	Error message definition
Chapter		ERROR_RTNS	Error message routines
Chapter		EXCEPTION	/EXCEPTION/ - errors and exceptions
Chapter		EXPC		/EXPC/ - the output common block
Chapter		EXPAND		Using /EXPC/ - text expansion
Chapter		TXTC		/TXTC/ - the input common block
Chapter		CHARACTER	Basic routines for reading from /TXTC/
Chapter		NUMBERS		Reading numbers
Chapter		STRINGS		Reading strings
Chapter		FILENAME	Filename parsing routines
Chapter		TERMINAL	Terminal input/output
Chapter		FILE		File read and write routines
Chapter		DCL		DCL command line interpretation
Chapter		COMMANDS	Command decoding
Chapter		IFF		IFF file opening routines
Chapter		MAPPED		Mapped section files
Chapter		MAGTAPE		Basic magnetic tape I/O routines
Chapter		SYSTEM		Routines to ease use of system facilities
Chapter		SORT		Sort routines

Appendix	MESSAGES	LSLLIB success/error codes
Appendix	COMPARISON	Differences from VIOLIB/CMDLIB

