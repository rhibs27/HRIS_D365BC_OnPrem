table 50061 Appraisal
{
    DataClassification = CustomerContent;
    // version Remit1.00

    fields
    {
        field(1; "Appraisal Code"; Code[20])
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
        field(2; "Employee Code"; Code[20])
        {
            TableRelation = Employee."No.";

            trigger OnValidate()
            begin
                OnValidateEmployeeNo;
            end;
        }
        field(3; "Employee Name"; Text[100])
        {
        }
        field(4; "Date of Employement"; Date)
        {
        }
        field(5; "Appraisal Type"; Enum "Appraisal Type")
        {

            trigger OnValidate()
            begin
                if "Appraisal Type" <> xRec."Appraisal Type" then begin
                    Clear("Appraisal Subtype Monthly");
                    Clear("Appraisal Subtype Quarterly");
                end;
                // if "Appraisal Type" = "Appraisal Type"::Quarterly then
                //      Error('Quarterly Appraisal has been disabled.');
            end;
        }
        field(6; "Final Score"; Decimal)
        {
            Editable = false;

            trigger OnValidate()
            begin
                RatingSetup.Reset;
                RatingSetup.SetRange(Type, RatingSetup.Type::Appraisal);
                RatingSetup.SetFilter(From, '<=%1', "Final Score");
                RatingSetup.SetFilter("To", '>=%1', "Final Score");
                if RatingSetup.FindFirst then
                    Validate(Rating, RatingSetup.Remarks);
            end;
        }
        field(7; "Final Grade"; Code[20]) { }
        field(8; Reviewer; Code[20])
        {
            TableRelation = Employee;
        }
        field(9; "Check Reviewer"; Code[20])
        {
            TableRelation = Employee;
        }
        field(10; "Reviewer III"; Code[20])
        {
            TableRelation = Employee;
        }
        field(11; "Posting Date"; Date) { }
        field(12; "Reviewed Score I"; Decimal) { }
        field(13; "Reviewed Score II"; Decimal) { }
        field(14; "Reviewed Score III"; Decimal) { }
        field(15; Department; Code[20])
        {
            Editable = false;
            TableRelation = "Organization Structure List".Code where(Type = filter("Deputation Type"::Department));
        }
        field(16; "Functional Title"; Code[20])
        {
            Editable = false;
            TableRelation = "Functional Title";
        }
        field(17; "Code"; Code[20])
        {
            Editable = true;
            Enabled = true;
        }
        field(18; "Job Grade"; Code[20]) { }
        field(19; "Total Tenure in Bank"; Integer) { }
        field(20; "Submission Date"; Date) { }
        field(21; "Reviewed Date I"; Date) { }
        field(22; "Reviewed Date II"; Date) { }
        field(23; "Reviewed Date III"; Date) { }
        field(24; "Total Tenure in Crc Position"; Date) { }
        field(25; Branch; Code[20])
        {
            Editable = false;
        }
        field(26; "Branch Name"; Text[50])
        {
            Editable = false;
        }
        field(27; Posted; Boolean) { }
        field(28; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(29; "KRA Category"; Code[50])
        {
            TableRelation = "Key Value Master".Code where(Type = filter("KRA Category"));

            trigger OnValidate()
            begin
                if GuiAllowed then
                    AppraisalMgt.OnValidateKRACategory(Rec);
            end;
        }
        field(37; "Approved Date"; Date)
        {
        }
        field(31; Rating; Enum "Appraisal Rating")
        {

        }
        field(32; Status; Enum "Appraisal Status")
        {
            trigger OnValidate()
            var
            begin
                If Rec.Status = Rec.Status::Submitted then
                    AppraisalMgt.CheckAppraisalAttachmentMandatory(Rec);
            end;
        }
        field(33; "Academic Degree"; Text[250]) { }
        field(34; "Written Verbal Warning Issued"; Text[150]) { }
        field(35; "Completion of Training"; Text[250]) { }
        field(36; "Disciplinary Actions Taken"; Text[200]) { }
        field(30; "Commendations on File"; Text[250]) { }
        field(38; "Frequent Untidy Uniform"; Text[150]) { }
        field(39; "Uninformed Absence"; Text[200]) { }
        field(40; "No of Sick Leaves Taken"; Decimal) { }
        field(41; "Development Plan Remarks"; Text[250]) { }
        field(42; "Improvement Time"; Decimal) { }
        field(43; "Reportees Comments"; Text[250]) { }
        field(44; "Sales and Marketing Corporate"; Boolean) { }
        field(45; "Sales and Marketing Retail"; Boolean) { }
        field(46; Operations; Boolean) { }
        field(47; "Finance or Accounts"; Boolean) { }
        field(48; Administration; Boolean) { }
        field(49; "Back Office"; Boolean) { }
        field(50; "Human Resource"; Boolean) { }
        field(51; "Reviewer Comments"; Text[250]) { }
        field(52; "Check Reviewers Comments"; Text[250]) { }
        field(53; "User ID"; Text[50])
        {
            Editable = false;
            TableRelation = "User Setup"."User ID";
        }
        field(54; "Recommender Code"; Code[50])
        {
            Description = 'Not Used';
            TableRelation = Employee;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin

                HRMgt.GetEmployeeName("Recommender Code", "Recommender Name");
            end;
        }
        field(55; "Approver Code"; Code[20])
        {
            TableRelation = Employee;

            trigger OnValidate()
            begin
                HRMgt.GetEmployeeName("Approver Code", "Approver Name");
            end;
        }
        field(56; "Recommender Name"; Text[50])
        {
            Description = 'Not Used';
            Editable = false;
        }
        field(57; "Approver Name"; Text[50])
        {
            Editable = false;
        }
        field(58; "Requested Date"; Date)
        {
            trigger OnValidate()
            begin
                EngNepDate.Reset;
                EngNepDate.SetRange("English Date", "Requested Date");
                if EngNepDate.FindFirst then
                    Validate("Fiscal Year", EngNepDate."Fiscal Year");
            end;
        }
        field(59; "Appraisal Subtype Monthly"; Enum "Nepali Month")
        {
            Caption = 'Appraisal Subtype Monthly';
        }
        field(60; "Appraisal Subtype Quarterly"; Enum Quater)
        {
            Caption = 'Appraisal Subtype Quarterly';
        }
        field(61; "Deputation on"; Enum "Deputation Type")
        {

        }
        field(62; Province; Code[20])
        {
            Editable = false;
        }
        field(63; "Sub-Province"; Code[20])
        {
            Editable = false;
        }
        field(64; "Extension Counter"; Code[20])
        {
            Editable = false;
        }
        field(65; Unit; Code[20])
        {
            Editable = false;
        }
        field(66; "Department Name"; Text[50])
        {
            Editable = false;
        }
        field(67; "Province Name"; Text[50])
        {
            Editable = false;
        }
        field(68; "Sub-Province Name"; Text[50])
        {
            Editable = false;
        }
        field(69; "Extension Counter Name"; Text[100])
        {
            Editable = false;
        }
        field(70; "Unit Name"; Text[50])
        {
            Editable = false;
        }
        field(71; "Fiscal Year"; Code[20])
        {
            Editable = true;
        }
        field(72; "Total Reviewers Score"; Decimal)
        {
            CalcFormula = sum("KRA Subform List"."Reviewers Final Score" where("Appraisal Code" = field("Appraisal Code")));
            FieldClass = FlowField;
        }
        field(73; "Total Check Reviewers Score"; Decimal)
        {
            CalcFormula = sum("KRA Subform List"."Check Reviewers Final Score" where("Appraisal Code" = field("Appraisal Code")));
            FieldClass = FlowField;
        }
        field(74; "Confirmation Eligible"; Boolean) { }
        field(75; "Appraisal Attachment"; Text[145]) { }
        field(76; "Functional Title Desc"; Text[100]) { }
        field(77; "Sol Id"; Code[20])
        {
            Caption = 'Sol Id';
        }
        field(78; Hide; Boolean) { }
        field(79; "Total Final Score"; Decimal)
        {
            CalcFormula = sum("KRA Subform List"."Final Score" where("Appraisal Code" = field("Appraisal Code")));
            FieldClass = FlowField;
        }
        field(80; "Final Grading"; Enum "Appraisal Final Grading")
        {

        }
    }

    keys
    {
        key(Key1; "Appraisal Code") { }
    }

    fieldgroups { }

    trigger OnDelete()
    begin
        //IF Posted THEN
        //ERROR(ErrorText)
        //ELSE
        //HRMgt.DeleteApprisalFormLine(Rec);
    end;

    trigger OnInsert()
    begin
        HumanResSetup.Get;
        Validate("Requested Date", Today);
        if "Appraisal Code" = '' then begin
            HumanResSetup.TestField("Appraisal No.");
            NoSeriesMgt.InitSeries(HumanResSetup."Appraisal No.", xRec."No. Series", 0D, "Appraisal Code", "No. Series");
        end;
        HumanResSetup.TestField("HR Head Functional Title");
        EmployeeVar.Reset;
        EmployeeVar.SetRange("Functional Title", HumanResSetup."HR Head Functional Title");
        EmployeeVar.SetRange(Status, EmployeeVar.Status::Active); //Min
        if EmployeeVar.FindFirst then
            Validate("Approver Code", EmployeeVar."No.");

        if not GuiAllowed then begin
            if "Employee Code" = '' then
                Validate("Employee Code", "Employee Code");
            AppraisalMgt.OnValidateKRACategory(Rec);
            CheckForDuplicateEmployeeAppraisal;
        end;
        InsertAttachmentAppraisal;
    end;

    trigger OnModify()
    begin
        //IF Posted THEN
        //ERROR(ErrorModify);
        CheckForDuplicateEmployeeAppraisal;
    end;

    var
        EmployeeVar: Record Employee;
        HRMgt: Codeunit "HR Mgt.";
        Appraisal: Record Appraisal;
        KRASubform: Record "KRA Subform List";
        HumanResSetup: Record "Human Resources Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        EngNepDate: Record "English-Nepali Date";
        RatingSetup: Record "Rating Setup";
        KRAMasterSetupRec: Record "KRA Master Setup";
        AppraisalMgt: Codeunit "AppraisalMgt.";

    local procedure ClearDetails()
    begin
    end;

    local procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        /*OldDimSetID := "Dimension Set ID";
        DimMgt.ValidateShortcutDimValues(FieldNumber,ShortcutDimCode,"Dimension Set ID");

        IF OldDimSetID <> "Dimension Set ID" THEN
         MODIFY;
         */
    end;

    procedure ShowDocDim()
    begin
        /*OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet2(
            "Dimension Set ID",STRSUBSTNO('%1',"Fiscal Year"),
            "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");

        IF OldDimSetID <> "Dimension Set ID" THEN
          MODIFY;

          */
    end;

    procedure DeleteAllSubFormKRA("code": Code[20])
    begin
        KRASubform.Reset;
        KRASubform.SetRange("Key Result Area", code);
        if KRASubform.FindFirst then
            repeat
                KRASubform.Delete;
            until KRASubform.Next = 0;
    end;

    procedure AssistEdit(OldAppraisal: Record Appraisal): Boolean
    begin
        Appraisal := Rec;
        HumanResSetup.Get;
        HumanResSetup.TestField("Appraisal No."); /* candidate nos not present in HRsetup table*/
        if NoSeriesMgt.SelectSeries(HumanResSetup."Appraisal No.", OldAppraisal."No. Series", Appraisal."No. Series") then begin
            HumanResSetup.Get;
            HumanResSetup.TestField("Appraisal No.");
            NoSeriesMgt.SetSeries(Appraisal."Appraisal Code");
            Rec := Appraisal;
            exit(true);
        end;
    end;

    local procedure OnValidateEmployeeNo()
    begin
        Clear(Branch);
        Clear("Branch Name");
        Clear(Department);
        Clear("Department Name");
        Clear("Extension Counter");
        Clear("Extension Counter Name");
        Clear(Province);
        Clear("Province Name");
        Clear("Sub-Province");
        Clear("Deputation on");
        Clear(Unit);
        Clear("Unit Name");
        Clear("Functional Title Desc");//Min
        Clear("Sol Id"); //Min

        if EmployeeVar.Get("Employee Code") then begin
            "Functional Title" := EmployeeVar."Functional Title";
            Department := EmployeeVar."Department Code";
            "Employee Name" := EmployeeVar."Full Name";
            "Branch Name" := EmployeeVar."Branch Name";
            "Job Grade" := EmployeeVar."Salary Grade";
            KRAMasterSetupRec.Reset; //Min 8.9.2022 -- for Transfer employee data manage
            KRAMasterSetupRec.SetRange("Employee Code", "Employee Code");
            KRAMasterSetupRec.SetRange("Key Result Area", '');
            if KRAMasterSetupRec.FindFirst then begin
                "Deputation on" := KRAMasterSetupRec."Transfer Deputation on";
                Province := KRAMasterSetupRec."Transfer Province Code";
                // "Sub-Province" := KRAMasterSetupRec."Transfer Sub Province Code";
                "Sol Id" := KRAMasterSetupRec."Transfer Sol Id"
            end else begin
                Validate("Deputation on", EmployeeVar."Deputation on");
                Validate(Province, EmployeeVar."Province Code");
                // Validate("Sub-Province", EmployeeVar."Sub Province Code");
                Validate("Sol Id", EmployeeVar."Sol Id"); //Min
            end;
            "Date of Employement" := EmployeeVar."Employment Date";
            Validate(Branch, EmployeeVar."Global Dimension 1 Code");
            Validate("Extension Counter", EmployeeVar."Extension Counter Code");
            Validate("Extension Counter Name", EmployeeVar."Extension Counter Name");
            Validate(Unit, EmployeeVar."Unit Code");
            Validate("Department Name", EmployeeVar."Department Name");
            Validate("Province Name", EmployeeVar."Province Name");
            Validate("Unit Name", EmployeeVar."Unit Name");
            Validate("Functional Title Desc", EmployeeVar."Functional Title Desc");//Min
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
                    // Appraisal.SetRange("Appraisal Subtype Monthly", "Appraisal Subtype Quarterly");
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

    procedure ChangeReviewerCheckReviewerAppraisal()
    var
        EmpActFilterPageBuilder: FilterPageBuilder;
        ReviewerCode: Code[20];
        CheckReviewerCode: Code[20];
        Text001: Label 'You cannot change, Status = %1, Appraisal Document.';
        Text002: Label 'The Reviewer has been updated Successfully.';
        Text003: Label 'The Check Reviewer has been updated Successfully.';
        Text004: Label 'Do you want to update Reviewer of this request ?';
    begin
        if Status in [Status::Reviewed, Status::"Check Reviewed"] then
            Error(Text001, Status);
        if not Confirm(Text004, false) then
            exit;

        EmpActFilterPageBuilder.AddRecord('Appraisal', Rec);
        EmpActFilterPageBuilder.AddField('Appraisal', Reviewer);
        EmpActFilterPageBuilder.AddField('Appraisal', "Check Reviewer");
        EmpActFilterPageBuilder.RunModal;
        Appraisal.SetView(EmpActFilterPageBuilder.GetView('Appraisal'));
        ReviewerCode := Appraisal.GetFilter(Reviewer);
        CheckReviewerCode := Appraisal.GetFilter("Check Reviewer");

        if (ReviewerCode <> '') then begin
            Validate(Reviewer, ReviewerCode);
            Modify;
            Message(Text002);
        end;
        if (CheckReviewerCode <> '') then begin
            Validate("Check Reviewer", CheckReviewerCode);
            Modify;
            Message(Text003);
        end;
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
}
