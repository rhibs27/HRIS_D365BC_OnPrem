page 33019827 "Payroll Column Configuration"
{
    // version PRM19.01.01

    DelayedInsert = true;
    PageType = List;
    SourceTable = "Payroll Column Configuration";
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Table No."; Rec."Table No.")
                {
                    ToolTip = 'Specifies the value of the Table No. field.';
                    ApplicationArea = All;
                }
                field("Field No."; Rec."Field No.")
                {
                    ToolTip = 'Specifies the value of the Field No. field.';
                    ApplicationArea = All;
                }
                field("Variable Field Code"; Rec."Variable Field Code")
                {
                    ToolTip = 'Specifies the value of the Variable Field Code field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }
}
