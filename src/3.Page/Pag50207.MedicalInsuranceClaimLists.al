page 50207 "Medical Insurance Claim Lists"
{
    CardPageId = "Medical Insurance Claim";
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,SetFilter';
    SourceTable = "Medical Insurance Claim";
    UsageCategory = Lists;
    ApplicationArea = All;
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;

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
                field("Policy Start Date"; Rec."Policy Start Date")
                {
                    ToolTip = 'Specifies the value of the Policy Start Date field.';
                    ApplicationArea = All;
                }
                field("Policy End Date"; Rec."Policy End Date")
                {
                    ToolTip = 'Specifies the value of the Policy End Date field.';
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
                field("Insurance Claim"; Rec."Insurance Claim")
                {
                    ToolTip = 'Specifies the value of the Insurance Claim field.';
                    ApplicationArea = All;
                }
                field("Insured Name"; Rec."Insured Name")
                {
                    ToolTip = 'Specifies the value of the Insured Name field.';
                    ApplicationArea = All;
                }
                field(Relation; Rec.Relation)
                {
                    ToolTip = 'Specifies the value of the Relation field.';
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
                field("HR Remarks"; Rec."HR Remarks")
                {
                    ToolTip = 'Specifies the value of the HR Remarks field.';
                    ApplicationArea = All;
                }
                field("Reimbursed Amount"; Rec."Reimbursed Amount")
                {
                    ToolTip = 'Specifies the value of the Reimbursed Amount field.';
                    ApplicationArea = All;
                }
                field("Batch Id"; Rec."Batch Id")
                {
                    ToolTip = 'Specifies the field Batch Id.';
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
                    MedicalClaimChangeDetail: Report "Medical Claim Change Details";
                    ClaimNos: Text;
                    SelectionCount: Integer;
                begin
                    CurrPage.SetSelectionFilter(SelectedRec);

                    if not SelectedRec.FindSet() then
                        Error('No records have been selected. Please select at least one claim.');

                    SelectionCount := 0;
                    ClaimNos := '';
                    repeat
                        if ClaimNos <> '' then
                            ClaimNos += '|';
                        ClaimNos += SelectedRec."No.";
                        SelectionCount += 1;
                    until SelectedRec.Next() = 0;

                    if not Confirm(
                        'You have selected %1 claim(s) for processing. Do you want to continue?',
                        false,
                        SelectionCount)
                    then
                        exit;

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
