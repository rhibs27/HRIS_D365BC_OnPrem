page 33019862 "Employee Leave Type Part"
{
    // version ATM.19.01.01

    Editable = false;
    PageType = ListPart;
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
                field("Leave Balance"; Rec."Leave Balance")
                {
                    ToolTip = 'Specifies the value of the Leave Balance field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }
}
