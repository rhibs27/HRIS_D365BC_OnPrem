page 50227 "Leave Journal"
{
    ApplicationArea = All;
    Caption = 'Leave Journal';
    PageType = Worksheet;
    SourceTable = "Employee Journal";
    UsageCategory = Tasks;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the value of the Employee No. field.', Comment = '%';
                }
                field("Leave Code"; Rec."Leave Code")
                {
                    ToolTip = 'Specifies the value of the Leave Code field.';
                    ApplicationArea = All;

                    // trigger OnValidate()
                    // begin
                    //     if Rec."Requested Date" <> 0D then
                    //         RemainingDays := LeaveMgt.CalculateRemainingDays(Rec."Employee No.", Rec."Leave Code", Rec."Requested Date");
                    //     LeaveType.Get(Rec."Leave Code");
                    //     IsCompensatory := LeaveType.Compensatory;
                    //     IsBereavement := LeaveType."Bereavement Leave";
                    //     if IsCompensatory then
                    //         RemainingDays := 0;
                    //     // if Rec."Leave Code" <> xRec."Leave Code" then
                    //     //     GenerateAttachment;
                    //     IsPaternity := LeaveType."Maternity/Paternity Leave";
                    // end;
                }
                field("Leave Description"; Rec."Leave Description")
                {
                    ToolTip = 'Specifies the value of the Leave Description field.';
                    ApplicationArea = All;
                }
                field("Leave Type"; Rec."Leave Type")
                {
                    ToolTip = 'Specifies the value of the Leave Type field.';
                    ApplicationArea = All;
                }
                field("Start Date"; Rec."Start Date")
                {
                    ToolTip = 'Specifies the value of the Start Date field.';
                    ApplicationArea = All;
                }
                field("End Date"; Rec."End Date")
                {
                    ToolTip = 'Specifies the value of the End Date field.';
                    ApplicationArea = All;
                }
                field("Start Time"; Rec."Start Time")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Start Time field.';
                    ApplicationArea = All;
                }
                field("End Time"; Rec."End Time")
                {
                    ToolTip = 'Specifies the value of the End Time field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("No. of Days"; Rec."No. of Days")
                {
                    ToolTip = 'Specifies the value of the No. of Days field.';
                    ApplicationArea = All;
                }
                field("Fiscal Year"; Rec."Fiscal Year")
                {
                    ToolTip = 'Specifies the value of the Fiscal Year field.';
                    ApplicationArea = All;
                }
                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field.';
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Post)
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Post;
                trigger OnAction()
                begin
                    LeaveMgt.PostLeaveJournal();
                end;
            }
        }
    }
    trigger OnAfterGetCurrRecord()
    begin

    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec.Type := Rec.Type::"Leave Request";
    end;

    var
        UnitEdit: Boolean;
        DepartmentEdit: Boolean;
        ExtensionCounterEdit: Boolean;
        BranchEdit: Boolean;
        ProvinceEdit: Boolean;
        LeaveMgt: Codeunit "Leave Mgt.";
}
