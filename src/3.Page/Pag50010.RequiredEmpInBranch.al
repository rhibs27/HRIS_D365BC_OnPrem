page 50010 "Required Emp In Branch"
{
    PageType = List;
    SourceTable = "Required Emp In Branch";
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
                field("Functional Title"; Rec."Functional Title")
                {
                    ToolTip = 'Specifies the value of the Functional Title field.';
                    ApplicationArea = All;
                }
                field("Functional Tilte Description"; Rec."Functional Tilte Description")
                {
                    ToolTip = 'Specifies the value of the Functional Tilte Description field.';
                    ApplicationArea = All;
                }
                field("Required Employee"; Rec."Required Employee")
                {
                    ToolTip = 'Specifies the value of the Required Employee field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }
}
