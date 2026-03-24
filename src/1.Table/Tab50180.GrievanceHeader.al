table 50181 "Grievance Header"
{
    Caption = 'Grievance Header';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20])
        {
            trigger OnValidate()
            begin
                HRSetup.Get();
                if "No." <> xRec."No." then begin
                    HRSetup.TestField("Grievance No.");
                    NoSeriesMgt.TestManual(HRSetup."Grievance No.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "Employee No."; Code[20])
        {
            TableRelation = Employee;
            trigger OnValidate()
            begin
                if Employee.Get("Employee No.") then begin
                    Validate("Employee Name", Employee."Full Name");
                    Validate("Shortcut Dimension 1 Code", Employee."Global Dimension 1 Code");
                    Validate("Deputation On", Employee."Deputation on");
                    Validate("Deputation Code", Employee."Deputation On Code");
                end;
            end;
        }
        field(3; "Employee Name"; Text[100])
        {
            Editable = false;
        }
        field(4; "Grievance Date"; Date) { }
        field(5; Category; Enum "Grievance Category") { }
        field(6; Priority; Enum "Grievance Priority")
        {
            trigger OnValidate()
            begin
                UpdateSLADates();
            end;
        }
        field(7; Subject; Text[250]) { }
        field(8; Description; Text[1000])
        {
            Caption = 'Description';
        }
        field(9; "Against Employee No."; Code[20])
        {
            TableRelation = Employee;
            trigger OnValidate()
            begin
                if "Against Employee No." <> '' then begin
                    if Employee.Get("Against Employee No.") then
                        Validate("Against Employee Name", Employee."Full Name")
                    else
                        Validate("Against Employee Name", '');
                end else
                    Validate("Against Employee Name", '');
            end;
        }
        field(10; "Against Employee Name"; Text[100])
        {
            Editable = false;
        }
        field(13; "Approval Status"; Enum "Approval Status") { }
        field(14; "HR Remarks"; Text[500]) { }
        field(15; "Resolution Date"; Date) { }
        field(16; "Resolution Description"; Blob)
        {
            Caption = 'Resolution Description';
        }
        field(17; "Resolved By"; Code[20])
        {
            TableRelation = Employee;
        }
        field(18; "Rejection Remarks"; Text[250]) { }
        field(19; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(20; "Fiscal Year"; Text[10])
        {
            Editable = false;
        }
        field(21; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code")
            end;
        }
        field(22; "Deputation On"; Enum "Deputation Type")
        {
            Editable = false;
        }
        field(23; "Deputation Code"; Code[20])
        {
            TableRelation = "Organization Structure List".Code where(Type = field("Deputation On"));
            Editable = false;
        }
        field(24; "User ID"; Text[50])
        {
            Editable = false;
            TableRelation = "User Setup"."User ID";
        }
        field(25; Anonymous; Boolean)
        {
            Caption = 'File Anonymously';
        }
        field(26; Severity; Enum "Grievance Severity")
        {
            Caption = 'Severity';
            trigger OnValidate()
            begin
                UpdateSLADates();
            end;
        }
        field(27; "SLA Response Due"; DateTime)
        {
            Caption = 'SLA Response Due';
            Editable = false;
            ToolTip = 'Specifies the deadline by which the grievance must be acknowledged, based on the SLA Matrix.';
        }
        field(28; "SLA Resolution Due"; DateTime)
        {
            Caption = 'SLA Resolution Due';
            Editable = false;
            ToolTip = 'Specifies the deadline by which the grievance must be resolved, based on the SLA Matrix.';
        }
        field(29; "SLA Escalation Due"; DateTime)
        {
            Caption = 'SLA Escalation Due';
            Editable = false;
            ToolTip = 'Specifies the deadline after which the grievance will be escalated if unresolved, based on the SLA Matrix.';
        }
        field(30; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Employee No.", "Approval Status") { }
    }

    trigger OnInsert()
    var
        GrievanceRec: Record "Grievance Header";
    begin
        if "Grievance Date" = 0D then
            "Grievance Date" := Today;
        "User ID" := UserId;
        HRSetup.Get();
        if "No." = '' then begin
            HRSetup.TestField("Grievance No.");
            HRMgt.InitNoSeriesNew(HRSetup."Grievance No.", xRec."No. Series", "Grievance Date", "No.", "No. Series");
            GrievanceRec.ReadIsolation(IsolationLevel::ReadUncommitted);
            GrievanceRec.SetLoadFields("No.");
            while GrievanceRec.Get("No.") do
                "No." := NoSeriesMgt.GetNextNo("No. Series");
        end;
        Validate("Fiscal Year", HRMgt.ReturnFiscalYear("Grievance Date"));
    end;

    trigger OnDelete()
    var
        GrievanceComment: Record "Grievance Comment";
        CannotDelete: Label 'Cannot delete a grievance that is not in Open status.';
    begin
        if not ("Approval Status" in ["Approval Status"::" ", "Approval Status"::Open]) then
            Error(CannotDelete);
        GrievanceComment.SetRange("Grievance No.", "No.");
        GrievanceComment.DeleteAll();
    end;

    procedure UpdateSLADates()
    var
        SLAMatrix: Record "Grievance SLA Matrix";
        BaseDateTime: DateTime;
    begin
        if (Priority = Priority::" ") or (Severity = Severity::" ") then begin
            "SLA Response Due" := 0DT;
            "SLA Resolution Due" := 0DT;
            "SLA Escalation Due" := 0DT;
            exit;
        end;
        if not SLAMatrix.Get(Priority, Severity) then begin
            "SLA Response Due" := 0DT;
            "SLA Resolution Due" := 0DT;
            "SLA Escalation Due" := 0DT;
            exit;
        end;
        if "Grievance Date" <> 0D then
            BaseDateTime := CreateDateTime("Grievance Date", 000000T)
        else
            BaseDateTime := CurrentDateTime;
        "SLA Response Due" := BaseDateTime + (SLAMatrix."Response Time (Hours)" * 3600000);
        "SLA Resolution Due" := BaseDateTime + (SLAMatrix."Resolution Time (Hours)" * 3600000);
        "SLA Escalation Due" := BaseDateTime + (SLAMatrix."Escalation Time (Hours)" * 3600000);
    end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    var
        DimMgt: Codeunit DimensionManagement;
    begin
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;

    var
        Employee: Record Employee;
        HRSetup: Record "Human Resources Setup";
        HRMgt: Codeunit "HR Mgt.";
        NoSeriesMgt: Codeunit "No. Series";
}
