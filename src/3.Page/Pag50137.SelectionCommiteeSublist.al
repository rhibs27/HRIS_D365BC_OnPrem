page 50137 "Selection Commitee Sublist"
{
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = "Selection Commitee";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Employee No"; Rec."Employee No")
                {
                    ToolTip = 'Specifies the value of the Employee No field.';
                    ApplicationArea = All;
                }
                field("Full Name"; Rec."Full Name")
                {
                    ToolTip = 'Specifies the value of the Full Name field.';
                    ApplicationArea = All;
                }
                field("Functional Title"; Rec."Functional Title")
                {
                    ToolTip = 'Specifies the value of the Functional Title field.';
                    ApplicationArea = All;
                }
                field("Salary Level"; Rec."Salary Level")
                {
                    ToolTip = 'Specifies the value of the Salary Level field.';
                    ApplicationArea = All;
                }
                field(Email; Rec.Email)
                {
                    ToolTip = 'Specifies the value of the Email field.';
                    ApplicationArea = All;
                }
                field(Approved; Rec.Approved)
                {
                    ToolTip = 'Specifies the value of the Approved field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Send Mail")
            {
                Image = Email;
                ToolTip = 'Executes the Send Mail action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if Confirm('Do you want to send mail for selection committee?', false) then begin
                        Rec.SendMailToSelectionCommitee;
                        Message('Done');
                    end;
                end;
            }
        }
    }
}
