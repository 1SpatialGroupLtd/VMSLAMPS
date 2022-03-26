[INHERIT ('Inherit_File')]
MODULE PLT11A ;

{ PLT11A.PAS <> }

(********************************************************************)
[GLOBAL] PROCEDURE IPP_Initialise_Plot_Parameters ;
(********************************************************************)
VAR
  I   : INTEGER ;

BEGIN (* IPP_Initialise_Plot_Parameters *)

  Line_Type_Code_Number := 1       ;
  Symbol_Code_Number    := 1       ;
  Quiet_Display         := FALSE ;

  { initialising definition page number 1 }
  Linear_Units      := 'METRIC ' ;
  Meters_or_Feet    := 'm ' ;
  MM_or_Inches      := 'mm' ;
  Rotation_Units    := 'GONS   ' ;
  Gons_or_Degrees   := ' gons   ' ;
  Ro                := 200.0 / Pi    ;
  Library_File_Name := 'LIBPAR.DAT                    ' ;
  Input_File_Name   := Blank_30 ;
  File_Format       := 'KERN CAM      ' ;
  Selected_Layers   := 'NO ' ;

  { initialising definition page number 2 }
  Event_Counter_Format := 5          ;
  Tag_Field_Single_Format := 16 ;
  Annotation_Format    := 16         ;
  Switch_Codes_Format  := 16         ;
  X_Single_Format      := '11.3    ' ;
  Y_Single_Format      := '11.3    ' ;
  Z_Single_Format      := '11.3    ' ;
  P_Single_Format      := '11.3    ' ;
  Computed_Area_Format := '11.3    ' ;
  Single_Recording_Order := 'EXYZP   ' ;

  { initialising definition page number 3 }
  Card_Number_Format        := 2  ;
  Tag_Field_Multiple_Format := 16 ;
  Fixed_Annotation          := 'PROJECT ABC     ' ;
  Decimal_Point_Recording   := 'YES' ;
  Sign_Of_P_Recording       := 'YES' ;
  X_Multiple_Format         := '11.3    ' ;
  Y_Multiple_Format         := '11.3    ' ;
  Z_Multiple_Format         := '11.3    ' ;
  P_Multiple_Format         := '11.3    ' ;
  Fixed_Annotation_Format   := 16 ;
  Multiple_Recording_Order  := 'XYZPXYZPXYZP   ' ;

  { initialising definition page number 4 }
  Plotter_Mode      := 'OFF-LINE' ;
  Plot_Horizontal   := '+X'       ;
  Plot_Vertical     := '+Y'       ;
  Plot_X_Scale      := 1000.0     ;
  Plot_Y_Scale      := 1000.0     ;
  Plot_Rotation     := 0.0        ;
  Plot_X_Index      := 0.0        ;
  Plot_Y_Index      := 0.0        ;
  Input_Sheet_Window    := FALSE ;

  { initialising definition page number 5 }
  Plot_Horizontal_Size  := 300.0 ;
  Plot_Vertical_Size    := 300.0 ;

  { initialising definition page number 6 }
  Nr_Window_Pts := 0 ;
  FOR I := 1 TO Max_Window_Points DO
      BEGIN
      X_Window [I] := 0.0 ;
      Y_Window [I] := 0.0 ;
      END ;

END ; (* IPP_Initialise_Plot_Parameters *)
END.
