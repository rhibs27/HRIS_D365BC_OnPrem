page 50395 "Cancelled Update Atten. List"
{
    CardPageId = "Cancel Document";
    Editable = false;
    PageType = List;
    Caption = 'Cancelled Update Attendance List';
    SourceTable = "Cancel Document";
    SourceTableView = WHERE(Type = CONST("Attendance Missed"),
                            Cancelled = CONST(true));
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                    ApplicationArea = All;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the value of the Employee No. field.';
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.';
                    ApplicationArea = All;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.';
                    ApplicationArea = All;
                }
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
                field("CheckIn Time"; rec."CheckIn Time")
                {
                    ApplicationArea = All;
                }
                field("CheckOut Time"; rec."CheckOut Time")
                {
                    ApplicationArea = All;
                }
                field("Requested Date"; Rec."Requested Date")
                {
                    ToolTip = 'Specifies the value of the Requested Date field.';
                    ApplicationArea = All;
                }
                field("Cancelled Document No."; Rec."Cancelled Document No.")
                {
                    ToolTip = 'Specifies the value of the Cancelled Document No. field.';
                    ApplicationArea = All;
                }
            }
        }
    }
}
