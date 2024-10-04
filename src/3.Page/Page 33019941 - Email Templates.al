page 33019941 "Email Templates"
{
    // version NP16.04

    CardPageId = "Email Template Card";
    Editable = false;
    PageType = List;
    SourceTable = "Email Template";
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
                field("Document Profile"; Rec."Document Profile")
                {
                    ToolTip = 'Specifies the value of the Document Profile field.';
                    ApplicationArea = All;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ToolTip = 'Specifies the value of the Document Type field.';
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ToolTip = 'Specifies the value of the Type field.';
                    ApplicationArea = All;
                }
                field(Subject; Rec.Subject)
                {
                    ToolTip = 'Specifies the value of the Subject field.';
                    ApplicationArea = All;
                }
            }
        }
        area(FactBoxes)
        {
            systempart(Control1000000009; Notes)
            {
                ApplicationArea = All;
            }
            systempart(Control1000000010; Links)
            {
                ApplicationArea = All;
            }
        }
    }

    actions { }
}
