enum 33019875 "Insurance Status"
{
    Extensible = true;
    
    value(0; " ")
    {
        Caption = ' ';
    }
    value(1; "Request to DTMD")
    {
        Caption = 'Request to DTMD';
    }
    value(2; Screened)
    {
        Caption = 'Screened';
    }
    value(3; "Forwarded to Insurance Co.")
    {
        Caption = 'Forwarded to Insurance Co.';
    }
    value(4; Reimbursed)
    {
        Caption = 'Reimbursed';
    }
    value(5; Rejected)
    {
        Caption = 'Rejected';
    }
}
