page 50248 "Shift Assignment"
{
    ApplicationArea = All;
    Caption = 'Shift Assignment';
    PageType = List;
    SourceTable = "Shift Assignment Header";
    UsageCategory = Lists;
    CardPageId = "Shift Assignment Card";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.', Comment = '%';
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.', Comment = '%';
                }
                field("Deputation Name"; Rec."Deputation Name")
                {
                    ToolTip = 'Specifies the value of the Deputation Name field.', Comment = '%';
                }
                field("Deputation Type"; Rec."Deputation Type")
                {
                    ToolTip = 'Specifies the value of the Deputation Type field.', Comment = '%';
                }
                field("From Date"; Rec."From Date")
                {
                    ToolTip = 'Specifies the value of the From Date field.', Comment = '%';
                }
                field("To Date"; Rec."To Date")
                {
                    ToolTip = 'Specifies the value of the To Date field.', Comment = '%';
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.', Comment = '%';
                }
            }
        }
    }
}
