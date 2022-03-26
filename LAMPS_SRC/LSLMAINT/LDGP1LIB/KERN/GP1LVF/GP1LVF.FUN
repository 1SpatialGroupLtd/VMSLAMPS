[11L[2"z[1w[11;80s
GP1LVF.FUN









[5w[1;44s
     Kern GP1

     VAX GP1LVF - USER'S GUIDE
     -------------------------











     GP1 LIBRARY VMS/FORTRAN

     718.380.0700





















     Kern & Co. Ltd.
     CH-5001 Aarau, Switzerland
     Optics, Electronics,
     Precision Mechanics



     March 1988
[1w[11;80s

[1w[7;90s
GP1LVF.FUN                                                     PAGE  1
----------------------------------------------------------------------

[5w[4;44s
CONTENTS
--------
[1w[9;88s



                                                        PAGE

[5w[4;44s
1. Introduction       [1w[9;80s                 2
[5w[4;44s
2. The library moduls [1w[9;80s                 3
[5w[4;44s
   List of moduls     [1w[9;80s                 4
[5w[4;44s
3. CALCOMP calls      [1w[9;80s                15
[5w[4;44s
4. Transmission
   programs           [1w[9;80s                16
[5w[4;44s
5. Defining symbols   [1w[9;80s                17
[5w[4;44s
6. Using digitizing
   program WHERED     [1w[9;80s                21
[5w[4;44s
7. I/O with non DEC
   computer           [1w[9;80s                23
[5w[4;44s
8. Hardware connection[1w[9;80s                23
[5w[4;44s
9. ASCII tables       [1w[9;80s                24


[1w[9;80s

GP1LVF.FUN                                              page  2
---------------------------------------------------------------

[5w[6;44s
1. Introduction

[1w[11;80s

The plot subroutines are written in  FORTRAN-77  for  computers
DEC-MicroVAX  under  operating  system  MicroVMS  (others   see
chapter 8).


All basic plot routines are secured as much as possible against
illegal parameter  values.  If such a  value is discovered,  an
error  message appears on the terminal and an error flag GP1ERR
in the COMMON block /GP1C01/  GP1ERR,LEUNIT,ANUNIT  is  set  to
TRUE. The function  is  not  executed and the program continues.
Some errors mostly located  in  the  initialization  are  fatal
errors with program aborting.

Some  routines  which   correspond  to  the  CALCOMP calls  are
included.  They  are  based on the  basic  subroutine calls and
make use of their error handling.

COMMON blocks with the following names are used: GP1C01,GP1C02,
GP1C03, GP1C04, GP1C05, GP1C06.

GPINIT must be  called before any  other plot command is given.
The  plotting  instructions  should  be  terminated  by calling
PLTEND.

For examples using the library refer to the programs

	GPFDIA   Dialogue program (using all moduls of the
                 library)
	GPFPUS   Put user symbols to GP1 and lets store them
	GPFFIL   File transfer to GP1

They are included in the delivery of the library.

GP1LVF.FUN                                              page  3
---------------------------------------------------------------

[5w[6;44s
2. The library moduls

[1w[11;80s

By default,  the  unit for  length and coordinate values are in
mms and may  be changed to cms or inches with SETPAR. The range
for the length and coordinate values is [-1310.69mm..1310.69mm].
Angles are entered by default in  the 360 degree system and may
be changed to gons or rads. They are interpreted counter clock-
wise  from  the  positive x axis  (in  the mathematical sense).
The  ranges  of  the parameter values are shown in brackets [].
The set parameters remain  until a  new  call to the subroutine
is made.  When the GP1  is powered on, the plotting  parameters
are set to their  default values (shown in the manual as D:..).

Variables  starting  with the  letters A..H,O..Z  are reals and
with the letters I..N are integers by default.

GP1LVF.FUN                                              page  4
---------------------------------------------------------------

[5w[6;44s
LIST OF MODULS[1w[11;80s

                                                           PAGE
Control and setting:           Initialize                     5
                               Reset                         13
                               Close plot                    12
                               Plot mode                     11
                               Local mode                    11
                               Get GP1 internal status       14
                               Plot speed                    11
                               Set origin                    11
                               New absolute origin           10
                               Clear window                  11
                               Set window                    11
                               Pen number                     9
                               Move pen up/down              13

Setting plot-parameters:       Scaling x/y                    6
                               Character height               9
                               Character spacing              8
                               Character distance            14
                               Character slant                9
                               Text rotation                  9
                               Text typ                      14
                               Line type                      9
                               Line scale                    10
                               Line ratio                    10
                               Line symbol                   10
                               Line symbol rotation          10
                               Line type/scale/ratio/symbol  12
                               Symbol scale                   7
                               Symbol rotation                7

Plotting commands:             Straight line                  5
                               Spline                         6
                               Circle                         6
                               Symbol                         7
                               Text string                    8
                               Circle with tangentialdrive   14
                               Grid                           8

Various commands:              Digitize                      12
                               Define symbol                 13
                               Store symbol                  13
                               Set parameters (units)        12
                               Get origin/window coordinates 14

CALCOMP calls:                 Plot                          15
                               Factor                        15
                               Number                        15
                               Symbol                        16

GP1LVF.FUN                                              page  5
---------------------------------------------------------------
[5w[6;44s
GPINIT[1w[11;80s
GPINIT initializes the GP1 in the on line  mode and/or  opens a
plot file in the off line mode.

GPINIT must be used before any other plot command is given.

Call: CALL GPINIT (MODE, FILNAM, LUN, ERR)

MODE     plot mode,
         0: off line mode, a plot file is produced,  no connec-
            tion to GP1 is needed
         1: on  line mode, no plot  file is produced,  GP1 must
            be connected with the driving computer
         2: on  and  off line mode,  combination of (0) and (1)

FILNAM   LOGICAL*1 array of minimal dimension 15,  contains the
         plot file name (e.g. '$DISK1:[JOHN]FIRST.DAT')  if its
         needed.

LUN      Set this  parameter to 1. Its only here for compatibi-
         lity to  the RT11 library (same call-parameter  list).
         Has no meaning in VMS operating system.

ERR      LOGICAL*1 error flag. Always set to FALSE.  No meaning
         in VMS operating system (compatibility to  RT11 only).


[5w[6;44s
VECTOR[1w[11;80s
VECTOR moves  the  drafting  tool over the shortest distance to
the target point. The tool can be raised and lowered.
The pen  carriage  will  not be decelerated at the target point
if  IPEN  value  4  is selected. This is useful when many short
straight  lines  are  drawn consecutively. Usually however, for
drawing most lines, option 2 is selected.

Call: CALL VECTOR (XEND,YEND,IPEN)

XEND,YEND   Coordinates of the target point
IPEN        Status of the drafting tool
             2 down with deceleration to target point
             3 up
             4 down without deceleration to target point

GP1LVF.FUN                                              page  6
---------------------------------------------------------------
[5w[6;44s
SCALE[1w[11;80s
With SCALE,  an individual scale  change can be  made for the x
and y axes separately.

Call: CALL SCALE (XSCL,YSCL)

XSCL,YSCL  Scale factors for the x and y axes (D:1)
           Range:[0.01..250.00, with 2 decimals]


[5w[6;44s
CIRCLE[1w[11;80s
With CIRCLE  you  can draw circle segments or complete circles,
providing  you  know the coordinates of the  starting,  end and
center point of the circle.

Call: CALL CIRCLE (XSTART,YSTART,XEND,YEND,XMID,YMID,IFLAG)

XSTART,YSTART   Coordinates of the starting point
XEND,YEND       Coordinates of the end point
XMID,YMID       Coordinates of the center point
IFLAG           Direction of rotation:
                 positive value: Counter clockwise
                 negative value: Clockwise


[5w[6;44s
SPIRAL[1w[11;80s
With SPIRAL,  logarithmic  spirals  or  circle  segments can be
plotted.

Call: CALL SPIRAL (XSTART,YSTART,ANGLE1,ANGLE2,RAD1,RAD2,IFLAG)

XSTART,YSTART   Coordinates of the starting point
ANGLE1,ANGLE2   Angles at the center of the circle with
                 respect to the starting and end point
RAD1,RAD2       Starting and ending radius, respectively
IFLAG           Direction of rotation:
                 positive value: Counter clockwise
                 negative value: Clockwise


[5w[6;44s
SPLINE[1w[11;80s
SPLINE interpolates  a  smooth  curve  through  a  minimum of 3
points.  Starting  and  ending  curvature are 0. With 2 points,
a straight line is plotted.

Call: CALL SPLINE (ILOC,XEND,YEND)

ILOC            0: Continue
                1: End
		2: Begin
XEND,YEND       Coordinates of the supporting points

GP1LVF.FUN                                              page  7
---------------------------------------------------------------

Example: Smooth curve through the points (x(i),y(i)),i=1,100)
                               .
                               .
      CALL SPLINE (2,X(1),Y(1))
      DO 200 I = 2,99
      CALL SPLINE (0,X(I),Y(I))
200   CONTINUE
      CALL SPLINE (1,X(100),Y(100))
                               .
                               .



[5w[6;44s
SYSET[1w[11;80s
With SYSET, the symbol is selected and plotted.

Call: CALL SYSET (NSYMB)

NSYMB   Symbol number [1..57] (D:0) with

        0: No symbol
        1: Circle
        2: Cross
        3: Triangle
        4: Square
        5: Point
        6: Equals sign
        7: Tree
        8: Apostroph
        9: Vertical straight line
       10: Circumflex
    11-25: CALCOMP symbols 0 - 14
    26-57: User defined symbols (can be changed)


[5w[6;44s
SYSCAL[1w[11;80s
SYSCAL allows the actual symbol to be scaled.

Call: CALL SYSCAL (SSYMB)

SSYMB   Height of the symbol [0.05mm..1250.0mm] (D:5.0mm)

[5w[6;44s
SYROTA[1w[11;80s
With  SYROTA,  a  symbol  is  rotated  around its center point.

Call: CALL SYROTA (RSYMB)

RSYMB   Rotation angle [-360.0deg..360.0deg] (D:0deg)

GP1LVF.FUN                                              page  8
---------------------------------------------------------------
[5w[6;44s
CHAR[1w[11;80s
CHAR allows selection of the annotation cell type.

Call: CALL CHAR (ITYP)

ITYP     0: Characters will be evenly spaced, as with a
             conventional typewriter
         1: Each character has a different width, as with
             movable type
             (D:1)

[5w[6;44s
STRSET[1w[11;80s
With STRSET,  a string  of  up to 80 characters can be plotted.

Call: CALL STRSET (TEXT)
      CALL STRSEL (TEXT)

TEXT     CHARACTER*(80) array.
         Blanks at the end of the string  are ignored.
         All ASCII characters are allowed exept "$".
         For newer  GP1 operating system use "STRSEL" which has
         no restriction for use of the "$" sign.


[5w[6;44s
GRID[1w[11;80s
A simple rectangular grid may be drawn.

Call: CALL GRID (XLEFT,YLOWER,XRIGHT,YUPPER,DELX,DELY,PHI)

XLEFT,YLOWER,XRIGHT,YUPPER  X/Y dimension
DELX,DELY                   Grid width
PHI                         Rotation angle

GP1LVF.FUN                                              page  9
---------------------------------------------------------------
[5w[6;44s
STRSCL[1w[11;80s
STRSCL changes the height of the characters

Call: CALL STRSCL (SSTR)

SSTR     Height [0.05mm..1250.0mm] (D:5.0mm)


[5w[6;44s
STROT[1w[11;80s
With STROT,  the whole  character  string is rotated around its
beginning point.

Call: CALL STROT (RSTR)

RSTR     Rotation angle [-360.0deg..360.0deg] (D:0deg)


[5w[6;44s
STRSLN[1w[11;80s
With STRSLN, the slant of the annotation characters is changed.

Call: CALL STRSLN (SLSTR)

SLSTR    Slant angle [60deg..120deg] (D:90.0deg)


[5w[6;44s
PENCHA[1w[11;80s
PENCHA allows a new selection of one of the five plotting tools.
(The fifth is the microscope)

Call: CALL PENCHA (NUMPEN)

NUMPEN    Number of the plotting tool to be selected [1..5].
          (D:1)


[5w[6;44s
LINSET[1w[11;80s
LINSET allows the line type to be changed.

Call: CALL LINSET (NUMLIN)

NUMLIN   Number of the desired line type [1..7]. (D:1)

         1: normal, solid
         2: solid line with symbol
         3: broken line with symbol
         4: dash point line
         5: dash double point line
         6: tree line
         7: symbol only

GP1LVF.FUN                                             page  10
---------------------------------------------------------------
[5w[6;44s
LINSCL[1w[11;80s
LINSCL allows the length of the pen-up segment of a broken line
to be changed.

Call: CALL LINSCL (SLIN)

SLIN     Length of the pen-up segment [0.05mm..1250.0mm]
         (D:5.0mm)


[5w[6;44s
LINRAT[1w[11;80s
LINRAT allows the ratio of  the  pen down  segment of  a broken
line with respect to the pen-up segment to be changed.

Call: CALL LINRAT (RLIN)

RLIN     Scale factor [0.01..250.0] (D:5.0)


[5w[6;44s
LINSYM[1w[11;80s
LINSYM  allows  a  symbol  which  is  embedded  in a line to be
changed.


Call: CALL LINSYM (NSLIN)

NSLIN    Symbol number [1..57] (D:0) , look at SYSET


[5w[6;44s
LINSRO[1w[11;80s
LINSRO is used to rotate a symbol, which is embedded in a  line
type, around its center.

Call: CALL LINSRO (SYROLI)

SYROLI   Rotation angle [-360.0deg..360.0deg] (D:0deg)


[5w[6;44s
NEWORG[1w[11;80s
NEWORG is  used  to set an origin with respect to the reference
point of the plotter (middle of table).

Call: CALL NEWORG (XREF,YREF)

XREF,YREF    Coordinates of the index with reference to the
             origin of the table (D:(0,0))

GP1LVF.FUN                                             page  11
---------------------------------------------------------------
[5w[6;44s
NEWIND[1w[11;80s
NEWIND is used to set a new window.

Call: CALL NEWIND (XLEFT,YLOWER,XRIGHT,YUPPER)

XLEFT,YLOWER    Coordinates of the lower left corner
XRIGHT,YUPPER   Coordinates of the upper right corner


[5w[6;44s
CLRWIN[1w[11;80s
CLRWIN deletes a previously set window.

Call: CALL CLRWIN


[5w[6;44s
SPEED[1w[11;80s
Speed is used to change the plotting speed.

Call: CALL SPEED (IVELOC)

        IVELOC     Speed setting [1..9] (D:9)


[5w[6;44s
SETORG[1w[11;80s
SETORG sets a  new  index  wherever  the plotting  tool is cur-
rently located.

Call: CALL SETORG


[5w[6;44s
LOCAL[1w[11;80s
LOCAL is used to switch to the handcontroller mode.

Call: CALL LOCAL




[5w[6;44s
REMOTE[1w[11;80s
REMOTE is used  to switch  from the  handcontroller mode to the
plot mode.

Call: CALL REMOTE

GP1LVF.FUN                                             page  12
---------------------------------------------------------------
[5w[6;44s
LINE[1w[11;80s
LINE combines  the  functions  LINSET,LINSCL,LINRAT,LINSYM  and
LINSRO.

Call: CALL LINE (NUMLIN,NSLIN,SLIN,RLIN,SYROLI)

NUMLIN         Number of line type
NSLIN          Number of the line symbol
SLIN           Length of the pen-up segment
RLIN           Ratio of  the  pen-down segment  with respect to
	        the pen-up segment
SYROLI         Rotation angle of the symbol in degrees

Input  999 or 999.0 for  parameter  values which should be left
unchanged.


[5w[6;44s
PLTEND[1w[11;80s
PLTEND terminates  a  plot  and  switches  from REMOTE to LOCAL
if  in  the  on  line  mode  and/or closes the plot file in the
off line mode.

Call: CALL PLTEND



[5w[6;44s
WHERE, WHERED[1w[11;80s
In the  on line mode,  WHERE returns  the  current pen position
coordinates. WHERE  cannot be used in the off line mode. WHERED
is  similar  to WHERE,  but  WHERED has an additional function.
It  sets  the  microscope,  changes  from  REMOTE to LOCAL, and
waits  for  the  operator to position the plotter on the target
point  and   press  the DIGITIZE key on the handcontroller. See
also chapter 7 for an example.

Call: CALL WHERE  (X,Y)
      CALL WHERED (X,Y)

X,Y        Coordinates of the current pen position


[5w[6;44s
SETPAR[1w[11;80s
SETPAR allows the  units  of length and angle to be changed for
the programm which is running.

Call: CALL SETPAR (ILEN,IANG)

ILEN  0: Length unit 1mm (D)
      1: Length unit 1cm
      2: Length unit 1inch

IANG  0: Angle unit 1 deg (D)
      1: Angle unit 1 gon
      2: Angle unit 1 rad

GP1LVF.FUN                                             page  13
---------------------------------------------------------------
[5w[6;44s
RESET[1w[11;80s
RESET is used to  reset all parameters to their default values.
RESET calls the following subroutines:

      CALL VECTOR (0.0,0.0,3)
      CALL SCALE  (1.0,1.0)
      CALL SETPAR (0,0)
      CALL SYSET  (0)
      CALL SYSCAL (5.0)
      CALL SYROTA (0.0)
      CALL CHAR   (1)
      CALL STRSCL (5.0)
      CALL STROT  (0.0)
      CALL STRSLN (90.0)
      CALL PENCHA (1)
      CALL LINSET (1)
      CALL LINSCL (5.0)
      CALL LINRAT (5.0)
      CALL LINSYM (0)
      CALL LINSRO (0.0)
      CALL CLRWIN
      CALL SPEED  (9)

Call: CALL RESET



[5w[6;44s
PENMOV[1w[11;80s
PENMOV is used to lift the pen up  (if the pen  is  down) or to
put the pen down (if the pen is up).

Call: CALL PENMOV


[5w[6;44s
SYMDEF[1w[11;80s
With SYMDEF you  can send a  symbol  data block to the GP1 (see
chapter 6).

Call: CALL SYMDEF (IPARAM)

IPARAM   INTEGER*2  array,  contents are the symbol data block,
         maximum dimension: 128.


[5w[6;44s
SYSTOR[1w[11;80s
SYSTOR cause the GP1 to store all user  defined symbols on  the
cassette.

Call: CALL SYSTOR

GP1LVF.FUN                                             page  14
---------------------------------------------------------------
[5w[6;44s
TXTYP[1w[11;80s
An other typ of text can be choosen, but only if the correspond
GP1-operating-system  option  has  been  installed  in the GP1.
		1     : STANDARD typ of characters
		2..10 : user defined character sets

The texttyp which has been choosen, will be stored  on the GP1-
cassette. At power-up time the same texttyp as before  will  be
loaded.

Call: CALL TXTYP (IFONT)

IFONT     Number of the character set (font) [1..10]. (D:1)


[5w[6;44s
CHARACTER DISTANCE[1w[11;88s
The  distance between  characters can be sligthly variied. 0 is
default, <0 means narrow, >0 means wider.

Call: CALL CHDIS (ICHDI)

ICHDI     Distance [-20..+20]. (D:0)


[5w[6;44s
GPSTAT[1w[11;80s
GPSTAT gets GP1 internal status byte (see GP1  user's guide for
meanings of the 8 bit).

Call: CALL GPSTAT (BIT)

BIT       INTEGER*2 array of 8 components
          Receiving 8 bit status


[5w[6;44s
TKREI[1w[11;80s
The tangentialdrive  moves  the  pen down makes a full rotation
counterclockwise and moves the pen up.

Call: CALL TKREI



[5w[6;44s
ORIWIN[1w[11;80s
In the  on line mode,  ORIWIN returns  the  current coordinates
of the actual GP1 origin and window.

Call: CALL ORIWIN (COORD)

COORD       Real array of 6 coordinates :
            X/Y-origin, X/Y-window-min, X/Y-window-max

GP1LVF.FUN                                             page  15
---------------------------------------------------------------

[5w[6;44s
3. CALCOMP calls

[1w[11;80s

Length  unit  should  be  1 cm. Do this either with the help of
the subroutine SETPAR or,  in the COMMON block /GP1C01/ GP1ERR,
LEUNIT,ANUNIT, set the variable LEUNIT = 1.
The  following  CALCOMP  compatible subroutines are included in
the library:

[5w[6;44s
PLOT[1w[11;80s
PLOT moves  the  plotting  tool  directly to  the target point.
There the index can be set  or  the  plot  can  be  terminated.

Call: CALL PLOT (XEND,YEND,IPEN)

XEND,YEND    Coordinates of the target point
IPEN         Status of the plotting tool (up,down):
             2 down with deceleration to target point
             3 up
             4 down without deceleration to target point
             999 termination of the plot
             -2 down, set index at the target point
             -3 up, set index at the target point
             -4 continuously, set index at the target point

[5w[6;44s
FACTOR[1w[11;80s
FACTOR is  used  to  change  the  scale  of  the  overall plot.
FACTOR is  another  method  of  changing  the plot  scale other
than SCALE. (see listings)

Call: CALL FACTOR (FACT)

FACT     Factor to change the scale of the overall plot

[5w[6;44s
NUMBER[1w[11;80s
With  number,  a  given  real  number  is  divided into decimal
digits and plotted.  Pay attention  to  rounding errors in very
small or big numbers!

Call: CALL NUMBER (XEND,YEND,HEIGHT,FNUM,PHI,IROUND)

XEND,YEND        Coordinates of the left starting point
HEIGHT           Height of the number
FNUM             Real number to be plotted
PHI              Slant angle of the number
IROUND           Number of digits to be rounded after the
                 decimal point:
                 > -1 : gives the number of digits to  be roun-
                        ded to after the decimal point
                   -1 : the decimal  point  will not be plotted
                 < -1 : gives the number of digits to be  roun-
                       ded to in the integer part of the number

GP1LVF.FUN                                             page  16
---------------------------------------------------------------
[5w[6;44s
SYMBOL[1w[11;80s
SYMBOL permits strings of annotation and symbols to be plotted.

Call: CALL SYMBOL (XEND,YEND,HEIGHT,STRSY,PHI,NUMBER)

XEND,YEND       Starting coordinates of the  string  or  center
                point of the symbol, respectively.
                If  XEND or  YEND is  999.0, plotting begins at
                the actual pen position
HEIGHT          Height of string or symbol
STRSY           INTEGER*2 array
                String: Each  word  has  room for 2  characters
                Symbol: The symbol number is stored in STRSY(1)
PHI             Rotation angle  of  the  character string or of
                the symbol.
NUMBER          > 0 : Number of characters to be plotted
                < 0 : Symbol plotting:
                      -1, the plotting tool moves to the
                      starting point in the up position
                      -2, the plotting tool moves to the
                      starting point in the down position




[5w[6;40s
4. Transmission programs

[1w[11;80s

SENDGP           Creates a GP1 plot record in ASCII
PUTIN            Transmits  the  ASCII record to the GP1 and/or
                 writes the ASCII record on a file
GPINIT           Initializes the GP1 in the on line mode and/or
                 opens a plot file in the off line mode
GPSTAT           Gets GP1 status
WHERE(D)         Sets the GP1 to LOCAL-mode, send a coordinate-
                 request and waits for the answer
LOCAL            If the GP1 is in REMOTE-mode it sends the com-
                 mand to switch  to LOCAL and waits for comple-
                 tion.
ORIWIN           Gets origin and window coordinates
SETORG           Switch to  LOCAL,  setting  origin and back to
                 REMOTE.

GP1LVF.FUN                                             page  17
---------------------------------------------------------------

[5w[6;44s
5. Defining symbols

[1w[11;88s

1. Draw a grid and an x,y coordinate system with


             -129 < x < 128
             -129 < y < 128


   i.e.

                         | y
                         |
                 -----------------           --
                 |   |   |   |   |
                 -----------------
                 |   |   |   |   |           max
             ------------------------- x     255
                 |   |   |   |   |           units
                 -----------------
                 |   |   |   |   |
                 -----------------           --
                         |
                         |

                  | max 255 units |


2. Draw the desired symbol onto this grid taking the  following
   rules into consideration:

- All coordinates  of the symbol must lie between -129 and +128
  (because they are stored as bytes).

- All coordinates must be integers.

- The symbol may consist of parts of straight lines and elipses.
  The  main  axes  of the elipses must be parallel to the x and
  y axes.

- To be compatible with the GP1 scaling, the symbol should have
  a maximum dimension of 125 grid units.

- The  symbol  should  be designed around the grid origin as in
  later use it may be rotated or  incorporated into line types.

GP1LVF.FUN                                             page  18
---------------------------------------------------------------


3. The symbol  may  be described by a series of line type codes
   and coordinate values.

- Possible line type codes are

     0 : straight line to (x,y), pen up
     1 : straight line to (x,y), pen down
     2 : part of  an  elipse,  clockwise, major axis horizontal
    -2 : part of an elipse, counterclockwise, major axis
         horizontal
     3 : part of an elipse, clockwise, major axis vertical
    -3 : part of an elipse, counterclockwise, major axis
         vertical

- An elipse needs four lines for a full description:

     code, coordinates of starting point
     code, coordinates of target point
     code, coordinates of centre of elipse
     code, length of major semi axis of elipse,
           length of minor semi axis of elipse

- A symbol cannot have more than 40 lines.

- In general  you can  assume  that the plotter initially is at
  (0,0) of the local coordinate system.

- The last line should be 0,0,0.


                      An example:

                           y
                           |
                           |
                  -10,60 +-|-----+ 40,60
                         | |     |
                 -10,50 .+ |     |
                     .   | |     |
                    .    | |     |
                   .     | |     |
       -30,0   ----+-----+-0-----+-------x
                   .     | |     |
                    .    | |     |
                     .   | |     |
                -10,-50 .+ |     |
                         | |     |
                -10,-60  +-|-----+ 40,-60
                           |
                           |


GP1LVF.FUN                                             page  19
---------------------------------------------------------------



To describe the above symbol, the following lines are required.


line type code    coordinate values  comment

                    x         y

      0           -10       -60      move  to  starting  point,
                                     pen up
      1            40       -60      move  with  pen  down on a
      1            40        60      rectangular to...
      1           -10        60
      1           -10       -60      ...this point
      0           -10       -50      pen up to the...
      3           -10       -50      start of elipse
      3           -10        50      end of elipse
      3           -10         0      centre of elipse
      3            50        30      length semi axes of
                                     elipse
      0             0         0      back to the origin


4. The symbol parameters may now be written on a file.

Create a file called SYMBOL.GP1 with the editor. This file must
have the following form:

         +-----------+
         |43,11      |    Heading
         |0,-10,-60  |    Data describing the symbol
         |1,40,-60   |                .
         |   .       |                .
         |   .       |                .
         |   .       |                .
         |3,50,30    |                .
         |0,0,0      |                .
         +-----------+


where the two numbers in the heading represent:

         43: the GP1 symbol number between 25 and 58
         11: the number of date lines describing the symbol


It is possible to put  several  symbol data  blocks on the same
file. No special separator is needed.

GP1LVF.FUN                                             page  20
---------------------------------------------------------------



5. If the GP1 is connected and ready,  the  file SYMBOL.GP1 may
   now be sent to the GP1 by running  the program "GPFPUS.SAV".


- The GP1 checks the data received for errors.  If  there is an
  error,  no  symbol  is  defined  and  a message is given to a
  connected terminal:

             "?GP1-F-Symbol definition error"


- The  symbol  remains  in  the GP1 until a new one is defined.


- All  user  defined  symbols  are stored on the  cassette. The
  program GPFPUS in the  GP1 FORTRAN PLOTTER LIBRARY does  this
  automatically.


- For  an example,  look  at  the  floppy  with the GP1 FORTRAN
  PLOTTER LIBRARY. The files concerned are:

     SYMBOL.GP1 - file of symbols
     GPFPUS.FOR - source file of GPFPUS.SAV
     SYMDEF.FOR - subroutine  from the library called by GPFPUS
                  to send a symbol to the GP1
     SYSTOR.FOR - subroutine  from the library called by GPFPUS
                  to store all user defined symbols on the TU58
                  cassette.

GP1LVF.FUN                                             page  21
---------------------------------------------------------------

[5w[6;40s
6. Using digitizing program
   WHERED

[1w[11;80s


C===========================================================
C
      PROGRAM GP1DIG
C
C===========================================================
C GP1 USER PROGRAM: Storing of digitized points on a file
C
C                   - Link the program with the ON LINE
C                     library.
C                   - Connect and start GP1.
C                   - Start the program with RUN GP1DIG.
C                   - Move the GP1 with the hand controller
C                     to the desired points and press
C                     DIGITIZE on the hand controller.
C                     Continue.
C                   - All digitized points are stored on
C                     the file GP1DIG.FOR on the same device
C                     as the running program.
C                   - Stop with two times DIGITIZE at he
C                     same point.
C===========================================================
C
      LOGICAL*1 IERR
C
C... Initialisation of GP1 and file
C
      CALL GPINIT (1, '$DISK1:[KELLY]GP1DIG.DAT', 1, IERR)
C
C... Text on CRT
C
---------------------------------------------------------------
      TYPE 9000,27
      TYPE 9004,27
      TYPE *,'                 GP1 digitizing program'
      TYPE *,'                 ......................'
      TYPE *
      TYPE *,' Hints:'
      TYPE *,'    Press DIGITIZE on the handcontroller'
      TYPE *,'    Pressing DIGITIZE twice at the same point ',
     1       'terminates the program'
      TYPE *,'    The digitized points are stored in the file ',
     1       'GP1DIG.DAT'
      TYPE 9002,27
C
C... Digitizing
C

GP1LVF.FUN                                             page  22
---------------------------------------------------------------

      X = 9999.99
      Y = 9999.99
C
10    XLAST = X
      YLAST = Y
      CALL WHERED (X,Y)
      IF (X .EQ. XLAST .AND. Y .EQ. YLAST) GOTO 20
C
      TYPE 9002,27
      TYPE 9003,27
      TYPE 9001,XLAST,YLAST
      TYPE 9005,X,Y
      GOTO 10
C
20    CALL PLTEND
      CALL EXIT
C
C-----------------------------------------------------------
C
C...Formats:
C
9000  FORMAT ('$'A1'[2J')
9001  FORMAT ('            Last digitized point : ',
     1        F10.2,F10.2)
9002  FORMAT ('$'A1'[18;H')
9003  FORMAT ('$'A1'[2K')
9004  FORMAT ('$'A1'[H')
9005  FORMAT ('            Actual point         : ',
     1        F10.2,F10.2)
C
C-----------------------------------------------------------
C
      E N D

GP1LVF.FUN                                             page  23
---------------------------------------------------------------

[5w[6;40s
7. I/O with non DEC-computers

[1w[11;80s

Some Routines has to be changed when using an computer not from
the VAX family of DEC.

There  are  special  I/O-functions which are used and which are
DEC-specific. They appear in the routines


         SENDGP                 WHERED
         PUTIN                  MESSAG
         GPINIT                 ORIWIN
         GPSTAT                 SETORG
         WHERE

and need revision or rewriting.

The library is working with the GP1  XON/XOFF-transmission-mode.
But as the GP1 has the capability of other modes (like ACK/NAK,
STATUS, HARDWARE-HANDSHAKE)  the user library can also be adap-
ted in an other way of intercommunication.



[5w[6;40s
8. Hardware connection

[1w[11;80s

The plotter is connected  to  the  computer  through any serial
asynchron interface  with  RS-423  compatibel standard (such as
RS-422 or RS-232).

Communication parameters:

2400 Baud
2    Stop Bit
8    Data Bit, Parity none


The line must be a terminalline of the VMS-system.  Define  the
line in the software  as  described in the installation manual.

GP1LVF.FUN                                             page  24
---------------------------------------------------------------

[5w[6;40s
9. ASCII tables

[1w[11;80s

 Octal:

 00 NUL  20 DLE  40 SP   60 0    100 @    120 P    140 `    160 p
 01 SOH  21 DC1  41 !    61 1    101 A    121 Q    141 a    161 q
 02 STX  22 DC2  42 "    62 2    102 B    122 R    142 b    162 r
 03 ETX  23 DC3  43 #    63 3    103 C    123 S    143 c    163 s
 04 EOT  24 DC4  44 $    64 4    104 D    124 T    144 d    164 t
 05 ENQ  25 NAK  45 %    65 5    105 E    125 U    145 e    165 u
 06 ACK  26 SYN  46 &    66 6    106 F    126 V    146 f    166 v
 07 BEL  27 ETB  47 '    67 7    107 G    127 W    147 g    167 w
 10 BS   30 CAN  50 (    70 8    110 H    130 X    150 h    170 x
 11 HT   31 EM   51 )    71 9    111 I    131 Y    151 i    171 y
 12 LF   32 SUB  52 *    72 :    112 J    132 Z    152 j    172 z
 13 VT   33 ESC  53 +    73 ;    113 K    133 [    153 k    173 {
 14 FF   34 FS   54 ,    74 <    114 L    134 \    154 l    174 |
 15 CR   35 GS   55 -    75 =    115 M    135 ]    155 m    175 }
 16 SO   36 RS   56 .    76 >    116 N    136 ^    156 n    176 ~
 17 SI   37 US   57 /    77 ?    117 O    137 _    157 o    177 DEL


 Decimal:

 00 NUL  16 DLE  32 SP   48 0    064 @    080 P    096 `    112 p
 01 SOH  17 DC1  33 !    49 1    065 A    081 Q    097 a    113 q
 02 STX  18 DC2  34 "    50 2    066 B    082 R    098 b    114 r
 03 ETX  19 DC3  35 #    51 3    067 C    083 S    099 c    115 s
 04 EOT  20 DC4  36 $    52 4    068 D    084 T    100 d    116 t
 05 ENQ  21 NAK  37 %    53 5    069 E    085 U    101 e    117 u
 06 ACK  22 SYN  38 &    54 6    070 F    086 V    102 f    118 v
 07 BEL  23 ETB  39 '    55 7    071 G    087 W    103 g    119 w
 08 BS   24 CAN  40 (    56 8    072 H    088 X    104 h    120 x
 09 HT   25 EM   41 )    57 9    073 I    089 Y    105 i    121 y
 10 LF   26 SUB  42 *    58 :    074 J    090 Z    106 j    122 z
 11 VT   27 ESC  43 +    59 ;    075 K    091 [    107 k    123 {
 12 FF   28 FS   44 ,    60 <    076 L    092 \    108 l    124 |
 13 CR   29 GS   45 -    61 =    077 M    093 ]    109 m    125 }
 14 SO   30 RS   46 .    62 >    078 N    094 ^    110 n    126 ~
 15 SI   31 US   47 /    63 ?    079 O    095 _    111 o    127 DEL
