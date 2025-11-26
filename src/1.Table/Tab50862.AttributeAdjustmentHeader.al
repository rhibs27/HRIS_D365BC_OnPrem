table 50164 "Attribute Adjustment Header"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(2; "Document Type"; Text[50])
        {
            Caption = 'Document Type';
        }
        field(10; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
        }

        field(3; "Pay Cycle Code"; Code[20])
        {
            Caption = 'Pay Cycle Code';
            TableRelation = "Pay Cycle";
        }

        field(4; "Pay Cycle Term"; Code[20])
        {
            Caption = 'Pay Cycle Term';
            TableRelation = "Pay Cycle Term".Term where("Pay Cycle Code" = field("Pay Cycle Code"));
        }

        field(5; "Pay Cycle Period"; Code[20])
        {
            Caption = 'Pay Cycle Period';
            TableRelation = "Pay Cycle Period".Period where("Pay Cycle Code" = field("Pay Cycle Code"),
                                                             "Pay Cycle Term" = field("Pay Cycle Term"));
        }

        field(6; "Payroll Attribute Filter"; Text[100])
        {
            Caption = 'Payroll Attribute Filter';
        }

        field(7; "Employee Filter"; Text[100])
        {
            Caption = 'Employee Filter';
        }

        field(8; "Adjustment Type Filter"; Text[50])
        {
            Caption = 'Adjustment Type Filter';
        }

        field(9; "Approval Status"; Enum "Approval Status")
        {
            Caption = 'Approval Status';
        }
    }

    keys
    {
        key(PK; "Document No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    var
        HRSetup: Record "Human Resources Setup";
        NoSeriesMgt: Codeunit "No. Series";
        HrMgt: Codeunit "HR Mgt.";
    begin
        if "Document No." = '' then begin
            HRSetup.Get();
            HRSetup.TestField("Attribute Adjustment Nos.");
            HrMgt.InitNoSeriesNew(HRSetup."Attribute Adjustment Nos.", xRec."No. Series", Today, "Document No.", "No. Series");
            "Document No." := NoSeriesMgt.GetNextNo(HRSetup."Attribute Adjustment Nos.");
        end;
    end;
}
