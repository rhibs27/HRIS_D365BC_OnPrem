page 33019968 "Promotion Eligibilty Criteria"
{
    PageType = List;
    SourceTable = "Promotion Eligibilty Criteria";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Salary Level"; Rec."Salary Level")
                {
                    ToolTip = 'Specifies the value of the Salary Level field.';
                    ApplicationArea = All;
                }
                field("Appraisal Remarks"; Rec."Appraisal Remarks")
                {
                    ToolTip = 'Specifies the value of the Appraisal Remarks field.';
                    ApplicationArea = All;
                }
                field("Services Experience"; Rec."Services Experience")
                {
                    ToolTip = 'Specifies the value of the Services Experience field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }
}
