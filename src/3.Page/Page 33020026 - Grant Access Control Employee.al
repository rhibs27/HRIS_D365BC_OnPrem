page 33020026 "Grant Access Control Employee"
{
    // version Access Control 1.00

    CardPageId = "Access Control Employee";
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Employee Activity";
    SourceTableView = where(Type = const("Access Control"));
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
                field("Request Case"; Rec."Request Case")
                {
                    ToolTip = 'Specifies the value of the Request Case field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }
}
