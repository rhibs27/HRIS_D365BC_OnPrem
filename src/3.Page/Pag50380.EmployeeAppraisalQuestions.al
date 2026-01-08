page 50380 "Employee Appraisal Questions"
{
    ApplicationArea = All;
    Caption = 'Employee Appraisal Questionnaire';
    PageType = ListPart;
    SourceTable = "Employee Appraisal Question";
    UsageCategory = Lists;
    DelayedInsert = true;
    InsertAllowed = false;
    ModifyAllowed = true;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the line number';
                    Editable = false;
                }
                field("Appraisal Code"; Rec."Appraisal Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the appraisal code';
                    Editable = false;
                }
                field("Employee Code"; Rec."Employee Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the employee code';
                    Editable = false;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the employee name';
                    Editable = false;
                }
                field("Question"; Rec."Question")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the question';
                    Editable = false;
                }
                field("Question Type"; Rec."Question Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of question';
                    Editable = false;
                }
                field("Comment"; Rec."Comment")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the response of Question';
                    Editable = Rec."Question Type" = Rec."Question Type"::Text;
                    Enabled = Rec."Question Type" = Rec."Question Type"::Text;
                }
                field("Yes/No"; Rec."Yes/No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies Yes/No answer';
                    Editable = Rec."Question Type" = Rec."Question Type"::"Yes/No";
                    Enabled = Rec."Question Type" = Rec."Question Type"::"Yes/No";
                }
            }
        }
    }

}