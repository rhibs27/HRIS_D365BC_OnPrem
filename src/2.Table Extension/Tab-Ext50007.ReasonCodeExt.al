tableextension 50007 "Reason Code Ext " extends "Reason Code"
{
    fields
    {
        modify(Description)
        {
            Caption = 'No.';
        }
        field(50000; "Transf. Claim Apporver Remarks"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Transf. Claim Recomm. Remarks"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(50002; "Transf. Claim Reviewer Remarks"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }
}