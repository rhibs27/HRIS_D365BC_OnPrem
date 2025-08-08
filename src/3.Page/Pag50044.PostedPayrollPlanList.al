page 50044 "Posted Payroll Plan List"
{
    // version PRM19.01.01

    CardPageId = "Posted Payroll Plan";
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Posted Payroll Header";
    SourceTableView = sorting("Posted Date")
                      order(ascending);
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Select; Select)
                {
                    Visible = IsSelected;
                    ToolTip = 'Specifies the value of the Select field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        InserttoPostedDoc;
                    end;
                }
                field("No."; Rec."No.")
                {
                    Width = 20;
                    ToolTip = 'Specifies the value of the No. field.';
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.';
                    ApplicationArea = All;
                }
                field(Narration; Rec.Narration)
                {
                    Width = 60;
                    ToolTip = 'Specifies the value of the Narration field.';
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                    ApplicationArea = All;
                }
                field("Assigned User ID"; Rec."Assigned User ID")
                {
                    ToolTip = 'Specifies the value of the Assigned User ID field.';
                    ApplicationArea = All;
                }
                field(Month; Rec.Month)
                {
                    ToolTip = 'Specifies the value of the Month field.';
                    ApplicationArea = All;
                }
                field("Nepali Month"; Rec."Nepali Month")
                {
                    ToolTip = 'Specifies the value of the Nepali Month field.';
                    ApplicationArea = All;
                }
                field("Nepali Year"; Rec."Nepali Year")
                {
                    ToolTip = 'Specifies the value of the Nepali Year field.';
                    ApplicationArea = All;
                }
                field("Employee Type"; Rec."Employee Type")
                {
                    ToolTip = 'Specifies the value of the Employee Type field.';
                    ApplicationArea = All;
                }
                field(Irregular; Rec.Irregular)
                {
                    ToolTip = 'Specifies the value of the Irregular field.';
                    ApplicationArea = All;
                }
                field(Reversed; Rec.Reversed)
                {
                    ToolTip = 'Specifies the value of the Reversed field.';
                    ApplicationArea = All;
                }
                field("Pay Cycle Code"; Rec."Pay Cycle Code")
                {
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
                field("Encashment Code"; Rec."Encashment Code")
                {
                    ToolTip = 'Specifies the value of the Encashment Code field.';
                    ApplicationArea = All;
                }
                field("Encashment Period"; Rec."Encashment Period")
                {
                    ToolTip = 'Specifies the value of the Encashment Period field.';
                    ApplicationArea = All;
                }
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
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ToolTip = 'Executes the &Navigate action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.Navigate;
                end;
            }
            action(PostCITPayment)
            {
                Caption = 'Post CIT';
                Image = PostDocument;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Post CIT action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    //PostedPayrollHdr.RESET;
                    PostedPayrollHdr.Copy(Rec);
                    CurrPage.SetSelectionFilter(PostedPayrollHdr);
                    if PostedPayrollHdr.FindFirst then
                        repeat
                            PayrollEngine.PostCITPayment(PostedPayrollHdr);
                        until PostedPayrollHdr.Next = 0;
                end;
            }
            action(PostPFContribution)
            {
                Caption = 'Post PF';
                Image = PostDocument;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Post PF action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    //PostedPayrollHdr.RESET;
                    PostedPayrollHdr.Copy(Rec);
                    CurrPage.SetSelectionFilter(PostedPayrollHdr);
                    if PostedPayrollHdr.FindFirst then
                        repeat
                            PayrollEngine.PostPFContribution(PostedPayrollHdr);
                        until PostedPayrollHdr.Next = 0;
                end;
            }
            action(PostIncometax)
            {
                Caption = 'Post Income tax';
                Image = PostDocument;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Post Income tax action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    //PostedPayrollHdr.RESET;
                    PostedPayrollHdr.Copy(Rec);
                    CurrPage.SetSelectionFilter(PostedPayrollHdr);
                    if PostedPayrollHdr.FindFirst then
                        repeat
                            PayrollEngine.PostIncomeTax(PostedPayrollHdr);
                        until PostedPayrollHdr.Next = 0;
                end;
            }
            action("Export Payroll Data")
            {
                Image = Export;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = not IsSelected;
                ToolTip = 'Executes the Export Payroll Data action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Report.Run(Report::"Export Payroll Data", true, false);
                end;
            }
            action("Payroll Summary Voucher")
            {
                Image = PrintVoucher;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                ToolTip = 'Executes the Payroll Summary Voucher action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    PostedPayrollHdr.Reset;
                    PostedPayrollHdr.SetRange("No.", Rec."No.");
                    Report.Run(Report::"Payroll Summary Voucher", true, true, PostedPayrollHdr);
                end;
            }
            action("Tax Audit Sheet Report")
            {
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
            action("Payroll Voucher")
            {
                Image = PrintReport;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                ToolTip = 'Executes the Payroll Voucher action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    PostedPayrollHdr.Reset;
                    PostedPayrollHdr.SetRange("No.", Rec."No.");
                    Report.Run(Report::"Payroll voucher", true, true, PostedPayrollHdr);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        CurrPage.Editable(IsSelected);
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        Clear(PostedDocument);
        Clear(TempPostedPayHeader);
        if TempPostedPayHeader.Find('-') then
            repeat
                if PostedDocument = '' then
                    PostedDocument := TempPostedPayHeader."No."
                else
                    PostedDocument += '|' + TempPostedPayHeader."No.";
            until TempPostedPayHeader.Next = 0;
        TempPostedPayHeader.DeleteAll;
    end;

    var
        PayrollEngine: Codeunit "Payroll Engine";
        PostedPayrollHdr: Record "Posted Payroll Header";
        Select: Boolean;

        IsSelected: Boolean;
        TempPostedPayHeader: Record "Posted Payroll Header" temporary;
        PostedDocument: Text;
        PostedPayrollLine: Record "Posted Payroll Line";

    procedure ToSelect()
    begin
        IsSelected := true
    end;

    local procedure InserttoPostedDoc()
    begin
        if Select then begin
            TempPostedPayHeader.Reset;
            TempPostedPayHeader.SetRange("No.", Rec."No.");
            if not TempPostedPayHeader.FindFirst then begin
                TempPostedPayHeader.Init;
                TempPostedPayHeader.Validate("No.", Rec."No.");
                TempPostedPayHeader.Insert;
            end;
        end else begin
            TempPostedPayHeader.Reset;
            TempPostedPayHeader.SetRange("No.", Rec."No.");
            if TempPostedPayHeader.FindFirst then
                TempPostedPayHeader.Delete;
        end;
    end;

    procedure ReturnPostedDocext(): Text
    begin
        exit(PostedDocument);
    end;
}
