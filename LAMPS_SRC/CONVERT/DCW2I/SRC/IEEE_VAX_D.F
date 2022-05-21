C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1992-06-01 15:23:28.000000000 +0100
C *
C * This program is free software: you can redistribute it and/or modify
C * it under the terms of the GNU General Public License as published by
C * the Free Software Foundation, version 3.
C *
C * This program is distributed in the hope that it will be useful, but
C * WITHOUT ANY WARRANTY; without even the implied warranty of
C * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
C * General Public License for more details.
C *
C * You should have received a copy of the GNU General Public License
C * along with this program. If not, see http://www.gnu.org/licenses/.
C
c ST -- 1/6/92 -- Function IEEE_VAX_D(Value)
c
c This function takes an IEEE format MC68881 Double precision floating
c point number and returns the VAX D_floating form of the number if it
c is in range.
c
c Note: The smallest vax floating point number is 4 times smaller than
c       the smallest ieee floating point number in normallized form.
c	The largest vax floating point number is .5 times as large as
c	the largest ieee floating point number.
c
c	Actual ranges:
c
c		Vax			IEEE
c		---			----
c
c	max	1.7014119x10**38	
c	min	0.29387365x10**-38	
c					
c
c Let E = the exponent part of the real (in signed magnitude form), and
c let M = the mantisa, and S = the sign. The vax represents floating point
c numbers as:
c
c	S bit -- bit 15
c	E     -- bits 7-14, 8 bit, excess 128 exponent.
c	M     -- bits 6(MSB)-0 and bits 31-16(LSB) unsigned fraction.
c       Numbers are stored in a normalized form with a hidden 1 bit
c	representing a 0.1 is immediately to the left of the MSB of M. Note
c	that the radix point of the fraction is to the left of the hidden
c	bit in this form.
c
c	IF E .ge. 1 then
c		value = (-1)**S x 2**(E-1023) x 0.1M
c	IF S .eq. 0 .and. E .eq. 0 then
c		value = 0 (unsigned)
c	IF S .eq. 1 .and. E .eq. 0 then
c		illegal value, signalled on attempted operation.
c
c The IEEE representation is as follows:
c
c	S bit -- bit 31
c	E     -- bits 23-30, 8 bit, excess 127 binary exponent.
c	M     -- bits 22(MSB) - 0(LSB) unsigned fraction.
c	Numbers are stored in either normalized or de-normalized form. In
c       normalized form (the usual representation) a hidden 1 bit representing
c       a 1.0 is immediatly to the left of the MSB of M. In denormalized form,
c       the hidden bit is 0. See below. Note that in IEEE form, the radix point
c	of the fraction is to the right of the hidden bit.
c
c	IF E .ge. 1 .and. E .le. 2046 then
c		actual value = (-1)**S x 2**(E-1023) x 1.M
c	IF E .eq. 0 .and. M .eq. 0 then
c		value = signed zero (S bit is preserved)
c	IF E .eq. 2047 .and. M .ne. 0 then
c		not a number (NAN). M can have any bit pattern, and the
c		result of any operation on a NAN with the MSB of F set
c		on an IEEE implementation results in a signal. The
c		interpretation on any value associated with a NAN is left
c		to the application.
c	IF E .eq. 2047 .and. M .eq. 0 then
c		value = Plus or minus infinity, depending on S.
c	IF E .eq. 0 .and. M .ne. 0 then
c		denormalized number, used to represent numbers less 
c		than can be represented in normalized form. The hidden bit
c		is assumed to a zero.
c		value = (-1)**S x 2**(E-126) x 0.M
c
c Note that the vax and ieee forms differ by a bias of 1 in their stored
c exponent form, and that they also differ implicitly by a power of 2 due to
c the difference in normalization scalling (ieee = 1.M, vax = 0.1M).
c Thus the conversion for the exponent is Evax = Eieee + 2. Further, the vax
c can represent smaller numbers in normallized form than can the 68881, so
c this routine converts the de-normalized numbers that are representable
c on the vax. Thus, all ieee normalized numbers with exponents less than 254
c are convertable to vax representations. Further, Some of the de-normalized
c numbers are convertable. Loss of range (overflow) occurs on the high end.
c The actual conversion outline follows:
c
c Normallized numbers:
c
c	numbers in the magnitude of:
c		1.175495 x 10**-38 to 1.7014119 x 10**38
c	are converted exactly, with no loss of precision.
c
c	numbers with a magnitude greater than 1.7014119 x 10**38
c       are converted to a vax reserved operand with sign of 1 and
c	exponent and mantissa of zero. This is the equivalent of
c       the result of a floating overflow on a 780 class machine.
c
c De-normalized numbers:
c
c	numbers in the magnitude of:
c		0.29387365 x 10**-38 to 1.175494 x 10**-38
c	are converted. Note that while the conversion is exact,
c       the vax has 1 to 2 bits more precision in this range than is
c	represenatble in the ieee form. The extra 1 or 2 bits are assigned
c       zeros in the conversion.
c
c	numbers less than 0.29387365 x10**-38 are mapped on to vax zero
c	with S=0, E=0, and M=0.
c
c Zeros:
c
c	both positive and minus zero in the ieee implementation are
c	mapped on to vax zero with S=0, M=0, and E=0.
c
c Infinities:
c
c	Infinities have no dual in the vax architecture, as such, the
c	value mapped is a vax reserved operand, with S=1, E=0, and M=0.
c	This is the equivalent of a floating overflow result on the
c	780 class machines.
c
c Not Numbers (NAN's):
c
c	These are mapped onto vax operands by setting the sign bit,
c	clearing the exponent, and preserving the mantissa. Note that
c	this conversion losses the original sign bit. The ieee representation
c       has twice as many NAN's as the vax, so half are lost.
c

	integer*4 function IEEE_VAX_D(value) ! really of type bit vector.

	implicit	none

	integer*4 	value

	integer*4 	S
	integer*4 	E
	integer*4 	M

	integer*4 	lib$extzv

c Fetch the fields from IEEE format:
c
c	31 30          23 22                           0
c      +--+--------------+------------------------------+
c      | S| Exponent     |MSB   Mantissa             LSB|
c      +--+--------------+------------------------------+
c
	S = lib$extzv(31,1,value)
	E = lib$extzv(23,8,value)
	M = lib$extzv(0,23,value)

c Note: The following code is optimized to deal with the two most likely
c       casses first: namely, normal values and zeros.
c

c Zeros and de-normalized numbers:

	if ( E .eq. 0 ) then

c Zeros:
	  if( M .eq. 0 ) then
	    S = 0

c de-normalized number:

	  else ! M .ne. 0

c          number is representable if  bit 21 or 22 is set.
c          shift the mantisa the right number of bits and strip the
c          high order set bit which becomes the hidden bit on the vax.
c          Numbers outside the representable range are set to zero.

	    if ( ( M .and. '400000'x) .ne. 0 ) then
	      M = (M .or. '3FFFFF'x) * 2
	      E = 2
	    else if ( ( M .and. '200000'x) .ne. 0 ) then
	      M = (M .or. '1FFFFF'x) * 4
	      E = 1
	    else
	      S = 0
	      E = 0
	      M = 0
	      end if
	    end if

c Normal value:

	else if ( E .lt. 254 ) then
	  E = E + 2


c un-representable (overflow)

	else if ( E .eq. 254 ) then
	  S = 1
	  E = 0
	  M = 0

c Infinities and NAN's

	else ! E .eq. 255
	  S = 1
	  E = 0

	  end if

c Store the numbers in vax format.
c
c	31                   16 15 14       7 6           0
c      +-----------------------+--+----------+-------------+
c      |    Mantissa        LSB| S| Exponent |MSB Mantissa |
c      +-----------------------+--+----------+-------------+
c
	call lib$insv(S,15,1,ieee_vax_d)
	call lib$insv(E, 7,8,ieee_vax_d)
	call lib$insv(lib$extzv(16,7,M),0,7,ieee_vax_d)
	call lib$insv(lib$extzv(0,16,M),16,16,ieee_vax_d)

	return
	end
