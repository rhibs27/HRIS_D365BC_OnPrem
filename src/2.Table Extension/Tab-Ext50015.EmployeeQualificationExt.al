tableextension 50015 "Employee Qualification Ext " extends "Employee Qualification"
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
                // Clear("To Date");
                // Clear("Time Period");
            end;
        }
        modify("To Date")
        {
            trigger OnAfterValidate()
            begin
                // Clear("Time Period");
            end;
        }
        field(50000; "Emp Qualification Type"; Enum "Emp. Qualification Type")
        {
            DataClassification = CustomerContent;
        }
        field(50001; Percentage; Decimal)
        { DataClassification = CustomerContent; }
        field(50002; Stream; Text[30])
        {
            DataClassification = CustomerContent;
            Description = 'example- Science, Management etc.';
        }
        field(50003; Year; Code[10])
        {
            DataClassification = CustomerContent;
            Description = 'Date of Completion of particular study';
        }
        field(50004; Designation; Text[30])
        { DataClassification = CustomerContent; }
        field(50005; "Time Period"; Decimal)
        { DataClassification = CustomerContent; }
        field(50006; Remuneration; Text[30])
        { DataClassification = CustomerContent; }
        field(50007; "Contact Number"; Text[30])
        { DataClassification = CustomerContent; }
        field(50008; Remarks; Text[30])
        { DataClassification = CustomerContent; }
        field(50009; Rank; Integer)
        { DataClassification = CustomerContent; }
        field(50010; "Qualification Type"; Enum "Qualification Type")
        {
            DataClassification = CustomerContent;
        }
        field(50011; "Master Type"; Enum EmployeeCandidate)
        {
            DataClassification = CustomerContent;
        }
        field(50012; CGPA; Decimal)
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
