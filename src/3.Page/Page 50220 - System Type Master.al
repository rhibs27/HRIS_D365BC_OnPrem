page 50220 "System Type Master"
{
    // version Access Control 1.00

    PageType = List;
    SourceTable = "System Access Control";
    SourceTableView = where("Type of Masters" = const("System Type"));
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
                    Caption = 'System Type Code';
                    ToolTip = 'Specifies the value of the System Type Code field.';
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    Caption = 'System Type Name';
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
            }
        }
    }

    actions { }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Type of Masters" := Rec."Type of Masters"::"System Type";
    end;
}
