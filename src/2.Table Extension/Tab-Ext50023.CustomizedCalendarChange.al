tableextension 50023 "Customized Calendar Change" extends "Customized Calendar Change"
{
    fields
    {
        field(50000; Provinces; Text[150])
        {
            Caption = 'Provinces';
            DataClassification = ToBeClassified;
        }
        field(50001; Gender; Enum "Employee Gender")
        {

        }
        field(50002; InOutValley; Enum "Outside/Inside Valley")
        {
            Caption = 'InOutValley';
            DataClassification = ToBeClassified;
        }
        field(50003; PostingRegion; Enum Region)
        {

            Caption = 'PostingRegion';
            DataClassification = ToBeClassified;
        }
        field(50004; Branch; Text[50])
        {
            Caption = 'Branch';
            DataClassification = ToBeClassified;
        }
    }
}
