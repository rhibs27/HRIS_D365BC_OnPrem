page 50040 "Payroll Plan"
{
    PageType = Card;
    SourceTable = "Payroll Header";
    ApplicationArea = All;
    Caption = 'Payroll Plan';
    layout
    {
        area(Content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                    ApplicationArea = All;

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update();
                    end;
                }
                field("Pay Cycle Code"; Rec."Pay Cycle Code")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Pay Cycle Code field.';
                    ApplicationArea = All;
                }
                field("Pay Cycle Term"; Rec."Pay Cycle Term")
                {
                    ToolTip = 'Specifies the value of the Pay Cycle Term field.';
                    ApplicationArea = All;
                }
                field("Pay Cycle Period"; Rec."Pay Cycle Period")
                {
                    ToolTip = 'Specifies the value of the Pay Cycle Period field.';
                    ApplicationArea = All;
                }
                field("Nepali Month"; Rec."Nepali Month")
                {
                    Caption = 'Payroll Cycle Month';
                    ToolTip = 'Specifies the value of the Payroll Cycle Month field.';
                    ApplicationArea = All;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ToolTip = 'Specifies the value of the Document Date field.';
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    Caption = 'Voucher Date';
                    ToolTip = 'Specifies the value of the Voucher Date field.';
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                    ApplicationArea = All;
                }
                field("From Date"; Rec."From Date")
                {
                    Importance = Additional;
                    ToolTip = 'Specifies the value of the From Date field.';
                    ApplicationArea = All;
                }
                field("To Date"; Rec."To Date")
                {
                    Importance = Additional;
                    ToolTip = 'Specifies the value of the To Date field.';
                    ApplicationArea = All;
                }
                field("Previous Year Payroll"; Rec."Previous Year Payroll")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Previous Year Payroll field.';
                    ApplicationArea = All;
                }
                field(Month; Rec.Month)
                {
                    Importance = Additional;
                    ToolTip = 'Specifies the value of the Month field.';
                    ApplicationArea = All;
                }
                field("From Date (B.S)"; Rec."From Date (B.S)")
                {
                    Importance = Additional;
                    ToolTip = 'Specifies the value of the From Date (B.S) field.';
                    ApplicationArea = All;
                }
                field("To Date (B.S)"; Rec."To Date (B.S)")
                {
                    Importance = Additional;
                    ToolTip = 'Specifies the value of the To Date (B.S) field.';
                    ApplicationArea = All;
                }
                field("Total Net Payable"; Rec."Total Net Payable")
                {
                    Importance = Additional;
                    ToolTip = 'Specifies the value of the Total Net Payable field.';
                    ApplicationArea = All;
                }
                field("Total Days"; Rec."Total Days")
                {
                    ToolTip = 'Specifies the value of the Total Days field.';
                    ApplicationArea = All;
                }
                field("No of Employees"; Rec."No of Employees")
                {
                    ToolTip = 'Specifies the value of the No of Employees field.';
                    ApplicationArea = All;
                }
                field("Nepali Year"; Rec."Nepali Year")
                {
                    Importance = Additional;
                    ToolTip = 'Specifies the value of the Nepali Year field.';
                    ApplicationArea = All;
                }
                field("Posting Description"; Rec."Posting Description")
                {
                    ToolTip = 'Specifies the value of the Posting Description field.';
                    ApplicationArea = All;
                }
                field("Assigned User ID"; Rec."Assigned User ID")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Assigned User ID field.';
                    ApplicationArea = All;
                }
                field(Remarks; Rec.Remarks)
                {
                    Importance = Additional;
                    ToolTip = 'Specifies the value of the Remarks field.';
                    ApplicationArea = All;
                }
                field(Irregular; Rec.Irregular)
                {
                    Visible = AjustmentVisible;
                    ToolTip = 'Specifies the value of the Irregular field.';
                    ApplicationArea = All;
                }
                field("Optimal Deduction"; Rec."Optimal Deduction")
                {
                    ToolTip = 'Specifies the value of the Optimal Deduction field.', Comment = '%';
                }
                field("Gross Payment"; Rec."Gross Payment")
                {
                    Visible = AjustmentVisible;
                    ToolTip = 'Specifies the value of the Gross Payment field.';
                    ApplicationArea = All;
                }
                field(Narration; Rec.Narration)
                {
                    ToolTip = 'Specifies the value of the Narration field.';
                    ApplicationArea = All;
                }
                field("OverTime From"; Rec."OverTime From")
                {
                    Visible = AjustmentVisible;
                    ToolTip = 'Specifies the value of the OverTime From field.';
                    ApplicationArea = All;
                }
                field("OverTime To"; Rec."OverTime To")
                {
                    Visible = AjustmentVisible;
                    ToolTip = 'Specifies the value of the OverTime To field.';
                    ApplicationArea = All;
                }
            }
            part(Control26; "Payroll Subform")
            {
                SubPageLink = "Document No." = field("No.");
                UpdatePropagation = Both;
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group("&Functions")
            {
                Caption = '&Functions';
                action("Get Attributes")
                {
                    Caption = 'Get Attributes';
                    Image = Components;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = not AjustmentVisible;
                    ToolTip = 'Executes the Get Attributes action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        PayrollHeader: Record "Payroll Header";
                    begin

                        PayrollHeader.Reset;
                        PayrollHeader.SetRange("No.", Rec."No.");
                        if PayrollHeader.FindFirst then begin
                            Rec.GetDetails(PayrollHeader);
                            PayrollHeader.Validate(Status, PayrollHeader.Status::Pending);
                            PayrollHeader.Modify;
                        end;
                    end;
                }
                action("Calculate Tax")
                {
                    Caption = 'Calculate Tax';
                    Image = TaxSetup;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Calculate Tax action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        PayrollHeader: Record "Payroll Header";
                    begin
                        CurrPage.SetSelectionFilter(PayrollHeader);
                        Rec.CalculatePayroll(PayrollHeader);
                    end;
                }
                action("Re-Open")
                {
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Re-Open action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        PayrollHeader: Record "Payroll Header";
                    begin
                        CurrPage.SetSelectionFilter(PayrollHeader);
                        Rec.ReOpenDocument(PayrollHeader);
                    end;
                }
                action(Post)
                {
                    Caption = 'P&ost';
                    Ellipsis = true;
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortcutKey = 'F9';
                    ToolTip = 'Executes the Post action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        Rec.TestField(Narration);
                        Codeunit.Run(Codeunit::"Payroll-Post", Rec);
                    end;
                }
                action("Import Employee")
                {
                    Image = Import;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = not AjustmentVisible;
                    ToolTip = 'Executes the Import Employee action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        ImportEmployeePayrollPlanReport: Report "Import Employee Payroll Plan";
                    begin
                        if not Confirm('Do you want to import employees in Employee Payroll Plan? Existing lines will be deleted.', false) then
                            exit;
                        ImportEmployeePayrollPlanReport.SetPayrollHeader(Rec);
                        ImportEmployeePayrollPlanReport.RunModal();
                    end;
                }
                action("Employee Adjustment")
                {
                    Image = AddContacts;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Visible = AjustmentVisible;
                    ToolTip = 'Executes the Employee Adjustment action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        Rec.TestField(Type, Rec.Type::Adjustment);
                        PayrollAdj.Reset;
                        PayrollAdj.FilterGroup(2);
                        PayrollAdj.SetRange("Payroll Document No.", Rec."No.");
                        PayrollAdj.FilterGroup(0);
                        if Rec.Status = Rec.Status::Open then
                            Page.RunModal(Page::"Employee Payroll Adjustment", PayrollAdj)
                        else
                            Error('Re-Open the document to make adjustments.');
                    end;
                }
                action("Export Employee Payroll")
                {
                    Image = ExportToExcel;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Export Employee Payroll action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        PayrollLine.Reset;
                        PayrollLine.SetRange("Document No.", Rec."No.");
                        Report.Run(Report::"Export Payroll Value", true, false, PayrollLine);
                    end;
                }
            }
            group("OverTime Calculation")
            {
                Caption = 'OverTime Calculation';
                action("Import OT Employee")
                {
                    Caption = '1. Import OT Employee';
                    Image = Import;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    Visible = false;
                    ToolTip = 'Executes the 1. Import OT Employee action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        // Rec.TestField(Type, Rec.Type::Adjustment);
                        // Rec.TestField("OverTime From");
                        // Rec.TestField("OverTime To");
                        // if (Rec."Encashment Code" = '') and (Rec."Encashment Period" = Rec."Encashment Period"::" ") then
                        //     Error(Text002);
                        // if not Confirm(Text001, false) then
                        //     exit;
                        // if Rec."Encashment Code" <> '' then
                        //     PayrollEngine.ImportOTEmployeeEncashCode(Rec);

                        // if Rec."Encashment Period" <> Rec."Encashment Period"::" " then
                        //     PayrollEngine.ImportOTEmployeeEncashPeriod(Rec);
                    end;
                }
                action("Update OT Amount")
                {
                    Caption = '2. Update OT Amount';
                    Image = UpdateUnitCost;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    Visible = false;
                    ToolTip = 'Executes the 2. Update OT Amount action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        // if (Rec."Encashment Code" = '') and (Rec."Encashment Period" = Rec."Encashment Period"::" ") then
                        //     Error(Text002);
                        // if Rec."Encashment Code" <> '' then
                        //     PayrollEngine.UpdateOTAmountEncashCode(Rec);
                        // if Rec."Encashment Period" <> Rec."Encashment Period"::" " then
                        //     PayrollEngine.UpdateOTAmountEncashPeriod(Rec);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        UserSetup.Get(UserId);
        if UserSetup."Allow Previous Year Payroll" then
            PrevYearPayroll := true
        else
            PrevYearPayroll := false;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.FilterGroup(2);
        TypeFilter := Rec.GetFilter(Type);
        Rec.FilterGroup(0);
        if TypeFilter = Format(Rec.Type::Payroll) then
            Rec.Validate(Type, Rec.Type::Payroll)
        else if TypeFilter = Format(Rec.Type::Resignation) then
            Rec.Validate(Type, Rec.Type::Resignation)
        else if TypeFilter = Format(Rec.Type::Settlement) then
            Rec.Validate(Type, Rec.Type::Settlement)
        else begin
            Rec.Validate(Type, Rec.Type::Adjustment);
            Rec.Validate(Irregular, true);
        end;
        Rec.Status := rec.Status::Open;
        if Rec.Type = Rec.Type::Adjustment then begin
            AjustmentVisible := true;
            CurrPage.Caption := 'Adjustment Plan';
        end;
    end;

    trigger OnOpenPage()
    begin
        if Rec.Type = Rec.Type::Adjustment then begin
            AjustmentVisible := true;
            CurrPage.Caption := 'Adjustment Plan';
        end;
        if Rec.Type = Rec.Type::Resignation then
            CurrPage.Caption := 'Resignation Payroll Plan';
        if Rec.Type in [Rec.Type::Adjustment, Rec.Type::Resignation] then
            VisiblePrevYearPayroll := true
        else
            VisiblePrevYearPayroll := false;
    end;

    var
        TypeFilter: Text;
        PayrollAdj: Record "Employee Payroll Adjustment";
        AjustmentVisible: Boolean;
        PayrollLine: Record "Payroll Line";
        UserSetup: Record "User Setup";
        PrevYearPayroll: Boolean;
        VisiblePrevYearPayroll: Boolean;
}
