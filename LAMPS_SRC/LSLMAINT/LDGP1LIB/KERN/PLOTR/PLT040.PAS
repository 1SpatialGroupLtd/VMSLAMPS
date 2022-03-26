[INHERIT ('Inherit_File')]
MODULE PLT040 ;

{ PLT040.PAS <> }

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

{
WRITELN ;
WRITELN ( ' String ', String:40, 'J',J:4, ' Value ', Value:12:6, Error ) ;
READLN ;
}

END ; (* PROCEDURE Find_Value *)


(**********************************************************************)
[GLOBAL] PROCEDURE IS_Interpret_String ;
(**********************************************************************)
CONST
     Blank_15 = '               ' ;
VAR
   Dval:	DOUBLE ;
   Found    : BOOLEAN ;
   Error    : BOOLEAN ;
   I        : INTEGER ;
   Value    : DOUBLE ;

   SString   : String_15  ;

   Old_Cam_Mode              : INTEGER ;
   Old_Line_Type_Code_Number : INTEGER ;
   Old_Symbol_Code_Number    : INTEGER ;

   New_Value                 : INTEGER ;

   N                         : INTEGER ;

BEGIN
     { find what is of interest }
     Found := FALSE ;

     Old_CAM_mode := CAM_Mode ;
     Old_Line_Type_Code_Number := Line_Type_Code_Number ;
     Old_Symbol_Code_Number    := Symbol_Code_Number ;

     { is it s change to ? }
     SString := Blank_15 ;
     FOR I := 1 TO 10 DO SString [I] := Input_Record [I] ;
         IF SString <> 'CHANGE TO      '
            THEN Found := TRUE ;

     IF Input_Record [11] IN [ 'A', 'C', 'L', 'M', 'N', 'P', 'S', 'T' ]
        THEN
        ELSE Found := TRUE ;

     { pen up }
     IF NOT Found
        AND ( Input_Record [11] = 'P' )
        THEN BEGIN
                  SString := Blank_15 ;
                  FOR I := 11 TO 16 DO SString [I-10] := Input_Record [I] ;
                  IF SString = 'PEN UP         '
                     THEN BEGIN
                               Last_Foot_Pedal := Left ;
                               Found := TRUE ;
                            END ;
              END ;

     { pen down }
     IF NOT Found
        AND ( Input_Record [11] = 'P' )
        THEN BEGIN
                  SString := Blank_15 ;
                  FOR I := 11 TO 18 DO SString [I-10] := Input_Record [I] ;
                  IF SString = 'PEN DOWN       '
                     THEN BEGIN
                               Last_Foot_Pedal := Right ;
                               Found := TRUE ;
                            END ;
              END ;

     { line type }
     IF NOT Found
        AND ( Input_Record [11] = 'L' )
        THEN BEGIN
                  SString := Blank_15 ;
                  FOR I := 11 TO 18 DO SString [I-10] := Input_Record [I] ;
                  IF SString = 'LINETYPE       '
                     THEN BEGIN
                               Found := TRUE ;
                               Find_Value ( 18, Value, Error ) ;
                               New_Value := TRUNC ( Value ) ;
                               IF NOT Error
                                  AND ( Line_Type_Code_Number <> New_Value )
                                  THEN BEGIN
                                          Line_Type_Code_Number := New_Value ;
                                          New_Selection := TRUE ;
                                         END ;
                            END ;
               END ;
     { straight }
     IF NOT Found
        AND ( Input_Record [11] = 'S' )
        THEN BEGIN
                  SString := Blank_15 ;
                  FOR I := 11 TO 18 DO SString [I-10] := Input_Record [I] ;
                  IF SString = 'STRAIGHT       '
                     THEN BEGIN
                               CAM_Mode := 1 ;
                               Found := TRUE ;
                            END ;
              END ;

     { curve, contour }
     IF NOT Found
        AND ( Input_Record [11] = 'C' )
        THEN BEGIN
                  SString := Blank_15 ;
                  FOR I := 11 TO 15 DO SString [I-10] := Input_Record [I] ;
                  IF   ( SString = 'CURVE          ' )
                    THEN BEGIN
                               CAM_Mode := 2 ;
                               Found := TRUE ;
                            END ;
               END ;
     IF NOT Found
        AND ( Input_Record [11] = 'C' )
        THEN BEGIN
                  SString := Blank_15 ;
                  FOR I := 11 TO 17 DO SString [I-10] := Input_Record [I] ;
                  IF   ( SString = 'CONTOUR        ' )
                    THEN BEGIN
                               CAM_Mode := 2 ;
                               Found := TRUE ;
                            END ;
              END ;


     { symbol object }
     IF NOT Found
        AND ( Input_Record [11] = 'S' )
        THEN BEGIN
                  SString := Blank_15 ;
                  FOR I := 11 TO 16 DO SString [I-10] := Input_Record [I] ;
                  IF   ( SString = 'SYMBOL         ' )
                    THEN BEGIN
                              Found := TRUE ;
                              Find_Value ( 16, Value, Error ) ;
                              New_Value := TRUNC ( Value ) ;
                              IF NOT Error
                                 THEN BEGIN
                                           CAM_Mode := 5 ;
                                           IF Symbol_Code_Number <> New_Value
                                              THEN New_Selection := TRUE ;
                                           Symbol_Code_Number := New_Value;
                                           Last_Foot_Pedal := Right ;
                                        END ;
                           END ;
              END ;

     { scale factor }
     IF NOT Found
        AND ( Input_Record [11] = 'S' )
        THEN BEGIN
                  SString := Blank_15 ;
                  FOR I := 11 TO 15 DO SString [I-10] := Input_Record [I] ;
                  IF   ( SString = 'SCALE          ' )
                    THEN BEGIN
                              Find_Value ( 15, Value, Error ) ;
                              Found := TRUE ;
                              IF NOT Error
                                 THEN BEGIN
                                           IF Display_Scale_Factor <> Value
                                              THEN New_Selection := TRUE ;
                                           Display_Scale_Factor := Value ;
                                        END ;
                           END ;
              END ;

     { symbol rotation }
     IF NOT Found
        AND ( Input_Record [11] = 'S' )
        THEN BEGIN
                  SString := Blank_15 ;
                  FOR I := 11 TO 25 DO SString [I-10] := Input_Record [I] ;
                  IF   ( SString = 'SYMBOL ROTATION' )
                    THEN BEGIN
                              Find_Value ( 25, Value, Error ) ;
                              Found := TRUE ;
                              IF NOT Error
                                 THEN BEGIN
                                           Symbol_Rotation := Value -
                                                     Plot_Rotation ;
                                           New_Selection := TRUE ;
                                        END ;
                           END ;
              END ;

     { text rotation }
     IF NOT Found
        AND ( Input_Record [11] = 'T' )
        THEN BEGIN
                  SString := Blank_15 ;
                  FOR I := 11 TO 23 DO SString [I-10] := Input_Record [I] ;
                  IF   ( SString = 'TEXT ROTATION  ' )
                    THEN BEGIN
                              Find_Value ( 23, Value, Error ) ;
                              Found := TRUE ;
                              IF NOT Error
                                 THEN BEGIN
                                           Symbol_Text_Rotation := Value -
                                                 Plot_Rotation ;
                                           New_Selection := TRUE ;
                                        END ;
                           END ;
              END ;

     { spot height }
     IF NOT Found
        AND ( Input_Record [11] = 'S' )
        THEN BEGIN
                  SString := Blank_15 ;
                  FOR I := 11 TO 20 DO SString [I-10] := Input_Record [I] ;
                  IF   ( SString = 'SPOT HEIGH     ' )
                    OR ( SString = 'SPOTHEIGHT     ' )
                     THEN BEGIN
                               CAM_Mode := 6 ;
                               Found := TRUE ;
                               Last_Foot_Pedal := Right ;
                            END ;
              END ;

     { net work }
     IF NOT Found
        AND ( Input_Record [11] = 'N' )
        THEN BEGIN
                  SString := Blank_15 ;
                  FOR I := 11 TO 17 DO SString [I-10] := Input_Record [I] ;
                  IF SString = 'NETWORK        '
                     THEN BEGIN
                               CAM_Mode := 7 ;
                               Found := TRUE ;
                               New_Selection := TRUE ;
                            END ;
              END ;

     { arc }
     IF NOT Found
        AND ( Input_Record [11] = 'A' )
        THEN BEGIN
                  SString := Blank_15 ;
                  FOR I := 11 TO 13 DO SString [I-10] := Input_Record [I] ;
                  IF SString = 'ARC            '
                     THEN BEGIN
                               CAM_Mode := 8 ;
                               N_Arc_Points := 0 ;
                               Found := TRUE ;
                            END ;
              END ;

     { pen }
     IF NOT Found
        AND ( Input_Record [11] = 'P' )
        THEN BEGIN
             SString := Blank_15 ;
             FOR I := 11 TO 13 DO SString [I-10] := Input_Record [I] ;
             IF SString = 'PEN            '
                THEN BEGIN
                     Find_Value ( 13, Value, Error ) ;
                     New_Value := TRUNC ( Value ) ;
                     Found := TRUE ;
                     IF NOT Error
                        THEN BEGIN
                                  { is it a line or a symbol ? }
                                  IF CAM_Mode IN [1..4, 7, 8]
                                     THEN Line_Pen_Selection := New_Value
                                     ELSE Symbol_Pen_Selection := New_Value ;
                                  New_Selection := TRUE ;
                               END ;
                        END ;
              END ;


     { we shall finish the curve mode }
     IF ( Old_CAM_Mode = 2 ) AND Something_to_Plot THEN
       IF   ( Old_CAM_Mode <> CAM_Mode )
         OR ( Old_Line_Type_Code_Number <> Line_Type_Code_Number ) THEN
         IF Location = CONTINUE THEN
           BEGIN
             Plot_Curve ( P4, Location, Last_X_Table, Last_Y_Table,
                          Height, Plotter_Device ) ;
             Location := TERMINATE ;
             Plot_Curve ( P4, Location, Last_X_Table, Last_Y_Table,
                          Height, Plotter_Device ) ;
             Location := START ;
           END ;


     Found := FALSE ;
     IF    ( Old_CAM_Mode <> CAM_Mode )
       THEN BEGIN
                 Found := FALSE ;
                 { are they both a line type }
                 IF    ( Old_CAM_Mode IN [ 1..4, 7,8 ] )
                   AND (     CAM_Mode IN [ 1..4, 7,8 ] )
                   THEN BEGIN
                        Found := TRUE ;
                        { is it the same line }
                        IF Old_Line_Type_Code_Number = Line_Type_Code_Number
                           THEN
                           ELSE New_Selection := TRUE
                           END
                   ELSE New_Selection := TRUE ;

                 { are they both a symbol }
                 IF NOT Found
                    THEN
                        IF    ( Old_CAM_Mode IN [ 5,6,9 ] )
                          AND (     CAM_Mode IN [ 5,6,9 ] )
                          THEN
                              { is it the same symbol }
                              IF Old_Symbol_Code_Number = Symbol_Code_Number
                                 THEN
                                 ELSE New_Selection := TRUE
                          ELSE New_Selection := TRUE ;
             END ;

     { MAPS 300 COMPATIBILITY }
     { marker }
     IF NOT Found
        AND ( Input_Record [11] = 'M' )
        THEN BEGIN
                  SString := Blank_15 ;
                  FOR I := 11 TO 16 DO SString [I-10] := Input_Record [I] ;
                  IF   ( SString = 'MARKER         ' )
                    THEN BEGIN
                              Found := TRUE ;

                              New_Selection := TRUE ;

                              Find_Value ( 16, Value, Error ) ;
                              Symbol_Code_Number := TRUNC ( Value ) ;

                              Get_Symbol_Definition ;

                              CAM_Mode := 10 ;
                              Last_Foot_Pedal := Right ;

                              READLN ( Input_File, Input_Record ) ;
                              Find_Value ( 23, Value, Error ) ;
                              Symbol_Rotation := Value - Plot_Rotation ;

                              READLN ( Input_File, Input_Record ) ;
                              Dval := DBLE (Standard_Symbol_Size) ;
                              Find_Value ( 23, Dval, Error ) ;

                              CAM_Mode := 10 ;

                              Display_Scale_Factor := 1.0 ;

                           END ;
              END ;

     { text }
     IF NOT Found
        AND ( Input_Record [11] = 'T' )
        THEN BEGIN
                  SString := Blank_15 ;
                  FOR I := 11 TO 19 DO SString [I-10] := Input_Record [I] ;
                  IF   ( SString = 'TEXT TYPE      ' )
                    THEN BEGIN
                              Found := TRUE ;

                              New_Selection := TRUE ;

                              Find_Value ( 20, Value, Error ) ;
                              Symbol_Code_Number := TRUNC (Value ) ;

                              READLN ( Input_File, Input_Record ) ;
                              Find_Value ( 23, Value, Error ) ;
                              Symbol_Text_Rotation := Value - Plot_Rotation ;

                              READLN ( Input_File, Input_Record ) ;
                              Dval := DBLE (Symbol_Annotation_Size) ;
                              Find_Value ( 23, Dval,
                                               Error ) ;

                              { text ratio ? }
                              READLN ( Input_File, Input_Record ) ;

                              READLN ( Input_File, Input_Record ) ;
                              Dval := DBLE (Standard_Symbol_Size) ;
                              Find_Value ( 23, Dval,
                                               Error ) ;

                              READLN ( Input_File, Input_Record ) ;
                              Maps300_Annotation := Blank_40 ;
                              FOR I := 1 TO 40 DO
                               Maps300_Annotation [I] := Input_Record [I+16] ;

                              { get rid of the ' }
                              FOR I := 1 TO 40 DO
                                  IF Maps300_Annotation [I] <> ' '
                                     THEN N := I ;
                              Maps300_Annotation [N] := ' ' ;

                              CAM_Mode := 11 ;

                              Display_Scale_Factor := 1.0 ;

                           END ;
              END ;

END ; (* PROCEDURE IS_Interpret_String *)
END.
