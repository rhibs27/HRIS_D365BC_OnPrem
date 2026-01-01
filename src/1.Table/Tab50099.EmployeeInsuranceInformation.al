table 50099 "Employee Insurance Information"
{
    DataClassification = CustomerContent;
    LookupPageId = "Employee Insurance Lists";
    DrillDownPageId = "Employee Insurance Lists";
    fields
    {
        field(1; "Insurance No."; Code[20])
        {
            Editable = false;
            trigger OnValidate()
            begin
                if "Insurance No." <> '' then begin
                    HRSetup.Get;
                    HRSetup.TestField("Employee Insurance No.");
                    NoSeriesMgt.TestManual(HRSetup."Employee Insurance No.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; Type; Enum "Employee Activity Type") { }
        field(3; "Employee No."; Code[20])
        {
            TableRelation = Employee;
            Editable = false;
            trigger OnValidate()
            begin
                if Employee.Get("Employee No.") then
                    Validate("Employee Name", Employee."Full Name")
                else
                    Clear("Employee Name");
            end;
        }
        field(4; "Employee Name"; Text[50]) { }
        field(5; "Insurance Company Code"; Code[20])
        {
            TableRelation = "Insurance Company" where(Blocked = const(false));
            trigger OnValidate()
            var
                InsuranceCompany: Record "Insurance Company";
            begin
                if "Insurance Company Code" <> '' then begin
                    if not InsuranceCompany.Get("Insurance Company Code") then
                        Error('Kindly select the company from the dropdown list');
                    Validate("Insurance Company Name", InsuranceCompany.Name);
                end else
                    Clear("Insurance Company Name");
            end;
        }
        field(6; "Insurance Company Name"; Text[50])
        {
            Editable = false;
        }
        field(7; "Policy Number"; Text[30])
        {
            trigger OnValidate()
            begin
                Clear(Len);
                Len := StrLen(DelChr("Policy Number", '=', DelChr("Policy Number", '=', SpecialChars)));
                if Len > 0 then
                    Error(SpecialCharsErr);
                EmpInsurance.Reset;
                EmpInsurance.SetRange("Employee No.", Rec."Employee No.");
                EmpInsurance.SetRange("Policy Number", Rec."Policy Number");
                if EmpInsurance.FindFirst then
                    Error(Text019, Rec."Policy Number", EmpInsurance."Insurance No.");
            end;
        }
        field(8; "Insurance Start Date (AD)"; Date)
        {
            trigger OnValidate()
            begin
                EngNepDate.Reset;
                EngNepDate.SetRange("English Date", "Insurance Start Date (AD)");
                if EngNepDate.FindFirst then
                    Validate("Insurance Start Date (BS)", EngNepDate."Nepali Date")
                else
                    Clear("Insurance Start Date (BS)");
                if "Insurance Start Date (AD)" > Today then
                    Error(Error002, Today);
            end;
        }
        field(9; "Insurance Start Date (BS)"; Text[20])
        {
            Editable = false;
        }
        field(10; "Insurance Expiry Date (AD)"; Date)
        {
            trigger OnValidate()
            begin
                EngNepDate.Reset;
                EngNepDate.SetRange("English Date", "Insurance Expiry Date (AD)");
                if EngNepDate.FindFirst then
                    Validate("Insurance Expiry Date (BS)", EngNepDate."Nepali Date")
                else
                    Clear("Insurance Expiry Date (BS)");
                if "Insurance Start Date (AD)" > "Insurance Expiry Date (AD)" then
                    Error(Error001, "Insurance Start Date (AD)");
            end;
        }
        field(11; "Insurance Expiry Date (BS)"; Text[20])
        {
            Editable = false;
        }
        field(12; "Insurance Amount"; Decimal) { }
        field(13; "Annual Premium Amount"; Decimal)
        {
            trigger OnValidate()
            begin
                if "Annual Premium Amount" > "Insurance Amount" then
                    Error('Annual Premium Amount Should be less than Insurance Amount.');
            end;
        }
        field(14; "Monthly Premium Amount"; Decimal) { }
        field(15; "Linked Home Loan Account No."; Text[30]) { }
        field(17; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(16; "Approval Status"; Enum "Approval Status") { }
        field(18; "Is Home Loan TieUp"; Boolean) { }
        field(19; "Requested Date"; Date)
        {
            Editable = false;
        }
        field(20; "Insurance Type"; Enum "Employee Insurance Type") { }
        field(21; Remarks; Text[250]) { }
        field(22; "Premium Paid By"; enum "Premium Paid By")
        {
            Caption = 'Premium Paid By';
        }
        field(23; "Rejection Remarks"; Text[250]) { }
        field(37; "Approved Date"; Date) { }
        field(24; "Expired"; Boolean) { }
        field(100; Status; Text[20])
        {
            TableRelation = "Status Master";
        }
        field(301; "Access Token"; code[60])
        {
            caption = 'Access Token';
            DataClassification = CustomerContent;
        }
        //     field(20; "Life Insurance Company"; Enum "Life Insurance Company")
        //     {
        //     }
        //     field(21; "Medical/Property Ins Company"; Enum "Medical/Property Ins Company")
        //     {
        //     }
    }
    keys
    {
        key(Key1; "Insurance No.") { }
    }
    fieldgroups { }
    trigger OnInsert()
    begin
        "Requested Date" := Today;
        if not GuiAllowed then begin
            if not HrMgt.IsSaaS() then
                Validate("Employee No.", Hrmgt.GetEmployeeNo());
            "Approval Status" := "Approval Status"::Pending;
            Validate(Type, Rec.Type::Insurance);
        end;
        if "Insurance No." = '' then begin
            HRSetup.Get;
            HRSetup.TestField("Employee Insurance No.");
            HRMgt.InitNoSeriesNew(HRSetup."Employee Insurance No.", xRec."No. Series", "Requested Date", "Insurance No.", "No. Series");
            EmpInsurance.ReadIsolation(IsolationLevel::ReadCommitted);
            EmpInsurance.SetLoadFields("Insurance No.");
            while EmpInsurance.Get("Insurance No.") do
                "Insurance No." := NoSeriesMgt.GetNextNo("No. Series");
            ApproverMgt.InsertApproval("Employee No.", "Insurance No.", Type, "Approval Status");
        end;
        /*EmpInsurance.Reset();
        EmpInsurance.SetRange("Employee No.","Employee No.");
        EmpInsurance.SETFILTER(Status,'%1|%2',EmpInsurance.Status::Open,EmpInsurance.Status::Pending);
        EmpInsurance.SETFILTER("Insurance No.",'<>%1',"Insurance No.");
        IF EmpInsurance.FindFirst() THEN
          ERROR('Insurance of employee %1 (%2) is pending.',EmpInsurance."Employee Name","Employee No.");*/
        // if not GuiAllowed then begin
        //     ApproverMgt.UpdateFirstApproverStatus(Rec."Insurance No.");
        // LoanMgt.CheckInsuranceAttachment("Insurance No.", "Employee No.");
        // IncomingDoc.Reset;
        // IncomingDoc.SetRange("No.", '');
        // IncomingDoc.SetRange("Employee Activity Type", IncomingDoc."Employee Activity Type"::Insurance);
        // IncomingDoc.SetRange("Employee Code", "Employee No.");
        // IncomingDoc.ModifyAll("No.", "Insurance No.");
        // end;
        if GuiAllowed then begin
            AttachmentSetup.Reset;
            AttachmentSetup.SetRange(Type, AttachmentSetup.Type::Insurance);
            if AttachmentSetup.Find('-') then
                repeat
                    IncomingDoc.Init;
                    IncomingDoc.Validate("No.", "Insurance No.");
                    IncomingDoc.Validate("Table ID", Database::"Employee Insurance Information");
                    IncomingDoc.Validate("Attachment Code", AttachmentSetup."Attachment Code");
                    IncomingDoc.Validate("Employee Code", "Employee No.");
                    IncomingDoc.Validate("Employee Activity Type", IncomingDoc."Employee Activity Type"::Insurance);
                    IncomingDoc."Entry No." := IncomingDoc.GetEntryNo();
                    IncomingDoc.Insert;
                until AttachmentSetup.Next = 0;
        end;
    end;

    trigger OnDelete()
    var
        CannotDelete: Label 'Cannot delete document.';
    begin
        if not ("Approval Status" in ["Approval Status"::" ", "Approval Status"::Open]) then
            Error(CannotDelete)
        else begin
            ApprovalEntry.Reset();
            ApprovalEntry.SetRange("Document No.", "Insurance No.");
            ApprovalEntry.SetRange("Employee No", "Employee No.");
            ApprovalEntry.DeleteAll();
        end;
    end;

    // trigger OnModify()
    // begin
    //     if "Approval Status" in ["Approval Status"::Open, "Approval Status"::Pending] then
    //         LoanMgt.CheckInsuranceAttachment("Insurance No.", "Employee No.");
    //     if not GuiAllowed then
    //         if "Approval Status" = "Approval Status"::Open then
    //             "Approval Status" := "Approval Status"::Pending;
    /*EmpInsurance.Reset();
    EmpInsurance.SetRange("Employee No.",Rec."Employee No.");
    EmpInsurance.SetRange("Policy Number",Rec."Policy Number");
    IF EmpInsurance.FindFirst() THEN
//       ERROR(Text019,Rec."Policy Number",EmpInsurance."Insurance No.");*/
    // end;
    var
        NoSeriesMgt: Codeunit "No. Series";
        HRSetup: Record "Human Resources Setup";
        Employee: Record Employee;
        EngNepDate: Record "English-Nepali Date";
        AttachmentSetup: Record "Attachment Setup";
        IncomingDoc: Record "Incoming Document";
        EmpInsurance: Record "Employee Insurance Information";
        ApproverMgt: Codeunit "Approver Mgt";
        Hrmgt: Codeunit "HR Mgt.";
        SpecialCharsErr: Label 'You cannot enter the special characters. ';
        SpecialChars: Label '!|@|#|$|%|&|*|(|)|_|-|+|=| |?';
        ApprovalEntry: Record "Approval HRMS";
        Len: Integer;
        Text019: Label 'Policy No. %1 already used in Insurance No. %2.';
        Error001: Label 'Insurance Expiry Date must be greater then Insurance Start Date %1.';
        Error002: Label 'Insurance Start Date must be less or equal to %1.';
}
