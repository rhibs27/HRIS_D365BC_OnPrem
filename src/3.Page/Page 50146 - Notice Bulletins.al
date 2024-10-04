page 50146 "Notice Bulletins"
{
    PageType = List;
    SourceTable = "Notice Bulletin";
    ApplicationArea = All;
    UsageCategory = History;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.';
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ToolTip = 'Specifies the value of the Type field.';
                    ApplicationArea = All;
                }
                field(Date; Rec.Date)
                {
                    ToolTip = 'Specifies the value of the Date field.';
                    ApplicationArea = All;
                }
                field(Notice; Rec.Notice)
                {
                    ToolTip = 'Specifies the value of the Notice field.';
                    ApplicationArea = All;
                }
                field("Image File Path"; Rec."Image File Path")
                {
                    ToolTip = 'Specifies the value of the Image File Path field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }
}
