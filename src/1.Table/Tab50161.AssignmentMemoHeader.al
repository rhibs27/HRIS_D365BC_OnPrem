table 50161 "Assignment Memo Header"
{
    Caption = 'Assignment Memo Header';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; Code[20])
        {
            trigger OnValidate()
            begin
                PGSetup.Get;
                if "No." <> xRec."No." then
                    case "Activity Type" of
                        "Activity Type"::"Allowance Assignment Memo":
                            begin
                                NoSeriesMgt.TestManual(PGSetup."Allowance Assignment Memo Nos");
                                "No. Series" := '';
                            end;
                        "Activity Type"::"Request Allowance":
                            begin
                                NoSeriesMgt.TestManual(PGSetup."Request Allowance Nos");
                                "No. Series" := '';
                            end;
                        "Activity Type"::"Shift Assignment Memo":
                            begin
                                NoSeriesMgt.TestManual(PGSetup."Shift Assignment Memo Nos");
                                "No. Series" := '';
                            end;
                    end;
            end;

        }
        field(2; "Activity Type"; Enum "Employee Activity Type")
        {
            DataClassification = ToBeClassified;
        }

        field(3; "From Date"; Date)
        {
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

                if Rec."From Date" <> xRec."From Date" then
                    Clear("To date");
            end;
        }
        field(4; "To date"; Date)
        {
            trigger OnValidate()
            begin
                if "Activity Type" <> "Activity Type"::"Request Allowance" then begin
                    TestField("From Date");
                    if "From Date" > "To date" then
                        Error('Invalid date.');
                end;
            end;
        }

        field(5; "Province Code"; Code[20])
        {
            TableRelation = "Organization Structure List".Code where(Type = const(Province));
        }
        field(6; "Branch Code"; Code[20])
        {
            TableRelation = "Organization Structure List".Code where(Type = const(Branch));
        }
        field(7; "Department Code"; Code[20])
        {
            TableRelation = "Organization Structure List".Code where(Type = const(Department));
        }
        field(8; "Unit Code"; Code[20])
        {
            TableRelation = "Organization Structure List".Code where(Type = const(Unit));
        }
        field(9; "Document Date"; Date)
        {
        }
        field(10; Remarks; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Rejection Remarks"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(12; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }

        field(15; "Payroll Attribute Code"; Code[20])
        {
            TableRelation = "Allowance Configuration"."Payroll Attribute";
            trigger OnValidate()
            var
                Employee: Record Employee;
                SalaryLevel: Record "Salary Level";
            begin
                if Employee.Get("Employee No.") then begin
                    SalaryLevel.Get(Employee."Salary Level");
                    if Employee."Vehicle Type" in [Employee."Vehicle Type"::"Four Wheeler", Employee."Vehicle Type"::"Two Wheeler"] then begin
                        "Fuel Limit (ltr)" := SalaryLevel."Fuel Limit (ltr)";
                        "Fuel Limit (amt)" := SalaryLevel."Fuel Limit (amt)";
                    end;
                end;
            end;
        }
        field(16; "Approval Status"; Enum "Approval Status")
        {

        }
        field(17; "Fiscal Year"; text[10])
        {
        }
        field(18; "Change Approver Remarks"; Text[250]) { }

        field(20; "Pay Cycle Code"; Code[20])
        {
            TableRelation = "Pay Cycle";

        }
        field(21; "Pay Cycle Term"; Code[20])
        {
            TableRelation = "Pay Cycle Term".Term where("Pay Cycle Code" = field("Pay Cycle Code"));


        }
        field(22; "Pay Cycle Period"; Integer)
        {
            TableRelation = "Pay Cycle Period".Period where("Pay Cycle Code" = field("Pay Cycle Code"),
                                                             "Pay Cycle Term" = field("Pay Cycle Term"));

        }
        field(23; "Employee No."; Code[50])
        {
            TableRelation = Employee where(Status = const(Active));
            DataClassification = ToBeClassified;
            Description = 'Only for Portal functionalities.';
            trigger OnValidate()
            var
                Employee: Record Employee;
            begin
                if Employee.Get("Employee No.") then begin
                    "Employee Name" := Employee.FullName();
                    "Permanent Address" := Employee.Address;
                    "Temporary Address" := Employee."Temporary Address";

                    if "Activity Type" in ["Activity Type"::"Request Allowance", "Activity Type"::"Shift Assignment Memo"] then begin
                        "Province Code" := Employee."Province Code";
                        "Branch Code" := Employee."Branch Code";
                        "Department Code" := Employee."Department Code";
                        "Unit Code" := Employee."Unit Code";
                    end;
                end else
                    "Employee Name" := '';
            end;
        }
        field(24; "Employee Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(25; "No of Lines"; Integer)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Count("Assignment Memo Line" where("Document No." = field("No.")));
        }
        field(26; "Total Line Amount"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum("Assignment Memo Line"."Allowance Amount" where("Document No." = field("No.")));
        }
        field(37; "Approved Date"; Date)
        {
        }
        field(38; "Substitute Approval Status"; Enum "Approval Status")
        {

        }
        field(39; "Fuel Limit (ltr)"; Decimal) { }

        field(40; "Fuel Limit (amt)"; Decimal) { }
        field(100; "Status"; Text[20])
        {
        }

        field(103; "Permanent Address"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(104; "Temporary Address"; Text[100])
        {
            DataClassification = ToBeClassified;
        }

    }

    keys
    {
        key(Key1; "No.") { }
    }

    trigger OnDelete()
    var
        CannotDelete: Label 'Cannot delete document.';
    begin
        if not ("Approval Status" in ["Approval Status"::" ", "Approval Status"::Open]) then
            Error(CannotDelete)
        else begin
            AssignmentMemoLine.Reset;
            AssignmentMemoLine.SetRange("Document No.", "No.");
            AssignmentMemoLine.DeleteAll(true);

            ApprovalHrms.Reset;
            ApprovalHrms.SetRange("Document No.", "No.");
            ApprovalHrms.DeleteAll(true);

            //clear marked document
            // if Rec."Activity Type" = Rec."Activity Type"::"Request Allowance" then begin
            //     AllowanceAssignmentMgt.ClearMarkedAllowanceData(Rec."No.");
            // end;
        end;
    end;

    trigger OnInsert()
    var
        TempAssignmentmemoHdr: Record "Assignment Memo Header" temporary;
        Recordref: RecordRef;
    begin
        "Document Date" := WorkDate();
        PGSetup.Get();
        TestField("Employee No.");
        if "No." = '' then
            case "Activity Type" of
                "Activity Type"::"Allowance Assignment Memo":
                    begin
                        PGSetup.TestField("Allowance Assignment Memo Nos");
                        HRMgt.InitNoSeriesNew(PGSetup."Allowance Assignment Memo Nos", "No.", "Document Date", "No.", "No. Series");
                        AssignmentMemoHdr.ReadIsolation(IsolationLevel::ReadCommitted);
                        AssignmentMemoHdr.SetLoadFields("No.");
                        while AssignmentMemoHdr.Get("No.") do
                            "No." := NoSeriesMgt.GetNextNo("No. Series");

                        ApproverMgt.InsertApproval("Employee No.", "No.", "Activity Type", "Approval Status");
                    end;

                "Activity Type"::"Request Allowance":
                    begin
                        PGSetup.TestField("Request Allowance Nos");
                        HRMgt.InitNoSeriesNew(PGSetup."Request Allowance Nos", xRec."No. Series", "Document Date", "No.", "No. Series");
                        AssignmentMemoHdr.ReadIsolation(IsolationLevel::ReadCommitted);
                        AssignmentMemoHdr.SetLoadFields("No.");
                        while AssignmentMemoHdr.Get("No.") do
                            "No." := NoSeriesMgt.GetNextNo("No. Series");

                        TempAssignmentmemoHdr := Rec;
                        TempAssignmentmemoHdr.Insert();
                        Recordref.GetTable(TempAssignmentmemoHdr);
                        ApproverMgt.InsertApprovalWithRecordref("Employee No.", "No.", "Activity Type", "Approval Status", Recordref);
                    end;
                "Activity Type"::"Shift Assignment Memo":
                    begin
                        PGSetup.TestField("Shift Assignment Memo Nos");
                        HRMgt.InitNoSeriesNew(PGSetup."Shift Assignment Memo Nos", "No.", "Document Date", "No.", "No. Series");
                        AssignmentMemoHdr.ReadIsolation(IsolationLevel::ReadCommitted);
                        AssignmentMemoHdr.SetLoadFields("No.");
                        while AssignmentMemoHdr.Get("No.") do
                            "No." := NoSeriesMgt.GetNextNo("No. Series");

                        ApproverMgt.InsertApproval("Employee No.", "No.", "Activity Type", "Approval Status");
                    end;
            end;

        AutoInsertDatesForRequestAllowance();
    end;

    var
        AssignmentMemoLine: Record "Assignment Memo Line";
        HrMgt: Codeunit "HR Mgt.";
        ApprovalHrms: Record "Approval HRMS";
        NoSeriesMgt: Codeunit "No. Series";
        ApproverMgt: Codeunit "Approver Mgt";
        AssignmentMemoHdr: Record "Assignment Memo Header";
        PGSetup: Record "Payroll General Setup";
        AssignmentMemoMgt: Codeunit "Assignment Memo Mgt";

    procedure AutoInsertDatesForRequestAllowance()
    begin
        if "Activity Type" = "Activity Type"::"Request Allowance" then begin
            PGSetup.Get();
            "From Date" := WorkDate();
            "To date" := PGSetup."Prev Fiscal Year End Date";
        end;
    end;

    procedure InsertDocumentAttachment(EmpActType: Enum "Employee Activity Type"; DocumentNo: Code[20]; EmployeeNo: Code[50])
    var
        IncDocAttachment: Record "Incoming Document";
    begin
        IncDocAttachment.Init();
        IncDocAttachment."No." := DocumentNo;
        IncDocAttachment.Validate(Type, IncDocAttachment.Type::" ");
        IncDocAttachment.Validate(Description, Format(EmpActType) + ': ' + Format(DocumentNo));
        if EmpActType = EmpActType::"Request Allowance" then
            IncDocAttachment.Validate("Employee Code", EmployeeNo);
        IncDocAttachment.Validate("Employee Activity Type", EmpActType);
        IncDocAttachment.Insert(true);
    end;
}