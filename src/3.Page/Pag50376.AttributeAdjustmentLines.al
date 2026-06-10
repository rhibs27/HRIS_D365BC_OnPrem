page 50376 "Attribute Adjustment Lines"
{
    PageType = ListPart;
    SourceTable = "Attribute Adjustment Line";
    ApplicationArea = All;
    Caption = 'Adjustment Lines';
    AutoSplitKey = true;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Employee No."; Rec."Employee No.") { ApplicationArea = All; }
                field("Employee Name"; Rec."Employee Name") { ApplicationArea = All; }
                field("Adjustment Type"; Rec."Adjustment Type") { ApplicationArea = All; }
                field("Attribute Code"; Rec."Attribute Code") { ApplicationArea = All; }
                field("Old Amount"; Rec."Old Amount") { ApplicationArea = All; }
                field("New Amount"; Rec."New Amount") { ApplicationArea = All; }
                field("Effective Start Date"; Rec."Effective Start Date") { ApplicationArea = All; }
                field("Effective End Date"; Rec."Effective End Date") { ApplicationArea = All; }
            }
        }
    }
    actions
    {
        area(processing)
        {
            action(InsertLine)
            {
                Caption = 'Insert Line';
                ApplicationArea = All;
            }

            action(ExportToExcel)
            {
                Caption = 'Export to Excel';
                ApplicationArea = All;
                Image = ExportToExcel;
                trigger OnAction()
                begin
                    if Rec."Document No." = '' then
                        Error('No Document selected. Open the Card page and try again.');
                    AttrAdjMgt.ExportLines(Rec."Document No.");
                end;
            }

            action(ImportFromExcel)
            {
                Caption = 'Import from Excel';
                ApplicationArea = All;
                Image = ImportExcel;
                trigger OnAction()
                begin
                    if Rec."Document No." = '' then
                        Error('No Document selected. Open the Card page and try again.');
                    AttrAdjMgt.ImportLines(Rec."Document No.");
                    CurrPage.Update();
                end;
            }
            action("Get Amount from Attribute Formula")
            {
                Caption = 'Get Amt. from Formula';
                ApplicationArea = All;
                Image = GetLines;
                trigger OnAction()
                var
                    AttributeAdjustmentMgt: Codeunit "Attribute Adjustment Mgt";
                    PayrollAttributes: Record "Payroll Attributes";
                    AttributeAdjLine: Record "Attribute Adjustment Line";
                begin
                    CurrPage.SetSelectionFilter(AttributeAdjLine);
                    repeat
                        if PayrollAttributes.Get(AttributeAdjLine."Attribute Code") then
                            if PayrollAttributes.Formula <> '' then begin
                                AttributeAdjLine.Validate("New Amount", AttributeAdjustmentMgt.GetAmountFromAttributeFormula(PayrollAttributes.Formula, Rec."Employee No."));
                                AttributeAdjLine.Modify(true);
                            end;
                    until AttributeAdjLine.Next() = 0;
                    CurrPage.Update();
                    Message('Amount has been updated successfully.');
                end;
            }
            action("Payroll Attributes Usage")
            {
                Image = PaymentDays;
                RunObject = page "Payroll Attributes Usage";
                RunPageLink = "Employee Code" = field("Employee No.");
                ToolTip = 'Executes the Payroll Attributes Usage action.';
                ApplicationArea = All;
            }
            //May be needed if selection filter is required for specific employee
            // action("Get Additional Attributes")
            // {
            //     ApplicationArea = All;
            //     Caption = 'Get Additional Attributes';
            //     Image = GetLines;
            //     trigger OnAction()
            //     var
            //         AdjustmentHeader: Record "Attribute Adjustment Header";
            //         AttributeAdjustmentMgt: Codeunit "Attribute Adjustment Mgt";
            //     begin
            //         AdjustmentHeader.Get(Rec."Document No.");
            //         if not (AdjustmentHeader."Adjustment Type" in [AdjustmentHeader."Adjustment Type"::Promotion, AdjustmentHeader."Adjustment Type"::Confirmation]) then
            //             Error('Adjustment Type must be %1 and %2', AdjustmentHeader."Adjustment Type"::Promotion, AdjustmentHeader."Adjustment Type"::Confirmation);
            //         AttributeAdjustmentMgt.UpdatePayrollAttributesInAttributeAdjustmentLine(AdjustmentHeader);
            //         CurrPage.Update();
            //         Message('Additional Attributes have been fetched successfully.');
            //     end;
            // }
        }
    }
    procedure AttributeFilter(AttributeCode: Code[20])
    begin
        Rec.SetRange("Attribute Code", AttributeCode);
        CurrPage.Update();
    end;

    procedure EmployeeFilter(Employee: Code[20])
    begin
        Rec.SetRange("Employee No.", Employee);
        CurrPage.Update();
    end;

    procedure ClearEmployeeFilter()
    begin
        Rec.SetRange("Employee No.");
        CurrPage.Update();
    end;

    procedure ClearAttributeCodeFilter()
    begin
        Rec.SetRange("Attribute Code");
        CurrPage.Update();
    end;

    var
        AttrAdjMgt: Codeunit "Excel Import";
}
