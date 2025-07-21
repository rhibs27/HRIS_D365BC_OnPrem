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
    ApplicationArea = All;
    Caption = 'payrollGeneralSetupAPI';
    layout
    {
        area(Content)
        {
            repeater(General)
            {

                field(no; Rec."No.")
                {

                }
                field(employeeNo; Rec."Employee No.")
                {

                }
                field(employeeName; Rec."Employee Name")
                {

                }
                field(fiscalYear; Rec."Fiscal Year")
                {

                }
                field(payrollMonth; Rec."Payroll Month")
                {

                }
                field(annualAccessibleMonth; Rec."Annual Assessable Income")
                {

                }
                field(rfContributionEligibleAmt; Rec."RF Contribution Eligible Amt")
                {

                }
                field(providentFundDeposited; Rec."Provident Fund Deposited")
                {

                }
                field(rfContributionDeposited; Rec."RF Contribution Deposited")
                {

                }
                field(providentFundProjected; Rec."Provident Fund Projected")
                {

                }
                field(actualProjectedContribution; Rec."Actual/Projected Contribution")
                {

                }
                field(additionalSpaceForRF; Rec."Additional Space for RF Cont.")
                {

                }
                field(projectionMonth; Rec."Projection Month")
                {

                }
                field(recommendedMonthlyCITRF; Rec."Recommended Monthly CIT/RF") { }
                field(rTFAmountMonth; Rec."RTF Amount (Month)") { }
                field(cITAmount; Rec."CIT Amount (Month)") { }
                field(rTFAmountLumpSum; Rec."RTF Amount (Lumpsum)") { }
                field(cITAmountLumpSum; Rec."CIT Amount( Lumpsum)") { }
                field(totalCommittedContribution; Rec."Total Committed Contribution")
                {

                }
                field(totalDeduction; Rec."Total Deduction")
                {

                }
                field(difference; Rec.Difference)
                {

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

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Approval Status" := Rec."Approval Status"::Pending;
        PayrollGeneralSetup.Get;
        if PayrollGeneralSetup."Enable RF Lumpsump Plan" then
            Rec."Lumpsum Committed Contribution" := Rec."Total Committed Contribution";
    end;

    trigger OnOpenPage()
    begin

    end;

    var
        HRMgt: Codeunit "HR Mgt.";
        IsApplied: Boolean;
        ActionVisible: Boolean;
        PayrollGeneralSetup: Record "Payroll General Setup";
}
