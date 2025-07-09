page 50264 "Service Inactivity Details"
{
    ApplicationArea = All;
    Caption = 'Service Inactivity Ledger List';
    PageType = List;
    SourceTable = "Service Inactivity Ledger";
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.', Comment = '%';
                }
                field("Start Date"; Rec."Start Date")
                {
                    ToolTip = 'Specifies the value of the Start Date field.', Comment = '%';
                }
                field("End Date"; Rec."End Date")
                {
                    ToolTip = 'Specifies the value of the End Date field.', Comment = '%';
                }
                field("No of days"; Rec."No of days")
                {
                    ToolTip = 'Specifies the value of the No of days field.', Comment = '%';
                }
                field("Source Doc No"; Rec."Source Doc No")
                {
                    ToolTip = 'Specifies the value of the Source Doc No field.', Comment = '%';
                }
                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field.', Comment = '%';
                }
            }
        }
    }
}
