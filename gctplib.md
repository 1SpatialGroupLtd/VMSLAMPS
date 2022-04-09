GCTPLIB - General Coordinate transformation library
======

Introduction
-----

Buried in LSLMAINT there is a modified copy of the FORTRAN GCTPLIB
library original released by U.S.G.S. , GCTP was developed (1980) by
Snyder and Elassel, while they were employed by the US Federal
government, and hence is automatically Public Domain, so there is no
US copyright on that starting point code. For background to GCTP see
(https://nweb.ngs.noaa.gov/PUBS_LIB/GeneralCartographicTransformationPackage_v2_TR_NOS124_CGS9.pdf).

There are several public versions of GCTP:
* GCTP/I - original from 1980
* GCTP/II - improved circa 1984 (Fortran 77)
* GCTP v3.2 - (Fortran 90)
* CGCTP - (C programming language)

The file headers in this release suggest the original code is Version
1.0.2 (1983) or later and we made changes Nov-1985 onwards. It is quite
possible that this is based on GCTP/I rather than GCTP/II.

As per (https://www.gnu.org/licenses/gpl-faq.html#GPLUSGov) that code can
be considered open source. However we have since added to that, we are
releasing those changes as GPLV3.

Spaces
-----

Standard GCTP supported the following "spaces" (Geographic is not a projection)

* (0) Geographic - ie Long,Lat
* (1) U T M
* (2) STATE PLANE
* (3) ALBERS CONICAL EQUAL-AREA
* (4) LAMBERT CONFORMAL CONIC
* (5) MERCATOR
* (6) POLAR STEREOGRAPHIC
* (7) POLYCONIC
* (8) EQUIDISTANT CONIC
* (9) TRANSVERSE MERCATOR
* (10) STEREOGRAPHIC
* (11) LAMBERT AZIMUTHAL EQUAL-AREA
* (12) AZIMUTHAL EQUIDISTANT
* (13) GNOMONIC
* (14) ORTHOGRAPHIC
* (15) GENERAL VERTICAL NEAR-SIDE PERSPECTIVE
* (16) SINUSOIDAL
* (17) EQUIRECTANGULAR (PLATE CARREE)
* (18) MILLER CYLINDRICAL
* (19) VAN DER GRINTEN I
* (20) OBLIQUE MERCATOR (HOTINE)

In addition this version of GCPTLIB contains the following additional
projections:

* (21) Oblique Mercator (spherical) (Added 1986) - A simplified version of
Oblique Mercator (Hotine).
* (22) Oblique Stereographic (specific) (Added 1986)
* (23) Cassini (Added 1992)
* (24) Krovak (Added 1993)
* (25) Bonne (Added 1993)
* (26) Mollweide (Added 1993)
* (27) Hammer-Aitof (Added 1993)
* (28) Winkel III. (Added 1993)
* (29) Miller oblate stereographic (Added 1995)
* (30) Another copy of Cassini
* (31) Another copy of Cassini

History
-----
History information for this version:-

* 15-OCT-1993 - entered into CMS
* 18-OCT-1993 - Identified as lampsv4.2
* 18-OCT-1993 - fix /optimization option
* 19-OCT-1993 - GCTP_CF_PROJ.SRC added
* 20-OCT-1993 - add pj0n$1.src (separate files for inverse transformation).
* 21-OCT-1993 - unspecified updates to PJ22$0.SRC, PJ28$0.SRC, PJ1A$0.SRC
*  8-NOV-1993 - new pj0n$1 routines for inverse transform
* 24-NOV-1993 - use CF01, not CF01$1 entry points
* 21-JUL-1994 - WI/CC 1388 - bug fixes to Bonne projection and other tidies
   NEWTON2D.SRC, PJ01$0.SRC, PJ09$0.SRC, PJ09$1.SRC, PJ21$0.SRC, PJ21$1.SRC
   PJ24$0.SRC, PJ24$1.SRC, PJ25$0.SRC, PJ25$1.SRC, PJ26$0.SRC, PJ26$1.SRC,
   PJ27$0.SRC, PJ27$1.SRC, PJ28$0.SRC, PJ01$1.SRC and PJ28$1.SRC
* 21-JUL-1994 - GCTPLIB.UPD added to CMS
*  9-DEC-1994 - Update GCTPLIB.UPD with more complete version
*  5-APR-1995 - Don't want an OLB in the CMS
* 19-OCT-1995 - WI/CC 1500 - Miller's Oblate Modified Stereographic proj. for Philips
   GTP$0.SRC, GTRN$0.SRC, PJ29$0.SRC, PJ29$1.SRC, PJ31$0.SRC, PJ31$1.SRC
   and GCTP_CF_PROJ.SRC
* 10-OCT-1996 - updated GCTPLIB.COM on WI/CC 1500 (almost a year later?)
* 11-OCT-1996 - Identified as 'Saved prior to converion to Fortran 77'
* 11-OCT-1996 - WI/CC 1514 - convert to F77
* 14-OCT-1996 - WI/CC 1559 SPR 3246 Fix ITRANS on AXP
   PJ24$0.SRC and PJ24$1.SRC
* 17-JUN-1999 - WI/CC 1598 - fix Oblique Mercator
   PJ21$0.SRC

Unix implementation
-----

A second copy of the code has been used on Unix (and now Windows) with
additional improvements and extensions. This is currently compiled from
the output of the f2c utility using the native C compiler.

As per (https://www.gnu.org/licenses/gpl-faq.html#ReleaseUnderGPLAndNF),
1Spatial also have a non-free version of this which is not released here.
This has additional UI elements and few changes to this code.
Obvious changes are:

* Implicit none
* Initialise results even in error cases.
* Make some constants explicitly Double precision
* A number of additional improvements.
* Longitudinal Range Shift.
* 7 parameters Datum shift
* (ARCK) Equal ARC-Second Raster Chart (in C)
* (NZMGK) New Zealand Map Grid (Replacing Cassini in Slot 30) 
* (RSO) Rectified Skew Orthomorphic Kind (in C)
* (LCC_1K) Lamberts Conformal Conic - 1 parallel Kind (replacing Cassini in Slot 31)
* (OSK) Oblique Stereographic Kind (in Slot 32)
* while present in the code, projections 1,2 and 22 are never used. 
* UTM projections are defined as transverse mercator at a higher level.

The non-free version has a revision history (relevant to the Fortran):

* Mar-1992 v1-0 Presumed derived from the VMS code.
* Dec-1995 v1-18 Major changes to close to what is here.
* Oct-1996 V1-24 Minor patch closer to VMS sources
* Jul-1999 V1-39 Minor patch closer to VMS sources
* Jun-2002 V1-45 Minor patch closer to VMS sources
* Oct-2016 v1-58 Latest release.

There may be additional fragments of code like this in the VMSLAMP
repository. 1Spatial reserves the right to retain private non-free
versions of that code. There is no commercial reason to invest the
effort in identifying such code.
