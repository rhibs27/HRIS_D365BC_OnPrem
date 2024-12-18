table 50014 "Facilitator Pool"
{
    // version NIC Asia1.00,Training

    DrillDownPageId = "Facilitator Pool Lists";
    LookupPageId = "Facilitator Pool Lists";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Employee No."; Code[20])
        {
            TableRelation = Employee;

            trigger OnValidate()
            begin
                if "Employee No." <> xRec."Employee No." then begin
                    Faciliator1.Reset;
                    Faciliator1.SetRange("Fiscal Year", "Fiscal Year");
                    Faciliator1.SetRange("Employee No.", "Employee No.");
                    if Faciliator1.FindFirst then
                        Error('Employee already exist');
                    Validate(Name, HRMgt.ReturnEmpName("Employee No."));
                end;

                if EmpVar.Get("Employee No.") then begin
                    Validate(Branch, EmpVar."Global Dimension 1 Code");
                    Validate(Province, EmpVar."Province Code");
                    Validate("Sub Province", EmpVar."Sub Province Code");
                    Validate(Department, EmpVar."Department Code");
                end else begin
                    Clear(Branch);
                    Clear(Province);
                    Clear("Sub Province");
                    Clear(Department);
                end;
            end;
        }
        field(2; Name; Text[100])
        {
            Editable = false;
        }
        field(3; Province; Code[20])
        {
        }
        field(4; "Sub Province"; Code[20])
        {
        }
        field(5; District; Code[20])
        {
        }
        field(6; Branch; Code[20])
        {
        }
        field(7; Department; Code[20])
        {
        }
        field(8; Position; Code[20])
        {
        }
        field(9; "Functional Title"; Code[20])
        {
        }
        field(10; Skill; Text[30])
        {
        }
        field(11; Qualification; Text[30])
        {
        }
        field(12; "Appointed Date"; Date)
        {
        }
        field(13; "Approval Status"; Enum "Attendance Status")
        {
            Editable = false;
        }
        field(14; "Fiscal Year"; Text[10]) { }
        field(15; "Line No"; Integer) { }
    }

    keys
    {
        key(Key1; "Fiscal Year", "Employee No.", "Line No") { }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        Faciliator1.Reset;
        Faciliator1.SetRange("Fiscal Year", "Fiscal Year");
        Faciliator1.SetRange("Approval Status", "Approval Status"::"pending approval");
        if Faciliator1.FindFirst then
            Error(ErrorCancel, "Fiscal Year");
    end;

    var
        HRMgt: Codeunit "HR Mgt.";
        Faciliator1: Record "Facilitator Pool";
        ErrorCancel: Label 'You cannot create new faciliator until previous faciliator of fiscal year %1 has been approved or is cancelled.';
        EmpVar: Record Employee;

    [IntegrationEvent(false, false)]
    procedure OnSendFacilitatorDocForApproval(var Facilitator: Record "Facilitator Pool")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelFacilitatorDocForApproval(var Facilitator: Record "Facilitator Pool")
    begin
    end;

    procedure UpdateApprovalStatus(var Facilitator: Record "Facilitator Pool"; ApprovalStatus: enum "Attendance Status")
    begin
        Faciliator1.Reset;
        Faciliator1.SetRange("Fiscal Year", Facilitator."Fiscal Year");
        Faciliator1.SetFilter("Approval Status", '<>%1|%2', "Approval Status"::released, "Approval Status"::rejected);
        Faciliator1.ModifyAll("Approval Status", ApprovalStatus);
        //Facilitator.VALIDATE("Approval Status", ApprovalStatus);
        //Facilitator.MODIFY;
    end;

    procedure CheckApprovalEntries(Facilitator: Record "Facilitator Pool"): Boolean
    var
        ApprovalEntry: Record "Approval Entry";
    begin
        ApprovalEntry.SetRange("Table ID", Database::"Facilitator Pool");
        ApprovalEntry.SetRange("Document No.", "Fiscal Year");
        ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Open);
        ApprovalEntry.SetRange("Related to Change", false);
        exit(not ApprovalEntry.IsEmpty);
    end;
}
