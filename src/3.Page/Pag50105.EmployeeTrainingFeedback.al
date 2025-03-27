page 50105 "Employee Training Feedback"
{
    AutoSplitKey = true;
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Employee Feedback";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
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
        HRMgt.CalTraineeRemarksTraining(Rec.Code, Rec."Employee No.");
    end;

    var
        HRMgt: Codeunit "HR Mgt.";
}
