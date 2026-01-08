page 50335 "Organization Structure Card"
{
    ApplicationArea = All;
    Caption = 'Organization Structure Card';
    PageType = Card;
    SourceTable = "Organization structure";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field("Type"; Rec."Type")
                {
                    ToolTip = 'Specifies the value of the Type field.', Comment = '%';
                }
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Code field.', Comment = '%';
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.', Comment = '%';
                }
            }
            part("Reporting Lines"; "Organization Structure Subform")
            {
                SubPageLink = Type = field(Type), Code = field(Code);
            }
            part("No of ATM/Vaults per OrgStruct"; "No of ATM/Vaults per OrgStruct")
            {
                SubPageLink = Type = field(Type), Code = field(Code);
            }
        }
    }
}
