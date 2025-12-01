table 50142 Resignation
{
    Caption = 'Resignation';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20])
        {

            trigger OnValidate()
            begin
                HRSetup.Get;
                if "No." <> xRec."No." then
                    if Cancelled then begin
                        NoSeriesMgt.TestManual(HRSetup."Cancel Document No. Series");
                        "No. Series" := '';
                    end else begin
                        case Type of
                            Type::Resignation:
                                begin
                                    NoSeriesMgt.TestManual(HRSetup."Resignation No.");
                                    "No. Series" := '';
                                end;
                        end;
                    end;
            end;
        }
        field(2; Type; Enum "Employee Activity Type")
        {
        }
        field(3; "Employee No."; Code[20])
        {
            TableRelation = Employee;

            trigger OnValidate()
            begin
                if EmpVar.Get("Employee No.") then begin
                    Validate("Employee Name", EmpVar."Full Name");
                    Validate("Shortcut Dimension 1 Code", EmpVar."Global Dimension 1 Code");
                    Validate(Department, EmpVar."Department Code");
                    Validate("Deputation On", EmpVar."Deputation on");
                    Validate("Salary Level Code", EmpVar."Salary Level");
                    Validate("Functional Title", EmpVar."Functional Title");
                    Validate("Province Code", EmpVar."Province Code");
                    Validate("Unit Code", EmpVar."Unit Code");
                    Validate("Extension Counter Code", EmpVar."Extension Counter Code");
                    Validate("Branch Name", EmpVar."Branch Name");
                    Validate("Department Name", EmpVar."Department Name");
                    Validate("Province Name", EmpVar."Province Name");
                end;
            end;
        }
        field(4; "Employee Name"; Text[50])
        {
            Editable = false;
        }
        field(5; Posted; Boolean)
        {
        }
        field(6; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }

        field(10; "Requested Date"; Date)
        {
            trigger OnValidate()
            begin
                Validate("Fiscal Year", HRMgt.ReturnFiscalYear("Requested Date"));
            end;
        }
        field(11; "Fiscal Year"; Text[10])
        {
            Editable = false;
        }
        field(14; Remarks; Text[100])
        {
        }
        field(15; "User ID"; Text[50])
        {
            Editable = false;
            TableRelation = "User Setup"."User ID";
        }
        field(16; "Approval Status"; Enum "Approval Status")
        {
        }
        field(17; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(18; Department; Code[20])
        {
            Editable = false;
        }
        field(19; "Branch Name"; Text[50])
        {
            Editable = false;
        }
        field(20; "Department Name"; Text[50])
        {
            Editable = false;
        }
        field(21; "Functional Title"; Code[20])
        {
            Editable = false;
            TableRelation = "Functional Title";
        }
        field(25; "Salary Level Code"; Code[20])
        {
            Editable = false;
            TableRelation = "Salary Level";
        }
        field(28; "Extension Counter Code"; Code[20])
        {
        }
        field(29; "Province Name"; Code[50])
        {
            Editable = false;
        }
        field(30; "Province Code"; Code[20])
        {
            TableRelation = Province;
        }
        field(31; "Unit Code"; Code[20])
        {
        }
        field(33; "Payroll No."; Code[20])
        {
        }
        field(36; "Rejection Remarks"; Text[100])
        {
        }
        field(37; "Approved Date"; Date)
        {
        }
        field(39; Cancelled; Boolean)
        {
        }
        field(40; "Cancelled No."; Code[20])
        {
        }
        field(41; "Cancelled Document No."; Code[20])
        {
            Editable = false;
        }
        field(48; "Reason Code"; Code[20])
        {
            TableRelation = "Standard Text" WHERE("Employee Activity Type" = FIELD(Type));

            trigger OnValidate()
            begin
                if Standardtext.Get("Reason Code") then
                    Validate("Reason Description", Standardtext.Description)
                else
                    Clear("Reason Description");
            end;
        }
        field(49; "Reason Description"; Text[50])
        { }
        field(51; "Deputation On"; Enum "Deputation Type")
        {
        }
        field(52; "Proposed Date of Resignation"; Date)
        {
            Description = 'Resignation';

            trigger OnValidate()
            begin
                if not GuiAllowed then
                    if "Proposed Date of Resignation" < Today then
                        Error(INVALID, FieldCaption("Proposed Date of Resignation"));
                ResignationMgt.UpdateResignationWaiver(Rec);
            end;
        }
        field(53; "Reason for Resignation"; Text[100])
        {
            Description = 'Resignation';
        }
        field(54; "Waiver Case"; Enum "Waiver Case")
        {
            Description = 'Resignation';
            trigger OnValidate()
            begin
                if "Waiver Case" <> xRec."Waiver Case" then begin
                    Clear("Apply for Waiver");
                    Clear("Reason for Waiver");
                end;
            end;
        }
        field(55; "Supervisor Proposed Date"; Date)
        {
            Description = 'Resignation';

            trigger OnValidate()
            begin
                if "Supervisor Proposed Date" < "Requested Date" then
                    Error('Supervisor proposed date(%1) must be greater than requested date(%2)', "Supervisor Proposed Date", "Requested Date");
            end;
        }
        field(56; "HR Proposed Date"; Date)
        {
            Description = 'Resignation';
        }
        field(57; "Insurance Claim"; Enum "Insurance Claim")
        {
            trigger OnValidate()
            begin
                Clear("Father Name");
                Clear("Mother Name");
                Clear("Spouse Name");
                Clear("Child Name");
                EmpRelative.Reset;
                EmpRelative.SetRange("Employee No.", "Employee No.");
                EmpRelative.SetRange("Relative Code", Format("Insurance Claim"));
                if EmpRelative.FindFirst then begin
                    case "Insurance Claim" of
                        "Insurance Claim"::Father:
                            Validate("Father Name", EmpRelative."First Name" + ' ' + EmpRelative."Middle Name" + ' ' + EmpRelative."Last Name");
                        "Insurance Claim"::Mother:
                            Validate("Mother Name", EmpRelative."First Name" + ' ' + EmpRelative."Middle Name" + ' ' + EmpRelative."Last Name");
                        "Insurance Claim"::Spouse:
                            Validate("Spouse Name", EmpRelative."First Name" + ' ' + EmpRelative."Middle Name" + ' ' + EmpRelative."Last Name");
                        "Insurance Claim"::Child:
                            Validate("Child Name", EmpRelative."First Name" + ' ' + EmpRelative."Middle Name" + ' ' + EmpRelative."Last Name");
                        else
                            Error('Please enter the family details in "Employee Relative" table.');
                    end;
                end;
            end;
        }
        field(58; "Father Name"; Text[50])
        {
            FieldClass = Normal;
        }
        field(59; "Mother Name"; Text[50])
        {
        }
        field(60; "Spouse Name"; Text[50])
        {
        }
        field(61; "Child Name"; Text[50])
        {
        }
        field(62; "Apply for Waiver"; Boolean)
        {
            Description = 'Resignation';
        }
        field(63; "Reason for Waiver"; Text[50])
        {
            Description = 'Resignation';
        }
        field(100; Status; text[50])
        {
        }

    }
    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }
    var
        EmpVar: Record Employee;
        EngNepDate: Record "English-Nepali Date";
        NoSeriesMgt: Codeunit "No. Series";
        HRSetup: Record "Human Resources Setup";
        HRMgt: Codeunit "HR Mgt.";
        INVALID: Label 'Invalid %1';
        ResignationMgt: Codeunit "Resignation Mgt";
        EmpRelative: Record "Employee Relative";
        Standardtext: Record "Standard Text";
        ApproverMgt: Codeunit "Approver Mgt";
        ResignationRec: Record Resignation;

    trigger OnInsert()
    begin
        if "Requested Date" = 0D then
            "Requested Date" := Today;
        HRSetup.Get;
        if "No." = '' then
            if Cancelled then begin
                HRSetup.TestField("Cancel Document No. Series");
                HRMgt.InitNoSeriesNew(HRSetup."Cancel Document No. Series", xRec."No. Series", "Requested Date", "No.", "No. Series");
            end else begin
                case Type of

                    //for resignation
                    Type::Resignation:
                        begin
                            HRSetup.TestField("Resignation No.");
                            HRMgt.InitNoSeriesNew(HRSetup."Resignation No.", xRec."No. Series", "Requested Date", "No.", "No. Series");
                            ResignationRec.ReadIsolation(IsolationLevel::ReadCommitted);
                            ResignationRec.SetLoadFields("No.");
                            while ResignationRec.Get("No.") do
                                "No." := NoSeriesMgt.GetNextNo("No. Series");
                            ApproverMgt.InsertApproval("Employee No.", "No.", Type, "Approval Status");//Create Approval line from Setup Santosh 
                        end;
                end;
            end;

        // InsertAttachmentLines;
    end;

    trigger OnDelete()
    var
        ApprovalEntry: Record "Approval HRMS";
        CannotDelete: Label 'Cannot delete document.';
    begin
        if not ("Approval Status" in ["Approval Status"::" ", "Approval Status"::Open]) then
            Error(CannotDelete)
        else begin
            ApprovalEntry.Reset();
            ApprovalEntry.SetRange("Document No.", "No.");
            ApprovalEntry.SetRange("Employee No", "Employee No.");
            ApprovalEntry.DeleteAll();
        end;
    end;

    // local procedure InsertAttendanceMissedAttachment()
    // var
    //     AttachmentMandatory: Record "Attachment Setup";
    //     IncomingDocument: Record "Incoming Document";
    // begin
    //     AttachmentMandatory.Reset;
    //     AttachmentMandatory.SetRange(Type, AttachmentMandatory.Type::"Attendance Missed");
    //     if AttachmentMandatory.FindFirst then
    //         repeat
    //             Clear(IncomingDocument);
    //             IncomingDocument.Reset;
    //             IncomingDocument.SetRange("Table ID", DATABASE::"Employee Activity");
    //             IncomingDocument.SetRange("No.", "No.");
    //             IncomingDocument.SetRange("Attachment Code", AttachmentMandatory."Attachment Code");
    //             if not IncomingDocument.FindFirst then begin
    //                 IncomingDocument.Reset;
    //                 IncomingDocument.Init;
    //                 IncomingDocument."Entry No." := IncomingDocument.GetEntryNo();
    //                 IncomingDocument.Description := Rec.TableName;
    //                 IncomingDocument."Attachment Code" := AttachmentMandatory."Attachment Code";
    //                 IncomingDocument."No." := "No.";
    //                 IncomingDocument."Employee Code" := "Employee No.";
    //                 IncomingDocument."Table ID" := DATABASE::"Employee Activity";
    //                 IncomingDocument.Insert(true);
    //             end;
    //         until AttachmentMandatory.Next = 0;
    // end;
}
