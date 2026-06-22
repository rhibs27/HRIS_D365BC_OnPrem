table 50164 "Attribute Adjustment Header"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(10; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            trigger OnValidate()
            begin
                if "Document No." <> xRec."Document No." then begin
                    HRSetup.Get;
                    NoSeries.TestManual(HRSetup."Attribute Adjustment Nos.");
                    "No. Series" := '';
                end;
            end;
        }
        field(20; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
        }
        field(30; "Pay Cycle Code"; Code[20])
        {
            Caption = 'Pay Cycle Code';
            TableRelation = "Pay Cycle";
        }
        field(40; "Pay Cycle Term"; Code[20])
        {
            Caption = 'Pay Cycle Term';
            TableRelation = "Pay Cycle Term".Term where("Pay Cycle Code" = field("Pay Cycle Code"));
        }
        field(50; "Pay Cycle Period"; Integer)
        {
            Caption = 'Pay Cycle Period';
            TableRelation = "Pay Cycle Period".Period where("Pay Cycle Code" = field("Pay Cycle Code"),
                                                            "Pay Cycle Term" = field("Pay Cycle Term"));
        }
        field(80; "Adjustment Type"; Enum "Service Event")
        {
            Caption = 'Adjustment Type';
            ValuesAllowed = " ", Promotion, Confirmation, "Transfer";
        }
        field(90; "Approval Status"; Enum "Approval Status")
        {
            Caption = 'Approval Status';
            Editable = false;
        }
        field(100; "Rejection Remarks"; Text[250])
        {
            Caption = 'Rejection Remarks';
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
        EmpActivityType: Enum "Employee Activity Type";
        HRSetup: Record "Human Resources Setup";
        NoSeriesMgt: Codeunit "No. Series";
    begin
        if "Document No." = '' then begin
            HRSetup.Get();
            HRSetup.TestField("Attribute Adjustment Nos.");
            HrMgt.InitNoSeriesNew(HRSetup."Attribute Adjustment Nos.", xRec."No. Series", Today, "Document No.", "No. Series");
            "Document No." := NoSeriesMgt.GetNextNo(HRSetup."Attribute Adjustment Nos.");

            if "Approval Status" <> "Approval Status"::Approved then
                ApproverMgt.InsertApproval(HrMgt.GetEmployeeNo(), "Document No.", EmpActivityType::"Attribute Adjustment", "Approval Status");
        end;

        PGSetup.Get();
        "Pay Cycle Code" := PGSetup."Pay Cycle Code";
        "Pay Cycle Term" := PGSetup."Pay Cycle Term";
        "Approval Status" := "Approval Status"::Open;
    end;

    trigger OnModify()
    begin
        if not GuiAllowed then begin
            TestField("Approval Status", "Approval Status"::Open);
            "Approval Status" := "Approval Status"::Pending;
        end;
    end;

    trigger OnDelete()
    var
        CannotDelete: Label 'Cannot delete %1 document.';
        ApprovalEntry: Record "Approval HRMS";
        AttributesAdjustmentLines: Record "Attribute Adjustment Line";
    begin
        if not ("Approval Status" in ["Approval Status"::" ", "Approval Status"::Created, "Approval Status"::Open]) then
            Error(CannotDelete, Format("Approval Status").ToLower)
        else begin
            ApprovalEntry.Reset();
            ApprovalEntry.SetRange("Document No.", "Document No.");
            ApprovalEntry.SetRange("Employee No", HrMgt.GetEmployeeNo());
            ApprovalEntry.DeleteAll();
            AttributesAdjustmentLines.Reset();
            AttributesAdjustmentLines.SetRange("Document No.", "Document No.");
            AttributesAdjustmentLines.DeleteAll();
        end;
    end;

    procedure AssistEdit(OldAttrAdj: Record "Attribute Adjustment Header"): Boolean
    begin
        HRSetup.Get;
        HRSetup.TestField("Attribute Adjustment Nos.");
        if NoSeries.LookupRelatedNoSeries(HRSetup."Attribute Adjustment Nos.", OldAttrAdj."No. Series", Rec."No. Series") then begin
            NoSeries.GetNextNo(Rec."Document No.");
            exit(true);
        end;
    end;

    var
        ApproverMgt: Codeunit "Approver Mgt";
        HrMgt: Codeunit "HR Mgt.";
        PGSetup: Record "Payroll General Setup";
        HRSetup: Record "Human Resources Setup";
        NoSeries: Codeunit "No. Series";
}
