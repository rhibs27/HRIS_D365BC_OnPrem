tableextension 50004 "General Ledger Setup Ext" extends "General Ledger Setup"
{
    fields
    {
        field(33019800; "Approval Dimension"; Code[20])
        {
            TableRelation = Dimension;
            DataClassification = CustomerContent;
        }
        field(33019801; "Employee Dimension"; Code[20])
        {
            TableRelation = Dimension.Code;
            DataClassification = CustomerContent;
        }
    }
}
