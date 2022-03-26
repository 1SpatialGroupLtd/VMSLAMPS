!************************************************************************
!*** See the documentation on STANDARD_RNO for the commands available ***
!*** in a SPEC file. If you can't find a paper copy, give the command ***
!***								      ***
!***			STANDARD_RNO  ?				      ***
!***								      ***
!*** at the dollar prompt. Don't forget to correct all of the pieces  ***
!*** of text within "<<" and ">>", and delete one of the title lines  ***
!*** below - the ones that start "specification file for"	      ***
!***								      ***
!*** (Also, you can delete these bits in asterisked boxes!)	      ***
!************************************************************************
! specification file for the <<PACKAGE>> package reference manual
! specification file for the <<PACKAGE>> package user guide

! set up the title page for the document

auto_title
title		<<PACKAGE>>
title		<<next_ line_ of_ title>>
short_title	<<short title>>
category	<<category>>
author		<<person who last edited>>
issue		<<issue no>>
date		<<date last edited>>

contents
changes
preface
contents
index

! set up the standard chapter description - no section numbers, no blank
! lines in front of a .HL, chapter names made up automatically (and thus
! no .CHAPTER or .APPENDIX commands inside the files), and the CHAPTER
! name output on a separate page, which can then be discarded, or kept as
! a divider.

no_section_numbers
auto_name_chapter
flag_page

!*********************************************************************
!*** The default template file uses each chapter's filename as its ***
!*** title, with "MODULE" in front. Alternatively, remove the      ***
!*** PREFIX_CHAPTER command, and instead add a title after each    ***
!*** filename - for instance					   ***
!***								   ***
!***		chapter  INTRODUCTION  The introduction		   ***
!***								   ***
!*********************************************************************

prefix_chapter	MODULE

! define the chapters and appendices to be included in the document

Chapter		INTRODUCTION


