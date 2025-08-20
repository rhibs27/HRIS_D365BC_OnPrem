table 50138 "Biometric Branch"
{
    Caption = 'Biometric Branch';
    DataClassification = ToBeClassified;
    LookupPageId = "Biometric Branches";
    fields
    {
        field(1; "Branch Code"; Code[20])
        {
            Caption = 'Branch Code';
            DataClassification = ToBeClassified;
        }
        // field(2; "Device SN"; Text[100])
        // {
        //     Caption = 'Device SN';
        //     DataClassification = ToBeClassified;
        // }
        field(3; "Branch Name"; Text[100])
        {
            Caption = 'Branch Name';
            DataClassification = ToBeClassified;
        }
        field(4; "No of Devices"; Integer)
        {
            Caption = 'No of Devices';
            FieldClass = FlowField;
            CalcFormula = count("Biometric Device Config." where("Branch Code" = field("Branch Code")));
            Editable = false;

        }
    }
    keys
    {
        key(PK; "Branch Code")
        {
            Clustered = true;
        }
    }
}
