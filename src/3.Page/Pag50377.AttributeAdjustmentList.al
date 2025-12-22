page 50377 "Attribute Adjustment List"
{
    PageType = List;
    SourceTable = "Attribute Adjustment Header";
    ApplicationArea = All;
    Caption = 'Attribute Adjustments';
    UsageCategory = Lists;
    CardPageID = "Attribute Adjustment Card";
    ModifyAllowed = false;
    DeleteAllowed = false;
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

        }
    }
}
