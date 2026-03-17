page 50033 "Payroll Attributes Usage"
{
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
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.';
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
                field("Use Attribute for Home loan"; rec."Use Attr. for Home loan GS")
                {
                    Caption = 'Use Attr. for Home loan Gross Salary';
                    ApplicationArea = All;
                }
                field("Use Attribute for Vehicle loan"; rec."Use Attr. for vehicle loan GS")
                {
                    Caption = 'Use Attr. for Vehicle loan Gross Salary';
                    ApplicationArea = All;
                }
                field("Use Attr. for Salary Adv. GS"; rec."Use Attr. for Salary Adv. GS")
                {
                    Caption = 'Use Attr. for Salary Adv. Gross Salary';
                    ApplicationArea = All;
                }
                field("Use Attr. for Home loan EL"; Rec."Use Attr. for Home loan EL")
                {
                    ApplicationArea = All;
                    Caption = 'Use Attribute for Home Loan Eligible Amount';
                    ToolTip = 'Specifies whether this payroll attribute will be used to determine the eligible amount for Home Loan.';
                }
                field("Use Attr. for Vehicle loan EL"; Rec."Use Attr. for Vehicle loan EL")
                {
                    ApplicationArea = All;
                    Caption = 'Use Attribute for Vehicle Loan Eligible Amount';
                    ToolTip = 'Specifies whether this payroll attribute will be used to determine the eligible amount for Vehicle Loan.';
                }
                field("Use Attr. for Salary Adv. EL"; Rec."Use Attr. for Salary Adv. EL")
                {
                    ApplicationArea = All;
                    Caption = 'Use Attribute for Salary Advance Eligible Amount';
                    ToolTip = 'Specifies whether this payroll attribute will be used to determine the eligible amount for Salary Advance.';
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
            action("Update Loan Flags (All)")
            {
                ApplicationArea = All;
                Image = UpdateDescription;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                trigger OnAction()
                var
                    PayrollAttr: Record "Payroll Attributes";
                begin
                    if Confirm('Do you want to update loan flags for all attributes?', false) then begin

                        PayrollAttr.Reset();

                        if PayrollAttr.FindSet() then
                            repeat
                                PayrollAttr."Use Attr. for Home loan GS" := Rec."Use Attr. for Home loan GS";
                                PayrollAttr."Use Attr. for Vehicle loan GS" := Rec."Use Attr. for Vehicle loan GS";
                                PayrollAttr."Use Attr. for Salary Adv. GS" := Rec."Use Attr. for Salary Adv. GS";

                                PayrollAttr."Use Attr. for Home loan EL" := Rec."Use Attr. for Home loan EL";
                                PayrollAttr."Use Attr. for Vehicle loan EL" := Rec."Use Attr. for Vehicle loan EL";
                                PayrollAttr."Use Attr. for Salary Adv. EL" := Rec."Use Attr. for Salary Adv. EL";

                                PayrollAttr.Modify();
                            until PayrollAttr.Next() = 0;

                        Message('Loan flags updated for all payroll attributes.');
                    end;
                end;
            }
        }
    }
}
