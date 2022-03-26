! DTMCREATE_REF.SPEC
! specification for the DTMCREATE reference manual

volumes		2

auto_title
title		DTMCREATE
title		Reference_ Manual
issue		1.8
short_title	DTMCREATE REFERENCE
category	REFERENCE
author		Steve Townrow
date		12-Oct-1992

changes
preface
contents
index

! The next three commands are strictly redundant, as they describe the
! default situation. However, they should be included as they make it
! more obvious what is going on.

no_section_numbers
auto_name_chapter
flag_page

! We use the default chapter title (ie the file-name) for each MODULEs
! flag page


! But note that the TITLEs will use the title supplied separately

Chapter		INTRODUCTION	General introduction to DTM software
Chapter		PACKAGE__OVERVIEW Introduction to the DTMCREATE package
Chapter		TRIANGULATION	Introduction to the triangulation approach
prefix_chapter	MODULE
Chapter		TRIANG		Triangulation generation
Chapter		TRIDER		Slope derivative estimation
Chapter		TRIEDIT		Interactive triangulation editor
Chapter		TRIGRID		Generation of DTM grid from triangulation

! the appendices 

Appendix	APPENDIX	DTMCREATE graphics lookup files
Appendix	BIBLIOGRAPHY	Bibliography
