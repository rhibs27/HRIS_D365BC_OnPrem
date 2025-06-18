table 50113 Roster
{
    Caption = 'Roster';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(2; "Type"; Enum "Employee Activity Type")
        {
            Caption = 'Type';
        }
        field(3; "Deputation Type"; Enum "Deputation Type")
        {
            Caption = 'Deputation Type';
        }
        field(4; "Deputation Code"; Code[20])
        {
            Caption = 'Deputation Code';
        }
        field(5; "Deputation Name"; Text[100])
        {
            Caption = 'Deputation Name';
        }
        field(6; "From Date"; Date)
        {
            Caption = 'From Date';
        }
        field(7; "To Date"; Date)
        {
            Caption = 'To Date';
        }
        field(8; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
        }
        field(9; Return; Boolean)
        {
            Caption = 'Return';
        }
        field(10; "Fiscal Year"; Text[10])
        {
            Caption = 'Fiscal Year';
        }
        field(11; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
        }
        field(12; "Employee Name"; Text[100])
        {
            Caption = 'Employee Name';
        }
        field(13; "Rejection Remarks"; Text[100])
        {
            Caption = 'Rejection Remarks';
        }
        field(16; "Approval Status"; Enum "Approval Status")
        {
            Caption = 'Approval Status';
        }
        field(37; "Approved Date"; Date)
        {
            Caption = 'Approved Date';
        }
        field(100; Status; Text[20])
        {
            Caption = 'Status';
        }

    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
    trigger OnDelete()
    var
        CannotDelete: Label 'Cannot delete document.';
    begin
        // if not ("Approval Status" in ["Approval Status"::" ", "Approval Status"::Open]) then
        //     Error(CannotDelete)
        // else begin
        // AllowanceLine.Reset;
        // AllowanceLine.SetRange("No.", "No.");
        // AllowanceLine.DeleteAll(true);
        // ApprovalHrms.Reset;
        // ApprovalHrms.SetRange("Document No.", "No.");
        // ApprovalHrms.DeleteAll(true);
        // end;
    end;

    trigger OnInsert()
    begin
        "Type" := "Type"::"Allowance Assignment";
        if not GuiAllowed then
            Validate("Employee No.", HrMgt.GetEmployeeNo());
        // TestField(Code);
        // if not GuiAllowed then
        //     CheckForSameWeek;
        HRSetup.Get;
        if "No." = '' then
            case "Type" of
                //for Roster
                "Type"::Roster:
                    begin
                        HRSetup.TestField("Roster Series");
                        NoSeriesMgt.InitSeries(HRSetup."Roster Series", xRec."No. Series", Today, "No.", "No. Series");
                        ApproverMgt.InsertApproval("Employee No.", "No.", "Type", "Approval Status");
                    end;
            end;
    end;

    var
        HrMgt: Codeunit "HR Mgt.";
        HRSetup: Record "Human Resources Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        ApproverMgt: Codeunit "Approver Mgt";

}
