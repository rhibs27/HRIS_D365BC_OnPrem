tableextension 50023 "Customized Calendar Change" extends "Customized Calendar Change"
{
    fields
    {
        field(50000; Provinces; Text[150])
        {
            Caption = 'Provinces';
            DataClassification = ToBeClassified;
        }
        field(50001; Gender; Enum "Gender")
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
        field(50005; Community; Enum "Community Type")
        {
            DataClassification = ToBeClassified;
        }

        field(50020; "Province Filter -OR"; Text[500])
        {
            DataClassification = ToBeClassified;

        }
        field(50021; "Gender Filter -OR"; Enum "Employee Gender")
        {
            DataClassification = ToBeClassified;
        }
        field(50022; "Inside/Outside Valley -OR"; Enum "Outside/Inside Valley")
        {
            DataClassification = ToBeClassified;

        }
        field(50023; "Posting Region -OR"; Enum Region)
        {
            DataClassification = ToBeClassified;

        }
        field(50024; "Branch Code -OR"; Text[500])
        {
            DataClassification = ToBeClassified;

        }
        field(50025; "Employee Filter -OR"; Text[20])
        {
            FieldClass = FlowFilter;
        }
        field(50026; "Community -OR"; Enum "Community Type")
        {
            DataClassification = ToBeClassified;
        }
        field(50027; "Disabled -OR"; Boolean)
        {
        }
        field(50028; "District -OR"; Text[500])
        {
            DataClassification = ToBeClassified;
        }
        field(50029; "Municipality -OR"; Text[500])
        {
            DataClassification = ToBeClassified;

        }
        field(50030; "Employee -OR"; Text[500])
        {
            DataClassification = ToBeClassified;
        }
    }
}
