report 33019868 "Allowance Assignment Mail"
{
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset { }

    requestpage
    {
        layout { }

        actions { }
    }

    labels { }

    trigger OnPostReport()
    begin
        Message('Success')
    end;

    trigger OnPreReport()
    begin
        SendMailAllowanceAssignment;
    end;

    var
        GLSetup: Record "General Ledger Setup";
        DimValue: Record "Dimension Value";
        AllowanceHeader: Record "Allowance Assignment Header";
        EmpHie: Record "Employee Hierarchy Master";
        HRMgt: Codeunit "HR Mgt.";
        EmailTemplate: Record "Email Template";
        PGSetup: Record "Payroll General Setup";
        AllowanceLine: Record "Allowance Assignment Line";

    local procedure SendMailAllowanceAssignment()
    begin
        PGSetup.Get;
        GLSetup.Get;
        if (((Today) - CalcDate('<-CM>', Today - PGSetup."Allowance Email Days") + 1) mod 7)
                                    <= PGSetup."Allowance Email Days" then begin
            DimValue.SetRange("Dimension Code", GLSetup."Global Dimension 1 Code");
            if DimValue.Find('-') then
                repeat
                    AllowanceHeader.Reset;
                    AllowanceHeader.SetRange(Type, AllowanceHeader.Type::Branch);
                    AllowanceHeader.SetFilter("From Date", '<=%1', Today - PGSetup."Allowance Email Days");
                    AllowanceHeader.SetFilter("To date", '>=%1', Today - PGSetup."Allowance Email Days");
                    AllowanceHeader.SetRange(Code, DimValue.Code);
                    if not AllowanceHeader.FindFirst then
                        HRMgt.SendMailFromTemplate(Database::"Allowance Assignment Header", EmailTemplate."Document Type"::"Allowance Assignment", 0, DimValue.Name, '', DimValue.Code, 0)
                    else if AllowanceHeader.FindFirst then begin
                        AllowanceLine.Reset;
                        AllowanceLine.SetRange("Entry No.", AllowanceHeader."Entry No.");
                        if not AllowanceLine.FindFirst then
                            HRMgt.SendMailFromTemplate(Database::"Allowance Assignment Header", EmailTemplate."Document Type"::"Allowance Assignment", 0, DimValue.Name, '', DimValue.Code, 0);
                    end;
                until DimValue.Next = 0;
            EmpHie.Reset;
            EmpHie.SetRange(Type, EmpHie.Type::"Extension Counter");
            if EmpHie.Find('-') then begin
                AllowanceHeader.Reset;
                AllowanceHeader.SetRange(Type, AllowanceHeader.Type::"Extension Counter");
                AllowanceHeader.SetFilter("From Date", '<=%1', Today - PGSetup."Allowance Email Days");
                AllowanceHeader.SetFilter("To date", '>=%1', Today - PGSetup."Allowance Email Days");
                AllowanceHeader.SetRange(Code, EmpHie.Code);
                if not AllowanceHeader.FindFirst then
                    HRMgt.SendMailFromTemplate(Database::"Allowance Assignment Header", EmailTemplate."Document Type"::"Allowance Assignment", 0, EmpHie.Description, '', EmpHie."Shortcut Dimension 1 Code", 0)
                else if AllowanceHeader.FindFirst then begin
                    AllowanceLine.Reset;
                    AllowanceLine.SetRange("Entry No.", AllowanceHeader."Entry No.");
                    if not AllowanceLine.FindFirst then
                        HRMgt.SendMailFromTemplate(Database::"Allowance Assignment Header", EmailTemplate."Document Type"::"Allowance Assignment", 0, DimValue.Name, '', DimValue.Code, 0);
                end;
            end;
        end;
    end;

    local procedure SendMailTo()
    begin
    end;
}
