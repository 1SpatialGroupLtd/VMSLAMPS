!
! IMP_REF.SPEC
! specification for the IMP reference manual

! note that we want three title pages, one for each of three volumes,
! so we must use the VOLUMES command
volumes		3

auto_title
title		IMP
title		Reference_ Manual
issue		5.9
short_title	IMP REFERENCE
category	REFERENCE
author		Matt Wenham
date		3-Dec-1997

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

prefix_chapter	MODULE

! But note that the TITLEs will use the title supplied separately

Chapter		INTRODUCTION	Introduction
Chapter		ICHECK		ICHECK - IFF geometry checking utility
Chapter		IDIFFERENCE	IDIFFERENCE - IFF comparison utility
Chapter		IFILTER		IFILTER - IFF smooth and filter utility
Chapter		IFIXAREA	IFIXAREA - IFF area checking utility
Chapter		IFROMTEXT	IFROMTEXT - IFF input from text file utility
Chapter		IINFO		IINFO - IFF brief report utility
Chapter		ILAYFC		ILAYFC - IFF feature code by layer utility
Chapter		IMEND		IMEND - IFF recovery utility
Chapter		IMERGE		IMERGE - IFF file merge utility
Chapter		IPATCH		IPATCH - IFF patch editor
Chapter		IRECODE		IRECODE - IFF data coding manipulation utility
Chapter		IRENUMBER	IRENUMBER - IFF feature renumbering utility
Chapter		IREPORT		IREPORT - IFF entry report utility
Chapter		ISELAC		ISELAC - IFF select by AC utility
Chapter		ISELECT		ISELECT - IFF selection by entry utility
Chapter		ISORT		ISORT - IFF sort utility
Chapter		ISTART		ISTART - IFF template file creation utility
Chapter		ITOTEXT		ITOTEXT - IFF output to text file utility
Chapter		ITRANS		ITRANS - IFF transformation utility
Chapter		IWINDOW		IWINDOW - IFF windowing utility
Chapter		ICUT		ICUT - IFF feature manipulation utility

! the appendices (previously all together in the file ITRANS_APPENDICES)
! are now separated into three files:

Appendix	ITRANS_SPHEROIDS	ITRANS - Spheroids offered
Appendix	ITRANS_PROJECTIONS	ITRANS - Projections offered
Appendix	ITRANS_FORMATS		ITRANS - Number formats for prompts

