[INHERIT ('Inherit_File')]
MODULE PLT061 ;

{ PLT061.PAS <> }

(**********************************************************************)
[GLOBAL] PROCEDURE PA_Plot_Annotation
             ( Annotation : String_40 ) ;
(**********************************************************************)
CONST
  Space = 2.0 ;

VAR
  I, J,
  Line_Number,
  N_Values,
  Field,
  Decimals     : INTEGER ;

  Value:	DOUBLE ;
  A, B,
  dX, dY       : DOUBLE ;
  SString       : String_40 ;

BEGIN

  { number of coordinates to plot }
  N_Values := 0 ;
  FOR I := 1 TO 4 DO
    IF Symbol_Annotation [I] IN [ 'X'..'Z', 'P', 'E', 'C', 'V', 'F'] THEN
      N_Values := N_Values + 1 ;

  { transformation values }
  A := Cos (Symbol_Text_Rotation) ;
  B := Sin (Symbol_Text_Rotation) ;

  { 4 possible characters in Text Format }
  Line_Number := 0 ;

  FOR I := 1 TO 4 DO
    BEGIN
      IF Symbol_Annotation [I] IN [ 'X'..'Z', 'P', 'E', 'C', 'V', 'F' ] THEN
        BEGIN
          Line_Number := Line_Number + 1 ;
          dX := 0.75 * Standard_Symbol_Size * Display_Scale_Factor ;
          dY := Symbol_Annotation_Size * Display_Scale_Factor * N_Values
                + Space * (N_Values-1) ;
          dY := dY/2.0 - Symbol_Annotation_Size * Display_Scale_Factor
                * Line_Number - Space * (Line_Number-1) ;

          { next text offset plotting position }
          Plot_Line ( P4, Up, (X_Table + A * dX - B * dY),
                              (Y_Table + B * dX + A * dY),
                              Height, Plotter_Device ) ;
        END ;

      CASE Symbol_Annotation [I] OF
        'F' : BEGIN
                SString := Blank_40 ;
                FOR J := 1 TO 16 DO
                  SString[J] := Symbol_Fixed_Text [J] ;
                PStr ( P4, SString ) ;
              END ;

        'V' : PStr   ( P4, Annotation ) ;

        'E' : BEGIN
                Value := Event_Counter ;
                Field := Event_Counter_Format ;
                Decimals := 0 ;
              END;

        'C' : BEGIN
                Value := Computed_Area ;
                Field := Computed_Area_Format_Field ;
                Decimals := Computed_Area_Format_Decimals ;
              END;

        'X' : BEGIN
                Value := East ;
                Field := X_Format_Field ;
                Decimals := X_Format_Decimals ;
              END ;

        'Y' : BEGIN
                Value := North ;
                Field := Y_Format_Field ;
                Decimals := Y_Format_Decimals ;
              END ;

        'Z' : BEGIN
                Value := Height ;
                Field := Z_Format_Field ;
                Decimals := Z_Format_Decimals ;
              END ;

        'P' : BEGIN
                Value := P_Distance ;
                Field := P_Format_Field ;
                Decimals := P_Format_Decimals ;
              END ;

        OTHERWISE
      END ;  { case }

      IF Symbol_Annotation [I] IN [ 'X'..'Z', 'P', 'E', 'C' ] THEN
        BEGIN
          IF ( I < 4 ) AND ( Symbol_Annotation [I+1] IN ['0'..'9'] ) THEN
            BEGIN
              Field := 1 ;
              Decimals := ORD( Symbol_Annotation [I+1] ) - ORD ( '0' ) ;
              CRTS_Convert_Real_To_String ( Value, Field, Decimals, SString  ) ;

              { leave one empty character }
              Field := Field + 1 ;
            END ;

          CRTS_Convert_Real_To_String ( Value, Field, Decimals, SString ) ;
          PStr ( P4, SString ) ;
        END ;

    END ;  { for I }

END ;  (* PROCEDURE PA_Plot_Annotation *)
END.
