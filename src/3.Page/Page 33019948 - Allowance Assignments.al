page 33019948 "Allowance Assignments"
{
    CardPageId = "Allowance Assignment Card";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Allowance Assignment Header";
    UsageCategory = Lists;
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
                field(Type; Rec.Type)
                {
                    ToolTip = 'Specifies the value of the Type field.';
                    ApplicationArea = All;
                }
                field("Code"; Rec.Code)
                {
                    ToolTip = 'Specifies the value of the Code field.';
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.';
                    ApplicationArea = All;
                }
                field("English Month"; Rec."English Month")
                {
                    ToolTip = 'Specifies the value of the English Month field.';
                    ApplicationArea = All;
                }
                field("English Year"; Rec."English Year")
                {
                    ToolTip = 'Specifies the value of the English Year field.';
                    ApplicationArea = All;
                }
                field(Week; Rec.Week)
                {
                    ToolTip = 'Specifies the value of the Week field.';
                    ApplicationArea = All;
                }
                field("From Date"; Rec."From Date")
                {
                    ToolTip = 'Specifies the value of the From Date field.';
                    ApplicationArea = All;
                }
                field("To date"; Rec."To date")
                {
                    ToolTip = 'Specifies the value of the To date field.';
                    ApplicationArea = All;
                }
                field("Created Date"; Rec."Created Date")
                {
                    ToolTip = 'Specifies the value of the Created Date field.';
                    ApplicationArea = All;
                }
                field("Created By"; Rec."Created By")
                {
                    ToolTip = 'Specifies the value of the Created By field.';
                    ApplicationArea = All;
                }
                field("Last Modified Date"; Rec."Last Modified Date")
                {
                    ToolTip = 'Specifies the value of the Last Modified Date field.';
                    ApplicationArea = All;
                }
                field("Last Modified By"; Rec."Last Modified By")
                {
                    ToolTip = 'Specifies the value of the Last Modified By field.';
                    ApplicationArea = All;
                }
                field("Approved Date"; Rec."Approved Date")
                {
                    ToolTip = 'Specifies the value of the Approved Date field.';
                    ApplicationArea = All;
                }
                field("Approver ID"; Rec."Approver ID")
                {
                    ToolTip = 'Specifies the value of the Approver ID field.';
                    ApplicationArea = All;
                }
                field("Approver Name"; Rec."Approver Name")
                {
                    ToolTip = 'Specifies the value of the Approver Name field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Create Allowance Header")
            {
                Image = CreateBins;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Create Allowance Header action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if not Confirm('Do you want to created allowance header for all branch and extension counter?') then
                        exit;
                    LoanMgt.InsertAllowanceHeader();
                end;
            }
        }
    }

    var
        LoanMgt: Codeunit "Loan Mgt.";
}
