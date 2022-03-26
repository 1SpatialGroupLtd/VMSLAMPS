[INHERIT ('Inherit_File')]
MODULE PLT050 ;

{ PLT050.PAS <> }

(**********************************************************************)
[GLOBAL] PROCEDURE STP_Something_to_Plot ;
(**********************************************************************)
VAR
   Found          : BOOLEAN ;
   I              : INTEGER ;
   Plot_File_Code : INTEGER ;

BEGIN { PROCEDURE STP_Something_to_Plot }

     Something_to_Plot := FALSE ;

     IF   (      ( CAM_Mode IN [ 1..4, 7,8 ] )
             AND ( Selected_Line_Type_Code_Number OR Selected_Line_Level ) )
       OR (      ( CAM_Mode IN [ 5,6,9,10,11 ] )
             AND ( Selected_Symbol_Code_Number OR Selected_Symbol_Level ) )
       THEN BEGIN

                 IF Selected_Line_Type_Code_Number
                    THEN Plot_File_Code := Line_Type_Code_Number ;

                 IF Selected_Line_Level
                    THEN Plot_File_Code := Line_Level ;

                 IF Selected_Symbol_Code_Number
                    THEN Plot_File_Code := Symbol_Code_Number ;

                 IF Selected_Symbol_Level
                    THEN Plot_File_Code := Symbol_Level ;

                 { find if we need to plot }
                 IF ( Selected_Layer [1] <> 1000 )
                    THEN BEGIN
                              Something_to_Plot := FALSE ;
                              I := 0 ;
                              REPEAT
                                    I := I + 1 ;
                                    IF Plot_File_Code = Selected_Layer [I]
                                       THEN Something_to_Plot := TRUE ;
                               UNTIL    Something_to_Plot
                                     OR ( I >= Nr_of_Layers ) ;
                           END ;

                 IF Selected_Layer [1] = 1000
                    THEN BEGIN
                              Something_to_Plot := TRUE ;
                              I := 1 ;
                              IF Nr_of_Layers > I
                                 THEN
                                   REPEAT
                                      I := I + 1 ;
                                      IF Plot_File_Code = -Selected_Layer [I]
                                         THEN Something_to_Plot := FALSE ;
                                   UNTIL NOT Something_to_Plot
                                         OR ( I >= Nr_of_Layers ) ;

                           END ;
             END ;

{
WRITE ( Line_Level:3, Plot_File_Code:3, Selected_Layer[1]:3 ) ;
WRITE ( Something_to_Plot ) ;
READLN ;
}

END ; (* PROCEDURE STP_Something_to_Plot *)
END.
