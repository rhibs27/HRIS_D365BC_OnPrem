page 50376 "Attribute Adjustment List"
{
    PageType = List;
    SourceTable = "Attribute Adjustment Header";
    ApplicationArea = All;
    Caption = 'Attribute Adjustment';
    UsageCategory = Lists;
    CardPageID = "Attribute Adjustment Card";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document No."; Rec."Document No.") { ApplicationArea = All; }
                field("Document Type"; Rec."Document Type") { ApplicationArea = All; }
                field("Pay Cycle Code"; Rec."Pay Cycle Code") { ApplicationArea = All; }
                field("Approval Status"; Rec."Approval Status") { ApplicationArea = All; }
            }
        }
    }

    actions
    {
        area(processing)
        {

        }
    }
}
