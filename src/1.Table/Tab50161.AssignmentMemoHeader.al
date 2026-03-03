table 50161 "Assignment Memo Header"
{
    //pay cycle based allowance assignment memo
    //doesnot support multiple pay cycle terms periods
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

                ValidateDatesAreWithinMonth("From Date", "To date");
                CheckIfAllowFutureAllowanceRequest();
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
                //check if dates are within the months
                ValidateDatesAreWithinMonth("From Date", "To date");
                CheckIfAllowFutureAllowanceRequest();
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
        field(9; "Document Date"; Date) { }
        field(10; Remarks; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Rejection Remarks"; Text[250])
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
                PayrollAttr: Record "Payroll Attributes";
            begin
                if Employee.Get("Employee No.") then begin
                    SalaryLevel.Get(Employee."Salary Level");
                    if Employee."Vehicle Type" in [Employee."Vehicle Type"::"Four Wheeler", Employee."Vehicle Type"::"Two Wheeler"] then begin
                        "Fuel Limit (ltr)" := SalaryLevel."Fuel Limit (ltr)";
                        if "Fuel Limit (ltr)" = 0 then
                            "Fuel Limit (amt)" := SalaryLevel."Transportation Allowance";
                    end;
                    if "Activity Type" = "Activity Type"::"Request Allowance" then
                        GetVehicleDetails();
                end;
                if PayrollAttr.Get("Payroll Attribute Code") then begin
                    "Payroll Attr. Description" := PayrollAttr.Description;
                end else begin
                    "Payroll Attr. Description" := '';
                end;
            end;
        }
        field(16; "Approval Status"; Enum "Approval Status") { }
        field(17; "Fiscal Year"; text[10]) { }
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
                Employee, Employee2 : Record Employee;
                HrMgt: Codeunit "HR Mgt.";
                SalaryLevel: Record "Salary Level";
            begin

                if Employee.Get("Employee No.") then begin
                    "Employee Name" := Employee.FullName();
                    "Permanent Address" := Employee.Address;
                    "Temporary Address" := Employee."Temporary Address";
                    "Salary Level" := Employee."Salary Level";

                    if "Activity Type" in ["Activity Type"::"Request Allowance"] then begin
                        "Province Code" := Employee."Province Code";
                        "Branch Code" := Employee."Branch Code";
                        "Department Code" := Employee."Department Code";
                        "Unit Code" := Employee."Unit Code";

                        if Employee.Get("Employee No.") then begin
                            SalaryLevel.Get(Employee."Salary Level");
                            if Employee."Vehicle Type" in [Employee."Vehicle Type"::"Four Wheeler", Employee."Vehicle Type"::"Two Wheeler"] then begin
                                "Fuel Limit (ltr)" := SalaryLevel."Fuel Limit (ltr)";
                                if "Fuel Limit (ltr)" = 0 then
                                    "Fuel Limit (amt)" := SalaryLevel."Transportation Allowance";
                            end;
                        end;
                        GetVehicleDetails();
                    end;
                end else begin
                    if not GuiAllowed then begin
                        if Employee2.Get(HrMgt.GetEmployeeNo()) then begin
                            "Employee Name" := Employee2.FullName();
                            "Permanent Address" := Employee2.Address;
                            "Temporary Address" := Employee2."Temporary Address";
                            "Salary Level" := Employee2."Salary Level";

                            if "Activity Type" in ["Activity Type"::"Request Allowance"] then begin
                                "Province Code" := Employee."Province Code";
                                "Branch Code" := Employee."Branch Code";
                                "Department Code" := Employee."Department Code";
                                "Unit Code" := Employee."Unit Code";

                                if Employee.Get("Employee No.") then begin
                                    SalaryLevel.Get(Employee."Salary Level");
                                    if Employee."Vehicle Type" in [Employee."Vehicle Type"::"Four Wheeler", Employee."Vehicle Type"::"Two Wheeler"] then begin
                                        "Fuel Limit (ltr)" := SalaryLevel."Fuel Limit (ltr)";
                                        if "Fuel Limit (ltr)" = 0 then
                                            "Fuel Limit (amt)" := SalaryLevel."Transportation Allowance";
                                    end;
                                end;
                                GetVehicleDetails();
                            end;
                        end;
                    end;
                end;
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
        field(27; "Salary Level"; Code[20])
        {
            TableRelation = "Salary Level".Code;
            Caption = 'Designation';
        }
        field(37; "Approved Date"; Date) { }
        field(38; "Substitute Approval Status"; Enum "Approval Status") { }
        field(39; "Fuel Limit (ltr)"; Decimal) { }
        field(40; "Fuel Limit (amt)"; Decimal) { }
        field(41; "Attachment Exists"; Boolean)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Exist("Incoming Document" where("Employee Activity Type" = const("Request Allowance"), "No." = field("No.")));
        }
        field(42; "Payroll Attr. Description"; Text[100]) { }
        field(43; "Nepali Month"; Enum "Nepali Month")
        {
            trigger OnValidate()
            var
                PayCyclePeriod: Record "Pay Cycle Period";
                PGSetup: Record "Payroll General Setup";
                Employee: Record Employee;
            begin
                //based on nepali month selected update the from date to date and other field
                PGSetup.Get();
                PGSetup.TestField("Payroll Fiscal Year Start Date");

                PayCyclePeriod.SetFilter("Nepali Month", '%1', "Nepali Month");
                PayCyclePeriod.SetFilter("Start Date", '>=%1', PGSetup."Payroll Fiscal Year Start Date");
                if PayCyclePeriod.FindFirst() then begin
                    if not GuiAllowed then
                        Employee.Get(HrMgt.GetEmployeeNo())
                    else
                        Employee.Get("Employee No.");
                    IF Employee."Employment Date" > PayCyclePeriod."Start Date" then
                        "From Date" := Employee."Employment Date"
                    else
                        "From Date" := PayCyclePeriod."Start Date";
                    "To date" := PayCyclePeriod."End Date";
                    "Pay Cycle Code" := PayCyclePeriod."Pay Cycle Code";
                    "Pay Cycle Term" := PayCyclePeriod."Pay Cycle Term";
                    "Pay Cycle Period" := PayCyclePeriod.Period;
                    CheckIfAllowFutureAllowanceRequest();
                end else begin
                    Error('No pay cycle period found for the selected Nepali Month.');
                end;
            end;
        }
        field(50; "Vehicle Type"; Enum "Vehicle Type") { }
        field(51; "Vehicle No."; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(52; "Vehicle Owner Name"; Text[150])
        {
            DataClassification = CustomerContent;
        }
        field(53; "Fuel Type"; Enum "Fuel Type")
        {
            DataClassification = CustomerContent;
        }
        field(60; "Effective Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'To be used for allowance claimed in prorata basis such as outstation allowance, remote allowance, etc.';
            trigger OnValidate()
            begin
                if ("Effective Date" <> 0D) and ("To date" <> 0D) then
                    if "Effective Date" > "To date" then
                        Error('Effective Date cannot be greater than To Date.');
            end;
        }
        field(71; "Ownership Start/End Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(100; "Status"; Text[20]) { }
        field(103; "Permanent Address"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(104; "Temporary Address"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(105; Reversed; Boolean)
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
        LeaveEarn: Record "Leave Earn";
    begin
        if not ("Approval Status" in ["Approval Status"::" ", "Approval Status"::Open]) then
            Error(CannotDelete)
        else begin
            LeaveEarn.SetCurrentKey("Claimed Document No.");
            LeaveEarn.SetRange("Claimed Document No.", Rec."No.");
            if LeaveEarn.FindSet() then
                repeat
                    LeaveEarn."Claimed Document No." := '';
                    LeaveEarn.Claimed := false;
                    LeaveEarn.Modify();
                until LeaveEarn.Next() = 0;
            AssignmentMemoLine.Reset;
            AssignmentMemoLine.SetRange("Document No.", Rec."No.");
            AssignmentMemoLine.DeleteAll(true);

            AssignmentmemoLineCopy.Reset;
            AssignmentmemoLineCopy.SetRange("Document No.", Rec."No.");
            AssignmentmemoLineCopy.DeleteAll(true);

            ApprovalHrms.Reset;
            ApprovalHrms.SetRange("Document No.", Rec."No.");
            ApprovalHrms.DeleteAll(true);

            IncomingDocument.Reset();
            IncomingDocumentAttachment.Reset();
            IncomingDocument.SetRange("No.", Rec."No.");
            IncomingDocumentAttachment.SetRange("Document No.", IncomingDocument."No.");
            IncomingDocumentAttachment.DeleteAll();
            IncomingDocument.DeleteAll();

        end;
    end;

    trigger OnInsert()
    var
        TempAssignmentmemoHdr: Record "Assignment Memo Header" temporary;
        Recordref: RecordRef;
    begin
        "Document Date" := WorkDate();
        PGSetup.Get();
        PGSetup.TestField("Use Allowance Configuration");
        TestField("Employee No.");
        Validate("Employee No.");
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
        InsertDocumentAttachment("Activity Type", "No.", "Employee No.");
        AutoInsertDatesForRequestAllowance();
        CheckIfWithinAllowancePeriod();
    end;

    var
        AssignmentMemoLine: Record "Assignment Memo Line";
        HrMgt: Codeunit "HR Mgt.";
        ApprovalHrms: Record "Approval HRMS";
        NoSeriesMgt: Codeunit "No. Series";
        ApproverMgt: Codeunit "Approver Mgt";
        AssignmentMemoHdr: Record "Assignment Memo Header";
        PGSetup: Record "Payroll General Setup";
        AssignmentmemoLineCopy: Record "Assignment Memo Line Copy";
        IncomingDocument: Record "Incoming Document";
        IncomingDocumentAttachment: Record "Incoming Document Attachment";

    procedure AutoInsertDatesForRequestAllowance()
    var
        PaycyclePeriod: Record "Pay Cycle Period";
    begin
        if "Activity Type" = "Activity Type"::"Request Allowance" then begin
            if ("From Date" = 0D) and ("To Date" = 0D) then begin
                PaycyclePeriod.Setfilter("Start Date", '<=%1', WorkDate());
                PaycyclePeriod.SetFilter("End Date", '>=%1', WorkDate());
                PaycyclePeriod.FindFirst();
                "From Date" := PaycyclePeriod."Start Date";
                "To date" := PaycyclePeriod."End Date";
                "Nepali Month" := PaycyclePeriod."Nepali Month";
            end;
        end;
    end;

    procedure InsertDocumentAttachment(EmpActType: Enum "Employee Activity Type"; DocumentNo: Code[20];
                                                       EmployeeNo: Code[50])
    var
        IncDocAttachment, IncDocAttachment1 : Record "Incoming Document";
        AttachmentSetup: Record "Attachment Setup";
        IncomingDoc: Record "Incoming Document";
        PayrollAttributes: Record "Payroll Attributes";
        IncomingDocumentAttachment: Record "Incoming Document Attachment";
    begin
        if not PayrollAttributes.Get("Payroll Attribute Code") then
            exit;

        if EmpActType = EmpActType::"Request Allowance" then begin
            AttachmentSetup.SetFilter(Type, Format(EmpActType));
            case PayrollAttributes."Specific Attributes" of
                PayrollAttributes."Specific Attributes"::"Education Allowance":
                    AttachmentSetup.SetRange("Sub Type", AttachmentSetup."Sub Type"::"Education Allowance");
                PayrollAttributes."Specific Attributes"::Reimbursement:
                    AttachmentSetup.SetRange("Sub Type", AttachmentSetup."Sub Type"::Reimbursement);
                PayrollAttributes."Specific Attributes"::"Remote Area Allowance":
                    AttachmentSetup.SetRange("Sub Type", AttachmentSetup."Sub Type"::"Remote Allowance");
                PayrollAttributes."Specific Attributes"::"OutStation Allowance":
                    AttachmentSetup.SetRange("Sub Type", AttachmentSetup."Sub Type"::"Outstation Allowance");
                PayrollAttributes."Specific Attributes"::"Maternity/Paternity Allowance":
                    AttachmentSetup.SetRange("Sub Type", AttachmentSetup."Sub Type"::"Maternity/Paternity Allowance");
                PayrollAttributes."Specific Attributes"::"Funeral Allowance":
                    AttachmentSetup.SetRange("Sub Type", AttachmentSetup."Sub Type"::"Funeral Allowance")
                else
                    AttachmentSetup.SetRange("Sub Type", AttachmentSetup."Sub Type"::" ");
            end;
        end
        else
            if EmpActType = EmpActType::"Shift Assignment Memo" then
                AttachmentSetup.SetRange(Type, AttachmentSetup.Type::"Shift Assignment Memo")
            else
                if EmpActType = EmpActType::"Allowance Assignment Memo" then
                    AttachmentSetup.SetRange(Type, AttachmentSetup.Type::"Allowance Assignment Memo");
        if AttachmentSetup.FindSet() then
            repeat
                IncDocAttachment1.SetRange("Document No.", DocumentNo);
                IncDocAttachment1.SetRange("Attachment Code", AttachmentSetup."Attachment Code");
                if IncDocAttachment1.IsEmpty then begin
                    IncDocAttachment.Init();
                    IncDocAttachment."Entry No." := GetNextEntrNo;
                    IncDocAttachment."No." := DocumentNo;
                    IncDocAttachment."Document No." := DocumentNo;
                    IncDocAttachment.Validate(Type, IncDocAttachment.Type::" ");
                    IncDocAttachment.Validate(Description, Format(EmpActType) + ': ' + Format(DocumentNo));
                    if EmpActType = EmpActType::"Request Allowance" then
                        IncDocAttachment.Validate("Employee Code", EmployeeNo);
                    IncDocAttachment.Validate("Employee Activity Type", EmpActType);
                    IncDocAttachment.Validate("Attachment Code", AttachmentSetup."Attachment Code");
                    IncDocAttachment.Insert(true);
                end;
            until AttachmentSetup.Next() = 0;
    end;

    local procedure GetNextEntrNo(): Integer
    var
        IncDocAttachmentForIncrement: Record "Incoming Document";
    begin
        if IncDocAttachmentForIncrement.FindLast() then
            IncDocAttachmentForIncrement."Entry No." += 1
        else
            IncDocAttachmentForIncrement."Entry No." := 1;
        exit(IncDocAttachmentForIncrement."Entry No.");
    end;

    procedure ValidateDatesAreWithinMonth(fromDate: Date; toDate: Date)
    var
        PayCycleperiod: Record "Pay Cycle Period";
    begin
        if (fromDate = 0D) or (toDate = 0D) then
            exit;

        PayCycleperiod.SetFilter("Start Date", '<=%1', fromDate);
        PayCycleperiod.SetFilter("End Date", '>=%1', toDate);
        if not PayCycleperiod.FindFirst then
            Error('From Date and To Date must be within the same payroll month.');

        if fromDate <> PayCycleperiod."Start Date" then
            Error('From Date must be the starting date of payroll month.');
        if toDate <> PayCycleperiod."End Date" then
            Error('To Date must be the ending date of payroll month.');

        "Pay Cycle Code" := PayCycleperiod."Pay Cycle Code";
        "Pay Cycle Term" := PayCycleperiod."Pay Cycle Term";
        "Pay Cycle Period" := PayCycleperiod.Period;
        "Nepali Month" := PayCycleperiod."Nepali Month";
    end;

    procedure CheckIfWithinAllowancePeriod()
    var
        PayCyclePeriod: Record "Pay Cycle Period";
    begin
        if "Activity Type" <> "Activity Type"::"Request Allowance" then
            exit;
        PayCyclePeriod.SetFilter("Start Date", '<=%1', "Document Date");
        PayCyclePeriod.SetFilter("End Date", '>=%1', "Document Date");
        PayCyclePeriod.FindFirst();
        if PayCyclePeriod."Allowance Start Date" <> 0D then
            if "Document Date" <= PayCyclePeriod."Allowance Start Date" then
                if "Activity Type" = "Activity Type"::"Request Allowance" then
                    Error('Allowance can not be requested until %1.', PayCyclePeriod."Allowance Start Date");
        if PayCyclePeriod."Allowance End Date" <> 0D then
            if "Document Date" >= PayCyclePeriod."Allowance End Date" then
                if "Activity Type" = "Activity Type"::"Request Allowance" then
                    Error('Allowance can not be requested from %1.', PayCyclePeriod."Allowance End Date");
    end;

    procedure GetVehicleDetails()
    var
        Employee: Record Employee;
        EmployeeEdit: Record "Employee Edit";
    begin
        if Employee.Get("Employee No.") then begin
            EmployeeEdit.SetRange("Employee No.", Employee."No.");
            if EmployeeEdit.FindLast() then begin
                "Vehicle Type" := EmployeeEdit."Vehicle Type";
                "Vehicle No." := EmployeeEdit."Vehicle No.";
                "Vehicle Owner Name" := EmployeeEdit."Vehicle Owner Name";
                "Fuel Type" := EmployeeEdit."Fuel Type";
                "Ownership Start/End Date" := EmployeeEdit."Ownership Start/End Date";
            end;
        end;
    end;

    procedure CheckIfAllowFutureAllowanceRequest()
    var
        PGSetup: Record "Payroll General Setup";
        PayCyclePeriod: Record "Pay Cycle Period";
    begin
        if "From Date" = 0D then
            exit;
        if "To Date" = 0D then
            exit;
        if "Activity Type" <> "Activity Type"::"Request Allowance" then
            exit;
        PayCyclePeriod.SetFilter("Start Date", '<=%1', WorkDate());
        PayCyclePeriod.SetFilter("End Date", '>=%1', WorkDate());
        PayCyclePeriod.FindFirst();

        PGSetup.Get();
        if ((not PGSetup."Allow Future Allowance Request") and
            ("From Date" > PayCyclePeriod."End Date")) then
            Error('Future allowance request is not allowed as per payroll setup.');

        if ((not PGSetup."Allow Future Allowance Request") and ("To Date" > PayCyclePeriod."End Date")) then
            Error('Future allowance request is not allowed as per payroll setup.');
    end;
}