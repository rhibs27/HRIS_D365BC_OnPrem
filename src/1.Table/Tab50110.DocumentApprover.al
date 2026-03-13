table 50110 "Document Approver"
{
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Document No."; Code[20]) { }
        field(2; "Line No."; Integer) { }
        field(3; "Employee No."; Code[20])
        {
            TableRelation = Employee;
            trigger OnValidate()
            begin
                EmpRec.Get("Employee No.");
                Validate("Employee Name", EmpRec."Full Name");
            end;
        }
        field(4; "Employee Name"; Text[100])
        {
            Editable = false;
        }
        field(5; Remarks; Text[100])
        {
        }
        field(6; "Approval Status"; enum "Approval Status")
        {
        }
        field(7; "Functional Title"; Code[20])
        {
            Editable = false;
            TableRelation = "Functional Title";
        }
        field(8; "Approved Date"; Date) { }
        field(10; "Document Type"; Enum "Employee Activity Type")
        {
            ValuesAllowed = " ", "Resignation", "Training";
        }
        field(11; "Rejection Remarks"; Text[100]) { }
        field(12; "Approver Sequence"; Integer)
        {
            trigger OnValidate()
            var
                IsHandled: Boolean;
            begin
                OnBeforeValidateApproverSequence(Rec, IsHandled);
                if not IsHandled then begin
                    if "Approver Sequence" = 1 then
                        Validate("Approval Status", "Approval Status"::Open)
                    else
                        Validate("Approval Status", "Approval Status"::Created);
                end;
            end;
        }
        field(13; "Deputation Type"; Enum "Deputation Type")
        {
            Caption = 'Deputation Type';
        }
        field(14; "Deputation Code"; Code[20])
        {
            Caption = 'Deputation Code';
            TableRelation = "Organization Structure List".Code where(Type = field("Deputation Type"));
        }
        field(15; "Approver Role"; Code[20])
        {
            Caption = 'Approver Code';
            TableRelation = "Approval Role".Code;
        }
        field(16; "Approved By"; Code[20])
        {
            Caption = 'Approved By';
            TableRelation = Employee;
        }
        field(17; "Attachment"; Media)
        {
            Caption = 'Attachment';
        }
    }
    keys
    {
        key(Key1; "Document No.", "Line No.") { }
    }
    fieldgroups { }
    trigger OnInsert()
    begin
        GetLineNo();
    end;

    var
        HRMgt: Codeunit "HR Mgt.";
        EmpRec: Record Employee;

    local procedure GetLineNo()
    var
        ResignationApprover: Record "Document Approver";
    begin
        ResignationApprover.Reset;
        ResignationApprover.SetCurrentKey("Line No.");
        ResignationApprover.SetRange("Document No.", "Document No.");
        if ResignationApprover.FindLast then
            "Line No." := ResignationApprover."Line No." + 10000
        else
            "Line No." := 10000;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeValidateApproverSequence(var DocumentApprover: Record "Document Approver"; var IsHandled: Boolean)
    begin
        //To be used skipping sequential approval mechanism
    end;
}
