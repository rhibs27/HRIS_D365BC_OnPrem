tableextension 50015 "Employee Qualification Ext " extends "Employee Qualification"
{
    fields
    {
        // modify("Employee No.")
        // {
        //     // TableRelation = if ("Master Type" = const(Candidate)) "Cancelled Document";
        // }
        modify("Qualification Code")
        {
            TableRelation = Qualification.Code where("Type" = field("Emp Qualification Type"), "Qualification Type" = field("Qualification Type"));
        }
        modify("From Date")
        {
            trigger OnAfterValidate()
            begin
                if "From Date" <> xRec."From Date" then
                    Clear("To Date");
            end;
        }
        modify("To Date")
        {
            trigger OnAfterValidate()
            begin
                if "From Date" > "To Date" then
                    Error('From Date is greater than to Date ');
                // Clear("Time Period");
            end;
        }
        field(50000; "Emp Qualification Type"; Enum "Emp. Document Type")
        {
            DataClassification = CustomerContent;
        }
        field(50001; Percentage; Decimal)
        {
            DataClassification = CustomerContent;
            MaxValue = 100;
            MinValue = 0;
        }
        field(50002; Stream; Text[30])
        {
            DataClassification = CustomerContent;
            CharAllowed = 'AZaz';
            Description = 'example- Science, Management etc.';
        }
        field(50003; Year; Text[4])
        {
            DataClassification = CustomerContent;
            Description = 'Date of Completion of particular study';
            CharAllowed = '09';
            trigger OnValidate()
            var
                Date: Integer;
            begin
                Evaluate(Date, year);
                if Date > Date2DMY(Today, 3) then
                    Error('Date is in Future');
            end;
        }
        field(50004; Designation; Text[30])
        { DataClassification = CustomerContent; }
        field(50005; "Time Period"; Decimal)
        { DataClassification = CustomerContent; }
        field(50006; Remuneration; Decimal)
        { DataClassification = CustomerContent; }
        field(50007; "Contact Number"; Text[30])
        {
            DataClassification = CustomerContent;
            CharAllowed = '09';
        }
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
        {
            DataClassification = CustomerContent;
            MaxValue = 4;
            MinValue = 0;
        }
        field(50013; Attachment; Media)
        {
        }
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
