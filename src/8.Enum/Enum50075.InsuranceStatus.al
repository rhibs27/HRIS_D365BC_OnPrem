enum 50075 "Insurance Status"
{
    Extensible = true;

    value(0; " ")
    {
        Caption = ' ';
    }
    value(1; Screened)
    {
        Caption = 'Screened';
    }
    value(2; "Forwarded to Insurance Co.")
    {
        Caption = 'Forwarded to Insurance Co.';
    }
    value(3; Reimbursed)
    {
        Caption = 'Reimbursed';
    }
    value(4; Rejected)
    {
        Caption = 'Rejected';
    }
    value(5; "Submitted to HRD")
    {
        Caption = 'Submitted to HRD';
    }
}
