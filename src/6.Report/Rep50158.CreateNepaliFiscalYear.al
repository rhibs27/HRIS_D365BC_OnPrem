report 50158 "Create Nepali Fiscal Year"
{
    ApplicationArea = All;
    Caption = 'Create Nepali Fiscal Year';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;

    dataset
    {
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    field("Starting Fiscal Year"; NepaliFiscalYear)
                    {
                        Caption = 'Fiscal Year';
                        ApplicationArea = Basic, Suite;
                        //   TableRelation = "English-Nepali Date"."Fiscal Year" where("Opening Fiscal Year" = const(true)); 
                    }
                }
            }
        }
    }

    labels
    {
    }

    trigger OnPreReport()

    begin
        for i := 1 to 13 do begin
            EngNep.reset;
            EngNep.SetCurrentKey("English Date");
            EngNep.setfilter("Fiscal Year", NepaliFiscalyear);
            EngNep.SetRange("Nepali Day", 1);
            if EngNep.FindFirst() then
                repeat
                    AccountingPeriod.init;
                    AccountingPeriod.validate("Starting Date", EngNep."English Date");
                    AccountingPeriod.validate("New Fiscal Year", EngNep."Opening Fiscal Year");
                    AccountingPeriod.Validate("Nepali Year", EngNep."Nepali Year");
                    AccountingPeriod.validate("Nepali Month", EngNep."Nepali Month");
                    AccountingPeriod.Validate(name, format(EngNep."English Month"));
                    AccountingPeriod.Validate("Nepali Fiscal Year", EngNep."Fiscal Year");
                    if AccountingPeriod.insert(true) then;
                until EngNep.next = 0;
        end;
    end;

    var
        AccountingPeriod: Record "Accounting Period";
        EngNep: Record "English-Nepali Date";
        i: Integer;
        NepaliFiscalYear: text;
        TempMonth: Integer;
}
