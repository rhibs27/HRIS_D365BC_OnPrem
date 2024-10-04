page 33019874 "KRA Card"
{
    PageType = Card;
    SourceTable = "KRA Master";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("KRA Category"; Rec."KRA Category")
                {
                    ToolTip = 'Specifies the value of the KRA Category field.';
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
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = All;
                }
                field("Weightage (%)"; Rec."Weightage (%)")
                {
                    ToolTip = 'Specifies the value of the Weightage (%) field.';
                    ApplicationArea = All;
                }
            }
            part(Control3; "KPI Master")
            {
                ShowFilter = false;
                SubPageLink = "KRA Category" = field("KRA Category");
                ApplicationArea = All;
            }
        }
    }

    actions { }

    trigger OnOpenPage()
    begin
        AppraisalSetup.Get;
        Rec."Weightage (%)" := AppraisalSetup.Weightage;
    end;

    var
        AppraisalSetup: Record "KRA Master Setup";
}
