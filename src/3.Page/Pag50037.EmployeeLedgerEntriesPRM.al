page 50037 "Employee Ledger Entries PRM"
{
    // version PRM19.01.01

    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Employee Ledger Entry PRM";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.';
                    ApplicationArea = All;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the value of the Employee No. field.';
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.';
                    ApplicationArea = All;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ToolTip = 'Specifies the value of the Document Type field.';
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.';
                    ApplicationArea = All;
                }
                field("Source Code"; Rec."Source Code")
                {
                    ToolTip = 'Specifies the value of the Source Code field.';
                    ApplicationArea = All;
                }
                field("Pay Cycle Code"; Rec."Pay Cycle Code")
                {
                    ToolTip = 'Specifies the value of the Pay Cycle Code field.';
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Employee Name field.';
                    ApplicationArea = All;
                }
                field("Pay Cycle Term"; Rec."Pay Cycle Term")
                {
                    ToolTip = 'Specifies the value of the Pay Cycle Term field.';
                    ApplicationArea = All;
                }
                field("Pay Cycle Period"; Rec."Pay Cycle Period")
                {
                    ToolTip = 'Specifies the value of the Pay Cycle Period field.';
                    ApplicationArea = All;
                }
                field("Pay Period Start Date"; Rec."Pay Period Start Date")
                {
                    ToolTip = 'Specifies the value of the Pay Period Start Date field.';
                    ApplicationArea = All;
                }
                field("Pay Period End Date"; Rec."Pay Period End Date")
                {
                    ToolTip = 'Specifies the value of the Pay Period End Date field.';
                    ApplicationArea = All;
                }
                field(Open; Rec.Open)
                {
                    ToolTip = 'Specifies the value of the Open field.';
                    ApplicationArea = All;
                }
                field("Creation Date"; Rec."Creation Date")
                {
                    ToolTip = 'Specifies the value of the Creation Date field.';
                    ApplicationArea = All;
                }
                field("User ID"; Rec."User ID")
                {
                    ToolTip = 'Specifies the value of the User ID field.';
                    ApplicationArea = All;
                }
                field("Date Filter"; Rec."Date Filter")
                {
                    ToolTip = 'Specifies the value of the Date Filter field.';
                    ApplicationArea = All;
                }
                field("Present Days"; Rec."Present Days")
                {
                    ToolTip = 'Specifies the value of the Present Days field.';
                    ApplicationArea = All;
                }
                field("Week off Days"; Rec."Week off Days")
                {
                    ToolTip = 'Specifies the value of the Week off Days field.';
                    ApplicationArea = All;
                }
                field("Leave Days"; Rec."Leave Days")
                {
                    ToolTip = 'Specifies the value of the Leave Days field.';
                    ApplicationArea = All;
                }
                field("Absent Days"; Rec."Absent Days")
                {
                    ToolTip = 'Specifies the value of the Absent Days field.';
                    ApplicationArea = All;
                }
                field("Total Days"; Rec."Total Days")
                {
                    ToolTip = 'Specifies the value of the Total Days field.';
                    ApplicationArea = All;
                }
                field("Tour Days"; Rec."Tour Days")
                {
                    ToolTip = 'Specifies the value of the Tour Days field.';
                    ApplicationArea = All;
                }
                field("Half Days"; Rec."Half Days")
                {
                    ToolTip = 'Specifies the value of the Half Days field.';
                    ApplicationArea = All;
                }
                field("Late Days"; Rec."Late Days")
                {
                    ToolTip = 'Specifies the value of the Late Days field.';
                    ApplicationArea = All;
                }
                field("Overtime Days"; Rec."Overtime Days")
                {
                    ToolTip = 'Specifies the value of the Overtime Days field.';
                    ApplicationArea = All;
                }
                field("Late Rate"; Rec."Late Rate")
                {
                    ToolTip = 'Specifies the value of the Late Rate field.';
                    ApplicationArea = All;
                }
                field(Narration; Rec.Narration)
                {
                    ToolTip = 'Specifies the value of the Narration field.';
                    ApplicationArea = All;
                }
                field("G/L Document No"; Rec."G/L Document No")
                {
                    ToolTip = 'Specifies the value of the G/L Document No field.';
                    ApplicationArea = All;
                }
                field("Posted Payroll Plan No."; Rec."Posted Payroll Plan No.")
                {
                    ToolTip = 'Specifies the value of the Posted Payroll Plan No. field.';
                    ApplicationArea = All;
                }
                field("Posted Payroll Plan Line No."; Rec."Posted Payroll Plan Line No.")
                {
                    ToolTip = 'Specifies the value of the Posted Payroll Plan Line No. field.';
                    ApplicationArea = All;
                }
                field("Payroll Attribute Code"; Rec."Payroll Attribute Code")
                {
                    ToolTip = 'Specifies the value of the Payroll Attribute Code field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action("&Navigate")
            {
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ToolTip = 'Executes the &Navigate action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.Navigate;
                end;
            }
        }
    }
}
