page 50352 "Organization Structure Subform"
{
    ApplicationArea = All;
    Caption = 'Organization Structure Subform';
    PageType = ListPart;
    SourceTable = "Organization Structure line";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Reporting Type"; Rec."Reporting Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Reporting Type field.', Comment = '%';
                }
                field("Reporting Code"; Rec."Reporting Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Reporting Code field.', Comment = '%';
                }
                field("Reporting Name "; Rec."Reporting Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Reporting Name field.', Comment = '%';
                }
            }
        }
    }
}
