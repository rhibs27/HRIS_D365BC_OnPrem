tableextension 50022 "Terms And Conditions Ext" extends "Terms And Conditions"
{
    fields
    {
        field(50000; "Document Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",Candidate;
            OptionCaption = ' ,Candidate';
        }
        field(50001; "Employment Type"; enum "Employee Type")
        {
            DataClassification = ToBeClassified;
        }
    }
}
