page 50324 "Maker Checker Lists"
{
    ApplicationArea = All;
    Caption = 'Maker Checker Lists';
    PageType = List;
    SourceTable = "Emp. Ledg. Entry No.";
    UsageCategory = Lists;
    DeleteAllowed = false;
    CardPageId = "Maker Checker Approval Card";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Emp. Ledg. Entry No."; Rec."Emp. Ledg. Entry No.")
                {
                    ToolTip = 'Specifies the value of the Emp. Ledg. Entry No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the value of the Line No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the value of the Employee No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Type"; Rec."Type")
                {
                    ToolTip = 'Specifies the value of the Type field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Amount 2"; Rec."Amount 2")
                {
                    ToolTip = 'Specifies the value of the Amount 2 field.', Comment = '%';
                    ApplicationArea = All;
                }
            }
        }
    }
}
