page 50172 "Attendance Integration Setup"
{
    ApplicationArea = all;
    Caption = 'Attendance Integration Setup';
    PageType = card;
    SourceTable = "Attendnce Integration Setup";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("ADMS Base URL"; Rec."Base URL")
                {
                    ToolTip = 'Specifies the value of the URL field.';
                }
                field("User Name"; Rec."User Name")
                {
                    ToolTip = 'Specifies the value of the User Name field.';
                }
                field(Password; Rec.Password)
                {
                    ToolTip = 'Specifies the value of the Password field.';
                    ExtendedDatatype = Masked;
                }
            }
            group(Company)
            {
                field("Branch Code"; Rec."Branch Code")
                {
                    ToolTip = 'Specifies the value of the Branch Code field.';
                }
                field("Company Code"; Rec."Company Code")
                {
                    ToolTip = 'Specifies the value of the Company Code field.';
                }
                field("Department Code"; Rec."Department Code")
                {
                    ToolTip = 'Specifies the value of the Department Code field.';
                }
            }
        }

    }
}
