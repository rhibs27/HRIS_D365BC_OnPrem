page 50276 "HR Overview"
{
    ApplicationArea = All;
    Caption = 'HR Overview';
    PageType = CardPart;
    SourceTable = "HR Cue";

    layout
    {
        area(Content)
        {
            grid("Active Employees")
            {
                group("Active Employee")
                {
                    field("Permanent Staff"; Rec."Permanent Staff")
                    {
                        Image = "None";
                        ToolTip = 'Specifies the value of the Permanent Staff field.';
                        ApplicationArea = All;
                    }
                    field("Probation Staff"; Rec."Probation Staff")
                    {
                        Image = "None";
                        ToolTip = 'Specifies the value of the Probation Staff field.';
                        ApplicationArea = All;
                    }

                    field("Contract Staff"; Rec."Contract Staff")
                    {
                        Image = "None";
                        ToolTip = 'Specifies the value of the Contract Staff field.';
                        ApplicationArea = All;
                    }
                }
            }


            field("Contract Expiry Employees"; Rec."Contract Expiry Employees")
            {
                Caption = 'Contract Expiring';
                ToolTip = 'Specifies the value of the Expiring field.';
                ApplicationArea = All;
            }

            field("Contract Expired Employees"; Rec."Contract Expired Employees")
            {
                Caption = 'Contract Expired';
                ToolTip = 'Specifies the value of the Expired field.';
                ApplicationArea = All;
            }




        }
    }
    var
        usersetup: Record "User Setup";


}
