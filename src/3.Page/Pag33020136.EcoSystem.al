page 33020136 "Eco-System"
{
    ApplicationArea = All;
    Caption = 'Eco-System';
    PageType = List;
    SourceTable = "Employee Hierarchy Master";
    UsageCategory = Lists;
    SourceTableView = where(Type = filter('Eco-System'));

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';
                }
            }
        }
    }
    trigger OnOpenPage()
    begin
        Rec.Type := Rec.Type::"Eco-System";
    end;
}
