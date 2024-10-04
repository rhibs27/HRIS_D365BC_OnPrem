page 33019938 "Email Template Card"
{
    // version NP16.04

    PageType = Card;
    SourceTable = "Email Template";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(General)
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
                field(Subject; Rec.Subject)
                {
                    ToolTip = 'Specifies the value of the Subject field.';
                    ApplicationArea = All;
                }
                field("Email reciepent"; Rec."Email reciepent")
                {
                    Caption = 'Email Reciepent';
                    Visible = false;
                    ToolTip = 'Specifies the value of the Email Reciepent field.';
                    ApplicationArea = All;
                }
                field("Document Profile"; Rec."Document Profile")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Document Profile field.';
                    ApplicationArea = All;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ToolTip = 'Specifies the value of the Document Type field.';
                    ApplicationArea = All;
                }
                field("Sub Type"; Rec."Sub Type")
                {
                    ToolTip = 'Specifies the value of the Sub Type field.';
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ToolTip = 'Specifies the value of the Type field.';
                    ApplicationArea = All;
                }
                field("Loan Type"; Rec."Loan Type")
                {
                    ToolTip = 'Specifies the value of the Loan Type field.';
                    ApplicationArea = All;
                }
                field("Memo Type"; Rec."Memo Type")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Memo Type field.';
                    ApplicationArea = All;
                }
                // field("Product Segment"; Rec."Product Segment")
                // {
                //     Visible = false;
                //     ToolTip = 'Specifies the value of the Product Segment field.';
                //     ApplicationArea = All;
                // }
            }
            part(Message; "Email Template Messages")
            {
                SubPageLink = "Template Code" = field(Code);
                ApplicationArea = All;
            }
            part(Receipents; "Email Template Receipents")
            {
                SubPageLink = "Email Template Code" = field(Code);
                ApplicationArea = All;
            }
        }
        area(FactBoxes)
        {
            systempart(Control1000000010; Notes)
            {
                ApplicationArea = All;
            }
            systempart(Control1000000011; Links)
            {
                ApplicationArea = All;
            }
        }
    }

    actions { }
}
