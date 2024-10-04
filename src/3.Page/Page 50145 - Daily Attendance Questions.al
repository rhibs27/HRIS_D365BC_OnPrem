page 50145 "Daily Attendance Questions"
{
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Daily Attendance Question";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.';
                    ApplicationArea = All;
                }
                field("Question Date"; Rec."Question Date")
                {
                    ToolTip = 'Specifies the value of the Question Date field.';
                    ApplicationArea = All;
                }
                field(Question; Rec.Question)
                {
                    ToolTip = 'Specifies the value of the Question field.';
                    ApplicationArea = All;
                }
                field(Option1; Rec.Option1)
                {
                    ToolTip = 'Specifies the value of the Option1 field.';
                    ApplicationArea = All;
                }
                field(Option2; Rec.Option2)
                {
                    ToolTip = 'Specifies the value of the Option2 field.';
                    ApplicationArea = All;
                }
                field(Option3; Rec.Option3)
                {
                    ToolTip = 'Specifies the value of the Option3 field.';
                    ApplicationArea = All;
                }
                field(Option4; Rec.Option4)
                {
                    ToolTip = 'Specifies the value of the Option4 field.';
                    ApplicationArea = All;
                }
                field("Is Punch In Question"; Rec."Is Punch In Question")
                {
                    ToolTip = 'Specifies the value of the Is Punch In Question field.';
                    ApplicationArea = All;
                }
                field("Correct Option"; Rec."Correct Option")
                {
                    ToolTip = 'Specifies the value of the Correct Option field.';
                    ApplicationArea = All;
                }
                field("Sync to Portal"; Rec."Sync to Portal")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Sync to Portal field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Creation)
        {
            action("Sync to HR Portal")
            {
                Image = StepInto;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Sync to HR Portal action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if Confirm('Do you synchronize the selected attendance questions in HRMS Portal?', false) then begin
                        HRMgt.SyncAttendanceQuestion;
                    end;

                    Message('Daily attendance questions have been synced to HR Portal.');
                end;
            }
        }
    }

    var
        HRMgt: Codeunit "HR Mgt.";
}
