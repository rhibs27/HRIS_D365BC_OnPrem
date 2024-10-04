page 33019850 "Employee Leave Type"
{
    // version ATM.19.01.01

    PageType = List;
    SourceTable = "Employee Leave Type";
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
                field("Standard Level Code"; Rec."Standard Level Code")
                {
                    ToolTip = 'Specifies the value of the Standard Level Code field.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = All;
                }
                field("Min. Balance Days for Encash"; Rec."Min. Balance Days for Encash")
                {
                    ToolTip = 'Specifies the value of the Min. Balance Days for Encash field.';
                    ApplicationArea = All;
                }
                field("Max. Allowable Limit Per Year"; Rec."Max. Allowable Limit Per Year")
                {
                    ToolTip = 'Specifies the value of the Max. Allowable Limit Per Year field.';
                    ApplicationArea = All;
                }
                field("Carry Forward"; Rec."Carry Forward")
                {
                    ToolTip = 'Specifies the value of the Carry Forward field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }
}
