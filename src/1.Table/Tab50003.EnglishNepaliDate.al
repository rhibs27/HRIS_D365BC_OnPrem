table 50003 "English-Nepali Date"
{
    // version IRD19.00/KPI1.00

    Caption = 'English-Nepali Date';
    DataPerCompany = false;
    DataClassification = CustomerContent;

    fields
    {
        field(1; "English Year"; Integer)
        {
        }
        field(2; "English Month"; Enum "English Month")
        {
        }
        field(3; "English Day"; Integer)
        {
        }
        field(4; Week; Enum Week)
        {

        }
        field(5; "English Date"; Date) { }
        field(6; "Week Integer"; Integer) { }
        field(7; "Day Off"; Boolean) { }
        field(8; "Nepali Date"; Code[20]) { }
        field(9; "Nepali Year"; Integer) { }
        field(10; "Nepali Month"; Enum "Nepali Month")
        {

        }
        field(11; "Nepali Day"; Integer) { }
        field(12; "Fiscal Year"; Code[20]) { }
        field(13; "Floating Holiday"; Boolean) { }
        field(14; Description; Text[30]) { }
        field(15; "Open Date for Appraisal"; Boolean) { }
        field(16; "Close Date for Appraisal"; Boolean) { }
        field(17; "Opening Fiscal Year"; Boolean) { }
        field(18; "Closing Fiscal Year"; Boolean) { }
        field(19; Quarter; Text[10])
        {
            Description = 'KPI1.00';
        }
    }

    keys
    {
        key(Key1; "Nepali Year", "English Year", "English Month", "English Day") { }
        key(Key2; "Fiscal Year") { }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Fiscal Year") { }
    }

    procedure getNepaliDate(EngDate: Date): Code[20]
    var
        EnglishNepaliDate: Record "English-Nepali Date";
    begin
        EnglishNepaliDate.Reset;
        EnglishNepaliDate.SetRange("English Date", EngDate);
        if EnglishNepaliDate.Find('-') then
            exit(EnglishNepaliDate."Nepali Date");
    end;

    procedure getNepaliMonth(EngDate: Date): Text[100]
    var
        EnglishNepaliDate: Record "English-Nepali Date";
    begin
        EnglishNepaliDate.Reset;
        EnglishNepaliDate.SetRange("English Date", EngDate);
        if EnglishNepaliDate.Find('-') then
            exit(Format(EnglishNepaliDate."Nepali Month"));
    end;

    procedure getNepaliYear(EngDate: Date): Integer
    var
        EnglishNepaliDate: Record "English-Nepali Date";
    begin
        EnglishNepaliDate.Reset;
        EnglishNepaliDate.SetRange("English Date", EngDate);
        if EnglishNepaliDate.Find('-') then
            exit(EnglishNepaliDate."Nepali Year");
    end;

    procedure getEngDate(NepDate: Code[20]): Date
    var
        EnglishNepaliDate: Record "English-Nepali Date";
    begin
        EnglishNepaliDate.Reset;
        EnglishNepaliDate.SetRange("Nepali Date", NepDate);
        if EnglishNepaliDate.Find('-') then
            exit(EnglishNepaliDate."English Date");
    end;
}
