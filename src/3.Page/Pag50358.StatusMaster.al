page 50358 "Status Master"
{
    ApplicationArea = All;
    Caption = 'Status Master';
    PageType = List;
    SourceTable = "Status Master";
    UsageCategory = Lists;


    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
                field(Role; Rec.Role)
                {
                    ToolTip = 'Specifies the value of the Role field.', Comment = '%';
                }
                field(Rejected; Rec.Rejected)
                {
                    ToolTip = 'Specifies the value of the Rejected field.', Comment = '%';
                }
            }
        }
    }
}
