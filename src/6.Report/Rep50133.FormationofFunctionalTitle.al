report 50133 "Formation of Functional Title"
{
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset { }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group("Formation of Functional Title")
                {
                    Caption = 'Formation of Functional Title';
                    field("Functional Title From"; FunctionalTitleFrom)
                    {
                        TableRelation = "Functional Title" where(Blocked = const(false));
                        ToolTip = 'Specifies the value of the FunctionalTitleFrom field.';
                        ApplicationArea = All;
                    }
                    field("Functional Title To"; FunctionalTitleTo)
                    {
                        TableRelation = "Functional Title" where(Blocked = const(false));
                        ToolTip = 'Specifies the value of the FunctionalTitleTo field.';
                        ApplicationArea = All;
                    }
                    field("Effective date"; EffectiveDate)
                    {
                        ToolTip = 'Specifies the value of the EffectiveDate field.';
                        ApplicationArea = All;
                    }
                    field(Block; BlockedFunctionalTitleFrom)
                    {
                        Caption = ' Block FunctionalTitle Code(From)';
                        ToolTip = 'Specifies the value of the  Block FunctionalTitle Code(From) field.';
                        ApplicationArea = All;
                    }
                    field(Remarks; Remarks)
                    {
                        ToolTip = 'Specifies the value of the Remarks field.';
                        ApplicationArea = All;
                    }
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
        if (FunctionalTitleFrom = '') or (FunctionalTitleTo = '') or (EffectiveDate = 0D) then
            Error('Please fill all the values.');

        ValidateValueForFunctionalTitle;
        ValidateValueForNonFunctionalTitle;
        if BlockedFunctionalTitleFrom then
            IfBlockFunctionalTitle;
    end;

    var
        Employee: Record Employee;
        EffectiveDate: Date;
        EmpServiceHistory: Record "Employee Service History";
        ServiceHistoryMgt: Codeunit "Service History Mgt";
        Remarks: Text;
        ServiceHistoryCode: Code[20];
        BlockedFunctionalTitleFrom: Boolean;
        FunctionalTitleFrom: Code[20];
        FunctionalTitleTo: Code[20];
        FunctionalTitleRec: Record "Functional Title";

    local procedure ValidateValueForFunctionalTitle()
    begin
        Employee.Reset;
        Employee.SetRange(Status, Employee.Status::Active);
        Employee.SetRange("Functional Title", FunctionalTitleFrom);
        if Employee.Find('-') then
            repeat
                ServiceHistoryCode := ServiceHistoryMgt.AddToServiceHistory(Employee."No.", EmpServiceHistory."Service Event"::"Formation of Department/Unit/Functional Title", Remarks, EffectiveDate);

                if EmpServiceHistory.Get(ServiceHistoryCode) then begin
                    EmpServiceHistory.Validate("Deputation On (To)", Employee."Deputation on");
                    EmpServiceHistory.Validate("Functional Title (To)", FunctionalTitleTo);
                    EmpServiceHistory.Validate("Salary Level (To)", Employee."Salary Level");
                    EmpServiceHistory.Validate("Deputation Code (To)", ServiceHistoryMgt.ExitTransferDeputationWiseCode(Employee."Deputation on", Employee."No."));
                    EmpServiceHistory.Validate("Deputation Value (To)", ServiceHistoryMgt.ExitTransferDeputationWiseValue(Employee."Deputation on", Employee."No."));
                    EmpServiceHistory.Modify;
                end;
            until Employee.Next = 0;
    end;

    local procedure ValidateValueForNonFunctionalTitle()
    begin
        Employee.Reset;
        Employee.SetRange(Status, Employee.Status::Active);
        Employee.SetFilter("Functional Title", FunctionalTitleFrom);
        if Employee.Find('-') then
            repeat
                Employee.Validate("Functional Title", FunctionalTitleTo);
                Employee.Modify;
            until Employee.Next = 0;
    end;

    local procedure IfBlockFunctionalTitle()
    begin
        if FunctionalTitleRec.Get(FunctionalTitleFrom) then begin
            FunctionalTitleRec.Validate(Blocked, true);
            FunctionalTitleRec.Modify;
        end;
    end;
}
