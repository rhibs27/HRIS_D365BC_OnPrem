table 50188 "Suspension Level"
{
    LookupPageId = "Suspension Level Setup";
    DataClassification = CustomerContent;
    Caption = 'Suspension Level';

    fields
    {
        field(1; Code; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(3; "Payroll Impact"; Boolean)
        {
            Caption = 'Payroll Impact';
        }
        field(4; "Payroll Impact Percentage"; Decimal)
        {
            Caption = 'Payroll Impact Percentage';
            MinValue = 0;
            MaxValue = 100;
        }
    }

    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }
}
