tableextension 50015 "Employee Qualification Ext " extends "Employee Qualification"
{
    fields
    {
        modify("Qualification Code")
        {
            TableRelation = Qualification.Code where("Type" = field("Emp Qualification Type"), "Qualification Type" = field("Qualification Type"));
            trigger OnAfterValidate()
            Var
                Qualification: Record Qualification;
            begin
                if Qualification.get("Qualification Code") then begin
                    Validate("Qualification Type", Qualification."Qualification Type");
                    Validate(Rank, Qualification.Rank);
                    if "GPA Scale" <> 0 then
                        Validate("GPA Scale", "GPA Scale");
                end;
            end;
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
                if ("From Date" <> 0D) and ("To Date" <> 0D) then
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
            CharAllowed = 'AZaz  ';
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
        field(50004; Designation; Text[50])
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
        field(50008; Remarks; Text[100])
        { DataClassification = CustomerContent; }
        field(50009; Rank; Integer)
        { DataClassification = CustomerContent; }
        field(50010; "Qualification Type"; Enum "Qualification Type")
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50011; "Master Type"; Enum EmployeeCandidate)
        {
            DataClassification = CustomerContent;
        }
        field(50012; CGPA; Decimal)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if CGPA > "GPA Scale" then
                    Error('CGPA cannot be greater than GPA Scale');
            end;
        }
        field(50013; Attachment; Media) { }
        field(50014; Running; Boolean) { }
        field(50015; "GPA Scale"; Decimal) { }
    }
    keys { }
    trigger OnInsert()
    var
        Employee: Record Employee;
    begin
        if "Qualification Code" = '' then
            Error('Qualification Code cannot be empty.');

        if "Master Type" = "Master Type"::Employee then begin
            Employee.Get("Employee No.");
            "Employee Status" := Employee.Status;
        end;
    end;
}
