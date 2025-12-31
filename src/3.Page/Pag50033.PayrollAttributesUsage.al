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
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.';
                    ApplicationArea = All;
                }
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
                field("Static Amount"; Rec."Static Amount")
                {
                    ToolTip = 'Specifies the value of the Static Amount field.', Comment = '%';
                }
                field("RF Contribution Type"; Rec."RF Contribution Type")
                {
                    ToolTip = 'Specifies the value of RF Contribution Type field.', Comment = '%';
                }
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
                    ImportPayrollAttrReport: Report "Import Payroll Attributes";
                begin
                    Clear(ImportPayrollAttrReport);
                    ImportPayrollAttrReport.SetEmployeeNo(Rec.GetFilter("Employee Code"));
                    ImportPayrollAttrReport.Run();
                end;
            }
        }
    }
}
