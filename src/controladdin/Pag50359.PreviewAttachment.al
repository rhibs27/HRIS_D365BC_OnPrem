page 50359 "Preview Attachment"
{
    ApplicationArea = All;
    Caption = 'Preview Attachment';
    PageType = Worksheet;
    SourceTable = "Incoming Document";
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            usercontrol(MyChartControl; MyControlAddIn)
            {
                ApplicationArea = All;
            }
        }

    }
    actions
    {
    }
    trigger OnOpenPage()
    begin
        CurrPage.MyChartControl.GetAttachment(LargeText);
    end;

    var
        Base64Text: text;
        loanMgt: Codeunit "Loan Mgt.";
        LargeText: text;

    procedure PreviewAttachment(Base64Text: text);
    begin
        LargeText := Base64Text;
    end;
}
