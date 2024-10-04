page 33019991 "Attendance Journal Batches"
{
    // version AMS6.1.0

    PageType = List;
    SourceTable = "HR Budget Plan";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Fiscal Year"; Rec."Fiscal Year")
                {
                    ToolTip = 'Specifies the value of the Fiscal Year field.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = All;
                }
                // field("No. Series"; "No. Series")
                // {
                //     ToolTip = 'Specifies the value of the No. Series field.';
                //     ApplicationArea = All;
                // }
                // field("Posting No. Series"; "Posting No. Series")
                // {
                //     ToolTip = 'Specifies the value of the Posting No. Series field.';
                //     ApplicationArea = All;
                // }
            }
        }
        area(FactBoxes)
        {
            systempart(Control1000000007; Links)
            {
                Visible = false;
                ApplicationArea = All;
            }
            systempart(Control1000000006; Notes)
            {
                Visible = false;
                ApplicationArea = All;
            }
        }
    }

    actions { }
}
