tableextension 50017 "Employee Relative Ext" extends "Employee Relative"
{
    fields
    {
        modify("Employee No.")
        {
            trigger OnAfterValidate()
            begin
                GetNextLineNo;
            end;
        }
        modify("Phone No.")
        {
            trigger OnAfterValidate()
            var
                TypeHelper: Codeunit "Type Helper";
            begin
                if not TypeHelper.IsPhoneNumber(Rec."Phone No.") then
                    Error('Phone No Validation Error');
            End;
        }
        field(50000; Address; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(50001; Relation; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(50002; "Master Type"; Enum EmployeeCandidate)
        {
            DataClassification = CustomerContent;
        }
        field(50003; "Name(Nepali)"; Text[30])
        {
            DataClassification = CustomerContent;
            Description = 'In Nepali   for loan';
        }
        field(50004; "Fathers Name(Nepali)"; Text[30])
        {
            DataClassification = CustomerContent;
            Description = 'In Nepali   for loan';
        }
        field(50005; "GrandFather Name(Nepali)"; Text[30])
        {
            DataClassification = CustomerContent;
            Description = 'In Nepali   for loan';
        }
        field(50006; District; Code[10])
        {
            TableRelation = District."District Name";
            ValidateTableRelation = false;
            DataClassification = CustomerContent;
            Description = 'In Nepali   for loan';
        }
        field(50007; "VDC/Municipality"; Text[30])
        {
            DataClassification = CustomerContent;
            Description = 'In Nepali   for loan';
        }
        field(50008; "Ward No"; Integer)
        {
            DataClassification = CustomerContent;
            MinValue = 1;
            MaxValue = 32;
            Description = 'In Nepali   for loan';
        }
        field(50009; "Citizenship No."; Text[10])
        {
            DataClassification = CustomerContent;
            Description = 'In Nepali   for loan';
        }
        field(50010; Age; Integer)
        {
            DataClassification = CustomerContent;
            Description = 'In Nepali   for loan';
        }
        field(50011; "Citizenship Date"; Date)
        {
            DataClassification = CustomerContent;
            Description = 'In Nepali   for loan';
        }
        field(50012; "Citizenship Issued District"; Code[10])
        {
            TableRelation = District;
            DataClassification = CustomerContent;
        }
        field(50013; "Citizenship Date (Nepali)"; Text[10])
        {
            DataClassification = CustomerContent;
            Description = 'In Nepali';
        }
        field(50014; "Relationship"; Enum Relation)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup(Relative.Relation WHERE(Code = FIELD("Relative Code")));
            Editable = false;
        }
        field(50015; "Full Name"; Text[50])
        {
            DataClassification = CustomerContent;
            CharAllowed = 'AZaz';
        }
        field(50016; Employee_BOD; Enum "Employee/BOD Relation")
        {
            DataClassification = CustomerContent;
        }
    }
    trigger OnDelete()
    var
        HRCommentLine: Record "Human Resource Comment Line";
    begin
        if "Master Type" = "Master Type"::Employee then begin
            HRCommentLine.SetRange("Table Name", HRCommentLine."Table Name"::"Employee Relative");
            HRCommentLine.SetRange("No.", "Employee No.");
            HRCommentLine.DeleteAll;
        end;
    end;

    local procedure GetNextLineNo();
    var
        EmployeeRelative: Record "Employee Relative";
    begin
        EmployeeRelative.Reset;
        EmployeeRelative.SetRange("Employee No.", "Employee No.");
        if EmployeeRelative.FindLast then
            Validate("Line No.", EmployeeRelative."Line No." + 10000)
        else
            Validate("Line No.", 10000);
    end;
}
