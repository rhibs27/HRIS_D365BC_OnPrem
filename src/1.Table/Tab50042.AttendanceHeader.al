table 50042 "Attendance Header"
{
    DataClassification = CustomerContent;
    // version ATM19.01.01

    fields
    {
        field(1; "No."; Code[20])
        {
            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    AttendanceSetup.Get;
                    NoSeriesMngt.TestManual(AttendanceSetup."Attendance Document No. Series");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "From Date"; Date)
        {
            Editable = false;

            trigger OnValidate()
            begin
                ThrowErrorOnLineExist;
                if ("To Date" <> 0D) and ("From Date" <> 0D) then
                    if "From Date" >= "To Date" then
                        Error(Text000, FieldCaption("From Date"), FieldCaption("To Date"), 'greater');
                if "From Date" <> 0D then
                    Month := Date2DMY("From Date", 2);

                "From Date (B.S)" := EngNep.getNepaliDate("From Date");
                "Nepali Month" := "Nepali Month"::" ";
                "Nepali Year" := 0;
                EngNep.Reset;
                EngNep.SetRange("English Date", "From Date");
                if EngNep.FindFirst then begin
                    "Nepali Month" := EngNep."Nepali Month";
                    "Nepali Year" := EngNep."Nepali Year";
                end;
            end;
        }
        field(3; "To Date"; Date)
        {
            Editable = false;

            trigger OnValidate()
            begin
                ThrowErrorOnLineExist;
                if ("To Date" <> 0D) and ("From Date" <> 0D) then
                    if "From Date" >= "To Date" then
                        Error(Text000, FieldCaption("To Date"), FieldCaption("From Date"), 'lesser');
                "To Date (B.S)" := EngNep.getNepaliDate("To Date");
            end;
        }
        field(4; Month; Enum "English Month")
        {
            Editable = false;
        }
        field(5; Remarks; Text[50]) { }
        field(6; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(7; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(8; "Responsibility Center"; Code[20])
        {
            TableRelation = "Responsibility Center";
        }
        field(9; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(10; "Document Date"; Date) { }
        field(11; "Posting Date"; Date)
        {
            trigger OnValidate()
            begin
                if not (("Posting Date" >= "From Date") and ("Posting Date" <= "To Date")) then
                    Error(Text006, "From Date", "To Date");
            end;
        }
        field(12; Status; enum "Approval Status")
        {
            Editable = false;

        }
        field(13; "Posting Description"; Text[50]) { }
        field(14; "Assigned User ID"; Code[50])
        {
            Editable = false;
            TableRelation = "User Setup";
        }
        field(15; "From Date (B.S)"; Code[20])
        {
            Editable = false;
        }
        field(16; "To Date (B.S)"; Code[20])
        {
            Editable = false;
        }
        field(17; "Nepali Month"; Enum "Nepali Month")
        {
            Editable = false;
        }
        field(18; "Nepali Year"; Integer)
        {
            Editable = false;
        }
        field(19; "Pay Cycle Code"; Code[20])
        {
            TableRelation = "Pay Cycle";

            trigger OnValidate()
            begin
                TestStatusOpen;
                "Pay Cycle Period" := 0;
                "Pay Cycle Term" := '';
                "Nepali Month" := "Nepali Month"::" ";
                "Nepali Year" := 0;
                DeleteSummary;
            end;
        }
        field(20; "Pay Cycle Term"; Code[20])
        {
            TableRelation = "Pay Cycle Term".Term where("Pay Cycle Code" = field("Pay Cycle Code"));

            trigger OnValidate()
            begin
                TestStatusOpen;
                "Pay Cycle Period" := 0;
                "Nepali Month" := "Nepali Month"::" ";
                "Nepali Year" := 0;
                DeleteSummary;
            end;
        }
        field(21; "Pay Cycle Period"; Integer)
        {
            TableRelation = "Pay Cycle Period".Period where("Pay Cycle Code" = field("Pay Cycle Code"),
                                                             "Pay Cycle Term" = field("Pay Cycle Term"));

            trigger OnValidate()
            begin
                TestStatusOpen;
                TestField("Pay Cycle Code");
                TestField("Pay Cycle Term");
                if PayCyclePeriod.Get("Pay Cycle Code", "Pay Cycle Term", "Pay Cycle Period") then begin
                    Validate("To Date", 0D);
                    Validate("From Date", 0D);
                    Validate("From Date", PayCyclePeriod."Start Date");
                    Validate("To Date", PayCyclePeriod."End Date");
                    "Posting Date" := PayCyclePeriod."Pay Date";
                end;
                DeleteSummary;
            end;
        }
        field(22; Posted; Boolean)
        {
            Editable = false;
        }
        field(23; "Posted By"; Code[50])
        {
        }
        field(24; Type; Enum "Employee Type")
        {

        }
    }

    keys
    {
        key(Key1; "No.") { }
    }

    fieldgroups { }

    trigger OnDelete()
    begin
        //TestStatusOpen;
        AttendanceSummary.Reset;
        AttendanceSummary.SetRange("Document No.", "No.");
        AttendanceSummary.DeleteAll(true);
    end;

    trigger OnInsert()
    begin
        AttendanceSetup.Get;
        if "No." = '' then begin
            TestNoSeries;
            NoSeriesMngt.InitSeries(GetNoSeries, xRec."No. Series", 0D, "No.", "No. Series");
        end;
        InitRecord;
        "Assigned User ID" := UserId;
        "Document Date" := Today;
        Status := Status::Open;
    end;

    trigger OnModify()
    begin
        TestStatusOpen;
    end;

    trigger OnRename()
    begin
        Error(Text005, TableCaption);
    end;

    var
        NoSeriesMngt: Codeunit NoSeriesManagement;
        AttendanceSetup: Record "Attendance Setup";
        AttendanceSummary: Record "Attendance Summary";
        UserMgt: Codeunit "User Setup Management";
        EngNep: Record "English-Nepali Date";
        PayCyclePeriod: Record "Pay Cycle Period";
        HideModificationDialog: Boolean;
        Text000: Label '"%1" cannot be %3 than "%2".';
        Text001: Label 'Attendance Plan';
        Text002: Label 'Please delete the existing lines before changing the value in Attendance Document.';
        Text003: Label 'Do you want to change the attendance period? It will delete all existing lines.';
        Text005: Label 'You cannot rename a %1.';
        Text006: Label 'Posting Date must be within the range %1 and %2.';
        Text007: Label 'Do you want to post the Document %1?';
        Text008: Label 'Do you want to re-open the document %1?';
        Text009: Label 'There is nothing to post.';

    procedure AssistEdit(xAttendanceHeader: Record "Attendance Header"): Boolean
    begin
        AttendanceSetup.Get;
        TestNoSeries;
        if NoSeriesMngt.SelectSeries(GetNoSeries, xAttendanceHeader."No. Series", "No. Series") then begin
            TestNoSeries;
            NoSeriesMngt.SetSeries("No.");
            exit(true);
        end;
    end;

    procedure TestNoSeries(): Boolean
    begin
        AttendanceSetup.TestField("Attendance Document No. Series");
    end;

    procedure GetNoSeries(): Code[20]
    begin
        exit(AttendanceSetup."Attendance Document No. Series");
    end;

    procedure InitRecord()
    begin
        "Posting Description" := Format(Text001) + ' ' + "No.";
        "Document Date" := Today;
        "Posting Date" := Today;
        "Responsibility Center" := UserMgt.GetRespCenter(0, "Responsibility Center");
    end;

    procedure LineExists(): Boolean
    var
        SalaryLine: Record "Payroll Line";
    begin
        SalaryLine.Reset;
        SalaryLine.SetRange("Document No.", "No.");
        if SalaryLine.FindFirst then
            exit(true)
        else
            exit(false);
    end;

    procedure ReOpenDocument(var AttendanceHeader: Record "Attendance Header")
    begin
        if not Confirm(Text008, false, "No.") then
            exit;
        if AttendanceHeader.FindFirst then begin
            AttendanceHeader.Status := Status::Open;
            AttendanceHeader.Posted := false;
            AttendanceHeader."Posted By" := '';
            AttendanceHeader.Modify;
            ChangeStatus(AttendanceHeader."No.", AttendanceHeader.Status);
        end;
    end;

    procedure SetHideModificationDialog(NewHideModificationDialog: Boolean)
    begin
        HideModificationDialog := NewHideModificationDialog;
    end;

    procedure TestStatusOpen()
    begin
        /*
        IF NOT HideModificationDialog THEN
          IF Status <> Status::Open THEN
            ERROR(Text004);
        TESTFIELD(Posted,FALSE);
        */
    end;

    local procedure ThrowErrorOnLineExist()
    begin
        if LineExists then
            Error(Text002)
    end;

    procedure PostDocument()
    begin
        if not Confirm(Text007, false, "No.") then
            exit;
        TestField("Pay Cycle Code");
        TestField("Pay Cycle Term");
        TestField("Pay Cycle Period");
        AttendanceSummary.Reset;
        AttendanceSummary.SetRange("Document No.", "No.");
        if AttendanceSummary.Count = 0 then
            Error(Text009);
        Status := Status::Released;
        Posted := true;
        "Posted By" := UserId;
        "Posting Date" := Today;
        Modify;
        ChangeStatus("No.", Status);
    end;

    local procedure DeleteSummary()
    begin
        AttendanceSummary.Reset;
        AttendanceSummary.SetRange("Document No.", "No.");
        if AttendanceSummary.Count > 0 then begin
            if not Confirm(Text003, false) then
                exit;
            AttendanceSummary.DeleteAll(true);
        end;
    end;

    local procedure ChangeStatus(DocumentNo: Code[20]; NewStatus: enum "Approval Status")
    var
        AttendanceSummary: Record "Attendance Summary";
        AttendanceLine: Record "Attendance Line";
    begin
        AttendanceSummary.Reset;
        AttendanceSummary.SetRange("Document No.", DocumentNo);
        if AttendanceSummary.FindSet then
            repeat
                AttendanceSummary.Status := NewStatus;
                AttendanceSummary.Modify;
            until AttendanceSummary.Next = 0;
        AttendanceLine.Reset;
        AttendanceLine.SetRange("Document No.", DocumentNo);
        if AttendanceLine.FindSet then
            repeat
                AttendanceLine.Status := NewStatus;
                AttendanceLine.Modify;
            until AttendanceLine.Next = 0;
    end;

    procedure ImportEmployee()
    var
        ImportAttendance: Report "Import Attendance";
    begin
        Clear(ImportAttendance);
        ImportAttendance.SetAttendanceDocument(Rec);
        ImportAttendance.Run;
    end;
}
