table 33019860 "Employee Activity Second"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20])
        {
            trigger OnValidate()
            begin
                HRSetup.Get;
                if "No." <> xRec."No." then begin
                    NoSeriesMgt.TestManual(HRSetup."Residential No.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "Employee No."; Code[20])
        {
            TableRelation = Employee;

            trigger OnValidate()
            begin
                OnValidateEmployeeNo;
            end;
        }
        field(3; "Employee Name"; Text[50]) { }
        field(4; "Salary Level"; Code[20])
        {
            TableRelation = "Salary Level";

            trigger OnValidate()
            begin
            end;
        }
        field(5; "Salary Level Description"; Text[50]) { }
        field(6; "Functional Title"; Code[20])
        {
            TableRelation = "Functional Title";
        }
        field(7; "Functional Title Desc"; Text[100])
        {
        }
        field(8; "Deputation on"; Enum "Deputation Type")
        {

        }
        field(9; Province; Text[30])
        {
            Description = 'Provience address';

            trigger OnLookup()
            begin
                Validate(Province, HRMgt.LookupProvience(Province));
            end;
        }
        field(10; District; Text[30])
        {
            trigger OnLookup()
            begin
                Validate(District, HRMgt.LookupDistrict(Province, District));
            end;
        }
        field(11; Municipality; Text[30])
        {
            trigger OnLookup()
            begin
                //VALIDATE(Municipality,HRMgt.LookupMunicipality(District,"Local Levels",Municipality));
            end;
        }
        field(12; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(13; "Created Date"; Date)
        {
            Editable = false;
        }
        field(14; "Local Levels"; Enum "Local Levels")
        {
        }
        field(15; "Ward No."; Code[5]) { }
        field(16; "Street Name"; Text[30]) { }
        field(17; "House No."; Text[10]) { }
        field(18; Latitude; Text[30]) { }
        field(19; Longititude; Text[30]) { }
        field(20; "Approver Code"; Code[50])
        {
            TableRelation = Employee;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                if EmployeeVar.Get("Approver Code") then
                    "Approver Name" := EmployeeVar."Full Name";
            end;
        }
        field(21; "Approver Name"; Text[50])
        {
            Editable = false;
        }
        field(22; Remarks; Text[100])
        {
        }
        field(23; Status; Enum "Employee Activity Second Status")
        {

        }
        field(24; "Screened By"; Code[50])
        {
        }
        field(25; Type; Enum "Employee Activity Second Type")
        {

        }
        field(26; "Screened Date"; Date) { }
        field(27; "Rejected By"; Code[50]) { }
        field(28; "Rejected Date"; Date) { }
        field(29; "Rejection Remarks"; Text[100]) { }
    }

    keys
    {
        key(Key1; "No.") { }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        HRSetup.Get;
        if "No." = '' then begin
            HRSetup.TestField("Residential No.");
            NoSeriesMgt.InitSeries(HRSetup."Residential No.", xRec."No. Series", Today, "No.", "No. Series");
        end;
        Validate("Created Date", Today);
        InsertResidentialAttachmentLines; //Min 10.20.2022
    end;

    var
        ResAddress: Record "Employee Activity Second";
        HRSetup: Record "Human Resources Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        EmployeeVar: Record Employee;
        HRMgt: Codeunit "HR Mgt.";

    procedure AssistEdit(OldResAddress: Record "Employee Activity Second"): Boolean
    begin
        ResAddress := Rec;
        HRSetup.Get;
        HRSetup.TestField("Residential No.");
        if NoSeriesMgt.SelectSeries(HRSetup."Residential No.", OldResAddress."No. Series", ResAddress."No. Series") then begin
            NoSeriesMgt.SetSeries(ResAddress."No.");
            Rec := ResAddress;
            exit(true);
        end;
    end;

    local procedure OnValidateEmployeeNo()
    begin
        Clear("Employee Name");
        Clear("Salary Level");
        Clear("Salary Level Description");
        Clear("Functional Title");
        Clear("Functional Title Desc");
        Clear("Deputation on");

        if EmployeeVar.Get("Employee No.") then begin
            "Employee Name" := EmployeeVar."Full Name";
            "Salary Level" := EmployeeVar."Salary Level";
            "Salary Level Description" := EmployeeVar."Salary Level Description";
            "Functional Title" := EmployeeVar."Functional Title";
            "Functional Title Desc" := EmployeeVar."Functional Title Desc";
            "Deputation on" := EmployeeVar."Deputation on";
        end;
    end;

    local procedure InsertResidentialAttachmentLines()
    var
        IncomingDocument: Record "Incoming Document";
        AttachmentMandatory: Record "Attachment Setup";
    begin
        IncomingDocument.Reset;
        IncomingDocument.SetRange("Table ID", Database::"Employee Activity Second");
        IncomingDocument.SetRange("No.", "No.");
        IncomingDocument.DeleteAll(true);
        AttachmentMandatory.Reset;
        AttachmentMandatory.SetRange(Type, AttachmentMandatory.Type::Passport);
        if AttachmentMandatory.FindFirst then
            repeat
                Clear(IncomingDocument);
                IncomingDocument.Reset;
                IncomingDocument.SetRange("Table ID", Database::"Employee Activity Second");
                IncomingDocument.SetRange("No.", "No.");
                IncomingDocument.SetRange("Attachment Code", AttachmentMandatory."Attachment Code");
                if not IncomingDocument.FindFirst then begin
                    IncomingDocument.Reset;
                    IncomingDocument.Init;
                    IncomingDocument."Entry No." := IncomingDocument.GetEntryNo();
                    IncomingDocument.Description := Rec.TableName;
                    IncomingDocument."Attachment Code" := AttachmentMandatory."Attachment Code";
                    IncomingDocument."No." := "No.";
                    IncomingDocument."Employee Code" := "Employee No.";
                    IncomingDocument."Table ID" := Database::"Employee Activity Second";
                    IncomingDocument.Insert(true);
                end;
            until AttachmentMandatory.Next = 0;
    end;
}
