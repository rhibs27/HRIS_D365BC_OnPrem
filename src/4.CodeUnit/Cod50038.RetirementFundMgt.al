codeunit 50038 "Retirement Fund Mgt"
{
    procedure GetRetirementFund(RetirementFund: Record "Retirement Fund")
    var
        RFContributionLine: Record "RF Contribution";
        PayrollAttributeUsgae: Record "Payroll Attributes Usage";
        PayrollLine: Record "Payroll Line";
    begin
        RFContributionLine.SetRange("Document No.", RetirementFund."No.");
        RFContributionLine.SetRange("Employee No.", RetirementFund."Employee No.");
        if RFContributionLine.FindFirst() then
            case RFContributionLine.Type of
                RFContributionLine.Type::Manual, RFContributionLine.Type::Optimum:
                    begin
                        PayrollAttributeUsgae.SetRange("Employee Code", RetirementFund."Employee No.");
                        PayrollAttributeUsgae.SetRange(Code, RFContributionLine."Attribute Code");
                        if PayrollAttributeUsgae.FindFirst() then begin
                            PayrollAttributeUsgae."RF Contribution Type" := RFContributionLine.Type;
                            PayrollAttributeUsgae.Modify();
                        end;
                    end;
                RFContributionLine.Type::Fixed:
                    begin
                        PayrollAttributeUsgae.SetRange("Employee Code", RetirementFund."Employee No.");
                        PayrollAttributeUsgae.SetRange(Code, RFContributionLine."Attribute Code");
                        if PayrollAttributeUsgae.FindFirst() then begin
                            PayrollAttributeUsgae.Amount := RFContributionLine.Amount;
                            PayrollAttributeUsgae."RF Contribution Type" := RFContributionLine.Type;
                            PayrollAttributeUsgae.Modify();
                        end else begin
                            PayrollAttributeUsgae.Init();
                            PayrollAttributeUsgae.Validate("Employee Code", RetirementFund."Employee No.");
                            PayrollAttributeUsgae.Validate(Code, RFContributionLine."Attribute Code");
                            PayrollAttributeUsgae.Validate(Amount, RFContributionLine.Amount);
                            PayrollAttributeUsgae."RF Contribution Type" := RFContributionLine.Type;
                            if PayrollAttributeUsgae.Insert() then;
                        end;
                    end;
                RFContributionLine.Type::Percent:
                    begin
                        PayrollAttributeUsgae.SetRange("Employee Code", RetirementFund."Employee No.");
                        PayrollAttributeUsgae.SetRange(Code, RFContributionLine."Attribute Code");
                        if PayrollAttributeUsgae.FindFirst() then begin
                            PayrollAttributeUsgae.Amount := PayrollLine.GetAmountRFContribution(RetirementFund."Employee No.") * RFContributionLine.Amount / 100;
                            PayrollAttributeUsgae."RF Contribution Type" := RFContributionLine.Type;
                            PayrollAttributeUsgae.Modify();
                        end else begin
                            PayrollAttributeUsgae.Init();
                            PayrollAttributeUsgae.Validate("Employee Code", RetirementFund."Employee No.");
                            PayrollAttributeUsgae.Validate(Code, RFContributionLine."Attribute Code");
                            PayrollAttributeUsgae.Validate(Amount, PayrollLine.GetAmountRFContribution(RetirementFund."Employee No.") * RFContributionLine.Amount / 100);
                            PayrollAttributeUsgae."RF Contribution Type" := RFContributionLine.Type;
                            if PayrollAttributeUsgae.Insert() then;
                        end;
                    end;
            end;
    end;

    procedure ApproveRetirementFund(RetirementFund: Record "Retirement Fund")
    var
        Employee: Record Employee;
    begin
        if Employee.Get(RetirementFund."Employee No.") then begin
            if RetirementFund."Self Deposited CIT Amount" <> 0 then
                Employee."Lumpsum CIT (Not Actual)" := RetirementFund."Self Deposited CIT Amount";
            if RetirementFund."Self Deposited RF Amount" <> 0 then
                Employee."Lumpsum RF (Not Actual)" := RetirementFund."Self Deposited RF Amount";
            Employee.Modify();
        end;
    end;


}
