page 33020015 "Employee Leave Days-HR Cue"
{
    // version NIC Asia1.00,Leave

    PageType = ListPart;
    SourceTable = "Leave Type Setup";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    ToolTip = 'Specifies the value of the Code field.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = All;
                }
                field(Approved; Rec.Approved)
                {
                    ToolTip = 'Specifies the value of the Approved field.';
                    ApplicationArea = All;
                }
                field(Requested; Rec.Requested)
                {
                    ToolTip = 'Specifies the value of the Requested field.';
                    ApplicationArea = All;
                }
                field(Recommended; Rec.Recommended)
                {
                    ToolTip = 'Specifies the value of the Recommended field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }

    trigger OnOpenPage()
    begin

        Rec.SetRange("Date Filter", Today);
    end;
}
