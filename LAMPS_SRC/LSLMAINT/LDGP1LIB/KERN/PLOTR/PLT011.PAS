[INHERIT ('Inherit_File')]
MODULE PLT011 ;

{ PLT011.PAS <> }

(********************************************************************)
[GLOBAL] PROCEDURE RPP_Read_Plot_Parameters_File ;
(********************************************************************)

VAR
     I, Len       : INTEGER ;
     Message_4    : String_40 ;
     In_Read      : TEXT    ;
     Ch           : CHAR    ;
     Dummy_10     : String_10 ;


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


{====================================================================}

BEGIN (* RPP_Read_Plot_Parameters_File *)

     Plot_Parameter_File   := 'PLOTR.DEF                     ' ;

     KT_Kern_Title (Ten_Digit_Number, Title) ;
     Message_4 := 'READING                                 ' ;
     FOR I := 1 TO File_Name_Length-8 DO Message_4 [I+8] := Plot_Parameter_File [I] ;
     IRAWF_Indicate_Reading_And_Writing_Files
     ('  Reading Off-Line Plotting Parameters  ', Message_4 ) ;

     OPEN ( In_Read,
            FILE_NAME := Plot_Parameter_File,
            HISTORY := OLD,
            ERROR := CONTINUE ) ;
     RESET (In_Read, ERROR := CONTINUE ) ;
     IF EOF ( in_Read ) THEN Len := -1
     ELSE Len := 1 ;

     IF Len > 0
     THEN BEGIN
          FOR I := 1 TO 13 DO    READLN (In_Read) ;

          { reading definition page number 1 }
          FOR I := 1 TO 3 DO  READLN (In_Read) ;
          Get_Field ;  READLN (In_Read, Linear_Units  ) ;
          IF Linear_Units [1] = 'M'
             THEN BEGIN
                       Meters_or_Feet := 'm ' ;
                       MM_or_Inches   := 'mm' ;
                    END
             ELSE BEGIN
                       Meters_or_Feet := 'ft' ;
                       MM_or_Inches   := 'in' ;
                    END ;
          Get_Field ;  READLN (In_Read, Rotation_Units) ;
          IF Rotation_Units [1] = 'G'
               THEN BEGIN
                         Ro := 200.0 / Pi ;
                         Gons_or_Degrees := ' gons   ' ;
                      END
               ELSE BEGIN
                         Ro := 180.0 / Pi ;
                         Gons_or_Degrees := ' degrees' ;
                      END ;
          Get_Field ;  READLN (In_Read, Library_File_Name ) ;
          Get_Field ;  READLN (In_Read, Input_File_Name    ) ;
          Get_Field ;  READLN (In_Read, File_Format ) ;
          Get_Field ;  READLN (In_Read, Selected_Layers ) ;

          { reading definition page number 2 }
          FOR I := 1 TO 3 DO  READLN (In_Read) ;
          Get_Field ;  READLN (In_Read, Event_Counter_Format ) ;
          Get_Field ;  READLN (In_Read, Tag_Field_Single_Format ) ;
          Get_Field ;  READLN (In_Read, Annotation_Format    ) ;
          Get_Field ;  READLN (In_Read, Switch_Codes_Format  ) ;
          Get_Field ;  READLN (In_Read, X_Single_Format      ) ;
          Get_Field ;  READLN (In_Read, Y_Single_Format      ) ;
          Get_Field ;  READLN (In_Read, Z_Single_Format      ) ;
          Get_Field ;  READLN (In_Read, P_Single_Format      ) ;
          Get_Field ;  READLN (In_Read, Computed_Area_Format ) ;
          Get_Field ;  READLN (In_Read, Single_Recording_Order ) ;

          { reading definition page number 3 }
          FOR I := 1 TO 3 DO  READLN (In_Read) ;
          Get_Field ;  READLN (In_Read, Card_Number_Format ) ;
          Get_Field ;  READLN (In_Read, Tag_Field_Multiple_Format ) ;
          Get_Field ;  READLN (In_Read, Fixed_Annotation ) ;
          Get_Field ;  READLN (In_Read, Decimal_Point_Recording ) ;
          Get_Field ;  READLN (In_Read, Sign_Of_P_Recording ) ;
          Get_Field ;  READLN (In_Read, X_Multiple_Format ) ;
          Get_Field ;  READLN (In_Read, Y_Multiple_Format ) ;
          Get_Field ;  READLN (In_Read, Z_Multiple_Format ) ;
          Get_Field ;  READLN (In_Read, P_Multiple_Format ) ;
          Get_Field ;  READLN (In_Read, Fixed_Annotation_Format ) ;
          Get_Field ;  READLN (In_Read, Multiple_Recording_Order ) ;

          { reading definition page number 4 }
          FOR I := 1 TO 3 DO  READLN (In_Read) ;
          Get_Field ;  READLN (In_Read, Plot_Horizontal   ) ;
          Get_Field ;  READLN (In_Read, Plot_Vertical     ) ;
          Get_Field ;  READLN (In_Read, Plot_X_Scale      ) ;
          Get_Field ;  READLN (In_Read, Plot_Y_Scale      ) ;
          IF Linear_Units [1] <> 'M'
           THEN BEGIN
                Plot_X_Scale := Plot_X_Scale * 12.0 ;
                Plot_Y_Scale := Plot_Y_Scale * 12.0 ;
                END ;
          IF (Plot_X_Scale = 0.0) THEN Plot_X_Scale := 1000.0 ;
          IF (Plot_Y_Scale = 0.0) THEN Plot_Y_Scale := 1000.0 ;
          Get_Field ;  READLN (In_Read, Plot_Rotation     ) ;
                       Plot_Rotation := Plot_Rotation / Ro ;
          Get_Field ;  READLN (In_Read, Plot_X_Index      ) ;
          Get_Field ;  READLN (In_Read, Plot_Y_Index      ) ;
          Get_Field ;  READLN (In_Read, Ch ) ;
          IF (Ch = 'Y') THEN Input_Sheet_Window := TRUE
                        ELSE Input_Sheet_Window := FALSE ;


          { reading definition page number 5 }
          Get_Field ;  READLN (In_Read, Plot_Horizontal_Size ) ;
          Get_Field ;  READLN (In_Read, Plot_Vertical_Size   ) ;
          IF Linear_Units [1] <> 'M'
           THEN BEGIN
                Plot_Horizontal_Size := Plot_Horizontal_Size * 25.4 ;
                Plot_Vertical_Size := Plot_Vertical_Size * 25.4 ;
                END ;


          { reading definition page number 6 }
          FOR I := 1 TO 3 DO  READLN (In_Read) ;
          Get_Field ;  READLN (In_Read, Nr_Window_Pts ) ;
          READLN (In_Read) ;
          READLN (In_Read) ;
          IF Nr_Window_Pts > 0
           THEN FOR I := 1 TO Nr_Window_Pts DO
                    BEGIN
                    READLN (In_Read, Dummy_10, X_Window [I],
                                               Y_Window [I] ) ;
                    END ;
          Close (In_Read) ;
          END

     ELSE BEGIN
          DBHEIG_Double_Height (10) ;
          SELGRA_Select_Graphics ('R') ;
          WRITELN ('            FILE NOT FOUND              ') ;
          WRITELN ('            FILE NOT FOUND              ') ;
          SELGRA_Select_Graphics ('O') ;
          BELLRI_Bell_Ring ;
          BELLRI_Bell_Ring ;

          TD_Time_Delay ( 2.0 );
          END ;

END ; (* RPP_Read_Plot_Parameters_File *)
END.
