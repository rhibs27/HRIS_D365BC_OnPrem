page 50119 "Job Title Card"
{
    PageType = Card;
    SourceTable = "Job Title";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Salary Level Code"; Rec."Salary Level Code")
                {
                    ToolTip = 'Specifies the value of the Salary Level Code field.';
                    ApplicationArea = All;
                }
                field("Functional Title"; Rec."Functional Title")
                {
                    ToolTip = 'Specifies the value of the Functional Title field.';
                    ApplicationArea = All;
                }
                field("Banking Experince"; Rec."Banking Experince")
                {
                    ToolTip = 'Specifies the value of the Banking Experince field.';
                    ApplicationArea = All;
                }
                field("Non-Banking Experince"; Rec."Non-Banking Experince")
                {
                    ToolTip = 'Specifies the value of the Non-Banking Experince field.';
                    ApplicationArea = All;
                }
                field("Minimum Age"; Rec."Minimum Age")
                {
                    ToolTip = 'Specifies the value of the Minimum Age field.';
                    ApplicationArea = All;
                }
            }
            part(Control8; "Job Title Subform")
            {
                SubPageLink = "Salary Level Code" = field("Salary Level Code"),
                              "Functional Title" = field("Functional Title");
                ApplicationArea = All;
            }
        }
    }

    actions { }
}
