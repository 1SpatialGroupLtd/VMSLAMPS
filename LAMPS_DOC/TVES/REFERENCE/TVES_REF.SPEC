
! TVES_REF.SPEC
! specification for the TVES reference manual

! note that we want three title pages, one for each of three volumes,
! so we must use the VOLUMES command
volumes		3

auto_title
title		TVES
title		Reference_ Manual
issue		2.2
short_title	TVES REFERENCE
category	REFERENCE
author		Various
date		22-Feb-1993

changes
!preface
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
Chapter		COVER		COVER - Intervisibility Calculation 
Chapter		DTICHECK	DTICHECK - DTI File checking Utility
Chapter		DTICONTOUR	DTICONTOUR - DTI contouring Utility
Chapter		I2GRID		I2GRID - Raster to Vector Conversion
Chapter		PROFILE		PROFILE - Vector Profile Generation
Chapter		SLOPES		SLOPES - Slope and Aspect Calculation
Chapter		ROVER		ROVER - Combined Raster and Vector Display
Chapter		VECTORISE	VECTORISE - Raster to Vector Conversion

