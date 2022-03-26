
! MATRIX_REF.SPEC
! specification for the MATRIX reference manual

! note that we want three title pages, one for each of three volumes,
! so we must use the VOLUMES command

! note that the PACKAGE APPENDIX must be included from the last chapter to
! appear in the index and contents correctly. --  Use .REQUIRE "APPENDIX.RNO" --
! Delete it from its current position and move it to the last chapter.
! It is now written from DTIFROMTEXT.

volumes		3

auto_title
title		MATRIX
title		Reference_ Manual
issue		3.7
short_title	MATRIX REFERENCE
category	REFERENCE
author		M Wenham
date		5-Jun-1997

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
Chapter		DTIVIEW		DTIVIEW - DTM 3-D Viewing Utility
Chapter		DTIEDIT		DTIEDIT - DTI File Screen Editor
Chapter		DTIBLEND	DTIBLEND - DTI File Edge Blend Utility
Chapter		DTITILE         DTITILE - DTI File Merge Utility
Chapter		DTICOMBINE	DTICOMBINE - DTI File Combine Utility
Chapter		DTIROTATE	DTIROTATE - DTI File Rotation Utility
Chapter		DTI2TEXT	DTI2TEXT - DTI to Text File Conversion
Chapter		DTICONVERT	DTICONVERT - DTI Header and Data Conversion
Chapter		DTIPATCH	DTIPATCH - DTI File Header Editor
Chapter		DTITRANS	DTITRANS - Projection Change and Resampling
Chapter		DTILIB		DTILIB - DTI Applications Library
Chapter		DTIFROMTEXT	DTIFROMTEXT - DTI from Text File Conversion
!                                             includes and the Appendix

