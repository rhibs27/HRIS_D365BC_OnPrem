report 33019804 ValidateEmpAttributes
{
    ProcessingOnly = true;
    ApplicationArea = All;

    dataset
    {
        dataitem(Employee; Employee)
        {
            trigger OnAfterGetRecord()
            begin
                PayrollAttUsage.Reset;
                PayrollAttUsage.SetRange("Employee Code", "No.");
                PayrollAttUsage.DeleteAll;
                ValidateBasic;
                ValidateGrade;
                ValidateAllPF;
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
        PayrollAttributes: Record "Payroll Attributes";
        PayrollAttUsage: Record "Payroll Attributes Usage";

    local procedure CheckAttUsageExist(AttributeCode: Code[20]): Boolean
    begin
        if PayrollAttUsage.Get(AttributeCode, Employee."No.") then
            exit(true);
    end;

    local procedure ValidateBasic()
    begin
        //Basic
        PayrollAttributes.Reset;
        PayrollAttributes.SetRange(Type, PayrollAttributes.Type::Benefits);
        PayrollAttributes.SetRange(Subtype, PayrollAttributes.Subtype::Basic);
        if PayrollAttributes.FindFirst then begin
            if not CheckAttUsageExist(PayrollAttributes.Code) then begin
                PayrollAttUsage.Init;
                PayrollAttUsage.Validate(Code, PayrollAttributes.Code);
                PayrollAttUsage.Validate("Employee Code", Employee."No.");
                PayrollAttUsage.Insert;
            end;
        end;
    end;

    local procedure ValidateGrade()
    begin
        //Grade
        PayrollAttributes.Reset;
        PayrollAttributes.SetRange(Type, PayrollAttributes.Type::Benefits);
        PayrollAttributes.SetRange(Subtype, PayrollAttributes.Subtype::Grade);
        if PayrollAttributes.FindFirst then begin
            if not CheckAttUsageExist(PayrollAttributes.Code) then begin
                PayrollAttUsage.Init;
                PayrollAttUsage.Validate(Code, PayrollAttributes.Code);
                PayrollAttUsage.Validate("Employee Code", Employee."No.");
                PayrollAttUsage.Insert;
            end;
        end;
    end;

    local procedure ValidateAllPF()
    begin
        PayrollAttributes.Reset;
        PayrollAttributes.SetFilter(Subtype, '%1|%2', PayrollAttributes.Subtype::"Employee Contribution", PayrollAttributes.Subtype::"Employer Contribution");
        if PayrollAttributes.Find('-') then
            repeat
                if not CheckAttUsageExist(PayrollAttributes.Code) then begin
                    PayrollAttUsage.Init;
                    PayrollAttUsage.Validate(Code, PayrollAttributes.Code);
                    PayrollAttUsage.Validate("Employee Code", Employee."No.");
                    PayrollAttUsage.Insert;
                end;
            until PayrollAttributes.Next = 0;
    end;
}
