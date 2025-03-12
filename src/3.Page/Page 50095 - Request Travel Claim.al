page 50095 "Request Travel Claim"
{
    // version NIC Asia1.00,Travel

    PageType = Card;
    SourceTable = "Travel Request";
    SourceTableTemporary = true;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(General)
            {
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
                field("Salary Level Code"; Rec."Salary Level Code")
                {
                    ToolTip = 'Specifies the value of the Salary Level Code field.';
                    ApplicationArea = All;
                }
                field("Start Date"; Rec."Start Date")
                {
                    ToolTip = 'Specifies the value of the Start Date field.';
                    ApplicationArea = All;
                }
                field("Depature Time"; Rec."Depature Time")
                {
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Depature Time field.';
                    ApplicationArea = All;
                }
                field("End Date"; Rec."End Date")
                {
                    ToolTip = 'Specifies the value of the End Date field.';
                    ApplicationArea = All;
                }
                field("Arrival Time"; Rec."Arrival Time")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Arrival Time field.';
                    ApplicationArea = All;
                }
                field("No. of Days"; Rec."No. of Days")
                {
                    ToolTip = 'Specifies the value of the No. of Days field.';
                    ApplicationArea = All;
                }
                field("Requested Date"; Rec."Requested Date")
                {
                    ToolTip = 'Specifies the value of the Requested Date field.';
                    ApplicationArea = All;
                }
                field("Start Date (BS)"; Rec."Start Date (BS)")
                {
                    ToolTip = 'Specifies the value of the Start Date (BS) field.';
                    ApplicationArea = All;
                }
                field("End Date (BS)"; Rec."End Date (BS)")
                {
                    ToolTip = 'Specifies the value of the End Date (BS) field.';
                    ApplicationArea = All;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Travel With"; Rec."Travel With")
                {
                    ToolTip = 'Specifies the value of the Travel With field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field.';
                    ApplicationArea = All;
                }
                field(Department; Rec.Department)
                {
                    ToolTip = 'Specifies the value of the Department field.';
                    ApplicationArea = All;
                }
                field("Branch Name"; Rec."Branch Name")
                {
                    ToolTip = 'Specifies the value of the Branch Name field.';
                    ApplicationArea = All;
                }
                field("Department Name"; Rec."Department Name")
                {
                    ToolTip = 'Specifies the value of the Department Name field.';
                    ApplicationArea = All;
                }
                field("Functional Title"; Rec."Functional Title")
                {
                    ToolTip = 'Specifies the value of the Functional Title field.';
                    ApplicationArea = All;
                }
                field("Purpose of Travel"; Rec."Purpose of Travel")
                {
                    ToolTip = 'Specifies the value of the Purpose of Travel field.';
                    ApplicationArea = All;
                }
            }
            group("Travel Claim")
            {
                field("Actual Travel Start Date"; Rec."Actual Travel Start Date")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Actual Travel Start Date field.';
                    ApplicationArea = All;
                }
                field("Actual Travel End Date"; Rec."Actual Travel End Date")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Actual Travel End Date field.';
                    ApplicationArea = All;
                }
                field("Actual Travel Start Time"; Rec."Actual Travel Start Time")
                {
                    ToolTip = 'Specifies the value of the Actual Travel Start Time field.';
                    ApplicationArea = All;
                }
                field("Actual Travel End Time"; Rec."Actual Travel End Time")
                {
                    ToolTip = 'Specifies the value of the Actual Travel End Time field.';
                    ApplicationArea = All;
                }
                field("Mode Of Travel"; Rec."Mode Of Travel")
                {
                    ToolTip = 'Specifies the value of the Mode Of Travel field.';
                    ApplicationArea = All;
                }
                field("Claim Type"; Rec."Claim Type")
                {
                    ToolTip = 'Specifies the value of the Claim Type field.';
                    ApplicationArea = All;
                }
                field("Claimed Country"; Rec."Claimed Country")
                {
                    ToolTip = 'Specifies the value of the Claimed Country field.';
                    ApplicationArea = All;
                }
                field("Road/Air Fare"; Rec."Road/Air Fare")
                {
                    ToolTip = 'Specifies the value of the Road/Air Fare field.';
                    ApplicationArea = All;
                }
                field(Reimbursable; Rec.Reimbursable)
                {
                    ToolTip = 'Specifies the value of the Reimbursable field.';
                    ApplicationArea = All;
                }
                field("Out of Pocket Expense"; Rec."Out of Pocket Expense")
                {
                    ToolTip = 'Specifies the value of the Out of Pocket Expense field.';
                    ApplicationArea = All;
                }
                field("Fooding Per Day Limit"; Rec."Fooding Per Day Limit")
                {
                    ToolTip = 'Specifies the value of the Fooding Per Day Limit field.';
                    ApplicationArea = All;
                }
                field("Fooding Allowance Limit"; Rec."Fooding Allowance Limit")
                {
                    ToolTip = 'Specifies the value of the Fooding Allowance Limit field.';
                    ApplicationArea = All;
                }
                field("Actual Fooding Allowance"; Rec."Fooding Allowance")
                {
                    Editable = true;
                    ToolTip = 'Specifies the value of the Fooding Allowance field.';
                    ApplicationArea = All;
                }
                field("Lodging Allowance Limit"; Rec."Lodging Allowance Limit")
                {
                    ToolTip = 'Specifies the value of the Lodging Allowance Limit field.';
                    ApplicationArea = All;
                }
                field("Lodging Per Day Limit"; Rec."Lodging Per Day Limit")
                {
                    ToolTip = 'Specifies the value of the Lodging Per Day Limit field.';
                    ApplicationArea = All;
                }
                field("Actual Lodging Allowance"; Rec."Lodging Allowance")
                {
                    Editable = true;
                    ToolTip = 'Specifies the value of the Lodging Allowance field.';
                    ApplicationArea = All;
                }
                field("Conveyance Expense"; Rec."Conveyance Expense")
                {
                    ToolTip = 'Specifies the value of the Conveyance Expense field.';
                    ApplicationArea = All;
                }
                field("Other Expense"; Rec."Other Expense")
                {
                    ToolTip = 'Specifies the value of the Other Expense field.';
                    ApplicationArea = All;
                }
                field("Total Claimed Amount"; Rec."Total Claimed Amount")
                {
                    ToolTip = 'Specifies the value of the Total Claimed Amount field.';
                    ApplicationArea = All;
                }
                field("Advance Cash"; Rec."Advance Cash")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Advance Cash field.';
                    ApplicationArea = All;
                }
                field("Net Receivable/Payable"; Rec."Net Receivable/Payable")
                {
                    ToolTip = 'Specifies the value of the Net Receivable/Payable field.';
                    ApplicationArea = All;
                }
            }
            part("Approval Subform"; "HRMS Approval Entry")
            {
                Editable = false;
                SubPageLink = "Document No." = field("No."),
                                "Employee No" = field("Employee No."),
                                "Document Type" = field(Type);
                ApplicationArea = all;
            }
            // group(Approvals)
            // {
            //     field("Recommender Code"; Rec."Recommender Code")
            //     {
            //         ToolTip = 'Specifies the value of the Recommender Code field.';
            //         ApplicationArea = All;
            //     }
            //     field("Recommender Name"; Rec."Recommender Name")
            //     {
            //         ToolTip = 'Specifies the value of the Recommender Name field.';
            //         ApplicationArea = All;
            //     }
            //     field("Approver Code"; Rec."Approver Code")
            //     {
            //         ToolTip = 'Specifies the value of the Approver Code field.';
            //         ApplicationArea = All;
            //     }
            //     field("Approver Name"; Rec."Approver Name")
            //     {
            //         ToolTip = 'Specifies the value of the Approver Name field.';
            //         ApplicationArea = All;
            //     }
            // }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Apply Travel Claim")
            {
                Image = Apply;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Apply Travel Claim action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    TravelMgt.ApplyForTravelClaim(Rec);
                    IsApplied := true;
                    CurrPage.Close;
                end;
            }
        }
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if not IsApplied then
            if not Confirm('The data will be erased. Do you want to continue?', true) then
                Error('')
            else begin
                // TempIncomingDoc.Reset;
                // TempIncomingDoc.SetRange("Employee Code", Rec."Employee No.");
                // TempIncomingDoc.SetRange("Leave Type Code", LeaveType.Code);
                // TempIncomingDoc.SetRange("No.", '');
                // if TempIncomingDoc.Find('-') then
                //     repeat
                //         LoanMgt.DeleteAttachment(TempIncomingDoc);
                //         if TempIncomingDoc."File Name" <> '' then
                //             Clear(TempIncomingDoc."File Name");

                //     until TempIncomingDoc.Next = 0;
                // TempIncomingDoc.DeleteAll;
                Approval.Reset();
                Approval.setRange("Document Type", Approval."Document Type"::"Travel Claim");
                Approval.SetRange("Document No.", '');
                Approval.SetRange("Employee No", Rec."Employee No.");
                Approval.DeleteAll();
            end;
    end;

    trigger OnOpenPage()
    begin
        ApproverMgt.InsertApprovalTemp(Rec."Employee No.", '', Rec.Type::"Travel Claim");
    end;

    var
        HRMgt: Codeunit "HR Mgt.";
        TravelMgt: Codeunit "Travel Mgt.";
        IsApplied: Boolean;
        ApproverMgt: Codeunit "Approver Mgt";
        Approval: Record "Approval HRMS";
}
