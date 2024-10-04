table 33019807 "BOD-EOD Header"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Employee No."; Code[20])
        {
            TableRelation = Employee;

            trigger OnValidate()
            begin
                if EmployeeVar.Get("Employee No.") then begin
                    Validate("Employee Name", EmployeeVar."Full Name");
                    Validate("Province Code", EmployeeVar."Province Code");
                    Validate("Province Name", EmployeeVar."Province Name");
                    Validate("Sub-Province Code", EmployeeVar."Sub Province Code");
                    Validate("Sub-Province Name", EmployeeVar."Sub Province Name");
                    Validate("Global Dimension 1 Code", EmployeeVar."Global Dimension 1 Code");
                    Validate("Branch Name", EmployeeVar."Branch Name");
                    Validate("Department Code", EmployeeVar."Department Code");
                    Validate("Department Name", EmployeeVar."Department Name");
                    Validate("Extension Counter", EmployeeVar."Extension Counter Code");
                    Validate("Extension Counter Name", EmployeeVar."Extension Counter Name");
                    Validate("Deputation On", EmployeeVar."Deputation on");
                    Validate("Functional Title", EmployeeVar."Functional Title");
                end;
            end;
        }
        field(2; "EOD/BOD Date"; Date) { }
        field(3; "Reviewer Code"; Code[20])
        {
            TableRelation = Employee;

            trigger OnValidate()
            begin
                if HRMgt.GetEmployeeNo = "Reviewer Code" then
                    Error('Employee himselves or herselves cannot be reviewer.');
                if EmployeeVar.Get("Reviewer Code") then
                    Validate("Reviewer Name", EmployeeVar."Full Name");
            end;
        }
        field(4; "Reviewer Name"; Text[50])
        {
            Editable = false;
        }
        field(5; "Employee Name"; Text[50])
        {
            Editable = false;
        }
        field(6; "Created DateTime"; DateTime)
        {
        }
        field(7; "BOD-Status"; Enum "BOD-EOD Status")
        {
            trigger OnValidate()
            begin
                CheckForPendingReview;
            end;
        }
        field(8; "EOD-Status"; Enum "BOD-EOD Status")
        {

            trigger OnValidate()
            begin
                CheckForPendingReview;
            end;
        }
        field(9; "Created By"; Text[50]) { }
        field(10; "Modified Date"; Date) { }
        field(11; "Province Code"; Code[20])
        {
            Editable = false;
            TableRelation = Province;
        }
        field(12; "Province Name"; Text[50])
        {
            Editable = false;
        }
        field(13; "Sub-Province Code"; Code[20])
        {
            Editable = false;
            TableRelation = "Sub Province".Code;
        }
        field(14; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1),
                                                          Blocked = const(false));
        }
        field(15; "Branch Name"; Text[50])
        {
            Editable = false;
        }
        field(16; "Sub-Province Name"; Text[50])
        {
            Editable = false;
        }
        field(17; "Department Code"; Code[20])
        {
            Editable = false;
        }
        field(18; "Department Name"; Text[50])
        {
            Editable = false;
        }
        field(19; "Functional Title"; Code[20])
        {
            Editable = false;
        }
        field(20; "Functional Title Description"; Text[50])
        {
            Editable = false;
        }
        field(21; "Unit Code"; Code[20])
        {
        }
        field(22; "Unit Name"; Text[50])
        {
        }
        field(23; "Extension Counter"; Code[20])
        {
        }
        field(24; "Extension Counter Name"; Text[50])
        {
        }
        field(25; "Deputation On"; Enum "Deputation Type")
        {

        }
        field(26; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }
        field(27; "Is Pending Review"; Boolean) { }
        field(28; "BOD Remarks"; Text[250]) { }
        field(29; "EOD Remarks"; Text[250]) { }
    }

    keys
    {
        key(Key1; "Entry No.") { }
    }

    fieldgroups { }

    trigger OnDelete()
    begin
        BodEodLine.Reset;
        BodEodLine.SetRange("Entry No", "Entry No.");
        BodEodLine.DeleteAll;
    end;

    trigger OnInsert()
    begin

        Validate("Employee No.", HRMgt.GetEmployeeNo);
        Validate("Created DateTime", CurrentDateTime);
        Validate("EOD/BOD Date", Today);
        Validate("Created By", UserId);
        BodEodHeader.Reset;
        BodEodHeader.SetRange("Employee No.", "Employee No.");
        BodEodHeader.SetRange("EOD/BOD Date", "EOD/BOD Date");
        if BodEodHeader.FindFirst then
            Error('BOD-EOD already exist for employee %1 (%2) of date %3', "Employee No.", "Employee Name", "EOD/BOD Date");
    end;

    trigger OnModify()
    begin
        Validate("Modified Date", Today);
    end;

    var
        HRMgt: Codeunit "HR Mgt.";
        EmployeeVar: Record Employee;
        BodEodHeader: Record "BOD-EOD Header";
        BodEodLine: Record "BOD/EOD Line";

    local procedure CheckForPendingReview()
    begin
        if ("BOD-Status" = "BOD-Status"::Submitted) or ("EOD-Status" = "EOD-Status"::Submitted) then
            Validate("Is Pending Review", true)
        else
            Validate("Is Pending Review", false);
    end;
}
