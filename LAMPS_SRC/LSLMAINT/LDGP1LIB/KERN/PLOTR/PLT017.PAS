[INHERIT ('Inherit_File')]
MODULE PLT017 ;

{ PLT017.PAS <> }

(**************************************************************************)
[GLOBAL] PROCEDURE CGTT_Compute_Ground_To_Table_Transformation ;
(**************************************************************************)
VAR
   Plot_X_Scale_Factor:		DOUBLE ;
   Plot_Y_Scale_Factor:		DOUBLE ;

   X_Scale,
   X_Angle,
   Y_Scale,
   Y_Angle,
   X_Preset,
   Y_Preset : DOUBLE ;

   In_Read  : TEXT ;
   Len      : INTEGER ;
   I, N     : INTEGER ;

   Message_4 : String_40 ;


{=========================================}
PROCEDURE Get_Field ;
{=========================================}
VAR
     Ch : CHAR ;
BEGIN
     REPEAT
          READ ( In_Read, Ch ) ;
     UNTIL (Ch = '=') OR (Ch = '?') OR (Ch = ':') ;
     READ ( In_Read, Ch ) ;
END ; (* Get_Field *)


{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
BEGIN (* CGTT_Compute_Ground_To_Table_Transformation *)

  {  Compute Transformation Matrix Ground To Table }
    Plot_X_Scale_Factor := 1.0 / Plot_X_Scale ;
    Plot_Y_Scale_Factor := 1.0 / Plot_Y_Scale ;

    { change scale from m to mm }
    IF Linear_Units = 'METRIC '
       THEN Ground_Unit_To_Table_Unit_Factor := 1000.0 ;

    { change scale from feet to mm }
    IF Linear_Units = 'ENGLISH'
       THEN Ground_Unit_To_Table_Unit_Factor := 25.4 * 12 ;

      E1 :=   Plot_X_Scale_Factor * COS ( - Plot_Rotation )
            * Ground_Unit_To_Table_Unit_Factor ;
      E2 := - Plot_Y_Scale_Factor * SIN ( - Plot_Rotation )
            * Ground_Unit_To_Table_Unit_Factor ;

      F1 :=   Plot_X_Scale_Factor * SIN ( - Plot_Rotation )
            * Ground_Unit_To_Table_Unit_Factor ;
      F2 :=   Plot_Y_Scale_Factor * COS ( - Plot_Rotation )
            * Ground_Unit_To_Table_Unit_Factor ;

      E0 := - ( E1 * Plot_X_Index + E2 * Plot_Y_Index ) ;
      F0 := - ( F1 * Plot_X_Index + F2 * Plot_Y_Index ) ;

      IF Plot_Horizontal [1] = '-'
         THEN BEGIN
                   E0 := - E0 ;
                   E1 := - E1 ;
                   E2 := - E2 ;
                END ;

      IF Plot_Vertical [1] = '-'
         THEN BEGIN
                   F0 := - F0 ;
                   F1 := - F1 ;
                   F2 := - F2 ;
                END ;

      { Download these parameters to the graphics library level }
      Download_WTT_Transformation ( E1, E2, E0, F1, F2, F0 ) ;

  {  Transformation Formulae Ground To Table }
  {
  X_Table := E1 * East + E2 * North + E0 ;
  Y_Table := F1 * East + F2 * North + F0 ;
  }

     { has sheet orientation been done }
     OPEN ( In_Read,
            FILE_NAME := 'SHEETO.DAT',
            HISTORY := OLD,
            ERROR := CONTINUE ) ;
     RESET ( In_Read, ERROR := CONTINUE ) ;
     IF EOF ( In_Read ) THEN Len := -1
     ELSE Len := 1 ;

     IF Len > 0
        THEN BEGIN
                  KT_Kern_Title (Ten_Digit_Number, Title) ;
                  Message_4 := 'READING SHEETO.DAT                      ' ;
                  IRAWF_Indicate_Reading_And_Writing_Files
                  ('  Reading Sheet Orientation Parameters  ', Message_4 ) ;

                  FOR I := 1 TO 12 DO READLN ( In_Read ) ;
                  Get_Field ; READLN ( In_Read , N ) ;
                  FOR I := 1 TO 2*N+6 DO READLN ( In_Read ) ;
                  Get_Field ; READ ( In_Read , X_Scale ) ;
                  Get_Field ; READ ( In_Read , X_Angle ) ;
                  Get_Field ; READ ( In_Read , Y_Scale ) ;
                  Get_Field ; READ ( In_Read , Y_Angle ) ;
                  Get_Field ; READ ( In_Read , X_Preset ) ;
                  Get_Field ; READ ( In_Read , Y_Preset ) ;

                  IF    ( X_Scale = Plot_X_Scale )
                    AND ( Y_Scale = Plot_Y_Scale )
                    AND ( ABS(X_Angle+Y_Angle-2*Plot_Rotation*Ro) < 0.001 )
                    AND ( X_Preset = Plot_X_Index )
                    AND ( Y_Preset = Plot_Y_Index )
                    THEN BEGIN
                            RESET ( In_Read );
                            READLN ( In_Read, E1, E2, E0 ) ;
                            READLN ( In_Read, F1, F2, F0 ) ;
                          END;
            END ;

END ; (* CGTT_Compute_Ground_To_Table_Transformation *)


(********************************************************************)
[GLOBAL] PROCEDURE COF_Compute_Input_Formats ;
(********************************************************************)
VAR
   I  : INTEGER ;

(********************************************************************)
PROCEDURE CRF_Check_Real_Format ( VAR Format          : String_8 ;
                                  VAR Format_Field,
                                      Format_Decimals : INTEGER  ) ;
(********************************************************************)
VAR
   Field,
   Decimals,
   I,
   N_Dec      : INTEGER ;

   SString               : String_40 ;
   Number_Of_Characters : INTEGER ;
   Value                : DOUBLE ;
   Error                : BOOLEAN ;

BEGIN
     Error := FALSE ;
     Field    := 0 ;
     Decimals := 0 ;
     SString := Blank_40 ;

     Number_Of_Characters := 0 ;
     FOR I := 1 TO 8 DO
         IF Format [I] <> ' '
            THEN BEGIN
                      Number_Of_Characters := Number_Of_Characters + 1 ;
                      SString [I] := Format [I] ;
                   END ;

     Convert_To_Numeric (SString, Number_Of_Characters, Value, Error);

     { only one decimal place is allowed }
     N_Dec := 0 ;
     I := 0 ;
     REPEAT
           I := I + 1 ;
           IF SString [I] = '.'
              THEN N_Dec := I ;
     UNTIL   ( SString [I] = '.' )
          OR ( I=40 ) ;

     IF    ( N_Dec > 0 )
       AND ( I < 40-1 )
       THEN
           FOR I := N_Dec+2 TO 40 DO
               IF SString [I] <> ' '
                  THEN Error := TRUE ;

     IF Value <= 0
        THEN Error := TRUE ;

     IF NOT Error
        THEN BEGIN
                  Field := TRUNC ( Value ) ;
                  Decimals := ROUND ( (Value-Field) * 10.0 ) ;
               END ;

     IF NOT Error
        THEN BEGIN
                  IF Decimals > Field
                     THEN Error := TRUE ;
                  IF Field > Max_Field
                     THEN Error := TRUE ;
               END ;

     IF NOT Error
        THEN BEGIN
                  Format_Field := Field ;
                  Format_Decimals := Decimals ;
               END
        ELSE BEGIN
                  Format := '11.3    ' ;
                  Format_Field := 11 ;
                  Format_Decimals := 3 ;
               END ;

END ; (* CRF_Check_Real_Format *)


BEGIN (* COF_Compute_Input_Formats *)

     IF File_Format [1] = 'K'
        THEN Kern_Cam_System_Format := TRUE
        ELSE Kern_Cam_System_Format := FALSE ;

     IF File_Format [1] = 'S'
        THEN Single_Point_Format := TRUE
        ELSE Single_Point_Format := FALSE ;

     IF File_Format [1] = 'M'
        THEN Multiple_Point_Format := TRUE
        ELSE Multiple_Point_Format := FALSE ;


     IF   Single_Point_Format
        OR Kern_Cam_System_Format
        THEN BEGIN
                  CRF_Check_Real_Format (X_Single_Format, X_Format_Field,
                                         X_Format_Decimals ) ;

                  CRF_Check_Real_Format (Y_Single_Format, Y_Format_Field,
                                         Y_Format_Decimals ) ;

                  CRF_Check_Real_Format (Z_Single_Format, Z_Format_Field,
                                         Z_Format_Decimals ) ;

                  CRF_Check_Real_Format (P_Single_Format, P_Format_Field,
                                         P_Format_Decimals ) ;
              END ;

     IF Multiple_Point_Format
        THEN BEGIN
                  CRF_Check_Real_Format (X_Multiple_Format, X_Format_Field,
                                         X_Format_Decimals ) ;

                  CRF_Check_Real_Format (Y_Multiple_Format, Y_Format_Field,
                                         Y_Format_Decimals ) ;

                  CRF_Check_Real_Format (Z_Multiple_Format, Z_Format_Field,
                                         Z_Format_Decimals ) ;

                  CRF_Check_Real_Format (P_Multiple_Format, P_Format_Field,
                                         P_Format_Decimals ) ;
              END ;

     CRF_Check_Real_Format
        (Computed_Area_Format, Computed_Area_Format_Field,
         Computed_Area_Format_Decimals ) ;

END ; (* COF_Compute_Input_Formats *)
END.
