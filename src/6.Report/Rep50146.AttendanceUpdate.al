report 50146 "Attendance Update"
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
                    AttendanceMgt.InsertAttendanceLine(Employee."No.", InitialDate, false);
                end;

                trigger OnPreDataItem()
                begin
                    if EmployeeNo <> '' then
                        SetRange("No.", EmployeeNo);
                    SetFilter("Employment Date", '<=%1', InitialDate);
                    SetRange(Status, Employee.Status::Active);
                end;
            }
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
    }

    trigger OnPreReport()
    begin
        IF FromDate = 0D THEN
            FromDate := TODAY - 1;
        IF ToDate = 0D THEN
            ToDate := TODAY;
        if (FromDate = 0D) or (ToDate = 0D) then
            Error(Err001);
        if FromDate > ToDate then
            Error('From Date %1 must be to date %2.', FromDate, ToDate);

        if (FromDate > Today) or (ToDate > Today) then
            Error('Cannot run attendance of future date. Please check the date.');
    end;

    var
        EmployeeNo: Code[250];
        InitialDate: Date;
        AttendanceMgt: Codeunit "Attendance Mgt";
        FromDate, ToDate : Date;
        Err001: Label 'Please Select From Date and To Date.';
        EngNep: Record "English-Nepali Date";

    procedure SetRequestFilterValue(FromDate1: Date; ToDate1: Date; EmpNo1: Code[20])
    begin
        FromDate := FromDate1;
        ToDate := ToDate1;
        EmployeeNo := EmpNo1;
    end;

}

