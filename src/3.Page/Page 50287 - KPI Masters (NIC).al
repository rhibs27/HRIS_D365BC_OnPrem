page 50287 "KPI Masters (NIC)"
{
    // version KPI1.00

    PageType = List;
    SourceTable = "KPI Master NIC";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("KPI No."; Rec."KPI No.")
                {
                    ToolTip = 'Specifies the value of the KPI No. field.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = All;
                }
                field(Blocked; Rec.Blocked)
                {
                    ToolTip = 'Specifies the value of the Blocked field.';
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ToolTip = 'Specifies the value of the Type field.';
                    ApplicationArea = All;
                }
                field("Is Department"; Rec."Is Department")
                {
                    ToolTip = 'Specifies the value of the Is Department field.';
                    ApplicationArea = All;
                }
                field("Is Operating Profit"; Rec."Is Operating Profit")
                {
                    ToolTip = 'Specifies the value of the Is Operating Profit field.';
                    ApplicationArea = All;
                }
                field("Is Adjustment KPI"; Rec."Is Adjustment KPI")
                {
                    ToolTip = 'Specifies the value of the Is Adjustment KPI field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }
}
