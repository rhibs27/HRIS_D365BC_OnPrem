page 50045 "Posted Payroll Plan"
{
    // version PRM19.01.01
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Posted Payroll Header";
    ApplicationArea = All;
    layout
    {
        area(Content)
        {
            group(General)
            {
                Editable = false;
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                    ApplicationArea = All;
                }
                field("Pay Cycle Code"; Rec."Pay Cycle Code")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Pay Cycle Code field.';
                    ApplicationArea = All;
                }
                field("Pay Cycle Term"; Rec."Pay Cycle Term")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Pay Cycle Term field.';
                    ApplicationArea = All;
                }
                field("Pay Cycle Period"; Rec."Pay Cycle Period")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Pay Cycle Period field.';
                    ApplicationArea = All;
                }
                field("Nepali Year"; Rec."Nepali Year")
                {
                    Importance = Additional;
                    ToolTip = 'Specifies the value of the Nepali Year field.';
                    ApplicationArea = All;
                }
                field("Nepali Month"; Rec."Nepali Month")
                {
                    Caption = 'Payroll Cycle Month';
                    Importance = Additional;
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
                field("Posting Description"; Rec."Posting Description")
                {
                    ToolTip = 'Specifies the value of the Posting Description field.';
                    ApplicationArea = All;
                }
                field("Employee Type"; Rec."Employee Type")
                {
                    ToolTip = 'Specifies the value of the Employee Type field.';
                    ApplicationArea = All;
                }
                field("Assigned User ID"; Rec."Assigned User ID")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Assigned User ID field.';
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
                field(Remarks; Rec.Remarks)
                {
                    Importance = Additional;
                    ToolTip = 'Specifies the value of the Remarks field.';
                    ApplicationArea = All;
                }
                field(Irregular; Rec.Irregular)
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Irregular field.';
                    ApplicationArea = All;
                }
                field("Gross Payment"; Rec."Gross Payment")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Gross Payment field.';
                    ApplicationArea = All;
                }
                field(Narration; Rec.Narration)
                {
                    ToolTip = 'Specifies the value of the Narration field.';
                    ApplicationArea = All;
                }
                field(Reversed; Rec.Reversed)
                {
                    ToolTip = 'Specifies the value of the Reversed field.';
                    ApplicationArea = All;
                }
                field("Previous Year Payroll"; Rec."Previous Year Payroll")
                {
                    ToolTip = 'Specifies the value of the Previous Year Payroll field.';
                    ApplicationArea = All;
                }
                field("OverTime From"; Rec."OverTime From")
                {
                    ToolTip = 'Specifies the value of the OverTime From field.';
                    ApplicationArea = All;
                }
                field("OverTime To"; Rec."OverTime To")
                {
                    ToolTip = 'Specifies the value of the OverTime To field.';
                    ApplicationArea = All;
                }
                field("Encashment Period"; Rec."Encashment Period")
                {
                    ToolTip = 'Specifies the value of the Encashment Period field.';
                    ApplicationArea = All;
                }
            }
            part(Control26; "Posted Payroll Subform")
            {
                Editable = false;
                SubPageLink = "Document No." = field("No.");
                ApplicationArea = All;
            }
            part(Control39; "Document Workflow")
            {
                SubPageLink = "Primary Key" = field("No.");
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        area(Navigation)
        {
            action("&Navigate")
            {
                Caption = '&Navigate';
                Image = Navigate;
                ToolTip = 'Executes the &Navigate action.';
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Rec.Navigate;
                end;
            }
            action("Send Email")
            {
                Image = Email;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Send Email action.';
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Rec.SendEmail(Rec."No.");
                end;
            }
            action(Reverse)
            {
                Image = ReverseLines;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Reverse action.';
                ApplicationArea = All;
                trigger OnAction()
                var
                    PostedPayrollHeader: Record "Posted Payroll Header";
                    PayrollEngine: Codeunit "Payroll Engine";
                begin
                    CurrPage.SetSelectionFilter(PostedPayrollHeader);
                    Rec.ReverseDocument(PostedPayrollHeader);
                    PayrollEngine.ModifyLeaveEarnEmployeeDetails(PostedPayrollHeader);
                end;
            }
            action(OpenInExcel)
            {
                ApplicationArea = All;
                Caption = 'Open in Excel';
                Image = Excel;
                ToolTip = 'Open the data in Excel for analysis or editing';
                trigger OnAction()
                var
                    EditInExcel: Codeunit "Edit in Excel";
                begin
                    EditInExcel.EditPageInExcel('Posted Payroll Plan' + Rec."No.", Page::"Payroll Plan");
                end;
            }
            action("Payroll CIT")
            {
                AccessByPermission = tabledata "Posted Payroll Header" = I;
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                Visible = false;
                ToolTip = 'Executes the Payroll CIT action.';
                ApplicationArea = All;
                trigger OnAction()
                begin
                    PostedPayrollHeaderRec.Reset;
                    PostedPayrollHeaderRec.SetRange("No.", Rec."No.");
                    Report.Run(50106, true, true, PostedPayrollHeaderRec);
                end;
            }
            action("Payroll PF")
            {
                AccessByPermission = tabledata "Posted Payroll Header" = I;
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                Visible = false;
                ToolTip = 'Executes the Payroll PF action.';
                ApplicationArea = All;
                trigger OnAction()
                begin
                    PostedPayrollHeaderRec.Reset;
                    PostedPayrollHeaderRec.SetRange("No.", Rec."No.");
                    Report.Run(50107, true, true, PostedPayrollHeaderRec);
                end;
            }
            action("Payroll Slip")
            {
                Image = Check;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Payroll Slip action.';
                ApplicationArea = All;
                trigger OnAction()
                begin
                    PostedPayrollHeaderRec.Reset;
                    PostedPayrollHeaderRec.SetRange("No.", Rec."No.");
                    PayrollSlipReport.PassParPortal('', Rec."Nepali Year", Rec."Nepali Month");
                    PayrollSlipReport.SetTableView(PostedPayrollHeaderRec);
                    PayrollSlipReport.Run();
                end;
            }
            action("Bank Statement")
            {
                Image = BankAccountLedger;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Bank Statement action.';
                ApplicationArea = All;
                trigger OnAction()
                begin
                    PostedPayrollHeaderRec.Reset;
                    PostedPayrollHeaderRec.SetRange("No.", Rec."No.");
                    Report.Run(Report::"Bank Sheet", true, true, PostedPayrollHeaderRec);
                end;
            }
            action("Tax Audit Sheet Report")
            {
                caption = 'Salary Sheet';
                Image = ExportToExcel;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Tax Audit Sheet Report action.';
                ApplicationArea = All;
                trigger OnAction()
                begin
                    PostedPayrollLine.Reset;
                    PostedPayrollLine.SetRange("Document No.", Rec."No.");
                    Report.Run(Report::"Export Posted Payroll Value", true, false, PostedPayrollLine);
                end;
            }
            action("Export to Excel")
            {
                Image = Excel;
                Promoted = true;
                PromotedCategory = "Report";
                ToolTip = 'Executes the Export to Excel action.';
                ApplicationArea = All;
                Caption = 'Pay Summary';
                trigger OnAction()
                begin
                    PostedPayrollLine.Reset;
                    PostedPayrollLine.SetRange("Document No.", Rec."No.");
                    Report.Run(Report::"Export Posted Payroll Value", true, false, PostedPayrollLine);
                end;
            }
            group(Functions)
            {
                Caption = 'Functions';
                Visible = false;
                action(PostCITPayment)
                {
                    Caption = 'Post CIT';
                    Image = PostDocument;
                    ToolTip = 'Executes the Post CIT action.';
                    ApplicationArea = All;
                    trigger OnAction()
                    begin
                        PayrollEngine.PostCITPayment(Rec);
                    end;
                }
                action(PostPFContribution)
                {
                    Caption = 'Post PF';
                    Image = PostDocument;
                    ToolTip = 'Executes the Post PF action.';
                    ApplicationArea = All;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    trigger OnAction()
                    begin
                        PayrollEngine.PostPFContribution(Rec);
                    end;
                }
                action(PostIncometax)
                {
                    Caption = 'Post Income tax';
                    Image = PostDocument;
                    ToolTip = 'Executes the Post Income tax action.';
                    ApplicationArea = All;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    trigger OnAction()
                    begin
                        PayrollEngine.PostIncomeTax(Rec);
                    end;
                }
                action(ReSet)
                {
                    ApplicationArea = Suite;
                    Caption = 'ReSet';
                    Image = ReOpen;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    ToolTip = 'Reopen the document to change it after it has been journal created.';
                    Visible = false;
                    trigger OnAction()
                    begin
                        PayrollEngine.Reopen(Rec);  //SRT
                    end;
                }
            }
        }
    }
    trigger OnOpenPage()
    begin
        if Rec.Type = Rec.Type::Adjustment then begin
            CurrPage.Caption := 'Posted Adjustment Plan';
        end;
        if Rec.Type = Rec.Type::Resignation then
            CurrPage.Caption := 'Posted Resignation Payroll Plan';
    end;

    var
        PostedPayrollHeaderRec: Record "Posted Payroll Header";
        PayrollEngine: Codeunit "Payroll Engine";
        PostedPayrollLine: Record "Posted Payroll Line";
        PayrollSlipReport: Report "Payroll Payslip";
}
