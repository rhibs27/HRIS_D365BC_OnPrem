table 50032 "Appraisal General Setup"
{
    Caption = 'Appraisal General Setup';
    DataClassification = ToBeClassified;

    fields
    {
//on test
        field(1; "Employment Type "; enum "Employee Type")
        {
            Caption = 'Employment Type ';
        }
        field(2; "Service Period "; DateFormula)
        {
            Caption = 'Service Period ';
        }
        field(3; "Include Probation Period "; Boolean)
        {
            Caption = 'Include Probation Period ';
        }
    }

}
