table 50094 "Attendance Log"
{
    // version AMS6.1.0
    // * Machine Emp. Code
    // * Employee Name
    // - Two fields Added
    //     validation of employee code will bring Employee code and Name in the record.

    Caption = 'Attendance Log';
    DataClassification = CustomerContent;

    fields
    {
        field(8; "Emp DateTime"; Text[100])
        {
            Caption = 'Emp Datetime';
            DataClassification = CustomerContent;
            //TableRelation = "Attendance Device";
        }
        field(1; "Employee ID"; Code[20])
        {
            //TableRelation = Employee;

            // trigger OnValidate()
            // begin
            //     if Employee.Get("Employee ID") then begin
            //         "Employee Name" := Employee."Full Name";
            //         //"Shortcut Dimension 1 Code" := Employee."Global Dimension 1 Code";
            //         //"Shortcut Dimension 2 Code" := Employee."Global Dimension 2 Code";
            //         //"Department Code" := Employee."Department Code";
            //     end
            //     else begin
            //         "Shortcut Dimension 1 Code" := '';
            //         "Shortcut Dimension 2 Code" := '';
            //         //"Department Code" := '';
            //     end;
            // end;
        }
        field(2; Date; Date) { }
        field(3; "Log Time"; Time) { }
        field(4; "Machine Code"; Integer) { }
        // field(5; "Employee Name"; Text[50])
        // {
        //     Editable = false;
        // }
        // field(6; "Shortcut Dimension 1 Code"; Code[20])
        // {
        //     CaptionClass = '1,2,1';
        //     Caption = 'Shortcut Dimension 1 Code';
        //     Editable = false;
        //     TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        // }
        // field(7; "Shortcut Dimension 2 Code"; Code[20])
        // {
        //     CaptionClass = '1,2,2';
        //     Caption = 'Shortcut Dimension 2 Code';
        //     Editable = false;
        //     TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        // }
        field(5; "Biometric Attendance"; Boolean)
        {
        }
        // field(9; "Assigned User ID"; Code[50])
        // {
        //     Editable = false;
        //     TableRelation = "User Setup";
        // }
        // field(10; "Creation Date"; Date)
        // {
        //     Editable = false;
        // }
        // field(11; "Entry No."; Integer)
        // {
        //     AutoIncrement = true;
        // }
        field(6; "Machine Emp. Code"; Code[20])
        {
            // trigger OnValidate()
            // var
            // begin
            //     Employee.Reset();
            //     // Employee.SetRange("Attendance Device ID", "Machine Code");
            //     Employee.SetRange("Employee Attendance ID", "Machine Emp. Code");
            //     if Employee.FindFirst() then
            //         Validate("Employee ID", Employee."No.");
            // end;
        }
        field(7; "Date Time Log"; DateTime) { }

        // field(13; "Department Code"; Code[20]) { }
        // field(14; "Check Out Time"; Time)
        // {
        // }
        // field(15; Status; Enum "Attendance Status")
        // {


        //     trigger OnValidate()
        //     begin
        //         if Status = Status::Approved then
        //             "Approved Date" := Today;
        //     end;
        // }
        // field(16; "Status Updated By"; Code[50])
        // {
        //     Editable = false;
        // }
        // field(17; "Status Updated Date"; Date)
        // {
        //     Editable = false;
        // }
        // field(18; "Requested By"; Code[50])
        // {
        //     Editable = false;
        // }
        // field(19; "Requested Date"; Date)
        // {
        //     Editable = false;
        // }
        // field(20; "Late Remarks"; Text[250]) { }
        // field(21; "Approver Remarks"; Text[250])
        // {
        //     trigger OnValidate()
        //     begin
        //         if not CanApprovePermission then
        //             Error('Not authorized.');
        //     end;
        // }
        // field(22; Delayed; Boolean) { }
        // field(23; "Approver Code"; Code[20])
        // {
        //     TableRelation = Employee;
        // }
        // field(24; "Approved Date"; Date)
        // {
        //     Editable = false;
        // }
        //field(25; "Punch out Remarks"; Text[250]) { }
        //field(26; "IP address"; Text[30]) { }
        // field(27; "Punch Out Reviewer"; Code[20])
        // {
        //     TableRelation = Employee;
        // }
        // field(28; "Punch Out Check Reviewer"; Code[20])
        // {
        //     TableRelation = Employee;
        // }
        // field(29; "Night Shift Check Out Time"; Time) { }
        // field(30; "Training Check In Time"; Time) { }
        // field(31; "Training Check Out Time"; Time) { }
    }

    keys
    {
        key(Key1; "Emp DateTime") { }
    }

    fieldgroups { }

    // trigger OnInsert()
    // begin
    //     "Assigned User ID" := UserId;
    //     "Creation Date" := Today;
    //     //UpdateDelayed; //pram
    // end;

    var
        Employee: Record Employee;
        HRSetup: Record "Human Resources Setup";

    procedure SendApprovalRequest()
    begin
    end;

    // procedure CancelApprovalRequest()
    // begin
    //     if Status = Status::Approved then
    //         Error('Line already approved.');

    //     Status := Status::" ";
    //     Modify;
    // end;

    // procedure ApproveRequest()
    // begin
    //     if not Confirm('Confirm approve selected line?', false) then
    //         exit;

    //     Status := Status::Approved;
    //     "Status Updated By" := UserId;
    //     "Status Updated Date" := Today;
    //     Modify;

    //     Message('Line has been approved.');
    // end;

    // procedure RejectRequest()
    // begin
    //     if not Confirm('Confirm reject selected line?', false) then
    //         exit;

    //     if CanApprovePermission then begin
    //         TestField("Approver Remarks");
    //         Status := Status::Rejected;
    //         "Status Updated By" := UserId;
    //         "Status Updated Date" := Today;
    //         Modify;

    //         Message('Line has been rejected.');
    //     end
    //     else
    //         Error('Not authorized.');
    // end;

    // local procedure CanApprovePermission(): Boolean
    // begin
    //     /*IF Employee.GET("Employee ID") THEN
    //       IF Employee1.GET(Employee."Recommender Code") THEN
    //         IF Employee1."NAV Login ID" = USERID THEN
    //           EXIT(TRUE);

    //     EXIT(FALSE);
    //     */
    //     exit(true);
    // end;

    // local procedure UpdateDelayed()
    // begin
    //     HRSetup.Get;
    //     if (HRSetup."Office Start Time" = 0T) or (HRSetup."Office End Time" = 0T) then
    //         exit;

    //     if ("Check In Time" > HRSetup."Office Start Time") and ("Check In Time" < 120000T) then
    //         Delayed := true;
    // end;
}
