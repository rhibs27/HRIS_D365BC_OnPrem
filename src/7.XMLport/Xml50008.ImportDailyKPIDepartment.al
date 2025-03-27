xmlport 50008 "Import Daily KPI Department"
{
    // version KPI1.00

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
                fieldelement(DepartmentCode; "KPI Daily Score".Department) { }
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
                    "KPI Daily Score".Type := "KPI Daily Score".Type::Department;
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
