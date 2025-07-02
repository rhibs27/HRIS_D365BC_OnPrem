table 50113 "Shift Assignment Header"
{
    Caption = 'Shift Assignment';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            Editable = false;
        }
        field(2; "Type"; Enum "Employee Activity Type")
        {
            Caption = 'Type';
        }
        field(3; "Deputation Type"; Enum "Deputation Type")
        {
            Caption = 'Deputation Type';
            Editable = false;
        }
        field(4; "Deputation Code"; Code[20])
        {
            Caption = 'Deputation Code';
            Editable = false;
            trigger OnValidate()
            var
                OrganizationStructureList: Record "Organization Structure List";
            begin
                if OrganizationStructureList.Get("Deputation Type", "Deputation Code") then
                    Validate("Deputation Name", OrganizationStructureList.Name);
            end;
        }
        field(5; "Deputation Name"; Text[100])
        {
            Caption = 'Deputation Name';
            Editable = false;
        }
        field(6; "From Date"; Date)
        {
            Caption = 'From Date';
            trigger OnValidate()
            var
                EngNepDate: Record "English-Nepali Date";
            begin
                EngNepDate.Reset;
                EngNepDate.SetRange("English Date", "From Date");
                if EngNepDate.FindFirst then
                    Validate("Fiscal Year", EngNepDate."Fiscal Year")
                else
                    Clear("Fiscal Year");
            end;
        }
        field(7; "To Date"; Date)
        {
            Caption = 'To Date';
            trigger OnValidate()
            begin
                if "From date" > "To Date" then
                    Error('Invalid date.');
                if GuiAllowed then
                    CheckForExistingDate("No.");
            end;
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
            trigger OnValidate()
            var
                Employee: Record Employee;
            begin
                If Employee.Get("Employee No.") then begin
                    Validate("Employee Name", Employee."Full Name");
                    Validate("Deputation Type", Employee."Deputation on");
                    Validate("Deputation Code", Employee."Deputation On Code");
                end;
            end;
        }
        field(12; "Employee Name"; Text[100])
        {
            Caption = 'Employee Name';
            Editable = false;
        }
        field(13; "Rejection Remarks"; Text[100])
        {
            Caption = 'Rejection Remarks';
        }
        field(16; "Approval Status"; Enum "Approval Status")
        {
            Caption = 'Approval Status';
            Editable = false;
        }
        field(37; "Approved Date"; Date)
        {
            Caption = 'Approved Date';
            Editable = false;
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
        if not ("Approval Status" in ["Approval Status"::" ", "Approval Status"::Open]) then
            Error(CannotDelete)
        else begin
            ShiftLine.Reset;
            ShiftLine.SetRange("No.", "No.");
            ShiftLine.DeleteAll(true);
            ApprovalHrms.Reset;
            ApprovalHrms.SetRange("Document No.", "No.");
            ApprovalHrms.DeleteAll(true);
        end;
    end;

    trigger OnInsert()
    begin
        "Type" := "Type"::"Shift Assignment";
        if not GuiAllowed then begin
            Validate("Employee No.", HrMgt.GetEmployeeNo());
            Validate("Approval Status", "Approval Status"::Open);
        end;
        // TestField(Code);
        // if not GuiAllowed then
        //     CheckForSameWeek;
        HRSetup.Get;
        if "No." = '' then
            case "Type" of
                //for Roster
                "Type"::"Shift Assignment":
                    begin
                        HRSetup.TestField("Shift Assignment Series");
                        NoSeriesMgt.InitSeries(HRSetup."Shift Assignment Series", xRec."No. Series", Today, "No.", "No. Series");
                        ApproverMgt.InsertApproval("Employee No.", "No.", "Type", "Approval Status");
                    end;
            end;
        if not GuiAllowed then
            if Type = Type::"Shift Assignment" then
                CheckForExistingDate("No.");
    end;

    var
        HrMgt: Codeunit "HR Mgt.";
        HRSetup: Record "Human Resources Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        ApproverMgt: Codeunit "Approver Mgt";
        ApprovalHRMS: Record "Approval HRMS";
        ShiftLine: Record "Shift Line";
        ShiftAssignmentMgt: Codeunit "Shift Assignment Mgt";


    procedure CheckForExistingDate(No: Code[20])
    var
        ShiftAssignment: Record "Shift Assignment Header";
    begin
        ShiftAssignment.Reset;
        if GuiAllowed then
            ShiftAssignment.SetFilter("No.", '<>%1', No);
        ShiftAssignment.SetRange(Type, ShiftAssignment.Type::"Shift Assignment");
        ShiftAssignment.SetRange("Fiscal Year", "Fiscal Year");
        ShiftAssignment.SetRange("Deputation Code", "Deputation Code");
        ShiftAssignment.SetFilter("Approval Status", '<>%1&<>%2', ShiftAssignment."Approval Status"::Rejected, ShiftAssignment."Approval Status"::Canceled);
        if ShiftAssignment.Findset then
            repeat
                if ("From Date" <= ShiftAssignment."TO date") and ("To date" >= ShiftAssignment."From Date") then
                    Error('Shift Assignment for this period %1 and %2 is already been assigned in %3.', ShiftAssignment."From Date", ShiftAssignment."To Date", ShiftAssignment."No.");
            until ShiftAssignment.Next() = 0;
    end;

}
