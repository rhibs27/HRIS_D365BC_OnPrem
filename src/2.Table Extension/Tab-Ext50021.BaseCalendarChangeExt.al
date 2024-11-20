tableextension 50021 "Base Calendar Change Ext" extends "Base Calendar Change"
{
    fields
    {
        field(50000; "Holiday Type"; Enum "Holiday Type")
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Province Filter"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(50002; "Gender Filter"; Enum "Employee Gender")
        {
            DataClassification = ToBeClassified;
        }
        field(50003; "Inside/Outisde Valley"; Enum "Outside/Inside Valley")
        {
            DataClassification = ToBeClassified;

        }
        field(50004; "Posting Region"; Enum Region)
        {
            DataClassification = ToBeClassified;

        }
        field(50005; "Shortcut Dimension 1 Code"; Code[250])
        {
            DataClassification = ToBeClassified;
            CaptionClass = '1,2,1';
            trigger OnLookup()
            begin
                Validate("Shortcut Dimension 1 Code", HRMgt.LookupBranch("Shortcut Dimension 1 Code", '', ''));
            end;
        }
        field(50006; "Employee Filter"; Text[20])
        {
            FieldClass = FlowFilter;
        }
    }

    var
        HRMgt: Codeunit "HR Mgt.";

    procedure UpdateEmployeeAttendanceActivity();
    var
        EmployeeAttendanceActivity: Record "Employee Attendance & Activity";
        Employee: Record Employee;
    begin
        if not Confirm('Do you want to update attendance logs for the date %1', false, Date) then
            exit;

        Employee.Reset;
        //Employee.SETRANGE("No.",'AK4371');
        if "Province Filter" <> '' then
            Employee.SetFilter("Province Code", "Province Filter");
        if "Gender Filter" <> "Gender Filter"::" " then
            Employee.SetRange(Gender, "Gender Filter");
        if "Inside/Outisde Valley" <> "Inside/Outisde Valley"::" " then
            Employee.SetRange("Inside/Outisde Valley", "Inside/Outisde Valley");
        if "Posting Region" <> "Posting Region"::" " then
            Employee.SetRange("Posting Region", "Posting Region");
        if "Shortcut Dimension 1 Code" <> '' then
            Employee.SetFilter("Global Dimension 1 Code", "Shortcut Dimension 1 Code");
        if Employee.FindFirst then
            repeat
                EmployeeAttendanceActivity.Reset;
                EmployeeAttendanceActivity.SetRange("Employee No.", Employee."No.");
                EmployeeAttendanceActivity.SetRange("Attendance Date", Date);
                if EmployeeAttendanceActivity.FindFirst then
                    repeat
                        EmployeeAttendanceActivity."Week Off Day" := 1;
                        EmployeeAttendanceActivity."Present Day" := 0;
                        EmployeeAttendanceActivity."Absent Day" := 0;
                        EmployeeAttendanceActivity."Day Type" := EmployeeAttendanceActivity."Day Type"::Holiday;
                        EmployeeAttendanceActivity."Holiday Remarks" := Description;
                        EmployeeAttendanceActivity.Modify;
                    until EmployeeAttendanceActivity.Next = 0;
            until Employee.Next = 0;

        Message('Holiday is updated for all employees for date %1', Date);
    end;
}
