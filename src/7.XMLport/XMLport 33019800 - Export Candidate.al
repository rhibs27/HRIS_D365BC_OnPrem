xmlport 33019800 "Export Candidate"
{
    Format = VariableText;
    TableSeparator = '<NewLine>';
    TextEncoding = UTF8;

    schema
    {
        textelement(Root)
        {
            tableelement(Integer; Integer)
            {
                AutoSave = false;
                MinOccurs = Zero;
                XmlName = 'CandidateCaptionTitle';
                SourceTableView = sorting(Number) where(Number = const(1));
                textelement(CandidateNoTitle)
                {
                    MinOccurs = Zero;

                    trigger OnBeforePassVariable()
                    begin
                        CandidateNoTitle := Candidate.FieldCaption("No.");
                    end;
                }
                textelement(CandidateFirstNameTitle)
                {
                    MinOccurs = Zero;

                    trigger OnBeforePassVariable()
                    begin
                        CandidateFirstNameTitle := Candidate.FieldCaption("First Name");
                    end;
                }
                textelement(CandidateMiddleNameTitle)
                {
                    MinOccurs = Zero;

                    trigger OnBeforePassVariable()
                    begin
                        CandidateMiddleNameTitle := Candidate.FieldCaption("Middle Name");
                    end;
                }
                textelement(CandidateLastNameTitle)
                {
                    MinOccurs = Zero;

                    trigger OnBeforePassVariable()
                    begin
                        CandidateLastNameTitle := Candidate.FieldCaption("Last Name");
                    end;
                }
                textelement(VacancyNoTitle)
                {
                    MinOccurs = Zero;

                    trigger OnBeforePassVariable()
                    begin
                        VacancyNoTitle := Candidate.FieldCaption("Vacancy Code");
                    end;
                }
                textelement(PhoneNoTitle)
                {
                    MinOccurs = Zero;

                    trigger OnBeforePassVariable()
                    begin
                        PhoneNoTitle := Candidate.FieldCaption("Phone No.");
                    end;
                }
                textelement(MobileNoTitle)
                {
                    MinOccurs = Zero;

                    trigger OnBeforePassVariable()
                    begin
                        MobileNoTitle := Candidate.FieldCaption("Mobile No.");
                    end;
                }
                textelement(GenderTitle)
                {
                    MinOccurs = Zero;

                    trigger OnBeforePassVariable()
                    begin
                        GenderTitle := Candidate.FieldCaption(Gender);
                    end;
                }
                textelement(BranchTitle)
                {
                    MinOccurs = Zero;

                    trigger OnBeforePassVariable()
                    begin
                        BranchTitle := 'Branch Code';
                    end;
                }
                textelement(JobPositionTypeTitle)
                {
                    MinOccurs = Zero;

                    trigger OnBeforePassVariable()
                    begin
                        JobPositionTypeTitle := Candidate.FieldCaption("Job Position Type");
                    end;
                }
                textelement(SalutationTitle)
                {
                    MinOccurs = Zero;

                    trigger OnBeforePassVariable()
                    begin
                        SalutationTitle := 'Salutation';
                    end;
                }
                textelement(BirthDateTitle)
                {
                    MinOccurs = Zero;

                    trigger OnBeforePassVariable()
                    begin
                        BirthDateTitle := Candidate.FieldCaption("Birth Date");
                    end;
                }
                textelement(StatusTitle)
                {
                    trigger OnBeforePassVariable()
                    begin
                        StatusTitle := Candidate.FieldCaption(Status);
                    end;
                }
            }
            tableelement(Candidate; Candidate)
            {
                AutoUpdate = true;
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
            }
        }
    }

    requestpage
    {
        layout { }

        actions { }
    }
}
