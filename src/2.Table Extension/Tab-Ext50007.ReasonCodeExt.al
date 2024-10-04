tableextension 50007 "Reason Code Ext " extends "Reason Code"
{
    fields
    {
        modify(Description)
        {
            Caption = 'No.';
        }
        field(70001; "Transf. Claim Apporver Remarks"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(70002; "Transf. Claim Recomm. Remarks"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(70003; "Transf. Claim Reviewer Remarks"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }
}