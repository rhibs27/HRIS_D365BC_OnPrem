page 50189 "Employee Code Mapping"
{
    // version AMS6.1.0

    PageType = List;
    SourceTable = "Employee Code Mapping";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Employee Code"; Rec."Employee Code")
                {
                    ToolTip = 'Specifies the value of the Employee Code field.';
                    ApplicationArea = All;
                }
                field("Employee Mapping Code"; Rec."Employee Mapping Code")
                {
                    ToolTip = 'Specifies the value of the Employee Mapping Code field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }
}
