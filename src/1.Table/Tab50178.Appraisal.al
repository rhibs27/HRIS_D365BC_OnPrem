table 50178 Appraisal
{
    DataClassification = CustomerContent;

    // version Remit1.00
    fields
    {
        field(1; "Appraisal Code"; Code[20])//this is similar as document no whose id is fixed to 1
        {
            trigger OnValidate()
            begin
                if "Appraisal Code" <> xRec."Appraisal Code" then begin
                    HumanResSetup.Get;
                    NoSeriesMgt.TestManual(HumanResSetup."Appraisal No.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "Document Type"; Enum "Employee Activity Type") //document type id is fixed to 2
        {
            Caption = 'Document Type';
            DataClassification = CustomerContent;
            InitValue = Appraisal;
        }
        field(16; "Approval Status"; Enum "Approval Status")//approval status fixed id to 16
        {
            Caption = 'Approval Status';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "Approval Status" = "Approval Status"::Pending then
                    AppraisalMgt.CheckAppraisalAttachmentMandatory(Rec);
                if "Approval Status" = "Approval Status"::Approved then begin
                    Posted := true;
                    "Posting Date" := Today;
                    "Approved Date" := Today;
                end else begin
                    Posted := false;
                    Clear("Posting Date");
                    Clear("Approved Date");
                end;

            end;
        }
        field(37; "Approved Date"; Date) { } // approved date field id is 37 which is fixed
        field(39; Cancelled; Boolean)//cancelled field id is fixed to 39 which is fixed
        {
            Caption = 'Cancelled';
            DataClassification = CustomerContent;
        }
        field(100; Status; Text[20]) // status field is 100 which is fixed
        {
        }
        field(3; "Employee Code"; Code[20])
        {
            TableRelation = Employee."No.";
            trigger OnValidate()
            begin
                if "Fiscal Year" = '' then
                    Error('Please select Fiscal Year first');
                OnValidateEmployeeNo;

            end;
        }
        field(4; "Employee Name"; Text[100]) { Editable = false; }
        field(5; "Date of Employement"; Date)
        {
            Editable = false;
        }
        field(6; Department; Code[20])
        {
            Editable = false;
            TableRelation = "Organization Structure List".Code
        where(Type = filter("Deputation Type"::Department));
        }
        field(7; "Functional Title"; Code[20])
        {
            Editable = false;
            TableRelation = "Functional Title";
        }
        field(8; Branch; Code[20]) { Editable = false; }
        field(9; "Branch Name"; Text[50]) { Editable = false; }
        field(11; Province; Code[20]) { Editable = false; }
        field(13; "Extension Counter"; Code[20]) { Editable = false; }
        field(14; Unit; Code[20]) { Editable = false; }
        field(15; "Department Name"; Text[50]) { Editable = false; }
        field(17; "Province Name"; Text[50]) { Editable = false; }
        field(18; "Extension Counter Name"; Text[100]) { Editable = false; }
        field(19; "Unit Name"; Text[50]) { Editable = false; }
        field(20; "Sub-unit"; Code[20]) { Editable = false; }
        field(21; "Sub-Unit Name"; Text[100]) { Editable = false; }
        field(22; "Functional Title Desc"; Text[100]) { }
        field(23; "Fiscal Year"; Code[20])
        {
            TableRelation = "Pay Cycle Term".Term;
            trigger OnValidate()
            begin
                if "Fiscal Year" <> xRec."Fiscal Year" then begin
                    Clear("Employee Code");
                    Clear("Employee Name");
                end;
            end;
        }
        field(24; Posted; Boolean) { Editable = false; }
        field(25; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(26; "Appraisal Type"; Enum "Appraisal Type")
        {
            trigger OnValidate()
            begin
                if "Appraisal Type" <> xRec."Appraisal Type" then begin
                    Clear("Appraisal Subtype Monthly");
                    Clear("Appraisal Subtype Quarterly");
                end;
            end;
        }
        field(27; "Appraisal Template"; Code[50])
        {
            TableRelation = "Appraisal Template"."Template Master No.";
            trigger OnValidate()
            var
                ApprisalTemplate: Record "Appraisal Template";
            begin
                if GuiAllowed then
                    AppraisalMgt.ValidateKRAInEmployeeQuestionnaire(Rec);
                AppraisalMgt.OnValidateKRACategory(Rec);
            end;
        }
        field(28; "KPI Rating Type"; Enum "KPI Rating Type")
        {

        }
        field(29; "Reviewer III"; Code[20]) { TableRelation = Employee; }
        field(30; "Posting Date"; Date) { Editable = false; }
        field(31; "Reviewed Score I"; Decimal) { }
        field(32; "Reviewed Score II"; Decimal) { }
        field(33; "Reviewed Score III"; Decimal) { }
        field(34; "Job Grade"; Code[20]) { }
        field(35; "Total Tenure in Bank"; Integer) { }
        field(36; "Submission Date"; Date) { }
        field(38; "Reviewed Date I"; Date) { }
        field(40; "Reviewed Date II"; Date) { }
        field(41; "Reviewed Date III"; Date) { }
        field(42; "Total Tenure in Crc Position"; Date) { }
        field(43; "Reportees Comments"; Text[250]) { }
        field(44; "Reviewer Comments"; Text[250]) { }
        field(45; "Check Reviewers Comments"; Text[250]) { }
        field(46; "Requested Date"; Date)
        {
            Editable = false;
        }
        field(47; "Appraisal Subtype Monthly"; Enum "Nepali Month") { }
        field(48; "Appraisal Subtype Quarterly"; Enum Quater) { }

        field(49; "Total Final Score"; Decimal)
        {
            Editable = false;
            trigger OnValidate()
            begin
                SetFinalGrading;
            end;
        }
        field(50; "Final Grading"; Enum "Appraisal Rating")
        {
            Editable = false;
        }
        field(51; "Cancelled Document No."; Code[20]) { }
        field(52; "Confirmation Date"; Date)
        {
            Editable = false;
        }
    }
    keys
    {
        key(Key1; "Appraisal Code") { }
    }
    trigger OnDelete()
    begin
        if "Approval Status" <> "Approval Status"::Open then
            Error('You can delete the Appraisal only when the Status is Open. Current Status: %1', Format(Status));
    end;

    trigger OnInsert()
    var
        ApproverMgt: Codeunit "Approver Mgt";
    begin
        HumanResSetup.Get;
        Validate("Requested Date", Today);
        if "Appraisal Code" = '' then begin
            HumanResSetup.TestField("Appraisal No.");
            HRMgt.InitNoSeriesNew(HumanResSetup."Appraisal No.", xRec."No. Series", 0D, "Appraisal Code", "No. Series");
            "Appraisal Code" := NoSeriesMgt.GetNextNo(HumanResSetup."Appraisal No.", Today, true);
        end;
        "Approval Status" := "Approval Status"::Open;
        "Document Type" := "Document Type"::Appraisal;
        if not GuiAllowed then begin
            if "Employee Code" = '' then
                Validate("Employee Code", "Employee Code");

            AppraisalMgt.OnValidateKRACategory(Rec);
            CheckForDuplicateEmployeeAppraisal;
        end;
        ApproverMgt.InsertApproval("Employee Code", "Appraisal Code", "Document Type", "Approval Status");
        InsertAttachmentAppraisal;
    end;

    trigger OnModify()
    begin
        CheckForDuplicateEmployeeAppraisal;
    end;

    var
        EmployeeVar: Record Employee;
        HRMgt: Codeunit "HR Mgt.";
        Appraisal: Record Appraisal;
        HumanResSetup: Record "Human Resources Setup";
        NoSeriesMgt: Codeunit "No. Series";
        AppraisalMgt: Codeunit "AppraisalMgt.";

    local procedure OnValidateEmployeeNo()
    var
        HRSetup: Record "Human Resources Setup";
        HRMgt: Codeunit "HR Mgt.";
        EngNepDate: Record "English-Nepali Date";
        EmployeeTransfer: Record "Employee Transfer";
        LatestEmployeeTransfer: Record "Employee Transfer";
        FiscalYearStartDate: Date;
        FiscalYearEndDate: Date;
        BranchAppraisalCriteria: DateFormula;
        TransferFound: Boolean;
        LatestTransferDate: Date;
        UseToValues: Boolean;
    begin
        Clear("Functional Title");
        Clear(Department);
        Clear("Department Name");
        Clear(Branch);
        Clear("Branch Name");
        Clear(Province);
        Clear("Province Name");
        Clear("Extension Counter");
        Clear("Extension Counter Name");
        Clear(Unit);
        Clear("Unit Name");
        Clear("Sub-unit");
        Clear("Sub-Unit Name");
        Clear("Functional Title Desc");
        if not EmployeeVar.Get("Employee Code") then
            exit;
        "Employee Name" := EmployeeVar."Full Name";
        "Date of Employement" := EmployeeVar."Employment Date";
        "Confirmation Date" := EmployeeVar."Confirmation Date";
        "Job Grade" := EmployeeVar."Salary Grade";
        HRSetup.Get();
        BranchAppraisalCriteria := HRSetup."Branch Appraisal Criteria";
        FiscalYearStartDate := 0D;
        FiscalYearEndDate := 0D;
        if "Fiscal Year" <> '' then begin
            FiscalYearEndDate := HRMgt.ReturnEndDateFY("Fiscal Year");//Appraisal Changes
            EngNepDate.Reset();
            EngNepDate.SetRange("Fiscal Year", "Fiscal Year");
            EngNepDate.SetCurrentKey("English Date");
            if EngNepDate.FindFirst() then
                FiscalYearStartDate := EngNepDate."English Date";
        end;
        EmployeeTransfer.Reset();
        EmployeeTransfer.SetRange("Employee No.", "Employee Code");
        EmployeeTransfer.SetRange("Approval Status", EmployeeTransfer."Approval Status"::Acknowledged);
        if (FiscalYearStartDate <> 0D) and (FiscalYearEndDate <> 0D) then
            EmployeeTransfer.SetRange("Transfer Effective Date", FiscalYearStartDate, FiscalYearEndDate);
        TransferFound := false;
        LatestTransferDate := 0D;
        if EmployeeTransfer.FindSet() then begin
            repeat
                if (not TransferFound) or
                   (EmployeeTransfer."Transfer Effective Date" > LatestTransferDate) then begin
                    LatestEmployeeTransfer := EmployeeTransfer;
                    LatestTransferDate := EmployeeTransfer."Transfer Effective Date";
                    TransferFound := true;
                end;
            until EmployeeTransfer.Next() = 0;
        end;
        if not TransferFound then begin

            Validate("Functional Title", EmployeeVar."Functional Title");
            Validate("Functional Title Desc", EmployeeVar."Functional Title Desc");

            Validate(Department, EmployeeVar."Department Code");
            Validate("Department Name", EmployeeVar."Department Name");

            Validate(Branch, EmployeeVar."Global Dimension 1 Code");
            Validate("Branch Name", EmployeeVar."Branch Name");

            Validate(Province, EmployeeVar."Province Code");
            Validate("Province Name", EmployeeVar."Province Name");

            Validate("Extension Counter", EmployeeVar."Extension Counter Code");
            Validate("Extension Counter Name", EmployeeVar."Extension Counter Name");

            Validate(Unit, EmployeeVar."Unit Code");
            Validate("Unit Name", EmployeeVar."Unit Name");

            Validate("Sub-unit", EmployeeVar."Sub Unit Code");
            Validate("Sub-Unit Name", EmployeeVar."Sub Unit Name");

            exit;
        end;

        UseToValues := CalcDate(BranchAppraisalCriteria, LatestEmployeeTransfer."Date of Joining Of Transfer") <= FiscalYearEndDate;
        if UseToValues then begin
            Validate("Functional Title", LatestEmployeeTransfer."Functional Title (To)");
            Validate("Functional Title Desc", LatestEmployeeTransfer."Functional Desc To");

            Validate(Department, LatestEmployeeTransfer."Department Code (To)");
            Validate("Department Name", LatestEmployeeTransfer."Department Name To");

            Validate(Branch, LatestEmployeeTransfer."To Branch");
            Validate("Branch Name", LatestEmployeeTransfer."Branch Name To");

            Validate(Province, LatestEmployeeTransfer."Province Code (To)");
            Validate("Province Name", LatestEmployeeTransfer."Province Name To");

            Validate("Extension Counter", LatestEmployeeTransfer."Extension Counter (To)");
            Validate("Extension Counter Name", LatestEmployeeTransfer."Extension Name To");

            Validate(Unit, LatestEmployeeTransfer."Unit (To)");
            Validate("Unit Name", LatestEmployeeTransfer."Unit Name To");

            Validate("Sub-unit", '');
            Validate("Sub-Unit Name", '');

        end
        else begin
            Validate("Functional Title", LatestEmployeeTransfer."Functional Title");
            Validate("Functional Title Desc", LatestEmployeeTransfer."Functional Title Desc");

            Validate(Department, LatestEmployeeTransfer.Department);
            Validate("Department Name", LatestEmployeeTransfer."Department Name");

            Validate(Branch, LatestEmployeeTransfer."From Branch");
            Validate("Branch Name", LatestEmployeeTransfer."Branch Name");

            Validate(Province, LatestEmployeeTransfer."Province Code");
            Validate("Province Name", LatestEmployeeTransfer."Province Name");

            Validate("Extension Counter", LatestEmployeeTransfer."Extension Counter Code");
            Validate("Extension Counter Name", LatestEmployeeTransfer."Extension Counter Name");

            Validate(Unit, LatestEmployeeTransfer."Unit Code");
            Validate("Unit Name", LatestEmployeeTransfer."Unit Name");

            Validate("Sub-unit", '');
            Validate("Sub-Unit Name", '');

        end;
    end;

    local procedure CheckForDuplicateEmployeeAppraisal()
    begin
        Appraisal.Reset;
        Appraisal.SetRange("Employee Code", "Employee Code");
        Appraisal.SetFilter("Appraisal Code", '<>%1', "Appraisal Code");
        case "Appraisal Type" of

            "Appraisal Type"::Quarterly:
                begin
                    Appraisal.SetRange("Appraisal Type", Appraisal."Appraisal Type"::Quarterly);
                    Appraisal.SetRange("Appraisal Subtype Quarterly", "Appraisal Subtype Quarterly");
                    Appraisal.SetRange("Fiscal Year", "Fiscal Year");
                end;

            "Appraisal Type"::Monthly:
                begin
                    Appraisal.SetRange("Appraisal Type", Appraisal."Appraisal Type"::Monthly);
                    Appraisal.SetRange("Fiscal Year", "Fiscal Year");
                end;

            "Appraisal Type"::Annually:
                begin
                    Appraisal.SetRange("Appraisal Type", Appraisal."Appraisal Type"::Annually);
                    Appraisal.SetRange("Fiscal Year", "Fiscal Year");
                end;

            "Appraisal Type"::Confirmation:
                Appraisal.SetRange("Appraisal Type", Appraisal."Appraisal Type"::Confirmation);
        end;
        if Appraisal.FindFirst then
            Error('Appraisal of type %3 for employee %1 (%2) already exist', "Employee Name", "Employee Name", "Appraisal Type");
    end;

    procedure DownloadAttachment(AttachName: Text)
    instream: InStream;
    begin
        instream.Read(AttachName);
        if AttachName <> '' then
            // Download(AttachName, 'Save To', '', '', AttachName);
            DownloadFromStream(instream, 'Save To', '', '', AttachName)
        else
            Error('No attachment found.');
    end;

    local procedure InsertAttachmentAppraisal()
    var
        AttachmentMandatory: Record "Attachment Setup";
        IncomingDocument: Record "Incoming Document";
    begin
        AttachmentMandatory.Reset;
        AttachmentMandatory.SetRange(Type, AttachmentMandatory.Type::Appraisal);
        if AttachmentMandatory.FindFirst then
            repeat
                Clear(IncomingDocument);
                IncomingDocument.Reset;
                IncomingDocument.SetRange("Table ID", DATABASE::Appraisal);
                IncomingDocument.SetRange("No.", "Appraisal Code");
                IncomingDocument.SetRange("Attachment Code", AttachmentMandatory."Attachment Code");
                if not IncomingDocument.FindFirst then begin
                    IncomingDocument.Reset;
                    IncomingDocument.Init;
                    IncomingDocument."Entry No." := IncomingDocument.GetEntryNo();
                    IncomingDocument.Description := Rec.TableName;
                    IncomingDocument."Attachment Code" := AttachmentMandatory."Attachment Code";
                    IncomingDocument."No." := "Appraisal Code";
                    IncomingDocument."Employee Code" := Rec."Employee Code";
                    IncomingDocument."Table ID" := DATABASE::Appraisal;
                    IncomingDocument.Insert(true);
                end;
            until AttachmentMandatory.Next = 0;
    end;

    local procedure SetFinalGrading()
    var
        RatingSetup: Record "Rating Setup";
    begin
        Clear("Final Grading");

        RatingSetup.Reset();
        RatingSetup.SetRange(Type, RatingSetup.Type::Appraisal);
        RatingSetup.SetFilter(From, '<=%1', "Total Final Score");
        RatingSetup.SetFilter("To", '>=%1', "Total Final Score");
        if RatingSetup.FindFirst() then
            "Final Grading" := RatingSetup.Rating;
    end;
}

