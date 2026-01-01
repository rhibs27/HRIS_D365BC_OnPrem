table 50054 "Recruitement Memo Line"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Memo No."; Code[20]) { }
        field(2; "Functional Title"; Code[20])
        {
            TableRelation = "Functional Title";

            trigger OnValidate()
            begin
                if FunctionalTitleVar.Get("Functional Title") then
                    Validate("Functional Title Description", FunctionalTitleVar.Description)
                else
                    Validate("Functional Title Description", '');
            end;
        }
        field(3; "Salary Level Code"; Code[100])
        {
            TableRelation = if (Type = const(Internal)) "Salary Level".Code;

            trigger OnLookup()
            begin
                Validate("Salary Level Code", HRMgt.LookupSalaryLevel("Salary Level Code"));
            end;

            trigger OnValidate()
            begin
                if "Salary Level Code" <> xRec."Salary Level Code" then begin
                    Validate("Salary Level Description", '');
                    if "Salary Level Code" <> '' then begin
                        SalaryLevel.Reset;
                        SalaryLevel.SetFilter(Code, "Salary Level Code");
                        if SalaryLevel.Find('-') then
                            repeat
                                if "Salary Level Description" = '' then
                                    "Salary Level Description" := SalaryLevel.Description
                                else
                                    "Salary Level Description" += ',' + SalaryLevel.Description;
                            until SalaryLevel.Next = 0;
                    end;
                end;
            end;
        }
        field(4; "Salary Level Description"; Text[250])
        {
            Editable = false;
        }
        field(5; Location; Enum "Outside/Inside Valley") { }
        field(6; "Required No."; Integer) { }
        field(7; "Functional Title Description"; Text[250])
        {
            Editable = false;
        }
        field(8; "Vacancy No."; Code[20])
        {
            TableRelation = "Vacancy Header";
        }
        field(9; "Line No."; Integer) { }
        field(10; Type; Enum InternalExternal) { }
        field(11; "Province Code"; Code[20])
        {
            TableRelation = Province;

            trigger OnValidate()
            begin
                if ProvinceVar.Get("Province Code") then
                    Validate("Province Name", ProvinceVar.Description)
                else
                    Clear("Province Name");
            end;
        }
        field(12; "Province Name"; Text[50])
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Memo No.", "Functional Title", "Line No.") { }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        RecruitmentLine.Reset;
        RecruitmentLine.SetRange("Memo No.", "Memo No.");
        RecruitmentLine.SetRange("Functional Title", "Functional Title");
        RecruitmentLine.SetRange("Province Code", "Province Code");
        if RecruitmentLine.FindFirst then
            Error('Recruitment line for province %1 of functional title %2 already exist.', "Functional Title", "Province Name");
    end;

    var
        FunctionalTitleVar: Record "Functional Title";
        HRMgt: Codeunit "HR Mgt.";
        SalaryLevel: Record "Salary Level";
        ProvinceVar: Record Province;
        RecruitmentLine: Record "Recruitement Memo Line";
}
