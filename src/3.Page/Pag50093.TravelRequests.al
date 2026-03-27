page 50093 "Travel Requests"
{
    // Editable = false;
    ApplicationArea = All;
    DeleteAllowed = false;
    PageType = List;
    SourceTable = "Travel Request";
    PromotedActionCategories = 'New,Process,Report,SetFilter';
    UsageCategory = Lists;
    SourceTableView = SORTING("No.")
                      ORDER(Descending) WHERE(Type = CONST("Travel Request"));
    CardPageId = "Travel Form";
    Editable = false;
    InsertAllowed = false;

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
                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.';
                    ApplicationArea = All;
                }
                field(Extended; Rec.Extended)
                {
                    ToolTip = 'Specifies the value of the Extended Travel field.';
                    ApplicationArea = All;
                }
                field("Travel Claimed"; Rec."Travel Claimed")
                {
                    ToolTip = 'Specifies the value of the Travel Claimed field.';
                    ApplicationArea = All;
                }
                field("Advance Cash Required"; Rec."Advance Cash Required")
                {
                    ToolTip = 'Specifies the value of the Advance Cash Required field.';
                    ApplicationArea = All;
                }
                field("Disbursed Advance"; Rec."Advance Disbursed")
                {
                    ToolTip = 'Specifies the value of the Advance Cash Required field.';
                    ApplicationArea = All;
                }
                field("Purpose of Travel"; Rec."Purpose of Travel")
                {
                    ToolTip = 'Specifies the value of the Purpose of Travel field.';
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("&Advance Disbursed")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Open action.';
                ApplicationArea = All;
                trigger OnAction()
                var
                    SelectedRec: Record "Travel Request";
                    ExchangeRate: Decimal;
                begin
                    CurrPage.SetSelectionFilter(SelectedRec);

                    if not SelectedRec.FindSet() then
                        Error('No records selected.');
                    repeat
                        if (SelectedRec."Approval Status" <> SelectedRec."Approval Status"::Approved) OR (not SelectedRec."Advance Cash Required") then
                            Error('All selected records must have Approval Status = Approved And "Advance Cash Required" must be True. Record %1', SelectedRec."No.");
                    until SelectedRec.Next() = 0;

                    if Rec."Travel Countries" <> Rec."Travel Countries"::Nepal then
                        OnBeforeAdvanceDisbursed(ExchangeRate);

                    if Confirm('Do you want to process the selected records?', false) then begin
                        SelectedRec.FindSet();
                        repeat
                            if ExchangeRate <> 0 then
                                OnApplyAdvanceDisbursed(SelectedRec, ExchangeRate);
                            // Once disbursed, it should not be set advance Disbursed to false again
                            // SelectedRec.Validate("Advance Disbursed", not SelectedRec."Advance Disbursed");
                            SelectedRec.Validate("Advance Disbursed", true);
                            SelectedRec.Modify(true);
                        until SelectedRec.Next() = 0;
                        Message('Advance Disbursed field has been updated for selected records.');
                    end else begin
                        Message('No changes made to the Advance Disbursed field.');
                    end;
                end;
            }
            action("Approve Travel Request")
            {
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = false;
                ToolTip = 'Executes the Approve Travel Request action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if Confirm('Do you want to approve the travel request?', false) then
                        ApprovalMgt.ApproveRejectDocument(RecRef, true);
                end;
            }
            action("Reject Travel Request")
            {
                Image = Reject;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Reject Travel Request action.';
                ApplicationArea = All;
                Visible = false;
                trigger OnAction()
                begin
                    if Confirm('Do you want to reject travel requet?', false) then
                        IF REC."Rejection Remarks" = '' then
                            Error('Rejection Remarks is Empty')
                        else begin
                            ApprovalMgt.ApproveRejectDocument(RecRef, false);
                            Message('Travel is Rejected by %1', HRMgt.GetEmpName());
                        end;
                end;
            }
        }
        area(Navigation)
        {
            action(Open)
            {
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ToolTip = 'Executes the Open action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.FilterGroup(2);
                    ClearAll();
                    Rec.SetFilter("Approval Status", '%1|%2', Rec."Approval Status"::" ", Rec."Approval Status"::Open);
                    Rec.FilterGroup(0);
                end;
            }
            action("Pending Approval")
            {
                Image = PendingApproval;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ToolTip = 'Executes the Pending Approval action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.FilterGroup(2);
                    ClearAll();
                    Rec.SetRange("Approval Status", Rec."Approval Status"::Pending);
                    Rec.FilterGroup(0);
                end;
            }
            action(Approved)
            {
                Image = Approve;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ToolTip = 'Executes the Approved action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.FilterGroup(2);
                    ClearAll();
                    Rec.SetRange("Approval Status", Rec."Approval Status"::Approved);
                    Rec.FilterGroup(0);
                end;
            }
            action(Rejected)
            {
                Image = DeleteQtyToHandle;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ToolTip = 'Executes the Rejected action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.FilterGroup(2);
                    ClearAll();
                    Rec.SetRange("Approval Status", Rec."Approval Status"::Rejected);
                    Rec.FilterGroup(0);
                end;
            }
            action(WithDrawn)
            {
                Image = Return;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ToolTip = 'Executes the Withdrawn action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.FilterGroup(2);
                    ClearAll();
                    Rec.SetRange("Approval Status", Rec."Approval Status"::Withdrawn);
                    Rec.FilterGroup(0);
                end;
            }
            action("Clear Filter")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Category4;
                Image = ClearFilter;
                ToolTip = 'Executes the clear filter action.';
                trigger OnAction()
                begin
                    Rec.FilterGroup(2);
                    rec.SetRange("Approval Status");
                    Rec.FilterGroup(0);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        IsPending := Rec."Approval Status" = Rec."Approval Status"::Pending;
        RecRef.GetTable(Rec);
    end;

    var
        HRMgt: Codeunit "HR Mgt.";

        IsPending: Boolean;
        ApprovalMgt: Codeunit "Approver Mgt";
        RecRef: RecordRef;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeAdvanceDisbursed(var ExchangeRate: Decimal)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnApplyAdvanceDisbursed(var TravelReq: Record "Travel Request"; ExchangeRate: Decimal)
    begin
    end;
}
