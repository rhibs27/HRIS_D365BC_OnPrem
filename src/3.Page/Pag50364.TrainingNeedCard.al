page 50402 "Training Need Card"
{
    PageType = Card;
    SourceTable = "Training Need Request";
    Caption = 'Training Need Request Card';
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field("Entry No."; Rec."Entry No.")
                {
                    Editable = false;
                    ToolTip = 'Specifies the unique entry number of this training need request.';
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                    StyleExpr = StatusStyle;
                    ToolTip = 'Specifies the current status of the training need request.';
                    ApplicationArea = All;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    Editable = IsOpen;
                    ToolTip = 'Specifies the employee submitting the training need.';
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    Editable = false;
                    ToolTip = 'Specifies the name of the employee.';
                    ApplicationArea = All;
                }
                field("Department Code"; Rec."Department Code")
                {
                    Editable = false;
                    ToolTip = 'Specifies the department of the employee.';
                    ApplicationArea = All;
                }
                field("Requested Date"; Rec."Requested Date")
                {
                    Editable = IsOpen;
                    ToolTip = 'Specifies the date this training need was identified.';
                    ApplicationArea = All;
                }
                field("Fiscal Year"; Rec."Fiscal Year")
                {
                    Editable = false;
                    ToolTip = 'Specifies the fiscal year.';
                    ApplicationArea = All;
                }
            }
            group("Training Details")
            {
                Caption = 'Training Details';
                field(Description; Rec.Description)
                {
                    Editable = IsOpen;
                    MultiLine = true;
                    ToolTip = 'Specifies the training topic or description.';
                    ApplicationArea = All;
                }
                field("Training Type"; Rec."Training Type")
                {
                    Editable = IsOpen;
                    ToolTip = 'Specifies the type of training requested.';
                    ApplicationArea = All;
                }
                field(Priority; Rec.Priority)
                {
                    Editable = IsOpen;
                    ToolTip = 'Specifies the priority of this training need.';
                    ApplicationArea = All;
                }
                field(Justification; Rec.Justification)
                {
                    Editable = IsOpen;
                    MultiLine = true;
                    ToolTip = 'Specifies the business justification for this training.';
                    ApplicationArea = All;
                }
            }
            group("HR Review")
            {
                Caption = 'HR Review';
                Visible = not IsOpen;
                field("Compiled By"; Rec."Compiled By")
                {
                    Editable = false;
                    ToolTip = 'Specifies the HR officer who compiled this need.';
                    ApplicationArea = All;
                }
                field("Compiled By Name"; Rec."Compiled By Name")
                {
                    Editable = false;
                    ToolTip = 'Specifies the name of the HR officer who compiled this need.';
                    ApplicationArea = All;
                }
                field("Compiled Date"; Rec."Compiled Date")
                {
                    Editable = false;
                    ToolTip = 'Specifies the date the need was compiled.';
                    ApplicationArea = All;
                }
                field("HR Remarks"; Rec."HR Remarks")
                {
                    MultiLine = true;
                    ToolTip = 'Specifies HR remarks or observations.';
                    ApplicationArea = All;
                }
                field("Linked Training No."; Rec."Linked Training No.")
                {
                    ToolTip = 'Specifies the training document this need is linked to.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Submit)
            {
                Caption = 'Submit';
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Enabled = IsOpen;
                ToolTip = 'Submit this training need request to HR for review.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    TrainingMgt.Submit(Rec);
                    SetLayout();
                    CurrPage.Update(false);
                    Message('Training need has been submitted for HR review.');
                end;
            }
            action(Compile)
            {
                Caption = 'Compile';
                Image = Reconcile;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Enabled = IsSubmitted;
                ToolTip = 'Mark this training need as compiled by HR.';
                ApplicationArea = All;

                trigger OnAction()
                var
                    HRMgt: Codeunit "HR Mgt.";
                begin
                    Rec.Compile(HRMgt.GetEmployeeNo());
                    SetLayout();
                    CurrPage.Update(false);
                    Message('Training need has been compiled.');
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetLayout();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        SetLayout();
    end;

    var
        IsOpen: Boolean;
        IsSubmitted: Boolean;
        StatusStyle: Text;
        TrainingMgt: Codeunit "Training Mgt";

    local procedure SetLayout()
    begin
        IsOpen := Rec.Status = Rec.Status::Open;
        IsSubmitted := Rec.Status = Rec.Status::Pending;

        case Rec.Status of
            Rec.Status::Open:
                StatusStyle := 'StandardAccent';
            Rec.Status::Pending:
                StatusStyle := 'Attention';
            Rec.Status::Approved:
                StatusStyle := 'Favorable';
            Rec.Status::Settled:
                StatusStyle := 'Favorable';
            else
                StatusStyle := 'Standard';
        end;
    end;
}
