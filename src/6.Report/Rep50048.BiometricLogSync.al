report 50048 "Biometric Log Sync"
{
    ApplicationArea = All;
    Caption = 'Biometric Log Sync';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    dataset
    {
        dataitem(DeviceConfigSetup; "Biometric Device Config.")
        {
            RequestFilterFields = "Branch Code", SN, "Date Filter";
            trigger OnAfterGetRecord()
            begin
                AdmsMgt.SyncAttendance(FromDate, ToDate, SN);
            end;
        }

    }
    requestpage
    {
        layout
        {
            area(content)
            {

            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
    trigger OnPreReport()
    begin
        if DeviceConfigSetup.GetFilter("Date Filter") <> '' then begin
            FromDate := DeviceConfigSetup.GetRangeMin("Date Filter");
            ToDate := DeviceConfigSetup.GetRangeMax("Date Filter");
        end;
        if FromDate = 0D then begin
            FromDate := WorkDate() - 3;
            ToDate := WorkDate() + 1;
        end;

    end;

    var
        FromDate: Date;
        ToDate: Date;
        AdmsMgt: Codeunit "Biometric Mgt.";
}
