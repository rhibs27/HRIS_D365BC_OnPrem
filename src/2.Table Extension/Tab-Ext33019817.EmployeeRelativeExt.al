tableextension 33019817 "Employee Relative Ext" extends "Employee Relative"
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
        field(33019800; Address; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(33019801; Relation; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(33019802; "Master Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = " ",Employee,Candidate;
            OptionCaption = ' ,Employee,Candidate';
        }
        field(33019803; "Name(Nepali)"; Text[30])
        {
            DataClassification = CustomerContent;
            Description = 'In Nepali   for loan';
        }
        field(33019804; "Fathers Name(Nepali)"; Text[30])
        {
            DataClassification = CustomerContent;
            Description = 'In Nepali   for loan';
        }
        field(33019805; "GrandFather Name(Nepali)"; Text[30])
        {
            DataClassification = CustomerContent;
            Description = 'In Nepali   for loan';
        }
        field(33019806; District; Code[10])
        {
            TableRelation = District;
            DataClassification = CustomerContent;
            Description = 'In Nepali   for loan';
        }
        field(33019807; "VDC/Municipality"; Text[30])
        {
            DataClassification = CustomerContent;
            Description = 'In Nepali   for loan';
        }
        field(33019808; "Ward No"; Integer)
        {
            DataClassification = CustomerContent;
            Description = 'In Nepali   for loan';
        }
        field(33019809; "Citizenship No."; Text[10])
        {
            DataClassification = CustomerContent;
            Description = 'In Nepali   for loan';
        }
        field(33019810; Age; Integer)
        {
            DataClassification = CustomerContent;
            Description = 'In Nepali   for loan';
        }
        field(33019811; "Citizenship Date"; Date)
        {
            DataClassification = CustomerContent;
            Description = 'In Nepali   for loan';
        }
        field(33019812; "Citizenship Issued District"; Code[10])
        {
            TableRelation = District;
            DataClassification = CustomerContent;
        }
        field(33019813; "Citizenship Date (Nepali)"; Text[10])
        {
            DataClassification = CustomerContent;
            Description = 'In Nepali';
        }
        field(33019814; "Relationship"; Enum Relation)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup(Relative.Relation WHERE(Code = FIELD("Relative Code")));
            Editable = false;
        }
        field(33019815; "Full Name"; Text[50])
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
