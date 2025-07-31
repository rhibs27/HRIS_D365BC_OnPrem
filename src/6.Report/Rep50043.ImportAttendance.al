report 50043 "Import Attendance"
{
    ProcessingOnly = true;
    ApplicationArea = All;
    AllowScheduling = false;

    dataset
    {
        dataitem(FilteredEmployee; Employee)
        {
            DataItemTableView = where("NAV Login ID" = filter(<> ''));
            RequestFilterFields = "No.", "Global Dimension 1 Code";

            trigger OnAfterGetRecord()
            begin
                ImportEmployee;
            end;

            trigger OnPostDataItem()
            begin
                // ISV_ONAFTERPOSTREPORT(AttendanceHeader);
                // ProgressWindow.Close;
            end;

            trigger OnPreDataItem()
            begin
                // ProgressWindow.Open(Text000);

                GetSetup;
                DeleteAttendanceSummary;
            end;
        }
    }

    requestpage
    {
        SaveValues = false;

        layout { }

        actions { }

        trigger OnOpenPage()
        begin
            if AttendanceHeader."Global Dimension 1 Code" <> '' then
                FilteredEmployee.SetFilter("Global Dimension 1 Code", AttendanceHeader."Global Dimension 1 Code");
            if AttendanceHeader."Global Dimension 2 Code" <> '' then
                FilteredEmployee.SetFilter("Global Dimension 2 Code", AttendanceHeader."Global Dimension 2 Code");
        end;
    }

    labels { }

    var
        AttendanceSetup: Record "Attendance Setup";
        AttendanceHeader: Record "Attendance Header";
        AttendanceSummary: Record "Attendance Summary";
        AttendanceType: Enum "Employee Type";

    local procedure DeleteAttendanceSummary()
    begin

        AttendanceSummary.Reset;
        AttendanceSummary.SetRange("Document No.", AttendanceHeader."No.");
        AttendanceSummary.DeleteAll;
    end;

    local procedure GetSetup()
    begin
        AttendanceSetup.Get;
        AttendanceSetup.TestField("Base Calender");
    end;

    procedure ImportEmployee()
    var
        PayrollEngine: Codeunit "Payroll Engine";
    begin
        Clear(PayrollEngine);
        if PayrollEngine.IsValidEmployee(FilteredEmployee, AttendanceHeader."From Date", AttendanceHeader."To Date") then begin

            Clear(AttendanceSummary);
            AttendanceSummary.Init;
            AttendanceSummary."Document No." := AttendanceHeader."No.";
            AttendanceSummary."Employee No." := FilteredEmployee."No.";
            AttendanceSummary."Employee Name" := FilteredEmployee."First Name" + ' ' + FilteredEmployee."Middle Name" + ' ' + FilteredEmployee."Last Name";
            AttendanceSummary.CopyFromAttendanceHeader(AttendanceHeader);
            AttendanceSummary.Insert(true);
        end;
    end;

    local procedure IsHoliday(Date: Date; Remarks: Text[100]): Boolean
    var
        AttMgt: Codeunit "HR Mgt.";
        gender: Enum "Employee Gender";
        InOutValley: Enum "Outside/Inside Valley";
        PostingRegion: Option;
        province: Text;
        Branch: Text;
        Community: Enum "Community Type";
        Disabled: Boolean;
    begin
        gender := gender::" ";
        Community := Community::" ";
        exit(AttMgt.CheckDateStatus(AttendanceSetup."Base Calender",
                                        Date,
                                        Remarks,
                                        province,
                                        gender,
                                        InOutValley,
                                        PostingRegion,
                                        Branch,
                                        Community,
                                        Disabled));
    end;

    procedure SetAttendanceDocument(var NewAttendanceHeader: Record "Attendance Header")
    begin
        AttendanceHeader := NewAttendanceHeader;
        AttendanceHeader.TestField("From Date");
        AttendanceHeader.TestField("To Date");
        AttendanceHeader.TestField("Pay Cycle Code");
        AttendanceHeader.TestField("Pay Cycle Term");
        AttendanceHeader.TestField("Pay Cycle Period");
        AttendanceType := NewAttendanceHeader.Type;
    end;

    [IntegrationEvent(true, false)]
    procedure ISV_ONAFTERPOSTREPORT(var NewAttendanceHeader: Record "Attendance Header")
    begin
    end;
}
