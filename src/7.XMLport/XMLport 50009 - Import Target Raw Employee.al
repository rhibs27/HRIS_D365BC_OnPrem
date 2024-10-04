xmlport 50009 "Import Target Raw Employee"
{
    // version KPI1.00

    TextEncoding = UTF8;
    Format = VariableText;
    TableSeparator = '<<NewLine>>';

    schema
    {
        textelement(Root)
        {
            tableelement("KPI Target Raw"; "KPI Target Raw")
            {
                AutoReplace = true;
                XmlName = 'KPIDailyTarget';
                fieldelement(EmployeeNo; "KPI Target Raw"."Employee Code") { }
                fieldelement(Type; "KPI Target Raw".Type) { }
                fieldelement(KPICode; "KPI Target Raw"."KPI Code") { }
                fieldelement(KPIDesc; "KPI Target Raw"."KPI Description") { }
                fieldelement(TargetScore; "KPI Target Raw"."Target Score") { }
                fieldelement(StartDate; "KPI Target Raw"."Start Date") { }
                textelement("kpi target raw::end date")
                {
                    XmlName = 'EndDate';
                }

                trigger OnAfterInitRecord()
                begin
                    if CheckFirstLine then
                        currXMLport.Skip;
                end;

                trigger OnBeforeInsertRecord()
                begin
                    //Candidate.Status:= Candidate.Status::Applied;
                    //"KPI Daily Score".Type := "KPI Daily Score".Type::Employee;
                end;
            }
        }
    }

    requestpage
    {
        layout { }

        actions { }
    }

    trigger OnPreXmlPort()
    begin
        FirstLine := true;
    end;

    var
        FirstLine: Boolean;

    local procedure CheckFirstLine(): Boolean
    begin
        if FirstLine then begin
            FirstLine := false;
            exit(true);
        end;
    end;
}
