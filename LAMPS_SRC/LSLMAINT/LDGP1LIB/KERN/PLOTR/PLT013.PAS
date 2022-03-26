[INHERIT ('Inherit_File')]
MODULE PLT013 ;

{ PLT013.PAS <> }

(**********************************************************************)
 [GLOBAL] PROCEDURE Get_Line_Definition ;
(**********************************************************************)

VAR
   I           : INTEGER;

   Data_String : String_128 ;

   SString      : String_40 ;
   Number_Of_Characters : INTEGER ;
   Value       : DOUBLE ;
   Error       : BOOLEAN ;


BEGIN  (* PROCEDURE Get_Line_Definition *)

     { init data string }
  FOR I := 1 TO 128 DO Data_String[I] := ' ';
     Data_String [127] := CHR (12) ;
     Data_String [128] := CHR (10) ;
 
     { read the data from the files }
     FIND ( Library_Pointer, Line_Type_Code_Number ) ;
     READ ( Library_Pointer, Data_String           ) ;

     { #1   LINE TYPE CODE NUMBER  = Line_Type_Code_Number }
     SString := Blank_40 ;
     Number_Of_Characters := 3 ;
     FOR I := 1 TO Number_Of_Characters DO
         SString[I] := Data_String[I+1];
     Convert_To_Numeric (SString, Number_Of_Characters, Value, Error );

     I := TRUNC ( Value );
     IF Line_Type_Code_Number <> I
        THEN BEGIN
                  WRITELN( '**** THE LINE FILE MUST BE REVISED ****' );
               END;

     { #2   LINE LEVEL = Line_Level }
     SString := Blank_40 ;
     Number_Of_Characters := 3 ;
     FOR I := 1 TO Number_Of_Characters DO
         SString[I] := Data_String[I+84];
     Convert_To_Numeric( SString, Number_Of_Characters, Value, Error );
     IF NOT ERROR
        THEN Line_Level := TRUNC ( Value )
        ELSE Line_Level := 0 ;

     { #3   ALPHA DESCRIPTOR  = Line_Alpha_Description }
     Number_Of_Characters := 16 ;
     FOR I := 1 TO Number_Of_Characters DO
         BEGIN
         IF Data_String[I+4] IN [ 'a'..'z' ] THEN
            CC_Capitalise_Char ( Data_String[I+4] ) ;
         Line_Alpha_Description [I] := Data_String[I+4] ;
          END ;

     { #4   AUTOMATIC PEN SELECTION = Line_Pen_Selection }
     SString := Blank_40 ;
     Number_Of_Characters := 1 ;
     FOR I := 1 TO Number_Of_Characters DO
         SString[I] := Data_String[I+20];
     Convert_To_Numeric( SString, Number_Of_Characters, Value, Error );
     IF NOT ERROR
        THEN Line_Pen_Selection := TRUNC ( Value )
        ELSE Line_Pen_Selection := 0 ;

     { #5   HARDWARE LINE TYPE NUMBER = Hardware_Line_Type_Number }
     SString := Blank_40 ;
     Number_Of_Characters := 2 ;
     FOR I := 1 TO Number_Of_Characters DO
         SString[I] := Data_String[I+21];
     Convert_To_Numeric( SString, Number_Of_Characters, Value, Error );
     IF NOT ERROR
        THEN Hardware_Line_Type_Number := TRUNC ( Value )
        ELSE Hardware_Line_Type_Number := 0 ;

     { #6  LINE CELL SIZE = Standard_Line_Size }
     SString := Blank_40 ;
     Number_Of_Characters := 10 ;
     FOR I := 1 TO Number_Of_Characters DO
         SString[I] := Data_String[I+23];
     Convert_To_Numeric( SString, Number_Of_Characters, Value, Error );
     IF NOT ERROR
        THEN Standard_Line_Size := Value
        ELSE Standard_Line_Size := 0.0 ;
     IF Linear_Units [1] <> 'M'
        THEN BEGIN
                  Standard_Line_Size := Standard_Line_Size * 25.4 ;
               END ;

     { #7  LINE RATIO = Line_Ratio }
     SString := Blank_40 ;
     Number_Of_Characters := 10 ;
     FOR I := 1 TO Number_Of_Characters DO
         SString[I] := Data_String[I+54];
     Convert_To_Numeric( SString, Number_Of_Characters, Value, Error );
     IF NOT ERROR
        THEN Line_Ratio := Value
        ELSE Line_Ratio := 0.0 ;

     { #8  INCLUDED SYMBOL NUMBER = Line_Symbol_Number }
     SString := Blank_40 ;
     Number_Of_Characters := 2 ;
     FOR I := 1 TO Number_Of_Characters DO
         SString[I] := Data_String[I+33];
     Convert_To_Numeric( SString, Number_Of_Characters, Value, Error );
     IF NOT ERROR
        THEN Line_Symbol_Number := TRUNC ( Value )
        ELSE Line_Symbol_Number := 0 ;

     { #9  SYMBOL ROTATION = Line_Symbol_Rotation }
     SString := Blank_40 ;
     Number_Of_Characters := 10 ;
     FOR I := 1 TO Number_Of_Characters DO
         SString[I] := Data_String[I+64];
     Convert_To_Numeric( SString, Number_Of_Characters, Value, Error );
     IF NOT Error
        THEN Line_Symbol_Rotation := Value / Ro
        ELSE Line_Symbol_Rotation := 0 ;

     { #10   NODE SYMBOL NUMBER = Line_Node_Symbol_Number }
     SString := Blank_40 ;
     Number_Of_Characters := 3 ;
     FOR I := 1 TO Number_Of_Characters DO
         SString[I] := Data_String[I+35];
     Convert_To_Numeric( SString, Number_Of_Characters, Value, Error );
     IF NOT Error
        THEN Line_Node_Symbol_Number := TRUNC ( Value )
        ELSE Line_Node_Symbol_Number := 0 ;

     { #11   VOICE RESPONSE = Line_Voice_Response }
     Number_Of_Characters := 16 ;
     FOR I := 1 TO Number_Of_Characters DO
         Line_Voice_Response [I] := Data_String[I+38];

END; (* PROCEDURE Get_Line_Definition *)
END.
