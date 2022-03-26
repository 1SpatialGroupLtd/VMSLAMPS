[INHERIT ('Inherit_File')]
MODULE PLT014 ;

{ PLT014.PAS <> }

(********************************************************************)
 [GLOBAL] PROCEDURE Get_Symbol_Definition ;
(********************************************************************)
VAR
   Index,
   N,
   I                    : INTEGER;

   Data_String          : String_128 ;

   SString               : String_40 ;
   Number_Of_Characters : INTEGER ;
   Value                : DOUBLE ;
   Error                : BOOLEAN ;

BEGIN  (* PROCEDURE Get_Symbol_Definition *)

     { init data string }
     FOR I := 1 TO 128 DO Data_String[I] := ' ';
     Data_String [127] := CHR (12) ;
     Data_String [128] := CHR (10) ;

     { read the data string in the file }
     Index := Symbol_Code_Number + Library_Size + 1 ;
     FIND ( Library_Pointer, Index       ) ;
     READ ( Library_Pointer, Data_String ) ;

     { #1 SYMBOL CODE NUMBER = Symbol_Code_Number }
     SString := Blank_40 ;
     Number_Of_Characters := 3 ;
     FOR I := 1 TO Number_Of_Characters DO
         SString[I] := Data_String[I+1];
     Convert_To_Numeric( SString, Number_Of_Characters, Value, Error );

     I := TRUNC ( Value ) ;
     IF Symbol_Code_Number <> I
        THEN BEGIN
                WRITELN( '**** THE SYMBOL FILE MUST BE REVISED ****' );
             END;

     { #2   SYMBOL LEVEL = Symbol_Level }
     SString := Blank_40 ;
     Number_Of_Characters := 3 ;
     FOR I := 1 TO Number_Of_Characters DO
         SString[I] := Data_String[I+34];
     Convert_To_Numeric( SString, Number_Of_Characters, Value, Error );
     IF NOT ERROR
        THEN Symbol_Level := TRUNC ( Value )
        ELSE Symbol_Level := 0 ;

     { #14 RELATIVE TO ( G/H/N )     Symbol_Rotation_Relative_To }
     Symbol_Rotation_Relative_To := 'NORTH AXIS    ' ;

     IF Data_String[38] = 'H'
        THEN Symbol_Rotation_Relative_To := 'HORIZONTAL    ' ;
     IF Data_String[38] = 'G'
        THEN Symbol_Rotation_Relative_To := 'GRID LINES    ' ;
     IF Data_String[38] = 'N'
        THEN Symbol_Rotation_Relative_To := 'NORTH AXIS    ' ;
     IF Data_String[38] = 'D'
        THEN Symbol_Rotation_Relative_To := 'DIGITIZED AXIS' ;

     { #3   ALPHA DESCRIPTION  = Symbol_Alpha_Description }
     Number_Of_Characters := 16 ;
     FOR I := 1 TO Number_Of_Characters DO
         BEGIN
         IF Data_String[I+4] IN [ 'a'..'z' ] THEN
           CC_Capitalise_Char ( Data_String[I+4] ) ;
         Symbol_Alpha_Description [I] := Data_String[I+4] ;
          END ;

     { #4 AUTOMATIC PEN SELECTION  = Symbol_Pen_Selection }
     SString := Blank_40 ;
     Number_Of_Characters := 1 ;
     FOR I := 1 TO Number_Of_Characters DO
         SString[I] := Data_String[I+20];
     Convert_To_Numeric( SString, Number_Of_Characters, Value, Error );
     IF NOT Error
        THEN Symbol_Pen_Selection := TRUNC ( Value )
        ELSE Symbol_Pen_Selection := 0 ;

     { #5 HARDWARE SYMBOL NUMBER = Hardware_Symbol_Number }
     Number_Of_Characters := 2 ;
     FOR I := 1 TO Number_Of_Characters DO
         SString [I] := Data_String[I+21];
     Convert_To_Numeric( SString, Number_Of_Characters, Value, Error );
     IF NOT Error
        THEN Hardware_Symbol_Number := TRUNC ( Value )
        ELSE Hardware_Symbol_Number := 0 ;

     { #6 SYMBOL FILE NAME = Symbol_File_Name }
     { align to the right }
     Number_Of_Characters := 10 ;
     N := Number_Of_Characters ;
     FOR I := 1 TO Number_Of_Characters DO
         IF Data_String[I+104] <> ' '
            THEN N := I ;
     Symbol_File_Name := Blank_40 ;
     FOR I := 1 TO N DO
         Symbol_File_Name [I + Number_Of_Characters -N] := Data_String[I+104];

     { #7 SYMBOL CELL SIZE   Standard_Symbol_Size }
     SString := Blank_40 ;
     Number_Of_Characters := 10 ;
     FOR I := 1 TO Number_Of_Characters DO
         SString[I] := Data_String[I+23];
     Convert_To_Numeric( SString, Number_Of_Characters, Value, Error );
     IF NOT Error
        THEN Standard_Symbol_Size := Value
        ELSE Standard_Symbol_Size := 0.0 ;
     IF Linear_Units [1] <> 'M'
        THEN BEGIN
                  Standard_Symbol_Size := Standard_Symbol_Size * 25.4 ;
                END ;

     { #8 SYMBOL ROTATION  Symbol_Rotation }
     IF Symbol_Rotation_Relative_To <> 'DIGITIZED AXIS'
        THEN BEGIN
                  SString := Blank_40 ;
                  Number_Of_Characters := 10 ;
                  FOR I := 1 TO Number_Of_Characters DO
                      SString[I] := Data_String[I+114];
                  Convert_To_Numeric
                         ( SString, Number_Of_Characters, Value, Error );
                  IF NOT Error
                     THEN Symbol_Rotation := Value / Ro
                     ELSE Symbol_Rotation := 0.0 ;
              END ;

     { #9 ANNOTATION  Symbol_Annotation }
     Number_Of_Characters := 4 ;
     FOR I := 1 TO Number_Of_Characters DO
         Symbol_Annotation [I] := Data_String[I+90];
     { fixed annotation Annotation_Type := 0 }


     { #10 FIXED TEXT  Symbol_Fixed_Text }
     Number_Of_Characters := 16 ;
     FOR I := 1 TO Number_Of_Characters DO
         Symbol_Fixed_Text [I] := Data_String[I+58];


     { #11 ANNOTATION SIZE  Symbol_Annotation_Size }
     SString := Blank_40 ;
     Number_Of_Characters := 10 ;
     FOR I := 1 TO Number_Of_Characters DO
         SString[I] := Data_String[I+38];
     Convert_To_Numeric( SString, Number_Of_Characters, Value, Error );
     IF NOT Error
        THEN Symbol_Annotation_Size := Value
        ELSE Symbol_Annotation_Size := 0.0 ;
     IF Linear_Units [1] <> 'M'
        THEN BEGIN
                  Symbol_Annotation_Size := Symbol_Annotation_Size * 25.4 ;
               END ;

     { #12 TEXT SLANT   Symbol_Annotation_Text_Slant , Angular_System }
     SString := Blank_40 ;
     Number_Of_Characters := 10 ;
     FOR I := 1 TO Number_Of_Characters DO
         SString[I] := Data_String[I+94];
     Convert_To_Numeric( SString, Number_Of_Characters, Value, Error );
     IF NOT Error
        THEN Symbol_Annotation_Text_Slant := Value / Ro
        ELSE Symbol_Annotation_Text_Slant := 0.0 ;

     { #13 TEXT ROTATION        Symbol_Text_Rotation , Angular_System }
     IF Symbol_Rotation_Relative_To <> 'DIGITIZED AXIS'
        THEN BEGIN
                  SString := Blank_40 ;
                  Number_Of_Characters := 10 ;
                  FOR I := 1 TO Number_Of_Characters DO
                      SString[I] := Data_String[I+48];
                  Convert_To_Numeric
                          ( SString, Number_Of_Characters, Value, Error );
                  IF NOT Error
                     THEN Symbol_Text_Rotation := Value / Ro
                     ELSE Symbol_Text_Rotation := 0.0 ;
              END ;

     { #15 VOICE RESPONSE          Symbol_Voice_Response }
     Number_Of_Characters := 16 ;
     FOR I := 1 TO Number_Of_Characters DO
         Symbol_Voice_Response [I] := Data_String[I+74];

     { determine the plot symbol rotation }
     IF Symbol_Rotation_Relative_To = 'HORIZONTAL    '
        THEN BEGIN
                  Symbol_Rotation :=  - Symbol_Rotation ;
                  Symbol_Text_Rotation :=  - Symbol_Text_Rotation ;
              END ;

     IF Symbol_Rotation_Relative_To = 'GRID LINES    '
        THEN BEGIN
                  Value := Plot_Rotation ;
                  IF Plot_Rotation < 0
                     THEN WHILE Value < - PI/4.0 DO Value := Value + PI/2.0
                     ELSE WHILE Value >   PI/4.0 DO Value := Value - PI/2.0 ;

                  Symbol_Rotation :=  - (Symbol_Rotation + Value ) ;
                  Symbol_Text_Rotation :=  - (Symbol_Text_Rotation + Value );
             END ;

     IF Symbol_Rotation_Relative_To = 'NORTH AXIS    '
        THEN BEGIN
                  Symbol_Rotation := Pi/2.0 - ( Symbol_Rotation
                                                           + Plot_Rotation ) ;
                  Symbol_Text_Rotation := Pi/2.0 - ( Symbol_Text_Rotation
                                                           + Plot_Rotation ) ;
             END ;


END; (* PROCEDURE Get Symbol Definition *)
END.
