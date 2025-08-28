report 50048 "Biometric Log Sync"
{
    ApplicationArea = All;
    Caption = 'Biometric Log Sync';
    // UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    dataset
    {
        dataitem(DeviceConfigSetup; "Biometric Device Config.")
        {
            RequestFilterFields = Id, "Date Filter";
            trigger OnAfterGetRecord()
            begin
                BiometricMgt.SyncAttendance(FromDate, ToDate, id);
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
        BiometricMgt: Codeunit "Biometric Mgt.";
}
