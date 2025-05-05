page 50321 "Employee Insurance Lists"
{
    ApplicationArea = All;
    Caption = 'Employee Insurance Lists';
    PageType = List;
    SourceTable = "Employee Insurance Information";
    SourceTableView = where(type = const(Insurance));
    UsageCategory = Lists;
    CardPageId = "Employee Insurance Card";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Insurance No."; Rec."Insurance No.")
                {
                    ToolTip = 'Specifies the value of the Insurance No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the value of the Employee No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Insurance Type"; Rec."Insurance Type")
                {
                    ToolTip = 'Specifies the value of the Type field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Insurance Company Name"; Rec."Insurance Company Name")
                {
                    ToolTip = 'Specifies the value of the Insurance Company field.', Comment = '%';
                    ApplicationArea = All;
                }
                // field("Life Insurance Company"; Rec."Life Insurance Company")
                // {
                //     ToolTip = 'Specifies the value of the Life Insurance Company field.', Comment = '%';
                //     ApplicationArea = All;
                // }
                // field("Medical/Property Ins Company"; Rec."Medical/Property Ins Company")
                // {
                //     ToolTip = 'Specifies the value of the Medical/Property Ins Company field.', Comment = '%';
                //     ApplicationArea = All;
                // }

                field("Policy Number"; Rec."Policy Number")
                {
                    ToolTip = 'Specifies the value of the Policy Number field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Insurance Start Date (AD)"; Rec."Insurance Start Date (AD)")
                {
                    ToolTip = 'Specifies the value of the Insurance Start Date (AD) field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Insurance Start Date (BS)"; Rec."Insurance Start Date (BS)")
                {
                    ToolTip = 'Specifies the value of the Insurance Start Date (BS) field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Insurance Expiry Date (AD)"; Rec."Insurance Expiry Date (AD)")
                {
                    ToolTip = 'Specifies the value of the Insurance Expiry Date (AD) field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Insurance Expiry Date (BS)"; Rec."Insurance Expiry Date (BS)")
                {
                    ToolTip = 'Specifies the value of the Insurance Expiry Date (BS) field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Insurance Amount"; Rec."Insurance Amount")
                {
                    ToolTip = 'Specifies the value of the Insurance Amount field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Annual Premium Amount"; Rec."Annual Premium Amount")
                {
                    ToolTip = 'Specifies the value of the Annual Premium Amount field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                    ApplicationArea = All;
                }

            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Screened)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the Screened action.';
                trigger OnAction()
                begin
                    ClearAll();
                    Rec.FilterGroup(2);
                    Rec.SetRange("Approval Status", Rec."Approval Status"::Approved);
                    Rec.FilterGroup(0);
                end;
            }
            action(Rejected)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the Rejected action.';

                trigger OnAction()
                begin
                    ClearAll();
                    Rec.FilterGroup(2);
                    Rec.SetRange("Approval Status", Rec."Approval Status"::Rejected);
                    Rec.FilterGroup(0);
                end;
            }
        }
    }
    trigger OnOpenPage()

    begin
        // Rec.FilterGroup(2);
        // Rec.SetRange("Approval Status", Rec."Approval Status"::Pending);
        // Rec.FilterGroup(0)
    end;
}
