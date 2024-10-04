xmlport 33019803 "Import Candidate"
{
    TextEncoding = UTF8;
    Format = VariableText;
    TableSeparator = '<<NewLine>>';

    schema
    {
        textelement(Root)
        {
            tableelement(Candidate; Candidate)
            {
                AutoReplace = true;
                XmlName = 'Candidate';
                fieldelement(CandidateNo; Candidate."No.") { }
                fieldelement(CandidateFirtstName; Candidate."First Name") { }
                fieldelement(CandidateMiddleName; Candidate."Middle Name") { }
                fieldelement(CandidateLastName; Candidate."Last Name") { }
                fieldelement(VacancyNo; Candidate."Vacancy Code") { }
                fieldelement(PhoneNo; Candidate."Phone No.") { }
                fieldelement(MobileNo; Candidate."Mobile No.") { }
                fieldelement(Gender; Candidate.Gender) { }
                fieldelement(Branch; Candidate."Global Dimension 1 Code") { }
                fieldelement(JobPositionType; Candidate."Job Position Type") { }
                fieldelement(Salutation; Candidate."Personal Title") { }
                fieldelement(BirthDate; Candidate."Birth Date") { }
                fieldelement(Status; Candidate.Status) { }

                trigger OnAfterInitRecord()
                begin
                    if CheckFirstLine then
                        currXMLport.Skip;
                end;

                trigger OnBeforeInsertRecord()
                begin
                    Candidate.Status := Candidate.Status::Applied;
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
