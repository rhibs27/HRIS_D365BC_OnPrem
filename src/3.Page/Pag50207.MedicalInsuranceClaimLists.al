page 50207 "Medical Insurance Claim Lists"
{
    CardPageId = "Medical Insurance Claim";
    PageType = List;
    SourceTable = "Medical Insurance Claim";
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
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.';
                    ApplicationArea = All;
                }
                field("Contact No."; Rec."Contact No.")
                {
                    ToolTip = 'Specifies the value of the Contact No. field.';
                    ApplicationArea = All;
                }
                field("Bank Account No."; Rec."Bank Account No.")
                {
                    ToolTip = 'Specifies the value of the Bank Account No. field.';
                    ApplicationArea = All;
                }
                field("Discharge Date"; Rec."Discharge Date")
                {
                    ToolTip = 'Specifies the value of the Discharge Date field.';
                    ApplicationArea = All;
                }
                field("Medical Prescription Date"; Rec."Medical Prescription Date")
                {
                    ToolTip = 'Specifies the value of the Medical Prescription Date field.';
                    ApplicationArea = All;
                }
                field("Total Insurance Claim Amount"; Rec."Total Insurance Claim Amount")
                {
                    ToolTip = 'Specifies the value of the Total Insurance Claim Amount field.';
                    ApplicationArea = All;
                }
                field("Child Name"; Rec."Child Name")
                {
                    ToolTip = 'Specifies the value of the Child Name field.';
                    ApplicationArea = All;
                }
                field("Spouse Name"; Rec."Spouse Name")
                {
                    ToolTip = 'Specifies the value of the Spouse Name field.';
                    ApplicationArea = All;
                }
                field("Mother Name"; Rec."Mother Name")
                {
                    ToolTip = 'Specifies the value of the Mother Name field.';
                    ApplicationArea = All;
                }
                field("Father Name"; Rec."Father Name")
                {
                    ToolTip = 'Specifies the value of the Father Name field.';
                    ApplicationArea = All;
                }
                field("Insurance Claim"; Rec."Insurance Claim")
                {
                    ToolTip = 'Specifies the value of the Insurance Claim field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions { }
}
