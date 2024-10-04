tableextension 50004 "General Ledger Setup Ext" extends "General Ledger Setup"
{
    fields
    {
        field(50000; "Approval Dimension"; Code[20])
        {
            TableRelation = Dimension;
            DataClassification = CustomerContent;
        }
        field(50001; "Employee Dimension"; Code[20])
        {
            TableRelation = Dimension.Code;
            DataClassification = CustomerContent;
        }
    }
}
