page 33019821 "Recruitment Card"
{
    PageType = Card;
    SourceTable = "Recruitement Memo";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Memo No."; Rec."Memo No.")
                {
                    ToolTip = 'Specifies the value of the Memo No. field.';
                    ApplicationArea = All;
                }
                field("Reference No."; Rec."Reference No.")
                {
                    ToolTip = 'Specifies the value of the Reference No. field.';
                    ApplicationArea = All;
                }
                field(Subject; Rec.Subject)
                {
                    ToolTip = 'Specifies the value of the Subject field.';
                    ApplicationArea = All;
                }
                field("Date of Request"; Rec."Date of Request")
                {
                    ToolTip = 'Specifies the value of the Date of Request field.';
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ToolTip = 'Specifies the value of the Type field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                        //RecrutmemoSubform.RUN;
                    end;
                }
                field("HRSC Meeting No."; Rec."HRSC Meeting No.")
                {
                    ToolTip = 'Specifies the value of the HRSC Meeting No. field.';
                    ApplicationArea = All;
                }
                field(Posted; Rec.Posted)
                {
                    ToolTip = 'Specifies the value of the Posted field.';
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.';
                    ApplicationArea = All;
                }
            }
            part(Control9; "Recruitment Memo Subform")
            {
                SubPageLink = "Memo No." = field("Memo No."),
                              Type = field(Type);
                ApplicationArea = All;
            }
            part(Control15; "Document Workflow")
            {
                SubPageLink = "Primary Key" = field("Memo No.");
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Post)
            {
                Image = PostedMemo;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Post action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if not Confirm('Do your want to post this document?', false) then
                        exit;
                    HRMgt.PostRecruitement(Rec."Memo No.");
                    CurrPage.Close;
                end;
            }
            action("Report")
            {
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Report action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    RecruitementMemo.Reset;
                    RecruitementMemo.SetRange("Memo No.", Rec."Memo No.");
                    if RecruitementMemo.FindFirst then
                        Report.Run(Report::"Recruitment Memo", true, true, RecruitementMemo);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        CurrPage.Editable(not Rec.Posted);
    end;

    var
        HRMgt: Codeunit "HR Mgt.";
        RecruitementMemo: Record "Recruitement Memo";
}
