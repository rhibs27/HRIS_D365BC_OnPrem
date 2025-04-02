table 50152 "Approval Setup Line"
{
    Caption = 'Approval Setup Line';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Request Type"; Enum "Employee Activity Type")
        {
            Caption = 'Request Type';
            Editable = false;
        }
        field(2; "Deputation On"; Enum "Deputation Type")
        {
            Caption = 'Deputation On';
            Editable = false;
        }
        field(3; "Employee Role"; Code[20])
        {
            Caption = 'Employee Role';
            TableRelation = "Approval Role";
        }
        field(4; "Approver Role"; Code[20])
        {
            Caption = 'Approver Role';
            TableRelation = "Approval Role";
            trigger OnValidate()
            var
                ApprovalRole: Record "Approval Role";
            begin
                if "Approver Role" <> xRec."Approver Role" then begin
                    Clear("Approver Role Name");
                    Clear("Approval Sequence");
                end;
                if ApprovalRole.Get("Approver Role") then
                    Validate("Approver Role Name", ApprovalRole.Description);
            end;
        }

        field(6; "Approver Role Name"; Text[100])
        {
            Caption = 'Approver Role Name';
            Editable = false;
        }
        field(7; "Approval Status"; Text[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Status Master";
            trigger OnValidate()
            var
                StatusMaster: Record "Status Master";
            begin
                StatusMaster.Reset();
                if StatusMaster.Get("Approval Status") then
                    Validate("Approval Role", StatusMaster.Role);
            end;
        }
        field(8; "Approval Role"; Text[20])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "From Deputation"; Boolean)
        {
            DataClassification = ToBeClassified;
            InitValue = true;

        }
        field(5; "Approval Sequence"; Integer)
        {
            Caption = 'Approval Sequence';
        }
    }
    keys
    {
        key(PK; "Request Type", "Deputation On", "Employee Role", "Approver Role")
        {
            Clustered = true;
        }
    }
}
