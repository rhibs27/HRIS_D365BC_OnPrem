page 50212 "Employeewise KPI List"
{
    PageType = ListPart;
    SourceTable = "OT Encashment Setup";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Encashment Code"; Rec."Encashment Code")
                {
                    ToolTip = 'Specifies the value of the Encashment Code field.';
                    ApplicationArea = All;
                }
                field(Period; Rec.Period)
                {
                    ToolTip = 'Specifies the value of the Period field.';
                    ApplicationArea = All;
                }
                field("Attribute Code"; Rec."Attribute Code")
                {
                    ToolTip = 'Specifies the value of the Attribute Code field.';
                    ApplicationArea = All;
                }
                // field("Weightage (%)"; "Weightage (%)")
                // {
                //     ToolTip = 'Specifies the value of the Weightage (%) field.';
                //     ApplicationArea = All;
                // }
                // field(Target; Target)
                // {
                //     ToolTip = 'Specifies the value of the Target field.';
                //     ApplicationArea = All;
                // }
                // field("Employee No."; "Employee No.")
                // {
                //     ToolTip = 'Specifies the value of the Employee No. field.';
                //     ApplicationArea = All;
                // }
                // field(Remarks; Remarks)
                // {
                //     ToolTip = 'Specifies the value of the Remarks field.';
                //     ApplicationArea = All;
                // }
            }
        }
    }

    actions { }
}
