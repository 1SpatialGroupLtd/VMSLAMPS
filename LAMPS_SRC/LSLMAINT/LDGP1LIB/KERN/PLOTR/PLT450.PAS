[INHERIT ('Inherit_File')]
MODULE PLT450 ;

{ PLT450.PAS <> }

(**********************************************************************)
[GLOBAL] PROCEDURE PUDS_Plot_Users_Defined_Symbol ;
(**********************************************************************)
VAR
   Error        : BOOLEAN ;
   Symbol_File  : TEXT ;

   Symbol_Center_North,
   Symbol_Center_East  : DOUBLE ;

   { transformation parameters  of the symbol }
   A, B, A0, B0 : DOUBLE ;

   { saved paraemeters }
   Saved_CAM_Mode              : INTEGER ;
   Saved_Line_Type_Code_Number : INTEGER ;
   Saved_Symbol_Code_Number    : INTEGER ;


(**********************************************************************)
PROCEDURE Find_Value (         I : INTEGER ;
                       VAR Value : DOUBLE ;
                       VAR Error : BOOLEAN ) ;
(**********************************************************************)
VAR
   SString     : String_40 ;
   J          : INTEGER ;
   First_Time : BOOLEAN ;
   Finished   : BOOLEAN ;

BEGIN
     J          := 0 ;
     SString     := Blank_40 ;
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

      UNTIL  Finished ;

      IF J > 0
         THEN Convert_To_Numeric ( SString, J, Value, Error)
         ELSE Error := TRUE ;

END ; (* PROCEDURE Find_Value *)


(**********************************************************************)
PROCEDURE IS_Interpret_String ;
(**********************************************************************)
VAR
   Found         : BOOLEAN ;
   New_Selection : BOOLEAN ;
   Error         : BOOLEAN ;
   I             : INTEGER ;
   Value         : DOUBLE ;

   SString        : String_40 ;

   Old_Cam_Mode              : INTEGER ;
   Old_Line_Type_Code_Number : INTEGER ;

BEGIN
     { find what is of interest }
     Found := FALSE ;
     New_Selection := FALSE ;

     Old_CAM_mode := CAM_Mode ;
     Old_Line_Type_Code_Number := Line_Type_Code_Number ;

     SString := Blank_40 ;
     FOR I := 1 TO 18 DO SString [I] := Input_Record [I] ;
     IF SString = 'CHANGE TO LINETYPE                      '
        THEN BEGIN
                  Find_Value ( 18, Value, Error ) ;
                  IF NOT Error
                     THEN BEGIN
                               Found := TRUE ;
                               Line_Type_Code_Number := TRUNC ( Value ) ;
                               New_Selection := TRUE ;
                            END ;
              END ;

     IF NOT Found
        THEN BEGIN
                  SString := Blank_40 ;
                  FOR I := 1 TO 18 DO SString [I] := Input_Record [I] ;
                  IF SString = 'CHANGE TO STRAIGHT                      '
                     THEN BEGIN
                               CAM_Mode := 1 ;
                               Found := TRUE ;
                               New_Selection := TRUE ;
                            END ;
              END ;

     IF NOT Found
        THEN BEGIN
                  SString := Blank_40 ;
                  FOR I := 1 TO 15 DO SString [I] := Input_Record [I] ;
                  IF SString = 'CHANGE TO CURVE                         '
                     THEN BEGIN
                               CAM_Mode := 2 ;
                               Found := TRUE ;
                               New_Selection := TRUE ;
                            END ;
              END ;


     IF NOT Found
        THEN BEGIN
                  SString := Blank_40 ;
                  FOR I := 1 TO 16 DO SString [I] := Input_Record [I] ;
                  IF SString = 'CHANGE TO SYMBOL                        '
                     THEN BEGIN
                               Find_Value ( 16, Value, Error ) ;
                               IF NOT Error
                                  THEN BEGIN
                                            CAM_Mode := 5 ;
                                            Found := TRUE ;
                                            New_Selection := TRUE ;
                                       Symbol_Code_Number := TRUNC ( Value );
                                         END ;
                           END ;
              END ;

     IF NOT Found
        THEN BEGIN
                  SString := Blank_40 ;
                  FOR I := 1 TO 16 DO SString [I] := Input_Record [I] ;
                  IF SString = 'CHANGE TO PEN UP                        '
                     THEN BEGIN
                               Last_Foot_Pedal := Left ;
                               Found := TRUE ;
                            END ;
              END ;

     IF NOT Found
        THEN BEGIN
                  SString := Blank_40 ;
                  FOR I := 1 TO 18 DO SString [I] := Input_Record [I] ;
                  IF SString = 'CHANGE TO PEN DOWN                      '
                     THEN BEGIN
                               Last_Foot_Pedal := Right ;
                               Found := TRUE ;
                            END ;
              END ;

     IF NOT Found
        THEN BEGIN
                  SString := Blank_40 ;
                  FOR I := 1 TO 13 DO SString [I] := Input_Record [I] ;
                  IF SString = 'CHANGE TO ARC                           '
                     THEN BEGIN
                               CAM_Mode := 8 ;
                               N_Arc_Points := 0 ;
                               Found := TRUE ;
                               New_Selection := TRUE ;
                            END ;
              END ;

     { we shall finish the curve mode }
     IF    ( Old_CAM_Mode = 2 ) THEN
       IF   ( Old_CAM_Mode <> CAM_Mode )
         OR ( Old_Line_Type_Code_Number <> Line_Type_Code_Number )
         OR ( Last_Foot_Pedal = Left ) THEN
         IF Location = CONTINUE THEN
           BEGIN
             Plot_Curve ( P4, Location, Last_X_Table, Last_Y_Table,
                          Height, Plotter_Device ) ;
             Location := TERMINATE ;
             Plot_Curve ( P4, Location, Last_X_Table, Last_Y_Table,
                          Height, Plotter_Device ) ;
             Location := START ;
           END ;

     IF New_Selection
        THEN BEGIN
                  { is it a line type ? }
                  IF    ( CAM_Mode IN [1..4, 7, 8] )
                    THEN Get_Line_Definition ;

                  { is it a symbol ? }
                  IF    ( CAM_Mode IN [ 5,6,9 ] )
                    THEN Get_Symbol_Definition ;

                  ILS_Initialize_Line_and_Symbols
                    ( P4,
                      CAM_Mode,
                      Plotter_Status,
                      Hardware_Line_Type_Number,
		      Standard_Line_Size,
                      Line_Pen_Selection,
		      Line_Symbol_Rotation,
                      Line_Symbol_Number,
		      Line_Ratio,
                      Hardware_Symbol_Number,
		      Standard_Symbol_Size,
                      Display_Scale_Factor,
		      Symbol_Pen_Selection,
                      Symbol_Rotation,
		      Symbol_Annotation_Size,
                      Symbol_Annotation_Text_Slant,
		      Symbol_Text_Rotation ) ;

              END ;

END ; (* PROCEDURE IS_Interpret_String *)


(**********************************************************************)
PROCEDURE Plot_Symbol ;
(**********************************************************************)
VAR
  Finished : BOOLEAN ;
  X,Y,Z    : DOUBLE ;

BEGIN

  Finished := FALSE ;

  REPEAT
    Record_Length := 0 ;
    REPEAT
      Record_Length :=  Record_Length + 1 ;
      READ ( Symbol_File, Input_Record [ Record_Length ] ) ;
    UNTIL EOLN ( Symbol_File ) ;
    READLN ( Symbol_File ) ;

    IF Input_Record [1] = ' ' THEN
      BEGIN
        CSTC_Convert_String_to_Coordinates ( X,Y, Z, Error ) ;
        IF NOT Error THEN
          BEGIN
            { transform into world coords, current system. }
            X_Table := A*(X - Symbol_Center_East) -
                       B*(Y - Symbol_Center_North) + A0 ;
            Y_Table := A*(Y - Symbol_Center_North) +
                       B*(X - Symbol_Center_East)  + B0 ;

            IF CAM_Mode = 8 THEN
              Plot_Arc ( P4, X_Table, Y_Table, Height,
                         Last_Foot_Pedal,
                         X_Arc, Y_Arc, Z_Arc,
                         N_Arc_Points, Plotter_Device ) ;

            PXYC_Plot_XY_Coordinates ;
          END ;
        END
      ELSE
        IS_Interpret_String ;

    IF EOF ( Symbol_File ) THEN Finished := TRUE ;

    IF Input_Record [1] = 'Q' THEN Finished := TRUE ;

  UNTIL Finished ;

  { we shall finish the curve mode }
  IF CAM_Mode IN [ 2,4 ] THEN
    BEGIN
      LOCATION := TERMINATE ;
      PXYC_Plot_XY_Coordinates ;
    END ;

END ; (* PROCEDURE Plot_Symbol *)


{======================================================================}
BEGIN { PROCEDURE PUDS_Plot_Users_Defined_Symbol }

     { save parameters }
     Saved_CAM_Mode := CAM_Mode ;
     Saved_Line_Type_Code_Number := Line_Type_Code_Number ;
     Saved_Symbol_Code_Number    := Symbol_Code_Number ;

     Error := FALSE ;
     { find start of file }
     FSF_Find_Start_of_File ( Error, Symbol_File ) ;

     { go to the plotting position }
     IF NOT Error
        THEN BEGIN
                  CAM_Mode := 1 ;
                  Last_Foot_Pedal := Left ;
                  PD_Plot_Datas ;
                  IF NOT Point_In
                     THEN Error := TRUE ;
                  A0 := X_Table ;
                  B0 := Y_Table ;
               END ;

     { find the orientation angles and scale, and transformation parameters }
     IF NOT Error
        THEN  FTP_Find_Transformation_Parameters
                  ( Error, Symbol_File, A, B, A0, B0,
                    Symbol_Center_North, Symbol_Center_East ) ;

     IF NOT Error
        THEN BEGIN
                  Plot_Symbol ;
                  CLOSE ( Symbol_File ) ;
               END ;

     { reset initial position }
     CAM_Mode := Saved_CAM_Mode ;
     Line_Type_Code_Number := Saved_Line_Type_Code_Number ;
     Symbol_Code_Number    := Saved_Symbol_Code_Number    ;

     Get_Line_Definition ;
     Get_Symbol_Definition ;

     ILS_Initialize_Line_and_Symbols
       ( P4,
         CAM_Mode,
         Plotter_Status,
         Hardware_Line_Type_Number,
         Standard_Line_Size,
         Line_Pen_Selection,
         Line_Symbol_Rotation,
         Line_Symbol_Number,
         Line_Ratio,
         Hardware_Symbol_Number,
         Standard_Symbol_Size,
         Display_Scale_Factor,
         Symbol_Pen_Selection,
         Symbol_Rotation,
         Symbol_Annotation_Size,
         Symbol_Annotation_Text_Slant,
         Symbol_Text_Rotation ) ;

{ 16-may-86 caused that consecutive user defined symbols were not plotted
     Last_Foot_Pedal := Left ;
}
END ; (* PROCEDURE PUDS_Plot_Users_Defined_Symbol *)
END.
