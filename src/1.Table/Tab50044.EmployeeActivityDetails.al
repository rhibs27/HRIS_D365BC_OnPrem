table 50044 "Employee Activity Details"
{
    // version ATM19.01.01

    DrillDownPageId = "Posted Employee Activities";
    LookupPageId = "Posted Employee Activities";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20])
        {
            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    AttendanceSetup.Get;
                    NoSeriesMngt.TestManual(AttendanceSetup."Activity Document No. Series");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; Approved; Boolean)
        {
            Editable = false;
        }
        field(3; Type; Enum "Employee leave Activity Type")
        {
            trigger OnValidate()
            begin
                "Leave Type" := '';
                "Start Date" := 0D;
                "End Date" := 0D;
                "Start Time" := 0T;
                "End Time" := 0T;
                "Total Days" := 0;
            end;
        }
        field(4; "Employee No."; Code[20])
        {
            TableRelation = Employee;

            trigger OnValidate()
            begin
                "Manager ID" := '';
                "Standard Level Code" := '';
                "Global Dimension 1 Code" := '';
                "Global Dimension 2 Code" := '';
                "Leave Type" := '';
                "Start Date" := 0D;
                "End Date" := 0D;
                "Start Time" := 0T;
                "End Time" := 0T;
                "Total Days" := 0;
                if "Employee No." <> '' then begin
                    Employee.Get("Employee No.");
                    Employee.TestField("Salary Level");
                    //Employee.TestField("Global Dimension 1 Code");
                    //Employee.TestField("Global Dimension 2 Code");
                    //Employee.TestField("Manager No.");
                    "Manager ID" := Employee."Manager No.";
                    "Global Dimension 1 Code" := Employee."Global Dimension 1 Code";
                    "Global Dimension 2 Code" := Employee."Global Dimension 2 Code";

                    SalaryLevel.Get(Employee."Salary Grade");
                    //SalaryLevel.TestField("Standard Step");
                    "Standard Level Code" := SalaryLevel."Standard Step";
                end;
            end;
        }
        field(5; "Leave Type"; Code[20])
        {
            TableRelation = "Employee Leave Type" where("Standard Level Code" = field("Standard Level Code"));

            trigger OnValidate()
            begin
                if not (Type in [Type::"Full Day Leave", Type::"Half Day Leave"]) then
                    Error(Text002, FieldCaption(Type), Type::"Full Day Leave", Type::"Half Day Leave");
            end;
        }
        field(6; Remarks; Text[100]) { }
        field(7; "Start Date"; Date)
        {
            trigger OnValidate()
            begin
                TestDate;
            end;
        }
        field(8; "End Date"; Date)
        {
            trigger OnValidate()
            begin
                TestDate;
            end;
        }
        field(9; "Start Time"; Time)
        {
            trigger OnValidate()
            begin
                TestTime;
            end;
        }
        field(10; "End Time"; Time)
        {
            trigger OnValidate()
            begin
                TestTime;
            end;
        }
        field(11; "Sent Date"; Date) { }
        field(12; "Approved Date"; Date) { }
        field(13; "Approved By"; Code[50]) { }
        field(14; "Manager ID"; Code[50])
        {
            Editable = false;
        }
        field(15; "Total Days"; Decimal) { }
        field(16; "Total Hours"; Duration)
        {
            Editable = false;
        }
        field(17; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(18; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(19; Opening; Boolean) { }
        field(20; "Standard Level Code"; Code[20])
        {
            Editable = false;
        }
        field(21; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(22; "Document Date"; Date)
        {
        }
        field(23; Status; enum "Approval Status")
        {
            Editable = false;
        }
        field(24; "Posting Description"; Text[50]) { }
        field(25; "Assigned User ID"; Code[50])
        {
            Editable = false;
            TableRelation = "User Setup";
        }
        field(26; Posted; Boolean) { }
        field(27; "Posted By"; Code[50]) { }
        field(28; "Leave Balance"; Decimal)
        {
            CalcFormula = sum("Employee Activity Details"."Total Days" where("Employee No." = field("Employee No."),
                                                                              Type = filter("Full Day Leave" | "Half Day Leave"),
                                                                              "Leave Type" = field("Leave Type"),
                                                                              Posted = const(true)));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "No.") { }
        key(Key2; "Employee No.", Type, "Leave Type", Posted) { }
        key(Key3; "Employee No.", "Start Date", "End Date") { }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        AttendanceSetup.Get;
        if "No." = '' then begin
            TestNoSeries;
            HrMgt.InitNoSeriesNew(GetNoSeries, xRec."No. Series", 0D, "No.", "No. Series");
        end;

        "Assigned User ID" := UserId;
        "Document Date" := Today;
    end;

    trigger OnRename()
    begin
        Error(Text005, TableCaption);
    end;

    var
        AttendanceSetup: Record "Attendance Setup";
        Employee: Record Employee;
        SalaryLevel: Record "Salary Grade";
        NoSeriesMngt: Codeunit "No. Series";
        HrMgt: Codeunit "HR Mgt.";
        Text005: Label 'You cannot rename a %1.';
        Text004: Label 'Reopen the document to modify data.';
        Text001: Label 'Start Date cannot be greater than End Date.';
        Text002: Label '%1 must be either %2 or %3.';
        Text006: Label '%1 Balance for Employee %2 is out of balance by %3.';
        Text007: Label 'Do you want to send activity for approval?';
        Text008: Label 'Do you want to reject activity %1 for Employee %2?';
        Text009: Label 'Do you want to reopen activity %1 for Employee %2?';
        Text010: Label 'Send for Approval,Reopen';
        Text011: Label 'You do not have permission to approve activity for Employee %1.';
        Text012: Label 'You do not have permission to reject activity for Employee %1.';
        HideConfirmationDialog: Boolean;
        Text013: Label 'Do you want to approve activity %1 for Employee %2?';
        OpeningEntry: Boolean;

    procedure AssistEdit(xEmployeeActivityDetails: Record "Employee Activity Details"): Boolean
    begin
        AttendanceSetup.Get;
        TestNoSeries;
        if NoSeriesMngt.LookupRelatedNoSeries(GetNoSeries, xEmployeeActivityDetails."No. Series", "No. Series") then begin
            TestNoSeries;
            NoSeriesMngt.GetNextNo("No.");
            exit(true);
        end;
    end;

    procedure TestNoSeries(): Boolean
    begin
        AttendanceSetup.TestField("Activity Document No. Series");
    end;

    procedure GetNoSeries(): Code[20]
    begin
        exit(AttendanceSetup."Activity Document No. Series");
    end;

    procedure TestStatusOpen()
    begin
        if Status <> Status::Open then
            Error(Text004);
        TestField(Posted, false);
    end;

    local procedure TestDate()
    var
        DayFactor: Decimal;
    begin
        if ("Start Date" <> 0D) and ("End Date" <> 0D) then begin
            if "Start Date" > "End Date" then
                Error(Text001);
            if Type = Type::"Half Day Leave" then
                DayFactor := 0.5
            else
                DayFactor := 1;
            if not Opening then
                DayFactor := DayFactor * -1;
            "Total Days" := ("End Date" - "Start Date" + 1) * DayFactor;
        end;
    end;

    local procedure TestTime()
    begin
        if ("Start Time" <> 0T) and ("End Time" <> 0T) then begin
            if "Start Time" > "End Time" then
                Error(Text001);
            "Total Hours" := ("End Time" - "Start Time")
        end;
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendDocumentForApproval(var EmployeeActivityDetails: Record "Employee Activity Details")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelApprovalRequest(var EmployeeActivityDetails: Record "Employee Activity Details")
    begin
    end;

    procedure ChangeApprovalStatus(): Text
    var
        Selection: Integer;
        SentForApprovalTxt: Label 'Document %1 is now sent for approval.';
        ReopenTxt: Label 'Document %1 is now reopened.';
    begin
        HideConfirmationDialog := true;
        if Status = Status::Open then begin
            Selection := StrMenu(Text010, 0);
            if Selection = 0 then
                exit('');
            case Selection of
                1:
                    begin
                        SendDocumentForApproval;
                        exit(SentForApprovalTxt);
                    end;
                2:
                    begin
                        ReopenDocument;
                        exit(ReopenTxt);
                    end;
            end;
        end;
    end;

    procedure SendDocumentForApproval(): Boolean
    begin
        if not HideConfirmationDialog then
            if not Confirm(Text007, false, "No.", "Employee No.") then
                exit;
        TestDocument;
        "Sent Date" := Today;
        Status := Status::Pending;
        Modify;
        exit(true);
    end;

    procedure ApproveDocument(): Boolean
    begin
        if not Confirm(Text013, false, "No.", "Employee No.") then
            exit;
        if not IsValidApprover then
            Error(Text011);
        if OpeningEntry then
            TestOpeningDocument
        else
            TestDocument;
        "Approved Date" := Today;
        "Approved By" := UserId;
        Approved := true;
        Posted := true;
        "Posted By" := UserId;
        Status := Status::Approved;
        if OpeningEntry then
            Opening := true;
        Modify;
        exit(true);
    end;

    procedure RejectDocument(): Boolean
    begin
        if not Confirm(Text008, false, "No.", "Employee No.") then
            exit;
        if not IsValidApprover then
            Error(Text012);
        if OpeningEntry then
            TestOpeningDocument
        else
            TestDocument;
        "Approved Date" := 0D;
        "Approved By" := '';
        Approved := false;
        Posted := true;
        "Posted By" := UserId;
        Status := Status::Rejected;
        Modify;
        exit(true);
    end;

    procedure CancelDocument(): Boolean
    begin
        if not HideConfirmationDialog then
            if not Confirm(Text009, false, "No.", "Employee No.") then
                exit;

        "Approved Date" := 0D;
        "Approved By" := '';
        Posted := false;
        "Posted By" := '';
        Approved := false;
        Status := Status::Open;
        Modify;
        exit(true);
    end;

    local procedure ReopenDocument(): Boolean
    begin
        CancelDocument;
        exit(true);
    end;

    local procedure TestDocument()
    begin
        TestField("Employee No.");
        TestField(Type);
        if Type in [Type::"Full Day Leave", Type::"Half Day Leave"] then begin
            TestField("Leave Type");
            CalcFields("Leave Balance");
            if "Leave Balance" < Abs("Total Days") then
                Error(Text006, "Leave Type", "Employee No.", "Leave Balance" + "Total Days");
        end;

        TestField(Remarks);
        TestField("Start Date");
        TestField("End Date");
        TestField("Manager ID");
        TestField("Total Days");
        if Type = Type::Overtime then begin
            TestField("Start Date", "End Date");
            TestField("Start Time");
            TestField("End Time");
            TestField("Total Hours");
        end;
    end;

    local procedure TestOpeningDocument()
    begin
        TestField("Employee No.");
        TestField(Type);
        if Type in [Type::"Full Day Leave", Type::"Half Day Leave"] then begin
            TestField("Leave Type");
        end;
        TestField(Remarks);
        TestField("Manager ID");
        TestField("Total Days");
    end;

    procedure IsValidApprover(): Boolean
    var
        UserSetup: Record "User Setup";
        Employee: Record Employee;
        IsApprover: Boolean;
    begin
        if UserSetup.Get(UserId) then begin
            IsApprover := UserSetup."Approval Administrator";
            if not IsApprover then begin
                if Employee.Get("Manager ID") then begin
                    if Employee."NAV Login ID" = UserId then
                        IsApprover := true;
                end;
            end;
            exit(IsApprover);
        end;
    end;

    procedure HasOpenApprovalEntriesForCurrentUser(): Boolean
    begin
        exit(IsValidApprover);
    end;

    procedure EnterOpeningEntry()
    var
        EmployeeActivityDetails: Record "Employee Activity Details" temporary;
    begin
        EmployeeActivityDetails := Rec;
        Init;
        "No." := EmployeeActivityDetails."No.";
        "Employee No." := EmployeeActivityDetails."Employee No.";
        "Manager ID" := EmployeeActivityDetails."Manager ID";
        "Standard Level Code" := EmployeeActivityDetails."Standard Level Code";
        "Global Dimension 1 Code" := EmployeeActivityDetails."Global Dimension 1 Code";
        "Global Dimension 2 Code" := EmployeeActivityDetails."Global Dimension 2 Code";
        Remarks := EmployeeActivityDetails.Remarks;
        "Assigned User ID" := EmployeeActivityDetails."Assigned User ID";
        Type := EmployeeActivityDetails.Type;
        Opening := true;
        Modify;
    end;

    procedure SetOpeningEntry(NewOpeningEntry: Boolean)
    begin
        OpeningEntry := NewOpeningEntry;
    end;
}
