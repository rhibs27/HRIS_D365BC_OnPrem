page 33019811 "Retirement Fund Entity"
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
                field(rfContributionEligibleAmt; "RF Contribution Eligible Amt")
                {
                    Editable = false;
                }
                field(providentFundDeposited; "Provident Fund Deposited")
                {
                    Editable = false;
                }
                field(rfContributionDeposited; "RF Contribution Deposited")
                {
                    Editable = false;
                }
                field(providentFundProjected; "Provident Fund Projected")
                {
                    Editable = false;
                }
                field(actualProjectedContribution; "Actual/Projected Contribution")
                {
                    Editable = false;
                }
                field(additionalSpaceforRF; "Additional Space for RF Cont.")
                {
                    Editable = false;
                }
                field(projectionMonth; "Projection Month")
                {
                    Editable = false;
                }
                field(nICARTFAmount; "NICA RTF Amount (Month)") { }
                field(cITAmount; "CIT Amount (Month)") { }
                field(nICARTFAmountLumpsum; "NICA RTF Amount (Lumpsum)") { }
                field(cITAmountLumpsum; "CIT Amount( Lumpsum)") { }
                field(totalCommittedContribution; "Total Committed Contribution")
                {
                    Editable = false;
                }
                field(totalDeduction; "Total Deduction")
                {
                    Editable = false;
                }
                field(difference; Difference)
                {
                    Editable = false;
                }
                field(approvalStatus; "Approval Status") { }
                field(createdDate; "Created Date") { }
                field(requestedDate; "Requested Date") { }
                field(screenedDate; "Screened Date") { }
                field(screenedBy; "Screened By") { }
                field(Remarks; Remarks) { }
                field(citContributionDeposited; "CIT Contribution Deposited") { }
                field(actualCITContribution; "Actual Lumpsump CIT") { }
                field(actualRTFContribution; "Actual Lumpsump RTF") { }
                field(lumpsumCommittedContribution; "Lumpsum Committed Contribution") { }
                field(lumpsumSpaceMaxBenefit; "Lumpsum Space Max Benefit") { }
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
