[INHERIT ('Inherit_File')]
MODULE PLT451 ;

{ PLT451.PAS <> }

(**********************************************************************)
[GLOBAL] PROCEDURE FSF_Find_Start_of_File
          ( VAR Error        : BOOLEAN ;
            VAR Symbol_File  : TEXT     ) ;
(**********************************************************************)
VAR
   Found       : BOOLEAN ;
   Finished    : BOOLEAN ;
   SString     : String_5 ;
   Ch          : CHAR ;
   Len         : INTEGER ;

BEGIN
     { open users defined symbol }
     OPEN ( Symbol_File,
            FILE_NAME := Symbol_File_Name,
            HISTORY := OLD,
            ERROR := CONTINUE ) ;

     RESET ( Symbol_File, ERROR := CONTINUE ) ;
     Error := EOF ( Symbol_File ) ;

     { find start of the file }
     Found       := FALSE ;
     Finished    := FALSE ;

     IF NOT Error
        THEN
            REPEAT

                  READLN ( Symbol_File, SString ) ;

                 IF SString = 'START'
                    THEN Found := TRUE ;

                 IF EOF ( Symbol_File )
                    THEN Finished := TRUE ;

                 IF SString = 'QUIT '
                    THEN Finished := TRUE ;

           UNTIL    Found
                 OR Finished ;

     IF NOT Found
        THEN Error := TRUE ;

     { find first point that defines the symbol }
     Found    := FALSE ;
     Finished := FALSE ;

     IF NOT Error
        THEN
             REPEAT
                   READLN ( Symbol_File, Input_Record ) ;

                   IF Input_Record [1] = ' '
                      THEN Found := TRUE ;

                   IF EOF ( Symbol_File )
                      THEN Finished := TRUE ;

                   IF Input_Record [1] = 'Q'
                      THEN Finished := TRUE ;

             UNTIL    Found
                   OR Finished ;

     IF NOT Found
        THEN Error := TRUE ;

END ; (* PROCEDURE Find_Start_of_File *)


(**********************************************************************)
[GLOBAL] PROCEDURE CSTC_Convert_String_to_Coordinates
             ( VAR X,Y,Z       : DOUBLE ;
               VAR Error       : BOOLEAN ) ;
(**********************************************************************)
VAR
   SString     : String_40 ;
   Value       : DOUBLE ;

   N           : INTEGER ;
   J           : INTEGER ;
   I           : INTEGER ;
   First_Time  : BOOLEAN ;
   Finished    : BOOLEAN ;
BEGIN
     IF Input_Record [1] <> ' '
        THEN Error := TRUE
        ELSE Error := FALSE ;

     IF NOT Error
        THEN BEGIN
                  N := 0 ;
                  I := 0 ;
                  REPEAT
                        N := N + 1 ;
                        SString := Blank_40 ;
                        J := 0 ;
                        First_Time := TRUE ;
                        Finished   := FALSE ;
                        REPEAT
                             I := I + 1 ;
                             IF    First_Time
                               AND ( Input_Record [I] <> ' ' )
                               THEN First_Time := FALSE ;

                             IF NOT First_Time
                               THEN BEGIN
                                         J := J + 1 ;
                                         SString [J] := Input_Record [I] ;
                                         IF SString [J] = ' '
                                            THEN BEGIN
                                                      Finished := TRUE ;
                                                      J := J - 1 ;
                                                   END ;
                                      END ;
                             IF   ( J = 40 )
                               OR ( I = Record_Length )
                               THEN Finished := TRUE ;

                        UNTIL Finished ;

                        IF J > 0
                           THEN Convert_To_Numeric ( SString, J, Value, Error)
                           ELSE Error := TRUE ;

                       IF NOT Error
                          THEN BEGIN
                                    IF N = 1 THEN X := Value ;
                                    IF N = 2 THEN Y := Value ;
                                    IF N = 3 THEN Z := Value ;
                                 END ;
                  UNTIL    Error
                        OR ( N = 3 ) ;
             END ;

END ; (* PROCEDURE CSTC_Convert_String_to_Coordinates *)


(**********************************************************************)
[GLOBAL] PROCEDURE FTP_Find_Transformation_Parameters
	( VAR Error                : BOOLEAN ;
	  VAR Symbol_File          : TEXT    ;
	  VAR A, B, A0, B0         : DOUBLE ;
	  VAR Symbol_Center_North,
	      Symbol_Center_East   : DOUBLE ) ;
(**********************************************************************)
VAR
  Height:		DOUBLE ;
  Rotation:		DOUBLE ;
  Distance:		DOUBLE ;
  Plot_Rotation:	DOUBLE ;
  Symbol_Plot_X_Scale:	DOUBLE ;
  Symbol_Plot_Y_Scale:	DOUBLE ;

  Symbol_Top_North:	DOUBLE ;
  Symbol_Top_East:	DOUBLE ;
  Symbol_Bottom_North:	DOUBLE ;
  Symbol_Bottom_East:	DOUBLE ;

BEGIN

  Record_Length := Max_Record_Length ;
  { determine symbol center coordinates }
  CSTC_Convert_String_to_Coordinates
    ( Symbol_Center_East, Symbol_Center_North, Height, Error ) ;

  IF EOF ( Symbol_File ) THEN Error := TRUE ;

  { determine symbol bottom coordinates }
  IF NOT Error THEN
    BEGIN
      READLN ( Symbol_File, Input_Record ) ;
      CSTC_Convert_String_to_Coordinates
        ( Symbol_Bottom_East, Symbol_Bottom_North, Height, Error ) ;
    END ;

  IF EOF ( Symbol_File ) THEN Error := TRUE ;

  { determine symbol top coordinates }
  IF NOT Error THEN
    BEGIN
      READLN ( Symbol_File, Input_Record ) ;
      CSTC_Convert_String_to_Coordinates
        ( Symbol_Top_East, Symbol_Top_North, Height, Error ) ;
    END ;

  IF EOF ( Symbol_File ) THEN Error := TRUE ;

  IF NOT Error THEN
    BEGIN
      Distance := SQRT ( ( (Symbol_Top_East  - Symbol_Bottom_East) *
                           (Symbol_Top_East  - Symbol_Bottom_East) )
                       + ( (Symbol_Top_North - Symbol_Bottom_North) *
                           (Symbol_Top_North - Symbol_Bottom_North) ) ) ;

      Plot_Rotation := ARCTAN ( ( Symbol_Top_East  - Symbol_Bottom_East ) /
                                ( Symbol_Top_North - Symbol_Bottom_North ) ) ;

      Symbol_Plot_X_Scale := ( Standard_Symbol_Size * Plot_X_Scale ) / 
                             ( Distance * Display_Scale_Factor * 
                               Ground_Unit_To_Table_Unit_Factor ) ;

      Symbol_Plot_Y_Scale := ( Standard_Symbol_Size * Plot_Y_Scale ) / 
                             ( Distance * Display_Scale_Factor * 
                               Ground_Unit_To_Table_Unit_Factor ) ;

      { Don't know what is going on here - commenting-out here gets
        roughly correct result. Should review effects of putting WTT
        transform in the library }
      Rotation := {Plot_Rotation +} Symbol_Rotation ;

      { positive rotation is clockwise relative to the vertical axis }
      A  := COS ( Rotation ) * Symbol_Plot_X_Scale ;
      B  := SIN ( Rotation ) * Symbol_Plot_Y_Scale ;

    END ;

END ; (* PROCEDURE FTP_Find_Transformation_Parameters *)
END.
