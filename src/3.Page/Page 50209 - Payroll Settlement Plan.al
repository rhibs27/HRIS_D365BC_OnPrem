page 50209 "Payroll Settlement Plan"
{
    // version PRM19.01.01

    PageType = Card;
    SourceTable = "Payroll Header";
    ApplicationArea = All;

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
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    Visible = true;
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                    ApplicationArea = All;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    Visible = true;
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code field.';
                    ApplicationArea = All;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ToolTip = 'Specifies the value of the Responsibility Center field.';
                    ApplicationArea = All;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ToolTip = 'Specifies the value of the Document Date field.';
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.';
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
                field("Nepali Month"; Rec."Nepali Month")
                {
                    Importance = Additional;
                    ToolTip = 'Specifies the value of the Nepali Month field.';
                    ApplicationArea = All;
                }
                field("Nepali Year"; Rec."Nepali Year")
                {
                    Importance = Additional;
                    ToolTip = 'Specifies the value of the Nepali Year field.';
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
                field(Remarks; Rec.Remarks)
                {
                    Importance = Additional;
                    ToolTip = 'Specifies the value of the Remarks field.';
                    ApplicationArea = All;
                }
                field(Irregular; Rec.Irregular)
                {
                    ToolTip = 'Specifies the value of the Irregular field.';
                    ApplicationArea = All;
                }
            }
            part(Control26; "Payroll Settlement Subform")
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
                    ToolTip = 'Executes the Get Attributes action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        PayrollHeader: Record "Payroll Header";
                    begin
                        //CurrPage.SETSELECTIONFILTER(PayrollHeader);
                        //GetDetails(PayrollHeader);

                        PayrollHeader.Reset;
                        PayrollHeader.SetRange("No.", Rec."No.");
                        if PayrollHeader.FindFirst then begin
                            Rec.UpdatePayrollAttributeUsage(PayrollHeader);
                            Rec.GetDetails(PayrollHeader);
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
                action(Release)
                {
                    Image = ReleaseDoc;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = false;
                    ToolTip = 'Executes the Release action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        Rec.ReleaseDocument;
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
                    ToolTip = 'Executes the P&ost action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        Codeunit.Run(Codeunit::"Payroll-Post", Rec);
                    end;
                }
                action("Import Employee")
                {
                    Image = Import;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Import Employee action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        Rec.ImportEmployee;
                    end;
                }
                action("Bank Account")
                {
                    Image = BankAccount;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = false;
                    ToolTip = 'Executes the Bank Account action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        Rec.OpenBalancingAccount;
                    end;
                }
                action("Salary Statement Preview")
                {
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Salary Statement Preview action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        PayrollHeaderRec.Reset;
                        PayrollHeaderRec.SetRange("No.", Rec."No.");
                        Report.Run(50103, true, true, PayrollHeaderRec);
                    end;
                }
            }
        }
    }

    trigger OnInit()
    begin
        Rec.Validate(Type, Rec.Type::Resignation);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Validate(Type, Rec.Type::Resignation);
    end;

    var
        PayrollHeaderRec: Record "Payroll Header";
}
