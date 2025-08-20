page 50177 "Biometric Branches"
{
    ApplicationArea = All;
    Caption = 'Biometric Branches';
    PageType = List;
    SourceTable = "Biometric Branch";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Branch Code"; Rec."Branch Code")
                {
                    ToolTip = 'Specifies the value of the Branch Code field.';
                }
                field("Branch Name"; Rec."Branch Name")
                {
                    ToolTip = 'Specifies the value of the Branch Name field.';
                }
                field("No of Devices"; Rec."No of Devices")
                {
                    ToolTip = 'Specifies the value of the No of Devices field.';
                    DrillDownPageId = "Biometric Device Config.";
                }
            }
        }
    }
}
