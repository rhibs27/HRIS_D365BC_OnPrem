page 33019863 "Mutually Exl. Payroll Group"
{
    PageType = List;
    SourceTable = "Mutually Excl. Payroll Group";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Type; Rec.Type)
                {
                    ToolTip = 'Specifies the value of the Type field.';
                    ApplicationArea = All;
                }
                field("Payroll Code"; Rec."Payroll Code")
                {
                    ToolTip = 'Specifies the value of the Payroll Code field.';
                    ApplicationArea = All;
                }
                field(Priority; Rec.Priority)
                {
                    ToolTip = 'Specifies the value of the Priority field.';
                    ApplicationArea = All;
                }
            }
        }
        area(FactBoxes)
        {
            systempart(Control7; Notes)
            {
                ApplicationArea = All;
            }
            systempart(Control8; Links)
            {
                ApplicationArea = All;
            }
        }
    }

    actions { }
}
