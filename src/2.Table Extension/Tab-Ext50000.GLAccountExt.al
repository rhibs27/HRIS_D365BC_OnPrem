tableextension 50000 "G/L Account Ext" extends "G/L Account"
{
    fields
    {
        field(33019800; "Document No. Filter"; Code[20])
        {
            Caption = 'Document No. Filter';
            // DataClassification = ToBeClassified;
            FieldClass = FlowFilter;
        }
    }
}
