report 50122 "Payroll voucher"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep33019923.Payrollvoucher.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = where(Number = const(1));
            dataitem("Posted Payroll Header"; "Posted Payroll Header")
            {
                column(Narration; Narration) { }
                dataitem("Posted Payroll Line"; "Posted Payroll Line")
                {
                    DataItemLink = "Document No." = field("No.");
                    RequestFilterFields = "Employee No.";
                    column(DebitAmtNetpay; DebitAmt) { }
                    column(CreditAmtNetpay; CreditAmt) { }
                    column(BankAccount; BankAccount) { }
                    column(NarrrationName1; NarrrationName) { }
                    column(DebitCreditPosted; DebitCredit) { }
                    column(EmployeeNo_PostedPayrollLine; "Posted Payroll Line"."Employee No.") { }

                    trigger OnAfterGetRecord()
                    begin
                        Clear(NarrrationName);
                        Employee.Get("Employee No.");
                        DetailedEmpLegerEntry.Reset();
                        DetailedEmpLegerEntry.SetRange("Document No.", "Document No.");
                        DetailedEmpLegerEntry.SetRange("Employee No.", "Employee No.");
                        DetailedEmpLegerEntry.SetFilter("Attribute Sub Type", '<>%1&<>%2', DetailedEmpLegerEntry."Attribute Sub Type"::"Lump Sum Contribution", DetailedEmpLegerEntry."Attribute Sub Type"::"Tax on Interest");
                        if DetailedEmpLegerEntry.Find('-') then
                            repeat
                                TempDetailedEmpLedgerEntry.Reset();
                                TempDetailedEmpLedgerEntry.SetRange("Document No.", "Document No.");
                                TempDetailedEmpLedgerEntry.SetRange("Finacle GL Name", DetailedEmpLegerEntry."Finacle GL Name"); //Abhiral 01.25.2023
                                TempDetailedEmpLedgerEntry.SetRange("Finacle GL No", DetailedEmpLegerEntry."Finacle GL No");
                                if TempDetailedEmpLedgerEntry.FindFirst then begin
                                    TempDetailedEmpLedgerEntry.Amount += DetailedEmpLegerEntry.Amount;
                                    TempDetailedEmpLedgerEntry.Modify;
                                end else begin
                                    TempDetailedEmpLedgerEntry.Init;
                                    TempDetailedEmpLedgerEntry."Document No." := DetailedEmpLegerEntry."Document No.";
                                    TempDetailedEmpLedgerEntry.Amount := DetailedEmpLegerEntry.Amount;
                                    TempDetailedEmpLedgerEntry."Finacle GL Name" := DetailedEmpLegerEntry."Finacle GL Name";
                                    TempDetailedEmpLedgerEntry."Finacle GL No" := DetailedEmpLegerEntry."Finacle GL No";
                                    TempDetailedEmpLedgerEntry."Entry No." := EntryNo;
                                    TempDetailedEmpLedgerEntry.Insert();
                                    EntryNo += 1;
                                end;
                            until DetailedEmpLegerEntry.Next = 0;

                        Clear(BankAccount);
                        Clear(DebitAmt);
                        Clear(CreditAmt);
                        Clear(DebitCredit);
                        if "Net Pay" < 0 then begin
                            DebitAmt := Abs("Net Pay");
                            DebitCredit := 'D';
                        end else begin
                            CreditAmt := Abs("Net Pay");
                            DebitCredit := 'C';
                        end;
                        if "Bank Account No." = '' then
                            BankAccount := PGSetup."Parking Account No."
                        else
                            BankAccount := "Bank Account No.";

                        NarrrationName := 'Salary ' + StrSubstNo('%1 ,%2 ,%3', "Posted Payroll Header"."Nepali Year", "Posted Payroll Header"."Nepali Month", "Posted Payroll Line"."Employee No.");
                    end;
                }
                dataitem(TempDetailedEmpLedgerEntry; "Detailed Employee Ledger Entry")
                {
                    DataItemLink = "Document No." = field("No.");
                    UseTemporary = true;
                    column(FinacleGLNo_; BankAccount) { }
                    column(FinacleGLName_; "Finacle GL Name") { }
                    column(DebitAmt; DebitAmt) { }
                    column(CreditAmt; CreditAmt) { }
                    column(NarrrationName2; NarrrationName) { }
                    column(DebitCreditDetailed; DebitCredit) { }

                    trigger OnAfterGetRecord()
                    begin
                        Clear(DebitAmt);
                        Clear(CreditAmt);
                        Clear(DebitCredit);
                        Clear(BankAccount);
                        Clear(NarrrationName);
                        if Amount < 0 then begin
                            CreditAmt := Abs(Amount);
                            DebitCredit := 'C';
                        end else begin
                            DebitAmt := Abs(Amount);
                            DebitCredit := 'D';
                        end;
                        BankAccount := "Finacle GL No";

                        NarrrationName := TempDetailedEmpLedgerEntry."Finacle GL Name";
                    end;
                }
            }

            trigger OnAfterGetRecord()
            begin
                EntryNo := 1;
                PGSetup.Get;
            end;
        }
    }

    requestpage
    {
        layout { }

        actions { }
    }

    labels { }

    var
        DetailedEmpLegerEntry: Record "Detailed Employee Ledger Entry";
        EntryNo: Integer;
        DebitAmt: Decimal;
        CreditAmt: Decimal;
        DebitCredit: Text;
        PGSetup: Record "Payroll General Setup";
        BankAccount: Text;
        Employee: Record Employee;
        NarrrationName: Text;
}
