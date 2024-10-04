page 33019877 "KRA List"
{
    CardPageId = "KRA List";
    PageType = List;
    SourceTable = "KRA Master";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("KRA Category"; Rec."KRA Category")
                {
                    ToolTip = 'Specifies the value of the KRA Category field.';
                    ApplicationArea = All;

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit then
                            CurrPage.Update;
                    end;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ToolTip = 'Specifies the value of the Type field.';
                    ApplicationArea = All;
                }
                field("Code"; Rec.Code)
                {
                    ToolTip = 'Specifies the value of the Code field.';
                    ApplicationArea = All;
                }
                field("Weightage (%)"; Rec."Weightage (%)")
                {
                    ToolTip = 'Specifies the value of the Weightage (%) field.';
                    ApplicationArea = All;
                }
            }
        }
        area(FactBoxes)
        {
            systempart(Control6; Notes)
            {
                ApplicationArea = All;
            }
            systempart(Control7; Links)
            {
                ApplicationArea = All;
            }
        }
    }

    actions { }
}
