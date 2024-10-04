page 50091 "Employee Leave Days"
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
                field("Remaining Days"; Rec."Remaining Days")
                {
                    ToolTip = 'Specifies the value of the Remaining Days field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }

    trigger OnOpenPage()
    begin
        Rec.CalcFields(Rec."Remaining Days");
    end;
}
