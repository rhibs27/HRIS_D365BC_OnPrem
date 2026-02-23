page 50382 "Reviewer Setups"
{
    ApplicationArea = All;
    Caption = 'Reviewer Setups';
    PageType = List;
    SourceTable = "Reviewer Setup";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Is Self Review"; Rec."Is Self Review")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Is Self Review field.';
                }
                field("Is Group Based"; Rec."Is Group Based")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Is Group Based field.';
                }
            }
        }
    }
}
