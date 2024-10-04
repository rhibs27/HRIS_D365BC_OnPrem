tableextension 50023 "Customized Calendar Change" extends "Customized Calendar Change"
{
    fields
    {
        field(33019800; Provinces; Text[150])
        {
            Caption = 'Provinces';
            DataClassification = ToBeClassified;
        }
        field(33019801; Gender; Enum "Employee Gender")
        {

        }
        field(33019802; InOutValley; Enum "Outside/Inside Valley")
        {
            Caption = 'InOutValley';
            DataClassification = ToBeClassified;
        }
        field(33019803; PostingRegion; Enum Region)
        {

            Caption = 'PostingRegion';
            DataClassification = ToBeClassified;
        }
        field(33019804; Branch; Text[50])
        {
            Caption = 'Branch';
            DataClassification = ToBeClassified;
        }
    }
}
