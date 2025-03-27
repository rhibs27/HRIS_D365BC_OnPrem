page 50071 "Employee KPI List"
{
    InsertAllowed = false;
    PageType = List;
    SourceTable = "OT Encashment Setup";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Encashment Code"; Rec."Encashment Code")
                {
                    ToolTip = 'Specifies the value of the Encashment Code field.';
                    ApplicationArea = All;
                }
                field("Attribute Code"; Rec."Attribute Code")
                {
                    ToolTip = 'Specifies the value of the Attribute Code field.';
                    ApplicationArea = All;
                }
                // field("Weightage (%)"; "Weightage (%)")
                // {
                // }
                // field(Target; Target)
                // {
                // }
                // field(Remarks; Remarks)
                // {
                // }
            }
        }
    }

    actions { }
}
