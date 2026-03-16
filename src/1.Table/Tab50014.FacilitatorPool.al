table 50014 "Facilitator Pool"
{
    DrillDownPageId = "Facilitator Pool Lists";
    LookupPageId = "Facilitator Pool Lists";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Employee No."; Code[20])
        {
            TableRelation = if ("Trainer Type" = const(Internal)) Employee where(Status = const(Active));
            trigger OnValidate()
            begin
                if EmpVar.Get("Employee No.") then begin
                    Validate(Province, EmpVar."Province Code");
                    Validate(Branch, EmpVar."Branch Code");
                    Validate(Department, EmpVar."Department Code");
                    Validate(Name, EmpVar."Full Name");
                    Validate("Functional Title", EmpVar."Functional Title");
                end else begin
                    Clear(Branch);
                    Clear(Province);
                    Clear(Department);
                end;
            end;
        }
        field(2; Name; Text[100])
        {
            Editable = false;
        }
        field(3; Province; Code[20]) { }
        field(4; "Trainer Type"; Enum "Resource person")
        {
            ValuesAllowed = Internal, External;
        }
        field(5; District; Code[20]) { }
        field(6; Branch; Code[20]) { }
        field(7; Department; Code[20]) { }
        field(8; Position; Code[20]) { }
        field(9; "Functional Title"; Code[20]) { }
        field(10; Skill; Text[30]) { }
        field(11; Qualification; Text[10])
        {
            TableRelation = Qualification.Code;
        }
        field(12; "Qualification Description"; Text[10])
        {
            TableRelation = Qualification.Code;
        }
        field(13; "Appointed Date"; Date) { }
        field(14; "Approval Status"; enum "Approval Status")
        {
            Editable = false;
        }
        field(15; "Fiscal Year"; Text[20])
        {
            trigger OnLookup()
            begin
                Validate("Fiscal Year", HRMgt.LookupFiscalYear());
            end;
        }
        field(16; "Line No"; Integer)
        {
            AutoIncrement = true;
        }
    }

    keys
    {
        key(Key1; "Employee No.", "Fiscal Year", "Line No") { }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        Facilitator1.Reset;
        Facilitator1.SetRange("Fiscal Year", "Fiscal Year");
        Facilitator1.SetRange("Employee No.", "Employee No.");
        if Facilitator1.FindFirst then
            Error(ErrorCancel, "Fiscal Year");
    end;

    var
        HRMgt: Codeunit "HR Mgt.";
        Facilitator1: Record "Facilitator Pool";
        ErrorCancel: Label 'You cannot create new facilitator until previous facilitator of fiscal year %1 has been Completed.';
        EmpVar: Record Employee;

    // [IntegrationEvent(false, false)]
    // procedure OnSendFacilitatorDocForApproval(var Facilitator: Record "Facilitator Pool")
    // begin
    // end;

    // [IntegrationEvent(false, false)]
    // procedure OnCancelFacilitatorDocForApproval(var Facilitator: Record "Facilitator Pool")
    // begin
    // end;

    // procedure UpdateApprovalStatus(var Facilitator: Record "Facilitator Pool"; ApprovalStatus: enum "Approval Status")
    // begin
    //     Faciliator1.Reset;
    //     Faciliator1.SetRange("Fiscal Year", Facilitator."Fiscal Year");
    //     Faciliator1.SetFilter("Approval Status", '<>%1|%2', "Approval Status"::released, "Approval Status"::rejected);
    //     Faciliator1.ModifyAll("Approval Status", ApprovalStatus);
    //     //Facilitator.VALIDATE("Approval Status", ApprovalStatus);
    //     //Facilitator.MODIFY;
    // end;

    // procedure CheckApprovalEntries(Facilitator: Record "Facilitator Pool"): Boolean
    // var
    //     ApprovalEntry: Record "Approval Entry";
    // begin
    //     ApprovalEntry.SetRange("Table ID", Database::"Facilitator Pool");
    //     ApprovalEntry.SetRange("Document No.", "Fiscal Year");
    //     ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Open);
    //     ApprovalEntry.SetRange("Related to Change", false);
    //     exit(not ApprovalEntry.IsEmpty);
    // end;
}
