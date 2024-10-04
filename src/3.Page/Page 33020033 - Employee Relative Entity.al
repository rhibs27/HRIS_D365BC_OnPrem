page 33020033 "Employee Relative Entity"
{
    // version APINICASIA1.00

    DelayedInsert = true;
    //The property 'EntityName' can only be set if the property 'PageType' is set to 'API'
    EntityName = 'employeeRelativeEntity';
    //The property 'EntitySetName' can only be set if the property 'PageType' is set to 'API'
    EntitySetName = 'employeeRelativeEntities';
    PageType = API;
    SourceTable = "Employee Relative";
    APIVersion = 'v2.0';
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(employeeNo; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the value of the Employee No. field.';
                    ApplicationArea = All;
                }
                field(lineNo; Rec."Line No.")
                {
                    ToolTip = 'Specifies the value of the Line No. field.';
                    ApplicationArea = All;
                }
                field(relativeCode; Rec."Relative Code")
                {
                    ToolTip = 'Specifies the value of the Relative Code field.';
                    ApplicationArea = All;
                }
                field(fullName; Rec."Full Name")
                {
                    ToolTip = 'Specifies the value of the Full Name field.';
                    ApplicationArea = All;
                }
                field(birthDate; Rec."Birth Date")
                {
                    ToolTip = 'Specifies the value of the Birth Date field.';
                    ApplicationArea = All;
                }
                field(relationship; Rec.Relationship)
                {
                    ToolTip = 'Specifies the value of the Relationship field.';
                    ApplicationArea = All;
                }
                field(masterType; Rec."Master Type")
                {
                    ToolTip = 'Specifies the value of the Master Type field.';
                    ApplicationArea = All;
                }
                field(phoneNo; Rec."Phone No.")
                {
                    ToolTip = 'Specifies the value of the Phone No. field.';
                    ApplicationArea = All;
                }
                field(relativesEmployeeNo; Rec."Relative's Employee No.")
                {
                    ToolTip = 'Specifies the value of the Relatives Employee No. field.';
                    ApplicationArea = All;
                }
                field(Comment; Rec.Comment)
                {
                    ToolTip = 'Specifies the value of the Comment field.';
                    ApplicationArea = All;
                }
                field(Address; Rec.Address)
                {
                    ToolTip = 'Specifies the value of the Address field.';
                    ApplicationArea = All;
                }
                field(Relation; Rec.Relation)
                {
                    ToolTip = 'Specifies the value of the Relation field.';
                    ApplicationArea = All;
                }
                field(nameNepali; Rec."Name(Nepali)")
                {
                    ToolTip = 'Specifies the value of the Name(Nepali) field.';
                    ApplicationArea = All;
                }
                field(fathersNameNepali; Rec."Fathers Name(Nepali)")
                {
                    ToolTip = 'Specifies the value of the Fathers Name(Nepali) field.';
                    ApplicationArea = All;
                }
                field(grandFatherNameNepali; Rec."GrandFather Name(Nepali)")
                {
                    ToolTip = 'Specifies the value of the GrandFather Name(Nepali) field.';
                    ApplicationArea = All;
                }
                field(District; Rec.District)
                {
                    ToolTip = 'Specifies the value of the District field.';
                    ApplicationArea = All;
                }
                field(vdcMunicipality; Rec."VDC/Municipality")
                {
                    ToolTip = 'Specifies the value of the VDC/Municipality field.';
                    ApplicationArea = All;
                }
                field(wardNo; Rec."Ward No")
                {
                    ToolTip = 'Specifies the value of the Ward No field.';
                    ApplicationArea = All;
                }
                field(citizenshipNo; Rec."Citizenship No.")
                {
                    ToolTip = 'Specifies the value of the Citizenship No. field.';
                    ApplicationArea = All;
                }
                field(Age; Rec.Age)
                {
                    ToolTip = 'Specifies the value of the Age field.';
                    ApplicationArea = All;
                }
                field(citizenshipDate; Rec."Citizenship Date")
                {
                    ToolTip = 'Specifies the value of the Citizenship Date field.';
                    ApplicationArea = All;
                }
                field(citizenshipIssuedDistrict; Rec."Citizenship Issued District")
                {
                    ToolTip = 'Specifies the value of the Citizenship Issued District field.';
                    ApplicationArea = All;
                }
                field(citizenshipDateNepali; Rec."Citizenship Date (Nepali)")
                {
                    ToolTip = 'Specifies the value of the Citizenship Date (Nepali) field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }

    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields(Relationship);
    end;
}
