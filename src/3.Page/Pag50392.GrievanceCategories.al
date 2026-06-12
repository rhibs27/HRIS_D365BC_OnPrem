page 50392 "Grievance Categories"
{
    ApplicationArea = All;
    Caption = 'Grievance Categories';
    PageType = List;
    SourceTable = "Grievance Category";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Code field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field("Anonymous Filing"; Rec."Anonymous Filing")
                {
                    ToolTip = 'Specifies the value of the Anonymous Filing field.', Comment = '%';
                }
                field("Email IDs"; Rec."Email IDs")
                {
                    ToolTip = 'Specifies the value of the Email IDs field.', Comment = '%';
                }
            }
        }
    }
}
