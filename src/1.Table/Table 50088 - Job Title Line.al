table 50088 "Job Title Line"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Salary Level Code"; Code[20]) { }
        field(2; "Functional Title"; Code[20]) { }
        field(3; "Line No"; Integer) { }
        field(4; "Code"; Code[20])
        {
            TableRelation = if ("Job Type" = const("Job Specification")) Qualification.Code;

            trigger OnValidate()
            begin
                if "Job Type" = "Job Type"::"Job Specification" then begin
                    Qualifiaction.Get(Code);
                    Description := Qualifiaction.Description;
                end;
            end;
        }
        field(5; Description; Text[50]) { }
        field(6; "Job Type"; Option)
        {
            OptionCaption = ' ,Job Description,Job Specification';
            OptionMembers = " ","Job Description","Job Specification";
        }
    }

    keys
    {
        key(Key1; "Salary Level Code", "Functional Title", "Line No") { }
    }

    fieldgroups { }

    var
        Qualifiaction: Record Qualification;
}
