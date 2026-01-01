page 50365 "Allowance Configurations"
{
    ApplicationArea = All;
    Caption = 'Allowance Configurations';
    PageType = List;
    SourceTable = "Allowance Configuration";
    UsageCategory = Tasks;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.', Comment = '%';
                }
                field("Payroll Attribute"; Rec."Payroll Attribute")
                {
                    ToolTip = 'Specifies the value of the Payroll Attribute field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.', Comment = '%';
                }
                field("Province Code"; Rec."Province Code")
                {
                    ToolTip = 'Specifies the value of the Province Code field.', Comment = '%';
                }
                field("Branch Code"; Rec."Branch Code")
                {
                    ToolTip = 'Specifies the value of the Branch Code field.', Comment = '%';
                }
                field("Department Code"; Rec."Department Code")
                {
                    ToolTip = 'Specifies the value of the Department Code field.', Comment = '%';
                }
                field("Employment Type"; Rec."Employment Type")
                {
                    ToolTip = 'Specifies the value of the Employment Type field.', Comment = '%';
                }
                field("Employee Work Shift"; Rec."Employee Work Shift")
                {
                    ToolTip = 'Specifies the value of the Employee Work Shift field.', Comment = '%';
                }
                field("Salary Level"; Rec."Salary Level")
                {
                    ToolTip = 'Specifies the value of the Salary Level field.', Comment = '%';
                }
                field("Min Service Yr. Eligibility"; Rec."Min Service Yr. Eligibility")
                {
                    ToolTip = 'Specifies the value of the Min Service Yr. Eligibility field.', Comment = '%';
                }
                field("Functional Title"; Rec."Functional Title")
                {
                    ToolTip = 'Specifies the value of the Functional Title field.', Comment = '%';
                }
                field("Earning Cycle"; Rec."Earning Cycle")
                {
                    ToolTip = 'Specifies the value of the Earning Cycle field.', Comment = '%';
                }
                field("ATM Site"; Rec."ATM Site")
                {
                    ToolTip = 'Specifies the value of the ATM Site field.', Comment = '%';
                }
                field("Leave Code"; Rec."Leave Code")
                {
                    ToolTip = 'Specifies the value of the Leave Code field.', Comment = '%';
                }
                field("Outside/Inside Valley"; Rec."Outside/Inside Valley")
                {
                    ToolTip = 'Specifies the value of the Outside/Inside Valley field.', Comment = '%';
                }
                field(Region; Rec.Region)
                {
                    ToolTip = 'Specifies the value of the Region field.', Comment = '%';
                }
                field("Remote Area Category"; Rec."Remote Area Category")
                {
                    ToolTip = 'Specifies the value of the Remote Area Category field.', Comment = '%';
                }
                field(Source; Rec.Source)
                {
                    ToolTip = 'Specifies the value of the Source field.', Comment = '%';
                }
                field(Formula; Rec.Formula)
                {
                    ToolTip = 'Specifies the value of the Formula field.', Comment = '%';
                }
                field("Specific Payroll Attribute"; Rec."Specific Payroll Attribute")
                {
                    ToolTip = 'Specifies the value of the Specific Payroll Attribute field.', Comment = '%';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("&Archive")
            {
                Image = Archive;
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the &Archive action.';
                trigger OnAction()
                var
                    PayrollArchive: Record "Payroll Archive";
                    RecRef: RecordRef;
                begin

                    RecRef.Open(Database::"Allowance Configuration");
                    RecRef.Get(Rec.RecordId);
                    PayrollArchive.RunArchive(RecRef.Number);
                end;
            }
        }
    }
}
