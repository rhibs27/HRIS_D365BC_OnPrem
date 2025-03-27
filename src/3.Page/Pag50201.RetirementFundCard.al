page 50201 "Retirement Fund Card"
{
    PageType = Card;
    SourceTable = "Retirement Fund";
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
                    Visible = false;
                    ToolTip = 'Specifies the value of the No. field.';
                    ApplicationArea = All;

                    trigger OnAssistEdit()
                    begin
                        if AssistEdit(xRec) then
                            CurrPage.Update;
                    end;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the value of the Employee No. field.';
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.';
                    ApplicationArea = All;
                }
                field("Fiscal Year"; Rec."Fiscal Year")
                {
                    ToolTip = 'Specifies the value of the Fiscal Year field.';
                    ApplicationArea = All;
                }
                field("Payroll Month"; Rec."Payroll Month")
                {
                    ToolTip = 'Specifies the value of the Payroll Month field.';
                    ApplicationArea = All;
                }
                field(Remarks; Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field.';
                    ApplicationArea = All;
                }
            }
            group("Past Details")
            {
                Caption = 'Past Details';
                Editable = false;
                field("Annual Accessible Income"; Rec."Annual Accessible Income")
                {
                    ToolTip = 'Specifies the value of the Annual Accessible Income field.';
                    ApplicationArea = All;
                }
                field("RF Contribution Eligible Amt"; "RF Contribution Eligible Amt")
                {
                    ToolTip = 'Specifies the value of the RF Contribution Eligible Amt field.';
                    ApplicationArea = All;
                }
                field("Provident Fund Deposited"; "Provident Fund Deposited")
                {
                    ToolTip = 'Specifies the value of the Provident Fund Deposited field.';
                    ApplicationArea = All;
                }
                field("RF Contribution Deposited"; "RF Contribution Deposited")
                {
                    ToolTip = 'Specifies the value of the RF Contribution Deposited field.';
                    ApplicationArea = All;
                }
                field("Provident Fund Projected"; "Provident Fund Projected")
                {
                    ToolTip = 'Specifies the value of the Provident Fund Projected field.';
                    ApplicationArea = All;
                }
                field("Actual/Projected Contribution"; "Actual/Projected Contribution")
                {
                    ToolTip = 'Specifies the value of the Actual/Projected Contribution field.';
                    ApplicationArea = All;
                }
                field("Additional Space for RF Cont."; "Additional Space for RF Cont.")
                {
                    ToolTip = 'Specifies the value of the Additional Space for RF Cont. field.';
                    ApplicationArea = All;
                }
                field("Projection Month"; "Projection Month")
                {
                    ToolTip = 'Specifies the value of the Projection Month field.';
                    ApplicationArea = All;
                }
                field("Actual Lumpsump CIT"; "Actual Lumpsump CIT")
                {
                    ToolTip = 'Specifies the value of the Actual Lumpsump CIT field.';
                    ApplicationArea = All;
                }
                field("Actual Lumpsump RTF"; "Actual Lumpsump RTF")
                {
                    ToolTip = 'Specifies the value of the Actual Lumpsump RTF field.';
                    ApplicationArea = All;
                }
                field("Lumpsum Committed Contribution"; "Lumpsum Committed Contribution")
                {
                    ToolTip = 'Specifies the value of the Lumpsum Committed Contribution field.';
                    ApplicationArea = All;
                }
            }
            group("Current Details")
            {
                Caption = 'Current Details';
                Editable = not IsScreened;
                group(Monthly)
                {
                    Caption = 'Monthly';
                    field("RTF Amount (Month)"; "RTF Amount (Month)")
                    {
                        Caption = 'RTF';
                        ToolTip = 'Specifies the value of the RTF field.';
                        ApplicationArea = All;
                    }
                    field("CIT Amount (Month)"; "CIT Amount (Month)")
                    {
                        Caption = 'CIT';
                        ToolTip = 'Specifies the value of the CIT field.';
                        ApplicationArea = All;
                    }
                }
                group(Lumpsum)
                {
                    Caption = 'Lumpsum';
                    field("RTF Amount (Lumpsum)"; "RTF Amount (Lumpsum)")
                    {
                        Caption = 'RTF';
                        ToolTip = 'Specifies the value of the RTF field.';
                        ApplicationArea = All;
                    }
                    field("CIT Amount( Lumpsum)"; "CIT Amount( Lumpsum)")
                    {
                        Caption = 'CIT';
                        ToolTip = 'Specifies the value of the CIT field.';
                        ApplicationArea = All;
                    }
                }
            }
            group(Result)
            {
                Caption = 'Result';
                Editable = false;
                field("Total Committed Contribution"; "Total Committed Contribution")
                {
                    ToolTip = 'Specifies the value of the Total Committed Contribution field.';
                    ApplicationArea = All;
                }
                field("Total Deduction"; "Total Deduction")
                {
                    ToolTip = 'Specifies the value of the Total Deduction field.';
                    ApplicationArea = All;
                }
                field(Difference; Difference)
                {
                    ToolTip = 'Specifies the value of the Difference field.';
                    ApplicationArea = All;
                }
            }
            group(Approval)
            {
                Caption = 'Approval';
                Editable = false;
                field("Approval Status"; "Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.';
                    ApplicationArea = All;
                }
                field("Created Date"; "Created Date")
                {
                    ToolTip = 'Specifies the value of the Created Date field.';
                    ApplicationArea = All;
                }
                field("Requested Date"; "Requested Date")
                {
                    ToolTip = 'Specifies the value of the Requested Date field.';
                    ApplicationArea = All;
                }
                field("Screened Date"; "Screened Date")
                {
                    ToolTip = 'Specifies the value of the Screened Date field.';
                    ApplicationArea = All;
                }
                field("Screened By"; "Screened By")
                {
                    ToolTip = 'Specifies the value of the Screened By field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Submit)
            {
                Image = Suggest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = ActionVisible;
                ToolTip = 'Executes the Submit action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if HRMgt.ApplyForRetirementFund(Rec) then begin
                        IsApplied := true;
                        CurrPage.Close;
                    end;
                end;
            }
            action(Screen)
            {
                Image = Stages;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Screen action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if not Confirm('Do you want to screen the document ?', false) then
                        exit;
                    HRMgt.ScreenRF(Rec);

                    Message('Document screened successfully.');
                end;
            }
            action(Reopen)
            {
                Image = ReOpen;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Reopen action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if not Confirm('Do you want to repoen the document ?', false) then
                        exit;
                    Rec.TestField("Approval Status", "Approval Status"::"Pending Approval");
                    "Approval Status" := "Approval Status"::Open;
                    Rec.Modify;
                    Message('Document open successfully.');
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        IsScreened := "Approval Status" = "Approval Status"::Screened;
        ActionVisible := "Approval Status" in ["Approval Status"::Open, "Approval Status"::" "];
    end;

    trigger OnOpenPage()
    begin
        IsScreened := "Approval Status" = "Approval Status"::Screened;
        ActionVisible := "Approval Status" in ["Approval Status"::Open, "Approval Status"::" "];
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        //IF NOT IsApplied THEN
        //IF NOT CONFIRM('The data will be erased. Do you want to continue?',TRUE) THEN
        //ERROR('');
    end;

    var
        HRMgt: Codeunit "HR Mgt.";
        IsApplied: Boolean;
        IsScreened: Boolean;
        ActionVisible: Boolean;
}
