page 50033 "Payroll Attributes Usage"
{
    // version PRM19.01.01

    DataCaptionFields = "Employee Code";
    PageType = List;
    SourceTable = "Payroll Attributes Usage";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Employee Code"; Rec."Employee Code")
                {
                    ToolTip = 'Specifies the value of the Employee Code field.';
                    ApplicationArea = All;
                }
                field("Code"; Rec.Code)
                {
                    LookupPageId = "Payroll Attributes";
                    ToolTip = 'Specifies the value of the Code field.';
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ToolTip = 'Specifies the value of the Type field.';
                    ApplicationArea = All;
                }
                field(Subtype; Rec.Subtype)
                {
                    ToolTip = 'Specifies the value of the Subtype field.';
                    ApplicationArea = All;
                }
                // field("Formula Exists"; Rec."Formula Exists")
                // {
                //     ToolTip = 'Specifies the value of the Formula Exists field.';
                //     ApplicationArea = All;
                // }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.';
                    ApplicationArea = All;
                }
                // field(Description; Rec.Description)
                // {
                //     ToolTip = 'Specifies the value of the Description field.';
                //     ApplicationArea = All;
                // }
                field(Formula; Rec.Formula)
                {
                    ToolTip = 'Specifies the value of the Formula field.';
                    ApplicationArea = All;
                }
                field("Start Date"; Rec."Start Date")
                {
                    ToolTip = 'Specifies the value of the Start Date field.';
                    ApplicationArea = All;
                }
                field("End Date"; Rec."End Date")
                {
                    ToolTip = 'Specifies the value of the End Date field.';
                    ApplicationArea = All;
                }
                // field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                // {
                //     ToolTip = 'Specifies the value of the Global Dimension 2 Code field.';
                //     ApplicationArea = All;
                // }
                // field("Is Loan EMI Applicable"; Rec."Is Loan EMI Applicable")
                // {
                //     ToolTip = 'Specifies the value of the Is Loan EMI Applicable field.';
                //     ApplicationArea = All;
                // }
                // field("Last EMI Date"; Rec."Last EMI Date")
                // {
                //     ToolTip = 'Specifies the value of the Last EMI Date field.';
                //     ApplicationArea = All;
                // }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Import Attributes")
            {
                ApplicationArea = All;
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Import Attributes action.';
                trigger OnAction()
                var
                    EmpVar: Record Employee;
                    FilterPage: FilterPageBuilder;
                    Ptxt: Label 'Select Employee';
                    EmpCode: Code[20];
                    PayrollEngine: Codeunit "Payroll Engine";
                begin
                    EmpVar.Reset();
                    EmpVar.SetRange("No.", Rec."Employee Code");
                    if EmpVar.FindSet() then;
                    FilterPage.AddRecord(Ptxt, EmpVar);
                    FilterPage.AddField(Ptxt, EmpVar."No.");
                    if FilterPage.RunModal() then begin
                        EmpVar.SetView(FilterPage.GetView(Ptxt));
                        EmpCode := EmpVar.GetFilter("No.");

                        if EmpCode = '' then
                            if not Confirm('No employee is selected. Do you want to import attributes to all Active Employees?', false) then
                                exit;

                        PayrollEngine.ImportPayrollAttributes(EmpCode);
                    end;
                end;
            }
        }
    }
}
