page 50011 "Retirement Fund Entity"
{
    DelayedInsert = true;
    EntityName = 'retirementFundEntity';
    EntitySetName = 'retirementFundEntities';
    PageType = API;
    APIPublisher = 'Agile';
    APIGroup = 'HRMS';
    APIVersion = 'v2.0';
    SourceTable = "Retirement Fund";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                Editable = false;
                field(no; Rec."No.")
                {
                    trigger OnAssistEdit()
                    begin
                        if AssistEdit(xRec) then
                            CurrPage.Update;
                    end;
                }
                field(employeeNo; Rec."Employee No.")
                {
                    Editable = false;
                }
                field(employeeName; Rec."Employee Name")
                {
                    Editable = false;
                }
                field(fiscalYear; Rec."Fiscal Year")
                {
                    Editable = false;
                }
                field(payrollMonth; Rec."Payroll Month")
                {
                    Editable = false;
                }
                field(annualAccessibleMonth; Rec."Annual Accessible Income")
                {
                    Editable = false;
                }
                field(rfContributionEligibleAmt; Rec."RF Contribution Eligible Amt")
                {
                    Editable = false;
                }
                field(providentFundDeposited; Rec."Provident Fund Deposited")
                {
                    Editable = false;
                }
                field(rfContributionDeposited; Rec."RF Contribution Deposited")
                {
                    Editable = false;
                }
                field(providentFundProjected; Rec."Provident Fund Projected")
                {
                    Editable = false;
                }
                field(actualProjectedContribution; Rec."Actual/Projected Contribution")
                {
                    Editable = false;
                }
                field(additionalSpaceForRF; Rec."Additional Space for RF Cont.")
                {
                    Editable = false;
                }
                field(projectionMonth; Rec."Projection Month")
                {
                    Editable = false;
                }
                field(nICARTFAmount; Rec."NICA RTF Amount (Month)") { }
                field(cITAmount; Rec."CIT Amount (Month)") { }
                field(nICARTFAmountLumpSum; Rec."NICA RTF Amount (Lumpsum)") { }
                field(cITAmountLumpSum; Rec."CIT Amount( Lumpsum)") { }
                field(totalCommittedContribution; Rec."Total Committed Contribution")
                {
                    Editable = false;
                }
                field(totalDeduction; Rec."Total Deduction")
                {
                    Editable = false;
                }
                field(difference; Rec.Difference)
                {
                    Editable = false;
                }
                field(approvalStatus; Rec."Approval Status") { }
                field(createdDate; Rec."Created Date") { }
                field(requestedDate; Rec."Requested Date") { }
                field(screenedDate; Rec."Screened Date") { }
                field(screenedBy; Rec."Screened By") { }
                field(Remarks; Rec.Remarks) { }
                field(citContributionDeposited; Rec."CIT Contribution Deposited") { }
                field(actualCITContribution; Rec."Actual Lumpsump CIT") { }
                field(actualRTFContribution; Rec."Actual Lumpsump RTF") { }
                field(lumpSumCommittedContribution; Rec."Lumpsum Committed Contribution") { }
                field(lumpSumSpaceMaxBenefit; Rec."Lumpsum Space Max Benefit") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Submit)
            {
                Image = Suggest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = ActionVisible;

                trigger OnAction()
                begin
                    if HRMgt.ApplyForRetirementFund(Rec) then begin
                        IsApplied := true;
                        CurrPage.Close;
                    end;
                end;
            }
            action(Screen)
            {
                Image = Stages;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if not Confirm('Do you want to screen the document ?', false) then
                        exit;
                    HRMgt.ScreenRF(Rec);

                    Message('Document screened successfully.');
                end;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Approval Status" := "Approval Status"::"Pending Approval";
        PayrollGeneralSetup.Get; //Min
        if PayrollGeneralSetup."Enable RF Lumpsump Plan" then
            "Lumpsum Committed Contribution" := "Total Committed Contribution";
    end;

    trigger OnOpenPage()
    begin
        //ERROR('Retirement Fund has been disabled for this year.');
    end;

    var
        HRMgt: Codeunit "HR Mgt.";
        IsApplied: Boolean;
        ActionVisible: Boolean;
        PayrollGeneralSetup: Record "Payroll General Setup";
}
