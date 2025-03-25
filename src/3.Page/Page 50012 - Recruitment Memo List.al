page 50012 "Recruitment Memo List"
{
    // version HR Recruitement

    CardPageId = "Recruitment Card";
    PageType = List;
    SourceTable = "Recruitment Memo";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Memo No."; Rec."Memo No.")
                {
                    ToolTip = 'Specifies the value of the Memo No. field.';
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update;
                    end;
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
        }
    }

    actions
    {
        area(Creation)
        {
            action(Post)
            {
                Enabled = ShowAction;
                Image = PostedMemo;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Post action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    HRMgt.PostRecruitement(Rec."Memo No.");
                end;
            }
            action("Show Vacacny Lists")
            {
                Image = List;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Show Vacacny Lists action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    HRMgt.ShowVacancyFromRecruitement(Rec."Memo No.");
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if Rec.Posted then
            ShowAction := false
        else
            ShowAction := true;
    end;

    var
        [InDataSet]
        ShowAction: Boolean;
        HRMgt: Codeunit "HR Mgt.";
}
