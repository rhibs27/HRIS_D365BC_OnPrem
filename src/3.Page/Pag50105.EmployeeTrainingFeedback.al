page 50105 "Employee Training Feedback"
{
    AutoSplitKey = true;
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Employee Feedback";
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Training No."; Rec."Training No.")
                {
                    ToolTip = 'Specifies the value of the Training No. field.';
                    ApplicationArea = All;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the value of the Employee No. field.';
                    ApplicationArea = All;
                }
                field(Question; Rec.Question)
                {
                    ToolTip = 'Specifies the value of the Question field.';
                    ApplicationArea = All;
                }
                field(Answer; Rec.Answer)
                {
                    ToolTip = 'Specifies the value of the Answer field.';
                    ApplicationArea = All;
                }
                field(Marks; Rec.Marks)
                {
                    ToolTip = 'Specifies the value of the Marks field.';
                    ApplicationArea = All;
                }
                field("Is Subjective"; Rec."Is Subjective")
                {
                    ToolTip = 'Specifies the value of the Is Subjective field.';
                    ApplicationArea = All;
                }

                field("Answers Text"; Rec."Answers Text")
                {
                    ToolTip = 'Specifies the value of the Answers Text field.';
                    ApplicationArea = All;
                }
                field("Answer II"; Rec."Answer II")
                {
                    ToolTip = 'Specifies the value of the Answer II field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Type := Rec.Type::Training;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        TrainingMgt.CalTraineeRemarksTraining(Rec."Training No.", Rec."Employee No.");
    end;

    var
        HRMgt: Codeunit "HR Mgt.";
        TrainingMgt: Codeunit "Training Mgt";
}
