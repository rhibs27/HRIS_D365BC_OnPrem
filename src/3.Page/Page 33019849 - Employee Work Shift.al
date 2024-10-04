page 33019849 "Employee Work Shift"
{
    // version ATM.19.01.01

    PageType = List;
    SourceTable = "Employee Work Shift";
    UsageCategory = Lists;
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
                field("Start Time"; Rec."Start Time")
                {
                    ToolTip = 'Specifies the value of the Start Time field.';
                    ApplicationArea = All;
                }
                field("End Time"; Rec."End Time")
                {
                    ToolTip = 'Specifies the value of the End Time field.';
                    ApplicationArea = All;
                }
                field("Working Hour"; Rec."Working Hour")
                {
                    ToolTip = 'Specifies the value of the Working Hour field.';
                    ApplicationArea = All;
                }
                field("Lunch Start"; Rec."Lunch Start")
                {
                    ToolTip = 'Specifies the value of the Lunch Start field.';
                    ApplicationArea = All;
                }
                field("Winter End Time"; Rec."Winter End Time")
                {
                    ToolTip = 'Specifies the value of the Winter End Time field.';
                    ApplicationArea = All;
                }
                field("Friday End Time"; Rec."Friday End Time")
                {
                    ToolTip = 'Specifies the value of the Friday End Time field.';
                    ApplicationArea = All;
                }
                field("Winter Start Date"; Rec."Winter Start Date")
                {
                    ToolTip = 'Specifies the value of the Winter Start Date field.';
                    ApplicationArea = All;
                }
                field("Winter End Date"; Rec."Winter End Date")
                {
                    ToolTip = 'Specifies the value of the Winter End Date field.';
                    ApplicationArea = All;
                }
                field("Registered Employees"; Rec."Registered Employees")
                {
                    ToolTip = 'Specifies the value of the Registered Employees field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }
}
