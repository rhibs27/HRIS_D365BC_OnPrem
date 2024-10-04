tableextension 50000 "G/L Account Ext" extends "G/L Account"
{
    fields
    {
        field(50000; "Document No. Filter"; Code[20])
        {
            Caption = 'Document No. Filter';
            // DataClassification = ToBeClassified;
            FieldClass = FlowFilter;
        }
    }
}
