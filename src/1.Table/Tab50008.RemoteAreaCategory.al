table 50008 "Remote Area Category"
{
    DataClassification = CustomerContent;
    // version KPI1.00

    fields
    {
        field(1; Category; Code[20]) { }
        field(2; "Remote allowance Percentage"; Decimal) { }
        field(3; "Remote Allowance Amount"; Decimal) { }
        field(4; "BM Accomodation Amount"; Decimal) { }
        field(5; "Remote Area Deduction"; Decimal) { }
        field(6; "KPI Incentive %"; Decimal)
        {
            Description = 'KPI1.00';
        }
    }

    keys
    {
        key(Key1; Category) { }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Category, "Remote allowance Percentage", "Remote Allowance Amount", "BM Accomodation Amount", "Remote Area Deduction")
        {
        }
    }
}
