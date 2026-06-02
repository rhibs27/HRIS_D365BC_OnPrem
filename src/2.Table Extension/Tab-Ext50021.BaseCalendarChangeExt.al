tableextension 50021 "Base Calendar Change Ext" extends "Base Calendar Change"
{
    fields
    {
        modify(Date)
        {
            trigger OnAfterValidate()
            var
                NepaliMonth: Enum "Nepali Month";
            begin
                Validate("Nepali Date", HRMgt.GetNepaliDate(Date));
                Evaluate(NepaliMonth, EnglishNepaliDate.getNepaliMonth(Date));
                Validate("Nepali Month", NepaliMonth);
            end;
        }
        field(50000; "Holiday Type"; Enum "Holiday Type")
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Province Filter"; Text[500])
        {
            DataClassification = ToBeClassified;
            trigger OnLookup()
            begin
                Validate("Province Filter", HRMgt.LookupProvinceOrganization());
            end;
        }
        field(50002; "Gender Filter"; Enum "Employee Gender")
        {
            DataClassification = ToBeClassified;
        }
        field(50003; "Inside/Outside Valley"; Enum "Outside/Inside Valley")
        {
            DataClassification = ToBeClassified;
        }
        field(50004; "Posting Region"; Enum Region)
        {
            DataClassification = ToBeClassified;
        }
        field(50005; "Branch Code"; Text[500])
        {
            DataClassification = ToBeClassified;
            trigger OnLookup()
            begin
                Validate("Branch Code", HRMgt.LookupBranch(''));
            end;
        }
        field(50006; "Employee Filter"; Text[20])
        {
            FieldClass = FlowFilter;
        }
        field(50007; Community; Enum "Community Type")
        {
            DataClassification = ToBeClassified;
        }
        field(50008; Disabled; Boolean) { }
        field(50009; "District"; Text[500])
        {
            DataClassification = ToBeClassified;
            trigger OnLookup()
            begin
                Validate(District, HRMgt.LookupMultipleDistrict());
            end;
        }
        field(50010; "Municipality"; Text[500])
        {
            DataClassification = ToBeClassified;
            trigger OnLookup()
            begin
                Validate(Municipality, HRMgt.LookupMultipleMunicipality());
            end;
        }
        field(50011; "Employee"; Text[500])
        {
            DataClassification = ToBeClassified;
            trigger OnLookup()
            begin
                Validate(Employee, HRMgt.LookupEmployee());
            end;
        }
        field(50012; "Nepali Date"; Text[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50013; "Nepali Month"; Enum "Nepali Month")
        {
            DataClassification = ToBeClassified;
        }
        field(50020; "Province Filter -OR"; Text[500])
        {
            DataClassification = ToBeClassified;
            trigger OnLookup()
            begin
                Validate("Province Filter -OR", HRMgt.LookupProvinceOrganization());
            end;
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
            trigger OnLookup()
            begin
                Validate("Branch Code -OR", HRMgt.LookupBranch(''));
            end;
        }
        field(50025; "Employee Filter -OR"; Text[20])
        {
            FieldClass = FlowFilter;
        }
        field(50026; "Community -OR"; Enum "Community Type")
        {
            DataClassification = ToBeClassified;
        }
        field(50027; "Disabled -OR"; Boolean) { }
        field(50028; "District -OR"; Text[500])
        {
            DataClassification = ToBeClassified;
            trigger OnLookup()
            begin
                Validate("District -OR", HRMgt.LookupMultipleDistrict());
            end;
        }
        field(50029; "Municipality -OR"; Text[500])
        {
            DataClassification = ToBeClassified;
            trigger OnLookup()
            begin
                Validate("Municipality -OR", HRMgt.LookupMultipleMunicipality());
            end;
        }
        field(50030; "Employee -OR"; Text[500])
        {
            DataClassification = ToBeClassified;
            trigger OnLookup()
            begin
                Validate("Employee -OR", HRMgt.LookupEmployee());
            end;
        }
        field(50301; "Access Token"; code[60])
        {
            caption = 'Access Token';
            DataClassification = CustomerContent;
        }
    }
    var
        HRMgt: Codeunit "HR Mgt.";
        EnglishNepaliDate: Record "English-Nepali Date";
}
