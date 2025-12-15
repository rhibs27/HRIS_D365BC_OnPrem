page 50376 "Attribute Adjustment List"
{
    PageType = List;
    SourceTable = "Attribute Adjustment Header";
    ApplicationArea = All;
    Caption = 'Attribute Adjustments';
    UsageCategory = Lists;
    CardPageID = "Attribute Adjustment Card";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document No."; Rec."Document No.") { ApplicationArea = All; }
                field("Pay Cycle Code"; Rec."Pay Cycle Code") { ApplicationArea = All; }
                field("Pay Cycle Term"; Rec."Pay Cycle Term") { ApplicationArea = All; }
                field("Pay Cycle Period"; Rec."Pay Cycle Period") { ApplicationArea = All; }
                field("Approval Status"; Rec."Approval Status") { ApplicationArea = All; }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Get Additional Attibutes")
            {
                ApplicationArea = All;
                Caption = 'Get Additional Attributes';
                Image = GetLines;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                trigger OnAction()
                begin

                end;
            }
        }
    }
}
