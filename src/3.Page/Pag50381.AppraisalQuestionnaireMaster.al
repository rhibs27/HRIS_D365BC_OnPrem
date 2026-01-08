page 50381 "Appraisal Questionnaire Master"
{
    ApplicationArea = All;
    Caption = 'Appraisal Questionnaire Master';
    PageType = List;
    SourceTable = "Appraisal Questionnaire Master";
    UsageCategory = Lists;


    layout
    {
        area(Content)
        {
            repeater(General)
            {
                Field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("KRA Master"; Rec."KRA Master")
                {
                    ToolTip = 'Specifies the value of the KRA Category field.';
                    ApplicationArea = All;
                }
                field("Question"; Rec."Question")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the question';
                }
                field("Question Type"; Rec."Question Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the question type';
                }

            }
        }
    }
}