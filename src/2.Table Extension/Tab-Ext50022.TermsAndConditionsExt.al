tableextension 50022 "Terms And Conditions Ext" extends "Terms And Conditions"
{
    fields
    {
        field(50000; "Document Type"; Enum Candidate)
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Employment Type"; enum "Employee Type")
        {
            DataClassification = ToBeClassified;
        }
    }
}
