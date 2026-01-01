page 50230 "Overtime Bulk List"
{
    ApplicationArea = All;
    Caption = 'Overtime Bulk List';
    CardPageId = "Overtime Bulk Card";
    PageType = List;
    SourceTable = "OverTime";
    SourceTableView = where(type = filter("Employee Activity Type"::"Overtime Bulk"));
    UsageCategory = Lists;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No"; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the Emp Act. No field.';
                    ApplicationArea = All;
                }
                field("Deputation Type"; Rec."Deputation Type") { }
                field("Deputation Code"; Rec."Deputation Code") { }
                field("Deputation Name"; Rec."Deputation Name") { }
                field("Start Date"; Rec."Start Date")
                {
                    ToolTip = 'Specifies the value of the Start Date field.';
                    ApplicationArea = All;
                }
                field("End Date"; Rec."End Date")
                {
                    ToolTip = 'Specifies the value of the End Date field.';
                    ApplicationArea = All;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.';
                    ApplicationArea = All;
                }
                field(Status; Rec.Status) { }
                field("Fiscal Year"; Rec."Fiscal Year")
                {
                    ToolTip = 'Specifies the value of the Fiscal Year field.';
                    ApplicationArea = All;
                }
                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field.';
                    ApplicationArea = All;
                }
            }
        }
    }
    actions { }
}
