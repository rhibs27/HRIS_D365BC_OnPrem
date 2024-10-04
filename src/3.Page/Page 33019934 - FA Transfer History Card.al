page 33019934 "FA Transfer History Card"
{
    // version IME Remit

    PageType = Card;
    SourceTable = "FA Transfer Register";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("FA No."; Rec."FA No.")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the FA No. field.';
                    ApplicationArea = All;
                }
                field(Date; Rec.Date)
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Date field.';
                    ApplicationArea = All;
                }
                field("From Location Code"; Rec."From Location Code")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the From Location Code field.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    Caption = 'From Location';
                    Editable = false;
                    ToolTip = 'Specifies the value of the From Location field.';
                    ApplicationArea = All;
                }
                field("To Location Code"; Rec."To Location Code")
                {
                    Caption = 'To Location Code';
                    Editable = false;
                    ToolTip = 'Specifies the value of the To Location Code field.';
                    ApplicationArea = All;
                }
                field("To Description"; Rec."To Description")
                {
                    Caption = 'To Location';
                    Editable = false;
                    ToolTip = 'Specifies the value of the To Location field.';
                    ApplicationArea = All;
                }
                field("From Responsible Emp"; Rec."From Responsible Emp")
                {
                    Caption = 'From Employee Code';
                    Editable = false;
                    ToolTip = 'Specifies the value of the From Employee Code field.';
                    ApplicationArea = All;
                }
                field("From Emp Description"; Rec."From Emp Description")
                {
                    Caption = 'From Responsible Employee';
                    Editable = false;
                    ToolTip = 'Specifies the value of the From Responsible Employee field.';
                    ApplicationArea = All;
                }
                field("To Responsible Emp"; Rec."To Responsible Emp")
                {
                    Caption = 'To Employee Code';
                    Editable = false;
                    ToolTip = 'Specifies the value of the To Employee Code field.';
                    ApplicationArea = All;
                }
                field("To Emp Description"; Rec."To Emp Description")
                {
                    Caption = 'To Responsible Employee';
                    Editable = false;
                    ToolTip = 'Specifies the value of the To Responsible Employee field.';
                    ApplicationArea = All;
                }
                field(Reason; Rec.Reason)
                {
                    Editable = false;
                    MultiLine = true;
                    ToolTip = 'Specifies the value of the Reason field.';
                    ApplicationArea = All;
                }
                field(Remarks; Rec.Remarks)
                {
                    Editable = false;
                    MultiLine = true;
                    ToolTip = 'Specifies the value of the Remarks field.';
                    ApplicationArea = All;
                }
                field("User ID"; Rec."User ID")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the User ID field.';
                    ApplicationArea = All;
                }
            }
        }
        area(FactBoxes)
        {
            systempart("<Notes>"; Notes)
            {
                Caption = 'Notes';
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Creation)
        {
            group("<Action1102159025>")
            {
                Caption = 'Printing';
                action("<Action1102159026>")
                {
                    Caption = 'Print';
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Print action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        //message('Test');

                        // to print
                        FATransfer.Reset;
                        FATransfer.SetRange(FATransfer."FA No.", Rec."FA No.");
                        FATransfer.SetRange(FATransfer."From Location Code", Rec."From Location Code");
                        Report.Run(70028, false, true, FATransfer);
                    end;
                }
            }
        }
    }

    var
        FATransfer: Record "FA Transfer Register";
}
