tableextension 33019815 "Employee Qualification Ext " extends "Employee Qualification"
{
    fields
    {
        modify("Employee No.")
        {
            TableRelation = if ("Master Type" = const(Candidate)) "Cancelled Document";
        }
        modify("Qualification Code")
        {
            TableRelation = Qualification.Code where("Type" = field("Emp Qualification Type"), "Qualification Type" = field("Qualification Type"));
        }
        modify("From Date")
        {
            trigger OnAfterValidate()
            begin
                Clear("To Date");
                Clear("Time Period");
            end;
        }
        modify("To Date")
        {
            trigger OnAfterValidate()
            begin
                Clear("To Date");
                Clear("Time Period");
            end;
        }
        field(33019800; "Emp Qualification Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = " ",Education,Work;
            Description = 'Type as Work Experience or Education';
        }
        field(33019801; Percentage; Decimal)
        { DataClassification = CustomerContent; }
        field(33019802; Stream; Text[30])
        {
            DataClassification = CustomerContent;
            Description = 'example- Science, Management etc.';
        }
        field(33019803; Year; Code[10])
        {
            DataClassification = CustomerContent;
            Description = 'Date of Completion of particular study';
        }
        field(33019804; Designation; Text[30])
        { DataClassification = CustomerContent; }
        field(33019805; "Time Period"; Decimal)
        { DataClassification = CustomerContent; }
        field(33019806; Remuneration; Text[30])
        { DataClassification = CustomerContent; }
        field(33019807; "Contact Number"; Text[30])
        { DataClassification = CustomerContent; }
        field(33019808; Remarks; Text[30])
        { DataClassification = CustomerContent; }
        field(33019809; Rank; Integer)
        { DataClassification = CustomerContent; }
        field(33019810; "Qualification Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = " ",SLC,"+2",Bachelor,Master,CA;
            OptionCaption = ' ,SLC,+2,Bachelor,Master,CA';
        }
        field(33019811; "Master Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = " ",Employee,Candidate;
            OptionCaption = ' ,Employee,Candidate';
        }
        field(33019812; CGPA; Decimal)
        { DataClassification = CustomerContent; }
    }
    keys { }
    trigger OnInsert()
    var
        Employee: Record Employee;
    begin
        if "Master Type" = "Master Type"::Employee then begin
            Employee.Get("Employee No.");
            "Employee Status" := Employee.Status;
        end;
    end;
}
