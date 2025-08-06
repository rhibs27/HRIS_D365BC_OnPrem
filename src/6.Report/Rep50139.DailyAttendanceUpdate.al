report 50139 "Daily Attendance Update"
{

    ProcessingOnly = true;
    UsageCategory = Tasks;
    ApplicationArea = All;

    dataset
    {
        dataitem(Date; Date)
        {
            dataitem(Employee; Employee)
            {
                trigger OnAfterGetRecord()
                begin
                    if "Employment Date" = 0D then
                        CurrReport.Skip;
                    AttendanceMgt.InsertAttendanceLine(Employee."No.", InitialDate, DocNo);
                    if Employee."Employment Type" = Employee."Employment Type"::Contract then
                        StatusInactiveForExpiredContractEmployee;
                end;

                trigger OnPreDataItem()
                begin
                    if EmployeeNo <> '' then
                        SetRange("No.", EmployeeNo);
                    SetFilter("Employment Date", '<=%1', InitialDate);
                    SetRange(Status, Employee.Status::Active);
                end;
            }
            //Date 
            trigger OnAfterGetRecord()
            begin
                Clear(InitialDate);
                InitialDate := "Period Start";
            end;

            trigger OnPreDataItem()
            begin
                SetRange("Period Start", FromDate, ToDate);
                SetRange("Period Type", "Period Type"::Date);
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                field("From Date"; FromDate)
                {
                    ToolTip = 'Specifies the value of the FromDate field.';
                    ApplicationArea = All;
                }
                field("To Date"; ToDate)
                {
                    ToolTip = 'Specifies the value of the ToDate field.';
                    ApplicationArea = All;
                }
                field("Employee No"; EmployeeNo)
                {
                    TableRelation = Employee."No." where(Status = const("Employee Status"::Active));
                    ToolTip = 'Specifies the value of the EmployeeNo field.';
                    ApplicationArea = All;
                }
            }
        }

        actions { }
    }

    labels { }
    trigger OnPreReport()
    begin
        AttendanceSetup.Get;
        DocNo := NoSeriesMgt.GetNextNo(AttendanceSetup."Attendance Line No. Series", Today, true);
        IF FromDate = 0D THEN
            FromDate := TODAY - 1;
        IF ToDate = 0D THEN
            ToDate := TODAY;
        if (FromDate = 0D) or (ToDate = 0D) then
            Error(Err001);
        if FromDate > ToDate then
            Error('From Date %1 must be to date %2.', FromDate, ToDate);

        if GuiAllowed then begin
            if (FromDate > Today) or (ToDate > Today) then
                Error('Cannot run attendance of future date. Please check the date.');
        end;
    end;

    var
        AttendanceSetup: Record "Attendance Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        DocNo, EmployeeNo : Code[20];
        InitialDate: Date;
        AttendanceLine: Record "Attendance Line";
        AttendanceLog: Record "Attendance Log";
        AttendanceMgt: Codeunit "Attendance Mgt";
        CalendarDescription: Text;
        FromDate, ToDate : Date;
        UserSetup: Record "User Setup";
        EmployeeAttendanceActivity: Record "Employee Attendance & Activity";
        Err001: Label 'Please Select From Date and To Date.';
        Err003: Label 'Please Select Employement Type for update attendance.';
        EngNep: Record "English-Nepali Date";

    local procedure StatusInactiveForExpiredContractEmployee()
    begin
        if Employee."Contract Expiry Date" <> 0D then
            if Employee."Contract Expiry Date" <= InitialDate then
                Employee.Validate(Status, Employee.Status::Inactive);
    end;

    procedure SetRequestFilterValue(FromDate1: Date; ToDate1: Date; EmpNo1: Code[20])
    begin
        FromDate := FromDate1;
        ToDate := ToDate1;
        EmployeeNo := EmpNo1;
    end;
}
