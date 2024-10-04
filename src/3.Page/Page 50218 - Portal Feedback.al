page 50218 "Portal Feedback"
{
    Editable = false;
    PageType = List;
    SourceTable = "Employee Feedback Portal";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Feedback No."; Rec."Feedback No.")
                {
                    ToolTip = 'Specifies the value of the Feedback No. field.';
                    ApplicationArea = All;
                }
                field("Feedback Text"; Rec."Feedback Text")
                {
                    ToolTip = 'Specifies the value of the Feedback Text field.';
                    ApplicationArea = All;
                }
                field(Attachment; Rec.Attachment)
                {
                    ToolTip = 'Specifies the value of the Attachment field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Download)
            {
                Image = MoveDown;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Download action.';
                ApplicationArea = All;

                trigger OnAction()
                var
                    instream: InStream;
                begin
                    TempFileName := Rec.Attachment;
                    instream.Read(TempFileName);
                    if DownloadFromStream(instream, 'Send to', '', '', TempFileName) then
                        Message('File Downloaded');
                end;
            }
        }
    }

    var
        TempFileName: Text;
}
