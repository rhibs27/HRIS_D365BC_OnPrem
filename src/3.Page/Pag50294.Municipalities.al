page 50294 Municipalities
{
    PageType = List;
    SourceTable = Municipality;
    ApplicationArea = All;
    UsageCategory = Lists;

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
                field(Description; Rec."Municipality Name")
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = All;
                }
                field("District Code"; Rec."District Code")
                {
                    ToolTip = 'Specifies the value of the District Code field.';
                    ApplicationArea = All;
                }
                field("District Name "; Rec."District Name")
                {
                    ToolTip = 'Specifies the value of the District Name field.';
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ToolTip = 'Specifies the value of the Municipality Type field.';
                    ApplicationArea = All;
                }
                field("No of ward"; Rec."No of ward")
                {
                    ToolTip = 'Specifies the value of the No of ward field.';
                    ApplicationArea = All;
                }
            }
        }
    }
    trigger OnOpenPage()
    begin
        rec.SetCurrentKey(Type);
        Rec.SetAscending(Type, false);
    end;
}
