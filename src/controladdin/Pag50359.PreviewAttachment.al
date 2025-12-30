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
    actions { }
    trigger OnOpenPage()
    begin
        CurrPage.MyChartControl.GetAttachment(LargeText);
    end;

    var
        LargeText: text;

    procedure PreviewAttachment(Base64Text: text);
    begin
        LargeText := Base64Text;
    end;
}
