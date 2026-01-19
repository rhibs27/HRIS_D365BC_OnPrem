report 50000 "Validate Travel Claim"
{
    ProcessingOnly = true;
    ApplicationArea = All;

    dataset { }

    requestpage
    {
        layout
        {
            area(Content)
            {
                field("Employee No."; EmpCode)
                {
                    TableRelation = Employee;
                    ToolTip = 'Specifies the value of the EmpCode field.';
                    ApplicationArea = All;
                }
                field("Leave Code"; LeaveCode)
                {
                    TableRelation = "Leave Type Setup";
                    ToolTip = 'Specifies the value of the LeaveCode field.';
                    ApplicationArea = All;
                }
                field("Balance Leave Days"; BalanceLeaveDays)
                {
                    ToolTip = 'Specifies the value of the BalanceLeaveDays field.';
                    ApplicationArea = All;
                }
            }
        }

        actions { }
    }

    labels { }

    trigger OnPostReport()
    begin
        Message('Success');
    end;

    trigger OnPreReport()
    begin
        //ValidateTravelClaim
        //ValidateEmployeeEmail;
        //ValidateBranch;
        //ValidateDetailedLedgeer;
        //ValidateDeputation;
        //DeleteTempTransferAttachment;
        //GetEmployeeFromEmployeeId;
        //ValdiateAllowanceLineCode;
        // InsertAllowanceHeader;
        //ValidateRiskAllowanceAmt;
        //CollpasedLeaveBalance;
        //ValidateFiscalYear;
    end;

    var
        Employee: Record Employee;
        HRMgt: Codeunit "HR Mgt.";
        LeaveEarn: Record "Leave Earn";
        EmpCode: Code[20];
        LeaveCode: Code[20];
        BalanceLeaveDays: Decimal;

    local procedure ValidateDetailedLedgeer()
    var
        DetailedLedgerEntry: Record "Detailed Employee Ledger Entry";
        PayrollAttribtes: Record "Payroll Attributes";
        EngNep: Record "English-Nepali Date";
    begin
        DetailedLedgerEntry.Reset;
        if DetailedLedgerEntry.Find('-') then
            repeat
                Clear(EngNep);
                EngNep.SetRange("English Date", DetailedLedgerEntry."Pay Period Start Date");
                if EngNep.FindFirst then;
                Employee.Get(DetailedLedgerEntry."Employee No.");
                PayrollAttribtes.Get(DetailedLedgerEntry."Payroll Attribute Code");
                if PayrollAttribtes.Type in [PayrollAttribtes.Type::Benefits, PayrollAttribtes.Type::"Non-Payment"] then begin
                    if Employee."Deputation on" in [Employee."Deputation on"::"Province"] then
                        DetailedLedgerEntry.Validate("Finacle GL No", Employee."Sol Id" + PayrollAttribtes."CBS Expense Code")
                    else
                        DetailedLedgerEntry.Validate("Finacle GL No", Employee."Sol Id" + PayrollAttribtes."CBS GL Code");
                end else begin
                    DetailedLedgerEntry.Validate("Finacle GL No", PayrollAttribtes."CBS GL Code");
                end;
                if PayrollAttribtes."Finacle GL Name" <> '' then
                    DetailedLedgerEntry.Validate("Finacle GL Name", StrSubstNo('%1 %2-%3', PayrollAttribtes."Finacle GL Name", EngNep."Nepali Year", EngNep."Nepali Month"))
                else
                    DetailedLedgerEntry.Validate("Finacle GL Name", ' ');
                DetailedLedgerEntry.Modify;
            until DetailedLedgerEntry.Next = 0;
    end;

    local procedure CollpasedLeaveBalance()
    begin
        LeaveEarn.Reset;
        LeaveEarn.Init;
        // LeaveEarn.Validate("Entry No.",leaveMgt.GetNextLeaveLedgerEntryNo());
        LeaveEarn.Validate("Leave Code", LeaveCode);
        LeaveEarn.Validate("Employee No.", EmpCode);
        LeaveEarn.Validate("Fiscal year", HRMgt.ReturnFiscalYear(Today));
        LeaveEarn.Validate("Posted Date", Today);
        LeaveEarn.Validate("Balancing Days", -Abs(BalanceLeaveDays));
        LeaveEarn.Validate(Remarks, 'Leave Collapsed.');
        LeaveEarn.Validate(Type, LeaveEarn.Type::Collapsed);
        LeaveEarn.Insert(true);
    end;

    local procedure ValidateFiscalYear()
    var
        GLEntry: Record "G/L Entry";
        DetailedEmpLedgerEntry: Record "Detailed Employee Ledger Entry";
        EmpLedgerEntry: Record "Employee Ledger Entry";
    begin
        GLEntry.Reset;
        GLEntry.ModifyAll("Fiscal Year", HRMgt.ReturnFiscalYear(Today));
        EmpLedgerEntry.Reset;
        EmpLedgerEntry.ModifyAll("Fiscal Year", HRMgt.ReturnFiscalYear(Today));
        DetailedEmpLedgerEntry.Reset;
        DetailedEmpLedgerEntry.ModifyAll("Fiscal Year", HRMgt.ReturnFiscalYear(Today));
    end;
}
