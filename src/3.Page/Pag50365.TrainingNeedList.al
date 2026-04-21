page 50398 "Training Need List"
{
    PageType = List;
    SourceTable = "Training Need Request";
    Caption = 'Training Need Requests';
    CardPageId = "Training Need Card";
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the entry number.';
                    ApplicationArea = All;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the employee who submitted the training need.';
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the employee name.';
                    ApplicationArea = All;
                }
                field("Deputation On"; Rec."Deputation On")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of Deputation On field';
                }
                field("Deputation Code"; Rec."Deputation Code")
                {
                    ToolTip = 'Specifies the value of Deputation Code field';
                    ApplicationArea = All;
                }

                field("Training Category"; Rec."Training Category")
                {
                    ToolTip = 'Specifies the type of training.';
                    ApplicationArea = All;
                }
                field("Training Name"; Rec."Training Name")
                {
                    ToolTip = 'Specifies the training topic or description.';
                    ApplicationArea = All;
                }
                field(Priority; Rec.Priority)
                {
                    ToolTip = 'Specifies the priority.';
                    ApplicationArea = All;
                }
                field("Requested Date"; Rec."Requested Date")
                {
                    ToolTip = 'Specifies the date the training need was requested.';
                    ApplicationArea = All;
                }
                field("Fiscal Year"; Rec."Fiscal Year")
                {
                    ToolTip = 'Specifies the fiscal year.';
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    StyleExpr = StatusStyle;
                    ToolTip = 'Specifies the current status.';
                    ApplicationArea = All;
                }
                field("Compiled By Name"; Rec."Compiled By Name")
                {
                    ToolTip = 'Specifies who compiled the training need.';
                    ApplicationArea = All;
                }
                field("Linked Training No."; Rec."Linked Training No.")
                {
                    ToolTip = 'Specifies the linked training document.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(CompileSelected)
            {
                Caption = 'Compile Selected';
                Image = Reconcile;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Mark the selected submitted training needs as compiled by HR.';
                ApplicationArea = All;

                trigger OnAction()
                var
                    TrainingNeedRequest: Record "Training Need Request";
                    HRMgt: Codeunit "HR Mgt.";
                    CompiledCount: Integer;
                begin
                    CurrPage.SetSelectionFilter(TrainingNeedRequest);
                    TrainingNeedRequest.SetRange(Status, TrainingNeedRequest.Status::Pending);
                    if TrainingNeedRequest.FindSet(true) then
                        repeat
                            TrainingNeedRequest.Compile(HRMgt.GetEmployeeNo());
                            CompiledCount += 1;
                        until TrainingNeedRequest.Next() = 0;
                    if CompiledCount > 0 then
                        Message('%1 training need(s) compiled.', CompiledCount)
                    else
                        Message('No submitted training needs selected.');
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        case Rec.Status of
            Rec.Status::Open:
                StatusStyle := 'StandardAccent';
            Rec.Status::Pending:
                StatusStyle := 'Attention';
            Rec.Status::Acknowledged:
                StatusStyle := 'Favorable';
            Rec.Status::Settled:
                StatusStyle := 'Favorable';
            else
                StatusStyle := 'Standard';
        end;
    end;

    var
        StatusStyle: Text;
}
