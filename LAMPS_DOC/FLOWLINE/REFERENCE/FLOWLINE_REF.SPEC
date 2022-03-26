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
! specification file for the FLOWLINE package reference manual

! set up the title page for the document

auto_title
title		FLOWLINE
title		Flowline Control System Definition and Operation Package
short_title	FLOWLINE
category	Reference Manual 
author		M Reid, J Billing, CC Brunt, JM Cadogan
issue		2.3
date		21-Jan-1993

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
!***		chapter  INTRODUCTION  The introdcution		   ***
!***								   ***
!*********************************************************************


! define the chapters and appendices to be included in the document

Chapter		INTRODUCTION  Introduction
Chapter		CONCEPTS      Database Concepts and Definition
Chapter         SYSTEM        System Operation and Management
Chapter         COMMAND       Flowline Command Files
Chapter		LAMPSCONTROL  MODULE LAMPSCONTROL
Chapter         FLN_MESSAGES  Flowline Library Messages
Appendix        DB_SPEC       Database Definitions
