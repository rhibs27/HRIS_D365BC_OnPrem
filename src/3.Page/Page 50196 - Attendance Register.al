page 50196 "Attendance Register"
{
    // version AMS6.1.0

    InsertAllowed = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Attendance';
    SourceTable = "Attendance Register";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Journal Template Name"; Rec."Journal Template Name")
                {
                    ToolTip = 'Specifies the value of the Journal Template Name field.';
                    ApplicationArea = All;
                }
                field("Journal Batch Name"; Rec."Journal Batch Name")
                {
                    ToolTip = 'Specifies the value of the Journal Batch Name field.';
                    ApplicationArea = All;
                }
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
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
                field("Attendance From"; Rec."Attendance From")
                {
                    ToolTip = 'Specifies the value of the Attendance From field.';
                    ApplicationArea = All;
                }
                field("Attendance To"; Rec."Attendance To")
                {
                    ToolTip = 'Specifies the value of the Attendance To field.';
                    ApplicationArea = All;
                }
                field("Present Days"; Rec."Present Days")
                {
                    ToolTip = 'Specifies the value of the Present Days field.';
                    ApplicationArea = All;
                }
                field("Absent Days"; Rec."Absent Days")
                {
                    ToolTip = 'Specifies the value of the Absent Days field.';
                    ApplicationArea = All;
                }
                field("Paid Days"; Rec."Paid Days")
                {
                    ToolTip = 'Specifies the value of the Paid Days field.';
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.';
                    ApplicationArea = All;
                }
                field("Source Code"; Rec."Source Code")
                {
                    ToolTip = 'Specifies the value of the Source Code field.';
                    ApplicationArea = All;
                }
                field("Posting No. Series"; Rec."Posting No. Series")
                {
                    ToolTip = 'Specifies the value of the Posting No. Series field.';
                    ApplicationArea = All;
                }
                field("Source No."; Rec."Source No.")
                {
                    ToolTip = 'Specifies the value of the Source No. field.';
                    ApplicationArea = All;
                }
                field("Total Holidays"; Rec."Total Holidays")
                {
                    ToolTip = 'Specifies the value of the Total Holidays field.';
                    ApplicationArea = All;
                }
                field("Late Ded"; Rec."Late Ded")
                {
                    ToolTip = 'Specifies the value of the Late Ded field.';
                    ApplicationArea = All;
                }
                field("Unpaid Days"; Rec."Unpaid Days")
                {
                    ToolTip = 'Specifies the value of the Unpaid Days field.';
                    ApplicationArea = All;
                }
                field("Actual PaidDays"; Rec."Actual PaidDays")
                {
                    ToolTip = 'Specifies the value of the Actual PaidDays field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Ledger Entries")
            {
                Caption = 'Ledger Entries';
                Image = SelectEntries;
                Promoted = true;
                PromotedCategory = Category4;
                RunObject = page "Attendance Ledger Entries";
                RunPageLink = "Journal Template Name" = field("Journal Template Name"),
                              "Journal Batch Name" = field("Journal Batch Name"),
                              "No." = field("No."),
                              "Journal Line No." = field("Line No."),
                              "Employee No." = field("Employee No.");
                ToolTip = 'Executes the Ledger Entries action.';
                ApplicationArea = All;
            }
        }
    }
}
