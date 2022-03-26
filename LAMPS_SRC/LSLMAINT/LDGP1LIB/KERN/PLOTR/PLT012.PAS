[INHERIT ('Inherit_File')]
MODULE PLT012 ;

{ PLT012.PAS <> }

(********************************************************************)
[GLOBAL] PROCEDURE WPP_Write_Plot_Parameters_File ;
(********************************************************************)
CONST
     Work_File = 'WORKPL.TEM' ;

VAR
   Out_Write       : TEXT    ;
   I, Len          : INTEGER ;

   Current_Time: String_8;

   Message_4               : String_40 ;
   Date                    : String_9 ;
   Angular_Units           : String_8 ;



(********************************************************************)
PROCEDURE WH_Write_Heading ;
(********************************************************************)
VAR
  I  : INTEGER ;

BEGIN (* WH_Write_Heading *)

  FD_Find_Date (Date) ;

  IF Rotation_Units = 'GONS   '
     THEN Angular_Units := ' gons   '
     ELSE Angular_Units := ' degrees' ;

   GT_Get_Time ( Current_Time );

   KT_Kern_Title (Ten_Digit_Number, Title) ;
   Message_4 := 'WRITING                                 ' ;
   FOR I := 1 TO File_Name_Length-8 DO Message_4 [I+8] := Plot_Parameter_File [I] ;
   IRAWF_Indicate_Reading_And_Writing_Files
   ('  Writing Off-Line Plotting Parameters  ', Message_4 ) ;

   WRITELN (Out_Write) ;
   WRITELN (Out_Write, 'Kern Off-Line Plot Program ',Ten_Digit_Number:14) ;
   WRITELN (Out_Write, '-----------------------------------------') ;
   WRITELN (Out_Write) ;
   WRITELN (Out_Write, 'This file is called ', Plot_Parameter_File) ;
   WRITELN (Out_Write) ;
   WRITELN (Out_Write, 'This file has been updated : ',Date:9) ;

   WRITE   (Out_Write, '                      Time : ',Current_Time ) ;

   WRITELN (Out_Write) ;
   WRITELN (Out_Write) ;
   WRITELN (Out_Write) ;
   WRITELN (Out_Write) ;

END ; (* WH_Write_Heading *)


(********************************************************************)
PROCEDURE WF_Write_File ;
(********************************************************************)
VAR
  I  : INTEGER ;

BEGIN (* WF_Write_File *)

   WRITELN (Out_Write, 'Definition Pages:') ;
   WRITELN (Out_Write, '~~~~~~~~~~~~~~~~~') ;
   WRITELN (Out_Write) ;
   WRITELN (Out_Write, 'Page 1                                      OVERALL PARAMETERS') ;
   WRITELN (Out_Write, '--------------------------------------------------------------') ;
   WRITELN (Out_Write, 'GROUND UNITS              = ', Linear_Units:7 ) ;
   WRITELN (Out_Write, 'GROUND ROTATION           = ', Rotation_Units:7) ;
   WRITELN (Out_Write, 'LIBRARY FILE NAME         = ', Library_File_Name) ;
   WRITELN (Out_Write, 'INPUT FILE NAME           = ', Input_File_Name) ;
   WRITELN (Out_Write, 'FILE FORMAT               = ', File_Format ) ;
   WRITELN (Out_Write, 'SELECTED LEVELS/LAYERS    = ', Selected_Layers ) ;
   WRITELN (Out_Write) ;

   WRITELN (Out_Write, 'Page 2                                     SINGLE POINT FORMAT') ;
   WRITELN (Out_Write, '--------------------------------------------------------------') ;
   WRITELN (Out_Write, 'EVENT COUNTER FORMAT      = ', Event_Counter_Format:2) ;
   WRITELN (Out_Write, 'TAG FIELD FORMAT          = ', Tag_Field_Single_Format:2) ;
   WRITELN (Out_Write, 'ANNOTATION FORMAT         = ', Annotation_Format:2) ;
   WRITELN (Out_Write, 'SWITCH CODES FORMAT       = ', Switch_Codes_Format:2) ;
   WRITELN (Out_Write, 'X FORMAT                  = ', X_Single_Format:8) ;
   WRITELN (Out_Write, 'Y FORMAT                  = ', Y_Single_Format:8) ;
   WRITELN (Out_Write, 'Z FORMAT                  = ', Z_Single_Format:8) ;
   WRITELN (Out_Write, 'P FORMAT                  = ', P_Single_Format:8) ;
   WRITELN (Out_Write, 'COMPUTED AREA FORMAT      = ', Computed_Area_Format:8) ;
   WRITELN (Out_Write, 'RECORDING ORDER           = ', Single_Recording_Order:8) ;
   WRITELN (Out_Write) ;

   WRITELN (Out_Write, 'Page 3                                   MULTIPLE POINT FORMAT') ;
   WRITELN (Out_Write, '--------------------------------------------------------------') ;
   WRITELN (Out_Write, 'CARD NUMBER FORMAT        = ', Card_Number_Format:1);
   WRITELN (Out_Write, 'TAG FIELD FORMAT          = ', Tag_Field_Multiple_Format:1 ) ;
   WRITELN (Out_Write, 'FIXED ANNOTATION          = ', Fixed_Annotation ) ;
   WRITELN (Out_Write, 'DECIMAL POINT RECORDING   = ', Decimal_Point_Recording ) ;
   WRITELN (Out_Write, 'SIGN OF P RECORDING       = ', Sign_Of_P_Recording ) ;
   WRITELN (Out_Write, 'X FORMAT                  = ', X_Multiple_Format:8) ;
   WRITELN (Out_Write, 'Y FORMAT                  = ', Y_Multiple_Format:8) ;
   WRITELN (Out_Write, 'Z FORMAT                  = ', Z_Multiple_Format:8) ;
   WRITELN (Out_Write, 'P FORMAT                  = ', P_Multiple_Format:8) ;
   WRITELN (Out_Write, 'FIXED ANNOTATION FORMAT   = ', Fixed_Annotation_Format :1 ) ;
   WRITELN (Out_Write, 'RECORDING ORDER           = ', Multiple_Recording_Order:15 ) ;
   WRITELN (Out_Write) ;

   WRITELN (Out_Write, 'Page 4                                   MANUSCRIPT PARAMETERS') ;
   WRITELN (Out_Write, '--------------------------------------------------------------') ;
   WRITELN (Out_Write, 'PLOT HORIZONTAL           = ', Plot_Horizontal:2) ;
   WRITELN (Out_Write, 'PLOT VERTICAL             = ', Plot_Vertical:2) ;
   IF Linear_Units [1] <> 'M'
    THEN BEGIN
         Plot_X_Scale := Plot_X_Scale / 12.0 ;
         Plot_Y_Scale := Plot_Y_Scale / 12.0 ;
         END ;
   WRITELN (Out_Write, '+ X SCALE                 = ', Plot_X_Scale:13:3) ;
   WRITELN (Out_Write, '+ Y SCALE                 = ', Plot_Y_Scale:13:3) ;
   WRITELN (Out_Write, 'PLOT ROTATION             = ', Plot_Rotation*Ro:13:6, Angular_Units:8 ) ;
   WRITELN (Out_Write, '+ X INDEX                 = ', Plot_X_Index:13:3, Meters_or_Feet:3 ) ;
   WRITELN (Out_Write, '+ Y INDEX                 = ', Plot_Y_Index:13:3, Meters_or_Feet:3 ) ;
   IF Linear_Units [1] <> 'M'
    THEN BEGIN
         Plot_Horizontal_Size := Plot_Horizontal_Size / 25.4 ;
         Plot_Vertical_Size := Plot_Vertical_Size / 25.4 ;
         END ;
   WRITE (Out_Write, 'INPUT SHEET WINDOW        = ' ) ;
   IF Input_Sheet_Window THEN WRITELN (Out_Write, 'YES' )
                         ELSE WRITELN (Out_Write, 'NO ' ) ;
   WRITELN (Out_Write) ;

   WRITELN (Out_Write, 'Page 5                                         MANUSCRIPT SIZE ' ) ;
   WRITELN (Out_Write, '--------------------------------------------------------------') ;
   WRITELN (Out_Write, 'PLOT HORIZONTAL SIZE      = ', Plot_Horizontal_Size:13:2, MM_or_Inches:3 ) ;
   WRITELN (Out_Write, 'PLOT VERTICAL SIZE        = ', Plot_Vertical_Size:13:2, MM_or_Inches:3 ) ;
   WRITELN (Out_Write) ;

   WRITELN (Out_Write, 'Page 6                                       MANUSCRIPT WINDOW ' ) ;
   WRITELN (Out_Write, '--------------------------------------------------------------') ;
   WRITELN (Out_Write, 'NUMBER OF WINDOW POINTS = ', Nr_Window_Pts:6 ) ;
   WRITELN (Out_Write) ;
   WRITELN (Out_Write, '                    EASTING            NORTHING ' ) ;
   IF Nr_Window_Pts > 0
    THEN FOR I := 1 TO Nr_Window_Pts DO
             WRITELN (Out_Write, I:4, '.',  X_Window [I] :24:3,
                                            Y_Window [I] :20:3 ) ;
   WRITELN (Out_Write) ;


   WRITELN (Out_Write) ;
   WRITELN (Out_Write, 'END OF FILE') ;


END ; (* WF_Write_File *)


(***********************************************************************)
PROCEDURE WPF_Write_Plot_File ;
(***********************************************************************)
CONST
  End_Of_File = 'END OF FILE                                                           ' ;

TYPE
  String_72 = PACKED ARRAY [1..72] OF CHAR ;

VAR
  Line_String  : String_72 ;
  Plot_Write   : FILE OF String_72 ;

BEGIN (* WPF_Write_Plot_File *)

   OPEN ( Plot_Write,
          FILE_NAME := Plot_Parameter_File,
          HISTORY := UNKNOWN ) ;
   REWRITE ( Plot_Write ) ;

   REPEAT

      READLN  ( Out_Write, Line_String ) ;
      Line_String [71] := CHR(13) ;
      Line_String [72] := CHR(10) ;
      WRITE ( Plot_Write, Line_String ) ;

   UNTIL EOF (Out_Write) ;

   CLOSE   (Plot_Write) ;

END ; (* WPF_Write_Plot_File *)



{====================================================================}

BEGIN (* WPP_Write_Plot_Parameters_File *)

   OPEN ( Out_Write,
          FILE_NAME := Work_File,
          ACCESS_METHOD := SEQUENTIAL,
          DISPOSITION := DELETE ) ;
   REWRITE (Out_Write ) ;

   WH_Write_Heading ;
   WF_Write_File ;

   RESET   (Out_Write) ;

   WPF_Write_Plot_File ;

   CLOSE   (Out_Write) ;

END ; (* WPP_Write_Plot_Parameters_File *)
END.

