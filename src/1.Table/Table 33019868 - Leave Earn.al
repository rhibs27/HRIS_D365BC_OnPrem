table 33019868 "Leave Earn"
{
    DataClassification = CustomerContent;
    // version NIC Asia1.00,Leave

    fields
    {
        field(1; "Entry No."; Code[20])
        {
            trigger OnValidate()
            begin
                if "Entry No." <> xRec."No. Series" then begin
                    HRSetup.Get;
                    NoSeriesMgt.TestManual(HRSetup."Leave Earn No.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "Leave Code"; Code[20])
        {
            TableRelation = "Leave Type Setup";

            trigger OnValidate()
            begin
                if LeaveTypeVar.Get("Leave Code") then
                    Validate("Leave Description", LeaveTypeVar.Description)
                else
                    Clear("Leave Description");
            end;
        }
        field(3; "Leave Description"; Text[50]) { }
        field(4; EmpNo; Code[20])
        {
            TableRelation = Employee;

            trigger OnValidate()
            begin
                if EmpVar.Get(EmpNo) then
                    Validate("Employee Full Name", EmpVar."Full Name")
                else
                    Clear("Employee Full Name");
            end;
        }
        field(5; "Employee Full Name"; Text[50])
        {
        }
        field(6; "Fiscal year"; Text[10])
        {
        }
        field(7; "Posted Date"; Date)
        {
        }
        field(8; "Balancing Days"; Decimal)
        {
        }
        field(9; "No. Series"; Code[20])
        {
        }
        field(10; Type; Enum "Leave Earn Type")
        {

        }
        field(11; "Leave Request No"; Code[20])
        {
            Editable = false;
        }
        field(12; Remarks; Text[50]) { }
        field(13; Closed; Boolean) { }
    }

    keys
    {
        key(Key1; "Entry No.") { }
    }

    fieldgroups { }

    trigger OnDelete()
    begin
        /*IF NOT(Type = Type::Earned) THEN
          ERROR(LeaveEarnError);
        IF EmployeeAct.GET("Leave Request No") THEN
          EmployeeAct.DELETE(TRUE);
          */
    end;

    trigger OnInsert()
    begin
        if "Entry No." = '' then begin
            HRSetup.Get;
            HRSetup.TestField("Leave Earn No.");
            NoSeriesMgt.InitSeries(HRSetup."Leave Earn No.", xRec."No. Series", "Posted Date", "Entry No.", "No. Series");
        end;
    end;

    var
        EmpVar: Record Employee;
        LeaveTypeVar: Record "Leave Type Setup";
        HRSetup: Record "Human Resources Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        HrMgt: Codeunit "HR Mgt.";

    procedure PostLeaveEarn(TempLeaveEarn: Record "Leave Earn" temporary)
    var
        LeaveEarn: Record "Leave Earn";
    begin
        LeaveEarn.Init;
        LeaveEarn.TransferFields(TempLeaveEarn);
        LeaveEarn."Fiscal year" := HrMgt.ReturnFiscalYear(Today);
        LeaveEarn."Posted Date" := Today;
        LeaveEarn.Type := LeaveEarn.Type::Earned;
        LeaveEarn.Insert(true);

        Message('Leave balance added successfully.');
    end;
}
