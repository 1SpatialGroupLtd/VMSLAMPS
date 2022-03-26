
! DTMCONVERT_REF.SPEC
! specification for the DTMCONVERT reference manual

auto_title
title		DTMCONVERT
title		Reference_ Manual
issue		2.7
short_title	DTMCONVERT
category	REFERENCE
author		J Cadogan
date		18-Dec-1996

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

! We use the default chapter title (ie the file-name) for each MODULE
! flag page

prefix_chapter	MODULE

! But note that the TITLEs will use the title supplied separately

Chapter		INTRODUCTION	Introduction
Chapter		DTI2DTED
Chapter		DTED2DTI
Chapter		NTF2DTI
Chapter		DTEDIFF
Chapter	 	IIS2DTI
Chapter		DTI2IIS
Chapter		DEM2DTI
Chapter		DTI2DEM
Chapter		MNT2DTI
Chapter		DTI2NTF

