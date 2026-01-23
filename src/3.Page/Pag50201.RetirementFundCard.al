page 50201 "Retirement Fund Card"
{
    PageType = Card;
    SourceTable = "Retirement Fund";
    ApplicationArea = All;
    //  InsertAllowed = false;

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
                        if Rec.AssistEdit(xRec) then
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
            }
            group("Annual Income Details")
            {
                Editable = false;
                Visible = false;
                field("Annual Accessible Income"; Rec."Annual Assessable Income")
                {
                    ToolTip = 'Specifies the value of the Annual Accessible Income field.';
                    ApplicationArea = All;
                }
                field("RF Contribution Eligible Amt"; Rec."RF Contribution Eligible Amt")
                {
                    ToolTip = 'Specifies the value of the RF Contribution Eligible Amt field.';
                    ApplicationArea = All;
                }
                field("Provident Fund Deposited"; Rec."Provident Fund Deposited")
                {
                    ToolTip = 'Specifies the value of the Provident Fund Deposited field.';
                    ApplicationArea = All;
                }
                field("RF Contribution Deposited"; Rec."RF Contribution Deposited")
                {
                    ToolTip = 'Specifies the value of the RF Contribution Deposited field.';
                    ApplicationArea = All;
                }
                field("Provident Fund Projected"; Rec."Provident Fund Projected")
                {
                    ToolTip = 'Specifies the value of the Provident Fund Projected field.';
                    ApplicationArea = All;
                }
                field("Actual/Projected Contribution"; Rec."Actual/Projected Contribution")
                {
                    ToolTip = 'Specifies the value of the Actual/Projected Contribution field.';
                    ApplicationArea = All;
                }
                field("Additional Space for RF Cont."; Rec."Additional Space for RF Cont.")
                {
                    ToolTip = 'Specifies the value of the Additional Space for RF Cont. field.';
                    ApplicationArea = All;
                }
                field("Projection Month"; Rec."Projection Month")
                {
                    ToolTip = 'Specifies the value of the Projection Month field.';
                    ApplicationArea = All;
                }
                field("Actual Lumpsump CIT"; Rec."Actual Lumpsump CIT")
                {
                    ToolTip = 'Specifies the value of the Actual Lumpsump CIT field.';
                    ApplicationArea = All;
                }
                field("Actual Lumpsump RTF"; Rec."Actual Lumpsump RTF")
                {
                    ToolTip = 'Specifies the value of the Actual Lumpsump RTF field.';
                    ApplicationArea = All;
                }
                field("Lumpsum Committed Contribution"; Rec."Lumpsum Committed Contribution")
                {
                    ToolTip = 'Specifies the value of the Lumpsum Committed Contribution field.';
                    ApplicationArea = All;
                }
            }
            group("Current Details")
            {
                Caption = 'Current Details';
                Editable = IsOpen;
                group(Monthly)
                {
                    Caption = 'Monthly';
                    field("Recommended Monthly CIT/RF"; Rec."Recommended Monthly CIT/RF")
                    {
                        Editable = false;
                        ToolTip = 'Optimal monthly retirement deposit to minimize TAX';
                    }
                    field("RTF Amount (Month)"; Rec."RTF Amount (Month)")
                    {
                        Caption = 'RTF';
                        Visible = false;
                        ToolTip = 'Specifies the value of the RTF field.';
                        ApplicationArea = All;
                    }
                    field("CIT Amount (Month)"; Rec."CIT Amount (Month)")
                    {
                        Caption = 'CIT';
                        Visible = false;
                        ToolTip = 'Specifies the value of the CIT field.';
                        ApplicationArea = All;
                    }
                    field("Attribute Code"; Rec."Attribute Code")
                    {
                        ToolTip = 'Specifies the value of the Attribute Code field.';
                        ApplicationArea = All;
                    }
                    field(Type; Rec.Type)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Type field.';
                        trigger OnValidate()
                        begin
                            Rec.TestField("Attribute Code");
                        end;
                    }
                    field("One Time Contribution"; Rec."One Time Contribution")
                    {
                        Caption = 'One Time Contribution';
                        ToolTip = 'Specifies the value of the One Time Contribution field.';
                        ApplicationArea = All;
                    }
                }
                group(Lumpsum)
                {
                    Caption = 'Lumpsum';
                    Visible = false;
                    field("RTF Amount (Lumpsum)"; Rec."RTF Amount (Lumpsum)")
                    {
                        Caption = 'RTF';
                        ToolTip = 'Specifies the value of the RTF field.';
                        ApplicationArea = All;
                    }
                    field("CIT Amount( Lumpsum)"; Rec."CIT Amount( Lumpsum)")
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
                field("Total Committed Contribution"; Rec."Total Committed Contribution")
                {
                    ToolTip = 'Specifies the value of the Total Committed Contribution field.';
                    ApplicationArea = All;
                }
                field("Total Deduction"; Rec."Total Deduction")
                {
                    ToolTip = 'Specifies the value of the Total Deduction field.';
                    ApplicationArea = All;
                }
                field(Difference; Rec.Difference)
                {
                    ToolTip = 'Specifies the value of the Difference field.';
                    ApplicationArea = All;
                }
            }
            group(Approval)
            {
                Caption = 'Approval';

                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Created Date"; Rec."Created Date")
                {
                    ToolTip = 'Specifies the value of the Created Date field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Requested Date"; Rec."Requested Date")
                {
                    ToolTip = 'Specifies the value of the Requested Date field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Rejection Remarks"; Rec."Rejection Remarks")
                {
                    ToolTip = 'Specifies the value of the Rejection Remarks field.';
                    ApplicationArea = All;
                    Visible = IsPending;
                }
            }
            part("RF Contribution Lines"; "RF Contribution Lines")
            {
                SubPageLink = "Document No." = field("No.");
                ApplicationArea = all;
                Editable = IsOpen;
            }
            part("Approval Subform"; "HRMS Approval Entry")
            {
                SubPageLink = "Document No." = field("No.");
                ApplicationArea = all;
                Editable = false;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Submit for Approval")
            {
                Image = Apply;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = IsOpen;
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

            action(Approve)
            {
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = IsPending;
                ToolTip = 'Executes the Approve Request action.';
                ApplicationArea = All;
                trigger OnAction()
                begin
                    if Confirm('Do you want to approve the request?', false) then begin
                        RecRef.GetTable(Rec);
                        ApprovalMgt.ApproveRejectDocument(RecRef, true);
                        Rec."Rejection Remarks" := '';
                        Message('Retirement fund is Approved by %1', HRMgt.GetEmpName());
                    end;
                end;
            }
            action("Reject Request")
            {
                Image = Reject;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Reject Request action.';
                ApplicationArea = All;
                Visible = IsPending;
                trigger OnAction()
                begin
                    if Confirm('Do you want reject the request?', false) then begin
                        IF REC."Rejection Remarks" = '' then
                            Error('Rejection Remarks is Empty')
                        else begin
                            RecRef.GetTable(Rec);
                            ApprovalMgt.ApproveRejectDocument(RecRef, false);
                            Message('Retirement Fund is Rejected by %1', HRMgt.GetEmpName());
                        end;
                    end;
                end;
            }
            action(Withdraw)
            {
                Image = CancelLine;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the WithDraw Request action.';
                ApplicationArea = All;
                Visible = IsPending;
                trigger OnAction()
                begin
                    if Confirm('Do you want WithDraw the request?', false) then begin
                        RecRef.GetTable(Rec);
                        ApprovalMgt.WithDrawRequest(RecRef);
                        Message('Retirement request has been withdrew.');
                    end;
                end;
            }
            action(Cancel)
            {
                Image = CancelLine;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;
                Visible = IsApproved;
                // trigger OnAction()
                // var
                //     PortalFunctions: Page "Portal Functions";
                //     CancellationRemarks: Text;
                //     FilterPageBuilder: FilterPageBuilder;
                //     RetirementFund: Record "Retirement Fund";
                // begin
                //     Rec.TestField("Approval Status", Rec."Approval Status"::Approved);
                //     Clear(FilterPageBuilder);
                //     FilterPageBuilder.AddRecord('Cancel RF', RetirementFund);
                //     FilterPageBuilder.AddField('Cancel RF', RetirementFund."Remarks");
                //     if FilterPageBuilder.RunModal() then begin
                //         RetirementFund.SetView(FilterPageBuilder.GetView('cancel RF'));
                //         CancellationRemarks := RetirementFund.GetFilter(Remarks);
                //         Rec."Remarks" := CancellationRemarks;
                //         PortalFunctions.CancelApprovedRF(rec."No.", CancellationRemarks);
                //         Message('Retirement request has been canceled.');
                //     end
                // end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        IsScreened := Rec."Approval Status" = Rec."Approval Status"::Screened;
        IsOpen := Rec."Approval Status" in [Rec."Approval Status"::Open, Rec."Approval Status"::" "];
        IsApproved := Rec."Approval Status" = rec."Approval Status"::Approved;
    end;

    trigger OnOpenPage()
    begin
        IsScreened := Rec."Approval Status" = Rec."Approval Status"::Screened;
        IsOpen := Rec."Approval Status" in [Rec."Approval Status"::Open, Rec."Approval Status"::" "];
        IsPending := Rec."Approval Status" = Rec."Approval Status"::Pending;
        IsApproved := Rec."Approval Status" = rec."Approval Status"::Approved;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        RFContribution: Record "RF Contribution";
    begin
        RFContribution.SetRange("Document No.", '');
        RFContribution.SetRange("Employee No.", Rec."Employee No.");
        RFContribution.DeleteAll();
    end;

    var
        RecRef: RecordRef;
        HRMgt: Codeunit "HR Mgt.";
        IsApplied: Boolean;
        IsScreened: Boolean;
        IsOpen: Boolean;
        IsPending: Boolean;
        ApprovalMgt: Codeunit "Approver Mgt";
        IsApproved: Boolean;
}
