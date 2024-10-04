tableextension 50011 "Change Log Entry Ext" extends "Change Log Entry"
{
    fields
    {
        field(50000; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
        }
    }
}
