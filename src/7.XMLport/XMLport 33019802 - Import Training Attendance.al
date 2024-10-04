xmlport 33019802 "Import Training Attendance"
{
    Format = VariableText;
    FormatEvaluate = Xml;
    TableSeparator = '<NewLine>';
    TextEncoding = UTF8;

    schema
    {
        textelement(Root)
        {
            tableelement(Integer; Integer)
            {
                AutoUpdate = true;
                XmlName = 'TrainingAttendanceTitle';
                SourceTableView = sorting(Number) where(Number = const(1));
                textelement(TrainingNoTitle)
                {
                    trigger OnBeforePassVariable()
                    begin
                        TrainingNoTitle := 'Training No.';
                    end;
                }
                textelement(EmployeeNoTitle)
                {
                    trigger OnBeforePassVariable()
                    begin
                        EmployeeNoTitle := "Training Attendance".FieldCaption("Employee No.");
                    end;
                }
                textelement(AttendanceDateTitle)
                {
                    trigger OnBeforePassVariable()
                    begin
                        AttendanceDateTitle := 'Attended Date';
                    end;
                }
                textelement(LineNoTitle)
                {
                    trigger OnBeforePassVariable()
                    begin
                        LineNoTitle := "Training Attendance".FieldCaption("Line No.");
                    end;
                }
            }
            tableelement("Training Attendance"; "Training Attendance")
            {
                AutoUpdate = true;
                XmlName = 'TrainingAttendance';
                fieldelement(TrainingNo; "Training Attendance"."Training No") { }
                fieldelement(EmployeeNo; "Training Attendance"."Employee No.") { }
                fieldelement(AttendanceDate; "Training Attendance"."Attended Date") { }
                fieldelement(LineNo; "Training Attendance"."Line No.") { }

                trigger OnAfterGetRecord()
                begin
                    if FirstLine then begin
                        FirstLine := false;
                        currXMLport.Skip;
                    end;
                end;
            }
        }
    }

    requestpage
    {
        layout { }

        actions { }
    }

    trigger OnInitXmlPort()
    begin
        FirstLine := true;
    end;

    var
        FirstLine: Boolean;
}
