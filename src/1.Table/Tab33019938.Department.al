table 33019938 Department
{
    Caption = 'Department';
    DataClassification = CustomerContent;
    // LookupPageID = Page "Department" ;
    // DrillDownPageID = Page "Department";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(2; Name; Text[50])
        {
            Caption = 'Name';
        }
        field(3; Address; Text[50])
        {
            Caption = 'Address';
        }
        field(4; "Province Code"; Code[20])
        {
            TableRelation = Province.Code;
            Caption = 'Province Code';
            trigger OnValidate()
            begin
                //PostCode.ValidatePostCode(City,"Province Code",County,"Country/Region Code",(CurrFieldNo <> 0) AND GUIALLOWED);
            end;
        }
        field(5; City; Text[30])
        {
            TableRelation = if ("Country/Region Code" = const()) "Sub Province".City
            else if ("Country/Region Code" = filter(<> '')) "Sub Province".City where("Country/Region Code" = field("Country/Region Code"));
            ValidateTableRelation = false;
            TestTableRelation = false;
            Caption = 'City';
            trigger OnValidate()
            begin
                //PostCode.ValidateCity(City,"Province Code",County,"Country/Region Code",(CurrFieldNo <> 0) AND GUIALLOWED);
            end;

            trigger OnLookup()
            begin
                //PostCode.LookupPostCode(City,"Province Code",County,"Country/Region Code");
            end;
        }
        field(6; "Phone No."; Text[30])
        {
            // ExtendedDatatype = 'Phone No.';
            Caption = 'Phone No.';
        }
        field(7; "No. of Members Employed"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count(Employee where(Status = filter(<> Terminated), "Department Code" = field(Code)));
            Caption = 'No. of Members Employed';
            Editable = false;
        }
        field(8; "Name 2"; Text[50])
        {
            Caption = 'Name 2';
        }
        field(9; "Address 2"; Text[50])
        {
            Caption = 'Address 2';
        }
        field(10; County; Text[30])
        {
            Caption = 'County';
            // CaptionClass = '5,1,' + "Country/Region Code";
        }
        field(11; "Fax No."; Text[30])
        {
            Caption = 'Fax No.';
        }
        field(12; "E-Mail"; Text[80])
        {
            // ExtendedDatatype = E-Mail;
            Caption = 'Email';
            trigger OnValidate()
            var

                MailManagement: Codeunit "Mail Management";
            begin
                MailManagement.ValidateEmailAddressField("E-Mail");
            end;
        }
        field(13; "Home Page"; Text[80])
        {
            ExtendedDatatype = URL;
            Caption = 'Home Page';
        }
        field(14; "Country/Region Code"; Code[10])
        {
            TableRelation = "Country/Region";
            Caption = 'Country/Region Code';
            trigger OnValidate()
            begin
                PostCode.CheckClearPostCodeCityCounty(City, "Province Code", County, "Country/Region Code", xRec."Country/Region Code");
            end;
        }
        field(15; "Sol ID"; Code[10]) { }
        field(16; Blocked; Boolean) { }
        field(17; "Eco-System"; Code[20])
        {
            TableRelation = "Employee Hierarchy Master" where(Type = const("Eco-System"));
            trigger OnValidate()
            begin
                if EmpHieMaster.Get("Eco-System") then
                    Validate("Eco-System Description", EmpHieMaster.Description)
                else
                    Clear("Eco-System Description");
            end;
        }
        field(18; "Eco-System Description"; Text[100])
        {
            Editable = false;
        }
        field(19; "KPI Incentive %"; Decimal)
        {
            Description = 'KPI1.00';
        }
        field(20; "Type"; Enum "Department Type")
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
    var
        PostCode: Record "Post Code";
        EmpHieMaster: Record "Employee Hierarchy Master";
}
