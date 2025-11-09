tableextension 50012 "Document Attachment Ext" extends "Document Attachment"
{
    fields
    {
        field(50000; "Attachment Document Type"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }
}
