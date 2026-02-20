page 50235 "Employee Edit list"
{
    ApplicationArea = All;
    Editable = false;
    // InsertAllowed = false;
    // DeleteAllowed = false;
    PageType = List;
    SourceTable = "Employee Edit";
    UsageCategory = Lists;
    CardPageId = "Employee Edit Card";
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
                field("Changes In Employee Type"; Rec."Changes In Employee Type")
                {
                    ToolTip = 'Specifies the value of the Changes In Employee Type field.';
                    ApplicationArea = All;
                }
                field("Requested Date"; Rec."Requested Date")
                {
                    ToolTip = 'Specifies the value of the Requested Date field.';
                    ApplicationArea = All;
                }
                field("Vehicle Type"; Rec."Vehicle Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Vehicle Type field.';
                }
                field("Vehicle No."; Rec."Vehicle No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Vehicle No. field.';
                }
                field("Vehicle Owner Name"; Rec."Vehicle Owner Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Vehicle Owner Name field.', Comment = '%';
                }
                field("Ownership Start/End Date"; Rec."Ownership Start/End Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Ownership Start/End Date field.', Comment = '%';
                }
                field("Claim Type"; Rec."Claim Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Claim Type field.', Comment = '%';
                }
                field("Claimed Type Effective Date"; Rec."Claimed Type Effective Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Claimed Type Effective Date field.', Comment = '%';
                }
                field("Approved Date"; Rec."Approved Date")
                {
                    ToolTip = 'Specifies the value of the Approved Date field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Rejection Remarks"; Rec."Rejection Remarks")
                {
                    ToolTip = 'Specifies the value of the Rejection Remarks field.';
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }

    actions { }
}
