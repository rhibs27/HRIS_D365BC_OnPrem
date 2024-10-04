tableextension 33019822 "Terms And Conditions Ext" extends "Terms And Conditions"
{
    fields
    {
        field(33019800; "Document Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",Candidate;
            OptionCaption = ' ,Candidate';
        }
        field(33019801; "Employment Type"; enum "Employee Type")
        {
            DataClassification = ToBeClassified;
        }
    }
}
