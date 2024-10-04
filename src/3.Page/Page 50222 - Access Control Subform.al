page 50222 "Access Control Subform"
{
    // version Access Control 1.00

    AutoSplitKey = true;
    PageType = ListPart;
    SourceTable = "Access Control Details";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("System Type Code"; Rec."System Type Code")
                {
                    ToolTip = 'Specifies the value of the System Type Code field.';
                    ApplicationArea = All;
                }
                field("System Type Name"; Rec."System Type Name")
                {
                    ToolTip = 'Specifies the value of the System Type Name field.';
                    ApplicationArea = All;
                }
                field("System Category Code"; Rec."System Category Code")
                {
                    ToolTip = 'Specifies the value of the System Category Code field.';
                    ApplicationArea = All;
                }
                field("System Category Name"; Rec."System Category Name")
                {
                    ToolTip = 'Specifies the value of the System Category Name field.';
                    ApplicationArea = All;
                }
                field("Granted Date"; Rec."Granted Date")
                {
                    ToolTip = 'Specifies the value of the Granted Date field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }
}
