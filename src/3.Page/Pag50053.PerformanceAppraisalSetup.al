page 50053 "Performance Appraisal Setup"
{
    ApplicationArea = All;
    Caption = 'Performance Appraisal Setup';
    PageType = Card;
    SourceTable = "Appraisal General Setup";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Employment Type "; Rec."Employment Type ")
                {
                    ToolTip = 'Specifies the value of the Employment Type field.', Comment = '%';
                }
                field("Include Probation Period "; Rec."Include Probation Period ")
                {
                    ToolTip = 'Specifies the value of the Include Probation Period field.', Comment = '%';
                }
                field("Service Period "; Rec."Service Period ")
                {
                    ToolTip = 'Specifies the value of the Service Period field.', Comment = '%';
                }
            }
        }
    }
}
