! IFFDCW.SPEC
! Specification for the IFFDCW module in the CONVERT reference manual
! Package leader: Steve Townrow
!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!
! NOTES RELEVANT TO PRODUCTION OF A NEW/ALTERED DOCUMENT
! ======================================================
!
! If the error messages for a utility are generated automatically by NEWMSG,
! then the following must be remembered:
!
! 1) If the utility that the messages belong to is (for instance) I2OSTF in
!    the package IFFOSTF, then the I2OSTFMSG.RNO file produced by NEWMSG
!    should be renamed to OSTF_I2OSTFMSG.RNO - ie, prefixed by the module
!    mnemonic like all other files belonging to that module.
!
! 2) The header levels in the .HL commands generated by NEWMSG will be wrong.
!    NEWMSG assumes that the titles for each message severity will be at
!    .HL 1, whereas the conventions for this document require them to be
!    at .HL 2. You will therefore have to edit the message file to correct
!    these header levels.
!
!				NOTE
!	Don't forget to use the 'Replace' command in the original .MES
!	file to specify how those EXPAND escape sequences should appear
!	in the .RNO file - if the message file for a program you are
!	working on doesn't, then please correct it. The more automatic
!	the generation of the message documentation, the better.
!
! 3) Don't forget to edit the xxx_CHANGES.RNO file to note what you have done.
!    It is OK to have several changes under one issue number, so long as the
!    document has not been issued.
!
! 4) Update the date, issue number (if necessary) and author fields below
!
! 5) If the change represents a change in the program, as well as in the
!    documentation, don't forget to edit/create an appropriate release
!    note. See the Package Leader if you have any problems.
!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!
! Automatically generate our title page
! (NOTE that the 'author' and 'date' reflect who last changed the document,
!	and when, rather than any original authorship. Any further history
!	should be contained in the CHANGES notes)
!
auto_title
title		CONVERT_ PACKAGE
title		IFFDCW_ Reference
issue		1.2
short_title	IFFDCW REFERENCE
category	REFERENCE
author		S Townrow
date		14-May-1993

changes		dcw_changes		! have change record for each utility
preface
contents
!index		! one day we want an index, but there's a lot of work to do yet

! The next three commands are strictly redundant, as they describe the
! default situation. However, they should be included as they make it
! more obvious what is going on.

no_section_numbers
!auto_name_chapter
flag_page

! Each chapter describes a module, so our simple naming convention will
! work - ie automatically prefix MODULE to the chapter's file name
	
!prefix_chapter	MODULE

chapter		DCW_FORMAT		DCW format description
chapter		DCW_PREP		DCW data preparation
chapter		DCW_DCW2I		DCW2I utility
