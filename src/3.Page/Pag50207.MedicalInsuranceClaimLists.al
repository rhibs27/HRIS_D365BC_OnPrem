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
                    Visible = false;
                }
                field("Spouse Name"; Rec."Spouse Name")
                {
                    ToolTip = 'Specifies the value of the Spouse Name field.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Mother Name"; Rec."Mother Name")
                {
                    ToolTip = 'Specifies the value of the Mother Name field.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Father Name"; Rec."Father Name")
                {
                    ToolTip = 'Specifies the value of the Father Name field.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Insurance Claim"; Rec."Insurance Claim")
                {
                    ToolTip = 'Specifies the value of the Insurance Claim field.';
                    ApplicationArea = All;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the approval status of the claim.';
                    ApplicationArea = All;
                    Visible = not SkipApproval;
                }
                field("Insurance Status"; Rec."Insurance Status")
                {
                    ToolTip = 'Specifies the current insurance processing status.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Update Document Status")
            {
                Caption = 'Update Document Status';
                Image = Campaign;
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'Send to Insurance Company, mark as Reimbursed, or Reject the selected claims.';

                trigger OnAction()
                var
                    SelectedRec: Record "Medical Insurance Claim";
                    MedicalClaimChangeDetail: Report MedicalClaimChangeDetails;
                    ClaimNos: Text;
                    SelectionCount: Integer;  // Bug #9 fix: replaced unused ProcessedCount
                begin
                    // Step 1: Collect the selection.
                    CurrPage.SetSelectionFilter(SelectedRec);

                    if not SelectedRec.FindSet() then
                        Error('No records have been selected. Please select at least one claim.');

                    // Step 2: Validate prerequisites and build the pipe-delimited
                    //         claim number string in a single pass.
                    //         Bug #3 fix: count is tracked manually so it is accurate
                    //         regardless of cursor position.
                    //         Bug #4 fix: we build ClaimNos here so there is no need
                    //         to call FindSet() again on an exhausted cursor.
                    SelectionCount := 0;
                    ClaimNos := '';
                    repeat
                        if SelectedRec."Approval Status" <> SelectedRec."Approval Status"::Approved then
                            Error(
                                'Claim %1 must have Approval Status "Approved" before it can be processed.',
                                SelectedRec."No.");

                        // Append to pipe-delimited list.
                        if ClaimNos <> '' then
                            ClaimNos += '|';
                        ClaimNos += SelectedRec."No.";
                        SelectionCount += 1;
                    until SelectedRec.Next() = 0;

                    // Step 3: Confirm with the accurate pre-counted integer.
                    if not Confirm(
                        'You have selected %1 claim(s) for processing. Do you want to continue?',
                        false,
                        SelectionCount)
                    then
                        exit;

                    // Step 4: Inject the claim numbers and run the report once.
                    //         Bug #1/#2/#4/#5 fix: Report.SetSelectionFilter() does not
                    //         exist in AL. The correct pattern is a public setter on the
                    //         report that accepts data before Run() is called.
                    Clear(MedicalClaimChangeDetail);
                    MedicalClaimChangeDetail.SetClaimNos(ClaimNos);
                    MedicalClaimChangeDetail.Run();
                end;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        SetLayout();
    end;

    trigger OnOpenPage()

    begin
        HRSetup.Get();
        SetLayout();
    end;

    var
        HRSetup: Record "Human Resources Setup";
        SkipApproval: Boolean;

    local procedure SetLayout()
    begin
        SkipApproval := HRSetup."Skip Medical Approval Setup"
    end;
}
