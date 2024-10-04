xmlport 33019812 "Import Daily KPI"
{
    // version KPI1.00

    // Encoding = UTF8;
    TextEncoding = UTF8;
    Format = VariableText;
    TableSeparator = '<<NewLine>>';

    schema
    {
        textelement(Root)
        {
            tableelement("KPI Daily Score"; "KPI Daily Score")
            {
                AutoReplace = true;
                XmlName = 'KPIDaiyScore';
                fieldelement(EmployeeNo; "KPI Daily Score"."Employee Code") { }
                fieldelement(EntryDate; "KPI Daily Score"."Entry Date") { }
                fieldelement(Type; "KPI Daily Score".Type) { }
                fieldelement(KPICode; "KPI Daily Score"."KPI Code") { }
                fieldelement(ActualPerDay; "KPI Daily Score"."Actual Score Per Day") { }

                trigger OnAfterInitRecord()
                begin
                    if CheckFirstLine then
                        currXMLport.Skip;
                end;

                trigger OnBeforeInsertRecord()
                begin
                    //Candidate.Status:= Candidate.Status::Applied;
                    "KPI Daily Score".Type := "KPI Daily Score".Type::Employee;
                    "KPI Daily Score"."KPI Type" := "KPI Daily Score"."KPI Type"::Qualitative;
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
