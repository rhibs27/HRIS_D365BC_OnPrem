page 50066 "Transfer Card"
{
    // version NIC Asia1.00

    // //Min -- Update field caption of "Shortcut Dimension 1 Code (To)" to "Branch Code (To)".
    // //Min 12.11.2022 -- for uneditable transfer effective date

    SourceTable = "Employee/HR Transfer";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Editable = ISOpen;
                field("No."; Rec."No.")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the No. field.';
                    ApplicationArea = All;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    Editable = true;
                    ToolTip = 'Specifies the value of the Employee No. field.';
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.';
                    ApplicationArea = All;
                }
                field("Salary Level Code"; Rec."Salary Level Code")
                {
                    ToolTip = 'Specifies the value of the Salary Level Code field.';
                    ApplicationArea = All;
                }
                field("Transfer Category"; Rec."Transfer Category")
                {
                    ToolTip = 'Specifies the value of the Transfer Category field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        GetTransferEditibility;
                    end;
                }
                field("Transfer Propose Date"; rec."Transfer Propose Date")
                {
                    ToolTip = 'Specifies the value of the "Transfer Propose Date field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Start Date"; Rec."Start Date")
                {
                    Editable = TransferCategoryEditable;
                    ToolTip = 'Specifies the value of the Start Date field.';
                    ApplicationArea = All;
                }
                field("End Date"; Rec."End Date")
                {
                    Editable = TransferCategoryEditable;
                    ToolTip = 'Specifies the value of the End Date field.';
                    ApplicationArea = All;
                }
                field("No. of Days"; Rec."No. of Days")
                {
                    ToolTip = 'Specifies the value of the No. of Days field.';
                    ApplicationArea = All;
                }
                field("Curr. Placement Period(Month)"; Rec."Curr. Placement Period(Month)")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Curr. Placement Period(Month) field.';
                    ApplicationArea = All;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Approval Status field.';
                    ApplicationArea = All;
                    Visible = ApprovalStatusView;
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Status field.';
                    ApplicationArea = All;
                    Visible = StatusView;
                }
                field("Requested Date"; Rec."Requested Date")
                {
                    Editable = false;
                    Visible = not IsOpen;
                }
            }
            group(Transfer)
            {
                field("Transfer Effective Date"; Rec."Transfer Effective Date")
                {
                    Editable = IsApproved and not rec."Is Transfer Details Added";
                    ToolTip = 'Specifies the value of the Transfer Effective Date field.';
                    ApplicationArea = All;
                }
                field("Reason For Transfer"; Rec."Reason for transfer")
                {
                    Editable = IsOpen;
                    ToolTip = 'Specifies the value of the Reason for Resignation field.';
                    ApplicationArea = All;
                    Caption = 'Reason For Transfer';
                }
                field(Description; Rec.Description)
                {
                    Editable = IsOpen;
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = All;
                }
                field("Notify to"; Rec."Notify to")
                {
                    ToolTip = 'Specifies the value of the Notify to field.';
                    ApplicationArea = All;
                    Editable = IsApproved and not rec."Is Transfer Details Added";
                }
            }
            group("On Hold")
            {
                Visible = IsHold;
                field("On Hold Date"; Rec."On Hold Date")
                {
                    ToolTip = 'Specifies the value of the On Hold Date field.';
                    ApplicationArea = All;
                }
                field("Reason For Hold"; Rec."Reason For Hold")
                {
                    ToolTip = 'Specifies the value of the Reason For Hold field.';
                    ApplicationArea = All;
                }
            }
            group(Cancelled)
            {
                Visible = Rec."Approval Status" = Rec."Approval Status"::Canceled;
                field("Cancelled Date"; Rec."Cancelled Date")
                {
                    ToolTip = 'Specifies the value of the Cancelled Date field.';
                    ApplicationArea = All;
                }
                field("Reason For Cancel"; Rec."Reason For Cancel")
                {
                    ToolTip = 'Specifies the value of the Reason For Cancel field.';
                    ApplicationArea = All;
                }
            }
            group(Placement)
            {
                field("Transfer Type"; Rec."Transfer Type")
                {
                    ToolTip = 'Specifies the value of the Transfer Type field.';
                    ApplicationArea = All;
                    Editable = IsApproved and not rec."Is Transfer Details Added";

                    trigger OnValidate()
                    begin
                        SetLayout;
                        CurrPage.UPDATE;
                    end;
                }
            }
            group(Control61)
            {
                ShowCaption = false;
                Visible = IsApproved or IsACK or IsHold;
                group("Current Placement")
                {
                    Editable = false;
                    field("Deputation On"; Rec."Deputation On")
                    {
                        ToolTip = 'Specifies the value of the Deputation On field.';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            GetTransferName;
                        end;
                    }
                    field("Extension Counter Code"; Rec."Extension Counter Code")
                    {
                        ToolTip = 'Specifies the value of the Extension Counter Code field.';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            GetTransferName;
                        end;
                    }
                    field("Extension Name"; ExtensionName)
                    {
                        ToolTip = 'Specifies the value of the ExtensionName field.';
                        ApplicationArea = All;
                    }
                    field("Functional Title"; Rec."Functional Title")
                    {
                        ToolTip = 'Specifies the value of the Functional Title field.';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            GetTransferName;
                        end;
                    }
                    field("Functional Title Desc"; FunctionalDescFrom)
                    {
                        Caption = 'Functional Title Description( From)';
                        Editable = false;
                        ToolTip = 'Specifies the value of the Functional Title Description( From) field.';
                        ApplicationArea = All;
                    }
                    field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                    {
                        ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field.';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            GetTransferName;
                        end;
                    }
                    field("Branch Name"; BranchName)
                    {
                        ToolTip = 'Specifies the value of the BranchName field.';
                        ApplicationArea = All;
                    }
                    field("Sub Province Code"; Rec."Sub Province Code")
                    {
                        ToolTip = 'Specifies the value of the Sub Province Code field.';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            GetTransferName;
                        end;
                    }
                    field("Sub-Province Name"; SubProvinceName)
                    {
                        ToolTip = 'Specifies the value of the SubProvinceName field.';
                        ApplicationArea = All;
                    }
                    field("Province Code"; Rec."Province Code")
                    {
                        ToolTip = 'Specifies the value of the Province Code field.';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            GetTransferName;
                        end;
                    }
                    field("Province Name"; ProvinceName)
                    {
                        ToolTip = 'Specifies the value of the ProvinceName field.';
                        ApplicationArea = All;
                    }
                    field("Unit Code"; Rec."Unit Code")
                    {
                        ToolTip = 'Specifies the value of the Unit Code field.';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            GetTransferName;
                        end;
                    }
                    field("Unit Name"; UnitName)
                    {
                        ToolTip = 'Specifies the value of the UnitName field.';
                        ApplicationArea = All;
                    }
                    field(Department; Rec.Department)
                    {
                        ToolTip = 'Specifies the value of the Department field.';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            GetTransferName;
                        end;
                    }
                    field("Department Name"; DepartmentName)
                    {
                        ToolTip = 'Specifies the value of the DepartmentName field.';
                        ApplicationArea = All;
                    }
                    field("Office Code"; Rec."Office Code")
                    {
                        ToolTip = 'Specifies the value of the Office Code field.';
                        ApplicationArea = All;
                    }
                }
                group("Proposed Placement")
                {
                    Editable = not Rec."Is Transfer Details Added" and IsApproved;
                    field("Deputation On (To)"; Rec."Deputation On (To)")
                    {
                        ToolTip = 'Specifies the value of the Deputation On (To) field.';
                        ApplicationArea = All;
                        Editable = IsApproved and not rec."Is Transfer Details Added";

                        trigger OnValidate()
                        begin
                            SetLayout;
                            GetTransferName;
                        end;
                    }
                    field("Extension Counter (To)"; Rec."Extension Counter (To)")
                    {
                        Editable = ExtensionCounterEdit;
                        ToolTip = 'Specifies the value of the Extension Counter (To) field.';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            GetTransferName;
                        end;
                    }
                    field("Extension Name To"; ExtensionNameTo)
                    {
                        Editable = false;
                        ToolTip = 'Specifies the value of the ExtensionNameTo field.';
                        ApplicationArea = All;
                    }
                    field("Functional Title (To)"; Rec."Functional Title (To)")
                    {
                        ToolTip = 'Specifies the value of the Functional Title (To) field.';
                        ApplicationArea = All;
                        Editable = IsApproved and not rec."Is Transfer Details Added";

                        trigger OnValidate()
                        begin
                            GetTransferName;
                        end;
                    }
                    field(FunctionalTitleTo; FunctionalDescTo)
                    {
                        Caption = 'Functional Title Description(To)';
                        //Editable = ForScreen;
                        ToolTip = 'Specifies the value of the Functional Title Description(To) field.';
                        ApplicationArea = All;
                    }
                    field("Shortcut Dimension 1 Code (To)"; Rec."Shortcut Dimension 1 Code (To)")
                    {
                        Caption = 'Branch Code (To)';
                        Editable = BranchEdit;
                        ToolTip = 'Specifies the value of the Branch Code (To) field.';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            GetTransferName;
                        end;
                    }
                    field("Branch Name To"; BranchNameTo)
                    {
                        Editable = false;
                        ToolTip = 'Specifies the value of the BranchNameTo field.';
                        ApplicationArea = All;
                    }
                    field("Sub Province Code (To)"; Rec."Sub Province Code (To)")
                    {
                        Editable = SubProvinceEdit;
                        ToolTip = 'Specifies the value of the Sub Province Code (To) field.';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            GetTransferName;
                        end;
                    }
                    field("SubProvince Name To"; SubProvinceNameTo)
                    {
                        Editable = false;
                        ToolTip = 'Specifies the value of the SubProvinceNameTo field.';
                        ApplicationArea = All;
                    }
                    field("Province Code (To)"; Rec."Province Code (To)")
                    {
                        Editable = ProvinceEdit;
                        ToolTip = 'Specifies the value of the Province Code (To) field.';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            GetTransferName;
                        end;
                    }
                    field("Province Name To"; ProvinceNameTo)
                    {
                        Editable = false;
                        ToolTip = 'Specifies the value of the ProvinceNameTo field.';
                        ApplicationArea = All;
                    }
                    field("Unit (To)"; Rec."Unit (To)")
                    {
                        Editable = UnitEdit;
                        ToolTip = 'Specifies the value of the Unit (To) field.';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            GetTransferName;
                        end;
                    }
                    field("Unit Name To"; UnitNameTo)
                    {
                        Editable = false;
                        ToolTip = 'Specifies the value of the UnitNameTo field.';
                        ApplicationArea = All;
                    }
                    field("Department Code (To)"; Rec."Department Code (To)")
                    {
                        Editable = DepartEdit;
                        ToolTip = 'Specifies the value of the Department Code (To) field.';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            GetTransferName;
                        end;
                    }
                    field("Department Name To"; DepartmentNameTo)
                    {
                        Editable = false;
                        ToolTip = 'Specifies the value of the DepartmentNameTo field.';
                        ApplicationArea = All;
                    }
                    field("Incoming Supervisior"; Rec."Incoming Supervisior")
                    {
                        ToolTip = 'Specifies the value of the Incoming Supervisior field.';
                        ApplicationArea = All;
                    }
                    field("Incoming Supervisior Name"; Rec."Incoming Supervisior Name")
                    {
                        ToolTip = 'Specifies the value of the Incoming Supervisior Name field.';
                        ApplicationArea = All;
                    }
                    field("Outgoing Branch Rep. Person"; Rec."Outgoing Branch Rep. Person")
                    {
                        ToolTip = 'Specifies the value of the Outgoing Branch Rep. Person field.';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            Rec.CalcFields("Outgoing Reporting Person Name");
                        end;
                    }
                    field("Outgoing Reporting Person Name"; Rec."Outgoing Reporting Person Name")
                    {
                        ToolTip = 'Specifies the value of the Outgoing Reporting Person Name field.';
                        ApplicationArea = All;
                    }
                }
            }
            part(Attachment; "Attachment Subform")
            {
                SubPageLink = "No." = field("No.");
                Visible = IsApproved and rec."Is Transfer Details Added" or IsACK or IsHold;
                ApplicationArea = All;
            }
            group(Remarks)
            {
                // Editable = not ForOpen and not ForApprove;
                // field("Recommender Remarks"; Rec.Remarks)
                // {
                //     Editable = IsPending;
                //     ToolTip = 'Specifies the value of the Remarks field.';
                //     ApplicationArea = All;
                //     Caption = 'Recommender Remarks';
                // }
                field("Rejection Remarks"; Rec."Rejection Remarks")
                {
                    ToolTip = 'Specifies the value of the Rejection Remarks field.';
                    ApplicationArea = All;
                    Editable = IsPending;
                    trigger OnValidate()
                    var
                        myInt: Integer;
                    begin
                        CurrPage.Update();
                        RecRef.GetTable(Rec);
                    end;
                }
                // field("Screener Remarks"; Rec."Screener Remarks")
                // {
                //     // Editable = (ForReview);
                //     // Visible = ForReview;
                //     ToolTip = 'Specifies the value of the Screener Remarks field.';
                //     ApplicationArea = All;
                // }
                // field("Reviewer Remarks"; Rec."Reviewer Remarks")
                // {
                //     // Editable = (ForRecommend) and (Rec."Approval Status" = Rec."Approval Status"::Recommended);
                //     Visible = ForRecommend;
                //     ToolTip = 'Specifies the value of the Reviewer Remarks field.';
                //     ApplicationArea = All;
                // }
            }
            // group(Approval)
            // {
            // Editable = ForOpen;

            // field("Recommender Code"; Rec."Recommender Code")
            // {
            //     Visible = Rec.Type = Rec.Type::"Employee Transfer";
            //     ToolTip = 'Specifies the value of the Recommender Code field.';
            //     ApplicationArea = All;
            // }
            // field("Recommender Name"; Rec."Recommender Name")
            // {
            //     Visible = Rec.Type = Rec.Type::"Employee Transfer";
            //     ToolTip = 'Specifies the value of the Recommender Name field.';
            //     ApplicationArea = All;
            // }
            // field("Approver Code"; Rec."Approver Code")
            // {
            //     Editable = false;
            //     ToolTip = 'Specifies the value of the Approver Code field.';
            //     ApplicationArea = All;
            // }
            // field("Approver Name"; Rec."Approver Name")
            // {
            //     ToolTip = 'Specifies the value of the Approver Name field.';
            //     ApplicationArea = All;
            // }
            // field(Reviewer; Rec.Reviewer)
            // {
            //     // Visible = Rec.Type = Rec.Type::"Employee Transfer";
            //     ToolTip = 'Specifies the value of the Reviewer field.';
            //     ApplicationArea = All;
            // }
            // field("Reviewer Name"; Rec."Reviewer Name")
            // {
            //     Visible = Rec.Type = Rec.Type::"Employee Transfer";
            //     ToolTip = 'Specifies the value of the Reviewer Name field.';
            //     ApplicationArea = All;
            // }
            // }
            group("Incoming Branch")
            {
                Visible = not IsOpen or not IsPending;
                Editable = IsApproved and rec."Is Transfer Details Added";
                field("Date of Joining Of Transfer"; Rec."Date of Joining Of Transfer")
                {
                    ToolTip = 'Specifies the value of the Date of Joining Of Transfer field.';
                    ApplicationArea = All;
                }
                field("Transfer Remarks"; Rec."Transfer Remarks")
                {
                    ToolTip = 'Specifies the value of the Transfer Remarks field.';
                    ApplicationArea = All;
                }
            }
            group(Relocation)
            {
                Visible = IsApproved and rec."Is Transfer Details Added";
                Editable = IsApproved and rec."Is Transfer Details Added" and not isACK;
                field("Relocation Distance";
                Rec."Relocation Distance")
                {
                    ToolTip = 'Specifies the value of the Relocation Distance field.';
                    ApplicationArea = All;
                }
                field("Relocation Allow."; Rec."Relocation Allow.")
                {
                    Caption = 'Relocation Allowance';
                    ToolTip = 'Specifies the value of the Relocation Allowance field.';
                    ApplicationArea = All;
                }
            }
            part("Approval Subform"; "HRMS Approval Entry")
            {
                Editable = false;
                SubPageLink = "Document No." = field("No."),
                                "Employee No" = field("Employee No."),
                                "Document Type" = field(Type);
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Send Approval Request")
            {
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = (Rec."Approval Status" = Rec."Approval Status"::Open) and (Rec.Type = Rec.Type::"Employee Transfer");
                ToolTip = 'Executes the Send Approval Request action.';
                ApplicationArea = All;

                trigger OnAction()
                var
                    ConfirmTransfer: Label 'Do you want to send transfer request ?';
                begin
                    if Confirm(ConfirmTransfer, false) then begin
                        TransferMgt.SendTransferApproval(Rec);
                        IsApplied := true;
                        CurrPage.Close;
                    end;
                end;
            }
            action("Confirm Transfer Details")
            {
                Image = Insert;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = IsApproved and not rec."Is Transfer Details Added";
                ToolTip = 'Executes the action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if Confirm('Do you want to Confirm this document?', false) then begin
                        TransferMgt.ConfirmTransferDetails(Rec);
                        CurrPage.Close;
                    end;
                end;
            }
            action(Review)
            {
                Image = Register;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;
                ToolTip = 'Executes the Review action.';
                ApplicationArea = All;
                trigger OnAction()
                begin
                    if Confirm('Do you want to review this document?', false) then begin
                        TransferMgt.ReviewTransfer(Rec);
                        CurrPage.Close;
                    end;
                end;
            }
            action(Screen)
            {
                Image = "Action";
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                // Visible = ForScreenButton;
                visible = false;
                ToolTip = 'Executes the Screen action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if Confirm('Do you want to screen this document?', false) then begin
                        TransferMgt.ScreenTransfer(Rec);
                        CurrPage.Close;
                    end;
                end;
            }
            action("Approve Request")
            {
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = IsPending;
                // Visible = Rec."Approval Status" = Rec."Approval Status"::Screened;
                ToolTip = 'Executes the Approve Request action.';
                ApplicationArea = All;
                trigger OnAction()
                begin
                    if Confirm('Do you want to approve this document?', false) then begin
                        ApproverMgt.ApproveRejectDocument(RecRef, true);
                        Message('Transfer is Approved by %1', HRMgt.GetEmpName());
                    end;
                end;
            }
            action("Hold Transfer")
            {
                Image = Stop;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = rec."Is Transfer Details Added" and IsApproved;
                ToolTip = 'Executes the Hold Transfer action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if Confirm('Do you want to hold this document?', false) then begin
                        TransferMgt.HoldTransfer(Rec);
                        CurrPage.Close;
                    end;
                end;
            }
            action("Cancel Transfer")
            {
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                // Visible = ForApprove;
                Visible = false;
                ToolTip = 'Executes the Cancel Transfer action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if Confirm('Do you want to cancel this document?', false) then begin
                        // TransferMgt.CancelTransfer(Rec);
                        // CurrPage.Close;
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
                Visible = IsPending;
                ToolTip = 'Executes the Reject Request action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if Confirm('Do you want to reject this document?', false) then begin
                        IF REC."Rejection Remarks" = '' then
                            Error('Rejection Remarks is Empty')
                        else begin
                            ApproverMgt.ApproveRejectDocument(RecRef, false);
                            Message('Transfer is Rejected by %1', HRMgt.GetEmpName());
                        end;
                    end;
                end;
            }
            action("Acknowledge Transfer")
            {
                Image = Alerts;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = (IsHold or IsApproved) and rec."Is Transfer Details Added";
                ToolTip = 'Executes the Acknowledge Transfer action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    TransferMgt.AcknowledgeTransfer(Rec);
                end;
            }
            // action("Access Control")
            // {
            //     Image = Register;
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     PromotedIsBig = true;
            //     PromotedOnly = true;
            //     Visible = false;
            //     ToolTip = 'Executes the Access Control action.';
            //     ApplicationArea = All;

            //     trigger OnAction()
            //     begin
            //         if Confirm('Do you want to open access control card?', false) then
            //             HRMgt.OpenGrantAccessControlFromTransfer(Rec."No.");
            //     end;
            // }
            action("Transfer Claim")
            {
                Image = CreateForm;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page "Transfer Claim Form";
                RunPageLink = "No." = field("No.");
                RunPageView = where(Type = filter("Employee Transfer" | "HR Transfer"));
                Visible = IsACK;
                ToolTip = 'Executes the Transfer Claim action.';
                ApplicationArea = All;
                trigger OnAction()
                begin

                end;
            }
            action("Return Transfer")
            {
                ToolTip = 'Executes the Return Transfer action.';
                ApplicationArea = All;
                Visible = false;
                trigger OnAction()
                begin
                    if Confirm('Do you want to return this document?', false) then begin
                        TransferMgt.ReturnTransfer(Rec);
                    end;
                end;
            }
            action("Transfer History")
            {
                Image = History;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = not ForAck;
                ToolTip = 'Executes the Transfer History action.';
                ApplicationArea = All;

                trigger OnAction()
                var
                    EmployeeTransfer: Record "Employee/HR Transfer";
                    PageTransferHistory: Page "Employee Transfer Requests";
                begin
                    EmployeeTransfer.Reset;
                    Rec.FilterGroup(2);
                    EmployeeTransfer.SetFilter(Type, '%1|%2', EmployeeTransfer.Type::"HR Transfer", EmployeeTransfer.Type::"Employee Transfer");
                    EmployeeTransfer.SetRange("Employee No.", Rec."Employee No.");
                    EmployeeTransfer.SetRange("Approval Status", EmployeeTransfer."Approval Status"::Acknowledged);
                    Rec.FilterGroup(0);
                    Clear(PageTransferHistory);
                    PageTransferHistory.ForHistoryPage;
                    PageTransferHistory.SetTableView(EmployeeTransfer);
                    PageTransferHistory.SetRecord(EmployeeTransfer);
                    PageTransferHistory.Run;
                end;
            }
            action("Attendance Missed")
            {
                Image = AddWatch;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Attendance Missed action.';
                ApplicationArea = All;
                Visible = false;
                trigger OnAction()
                begin
                    TempEmpActivity.DeleteAll;
                    TempEmpActivity.Init;
                    TempEmpActivity.Validate("Employee No.", Rec."Employee No.");
                    TempEmpActivity.Validate(Type, EmployeeActivity.Type::"Attendance Missed");
                    TempEmpActivity.Insert;
                    Page.Run(Page::"Cancel Document", TempEmpActivity);
                end;
            }
            action("Change Approver")
            {
                Image = Change;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                // Visible = Rec."Approval Status" = Rec."Approval Status"::Screened;
                Visible = false;
                ToolTip = 'Executes the Change Approver action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    // if Confirm('Do you want to modify approver?') then begin
                    //     TransferMgt.PopUpChangingTransferApprover(Rec);
                    // end;
                end;
            }
            action("Update Missed Transfer")
            {
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = false;
                ToolTip = 'Executes the Update Missed Transfer action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if Confirm('Do you want to Update this document?', false) then begin
                        //HRMgt.UpdateMissedTransfer(Rec); //Min
                    end;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetLayout;
        GetTransferName;
        GetTransferEditibility;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        // OnNewTransferRecord;
    end;

    trigger OnOpenPage()
    begin
        case rec.Type of
            rec.Type::"Attendance Missed":
                begin
                    ApproverMgt.InsertApprovalTemp(Rec."Employee No.", '', Rec.Type::"Employee Transfer");
                end;
        end;
        SetLayout;
        GetTransferName;
        Rec.CalcFields("Outgoing Reporting Person Name");
        RecRef.GetTable(Rec);
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if Rec."No." <> '' then
            exit;
        if Rec."Approval Status" = Rec."Approval Status"::Open then
            if not IsApplied then
                if not Confirm('The data will be erased.Do you want to continue?', false) then
                    Error('')
                else begin
                    Approval.Reset();
                    Approval.SetRange("Document No.", '');
                    Approval.setRange("Document Type", Approval."Document Type"::"Employee Transfer");
                    Approval.SetRange("Employee No", Rec."Employee No.");
                    Approval.DeleteAll();
                end;
    end;

    var
        EmployeeActivity: Record "Employee Activity";
        Employee: Record Employee;
        HRMgt: Codeunit "HR Mgt.";
        TransferMgt: Codeunit "Transfer Mgt.";
        Approval: Record "Approval HRMS";

        ProvinceEdit: Boolean;
        [InDataSet]
        DepartEdit: Boolean;
        [InDataSet]
        UnitEdit: Boolean;
        [InDataSet]
        BranchEdit: Boolean;
        [InDataSet]
        FunctionalEdit: Boolean;
        [InDataSet]
        ForAck: Boolean;
        TypeFilter: Text;
        [InDataSet]
        ForScreenButton: Boolean;
        BranchNameTo: Text;
        DepartmentNameTo: Text;
        ProvinceNameTo: Text;
        SubProvinceNameTo: Text;
        ExtensionNameTo: Text;
        UnitNameTo: Text;
        BranchName: Text;
        DepartmentName: Text;
        ProvinceName: Text;
        SubProvinceName: Text;
        ExtensionName: Text;
        UnitName: Text;
        [InDataSet]
        SubProvinceEdit: Boolean;
        [InDataSet]
        ExtensionCounterEdit: Boolean;
        TempEmpActivity: Record "Employee Activity" temporary;
        [InDataSet]
        TransferCategoryEditable: Boolean;
        HRSetup: Record "Human Resources Setup";
        FunctionalTitle: Record "Functional Title";
        FunctionalDescFrom: Text;
        FunctionalDescTo: Text;
        StatusView: Boolean;
        ApprovalStatusView: Boolean;
        IsPending: Boolean;
        IsOpen: Boolean;
        IsApproved: Boolean;
        IsApplied: Boolean;
        IsHold: Boolean;
        IsACK: Boolean;
        ApproverMgt: Codeunit "Approver Mgt";
        RecRef: RecordRef;


    local procedure SetLayout()
    begin
        if (Rec."Approval Status" = Rec."Approval Status"::pending) and not (rec.Status = '') then
            StatusView := true
        else
            ApprovalStatusView := true;
        IsPending := Rec."Approval Status" = Rec."Approval Status"::Pending;
        IsOpen := (Rec."Approval Status" = Rec."Approval Status"::Open) or (Rec."Approval Status" = Rec."Approval Status"::" ");
        IsApproved := Rec."Approval Status" = Rec."Approval Status"::Approved;
        IsHold := Rec."Approval Status" = Rec."Approval Status"::"On Hold";
        IsACK := rec."Approval Status" = rec."Approval Status"::Acknowledged;
        RecRef.GetTable(Rec);

        // case Rec."Approval Status" of
        //     Rec."Approval Status"::Open:
        //         IsOpen := true;
        //     Rec."Approval Status"::"Pending":
        //         ISPending := true;
        //     Rec."Approval Status"::Approved, Rec."Approval Status"::"On Hold":
        //         begin
        //             ISPending := true;
        //             ISApproved := true;
        //         end;
        //     Rec."Approval Status"::Acknowledged:
        //         begin
        //             IsApproved := true;
        //             IsPending := true;
        //         end;
        // end;
        if Rec.Type in [Rec.Type::"HR Transfer", Rec.Type::"Employee Transfer"] then begin //Min 12.11.2022
            if Rec."Approval Status" = Rec."Approval Status"::Approved then
                ForAck := true;
        end;
        case Rec."Deputation On (To)" of
            Rec."Deputation On (To)"::"Extension Counter":
                begin
                    BranchEdit := false;
                    ProvinceEdit := false;
                    SubProvinceEdit := false;
                    ExtensionCounterEdit := true;
                    UnitEdit := false;
                    DepartEdit := false;
                end;
            Rec."Deputation On (To)"::Branch:
                begin
                    BranchEdit := true;
                    ProvinceEdit := false;
                    SubProvinceEdit := false;
                    ExtensionCounterEdit := false;
                    UnitEdit := false;
                    DepartEdit := false;
                end;
            Rec."Deputation On (To)"::Province:
                begin
                    BranchEdit := false;
                    ProvinceEdit := true;
                    SubProvinceEdit := false;
                    ExtensionCounterEdit := false;
                    UnitEdit := false;
                    DepartEdit := false;
                end;
            Rec."Deputation On (To)"::"Sub Province":
                begin
                    BranchEdit := false;
                    ProvinceEdit := false;
                    SubProvinceEdit := true;
                    ExtensionCounterEdit := false;
                    UnitEdit := false;
                    DepartEdit := false;
                end;
            Rec."Deputation On (To)"::Unit:
                begin
                    BranchEdit := false;
                    ProvinceEdit := false;
                    SubProvinceEdit := false;
                    ExtensionCounterEdit := false;
                    UnitEdit := true;
                    DepartEdit := false;
                end;

            Rec."Deputation On (To)"::Department:
                begin
                    BranchEdit := false;
                    ProvinceEdit := false;
                    SubProvinceEdit := false;
                    ExtensionCounterEdit := false;
                    UnitEdit := false;
                    DepartEdit := true;
                end;
        end;

        if Rec."Transfer Type" = Rec."Transfer Type"::"Cross Transfer" then begin
            ProvinceEdit := true;
            FunctionalEdit := true;
            BranchEdit := true;
            DepartEdit := true;
            UnitEdit := true;
        end;

        // if Rec.Type = Rec.Type::"HR Transfer" then begin
        //     ForReview := true;
        //     if Rec."Approval Status" in [Rec."Approval Status"::Open, Rec."Approval Status"::" "] then
        //         ForOpen := true;
        // end;
    end;

    local procedure GetTransferName()
    var
        GLSetup: Record "General Ledger Setup";
        DimValue: Record "Dimension Value";
        DepartVar: Record Department;
        ProvinceVar: Record Province;
        SubProvinceVar: Record "Sub Province";
        EmpHie: Record "Employee Hierarchy Master";
    begin
        Clear(BranchName);
        Clear(BranchNameTo);
        Clear(DepartmentNameTo);
        Clear(DepartmentName);
        Clear(ProvinceName);
        Clear(ProvinceNameTo);
        Clear(SubProvinceName);
        Clear(SubProvinceNameTo);
        Clear(UnitNameTo);
        Clear(UnitName);
        Clear(ExtensionName);
        Clear(ExtensionNameTo);
        GLSetup.Get;

        if FunctionalTitle.Get(Rec."Functional Title") then
            FunctionalDescFrom := FunctionalTitle.Description;
        if FunctionalTitle.Get(Rec."Functional Title (To)") then
            FunctionalDescTo := FunctionalTitle.Description;

        if DimValue.Get(GLSetup."Global Dimension 1 Code", Rec."Shortcut Dimension 1 Code") then
            BranchName := DimValue.Name;

        if DimValue.Get(GLSetup."Global Dimension 1 Code", Rec."Shortcut Dimension 1 Code (To)") then
            BranchNameTo := DimValue.Name;

        if DepartVar.Get(Rec.Department) then
            DepartmentName := DepartVar.Name;

        if DepartVar.Get(Rec."Department Code (To)") then
            DepartmentNameTo := DepartVar.Name;

        if ProvinceVar.Get(Rec."Province Code") then
            ProvinceName := ProvinceVar.Description;

        if ProvinceVar.Get(Rec."Province Code (To)") then
            ProvinceNameTo := ProvinceVar.Description;

        SubProvinceVar.Reset;
        SubProvinceVar.SetRange(Code, Rec."Sub Province Code");
        if SubProvinceVar.FindFirst then
            SubProvinceName := SubProvinceVar.City;

        SubProvinceVar.Reset;
        SubProvinceVar.SetRange(Code, Rec."Sub Province Code (To)");
        if SubProvinceVar.FindFirst then
            SubProvinceNameTo := SubProvinceVar.City;

        EmpHie.Reset;
        EmpHie.SetRange(Type, EmpHie.Type::Unit);
        EmpHie.SetRange(Code, Rec."Unit Code");
        if EmpHie.FindFirst then
            UnitName := EmpHie.Description;

        EmpHie.Reset;
        EmpHie.SetRange(Type, EmpHie.Type::Unit);
        EmpHie.SetRange(Code, Rec."Unit (To)");
        if EmpHie.FindFirst then
            UnitNameTo := EmpHie.Description;

        EmpHie.Reset;
        EmpHie.SetRange(Type, EmpHie.Type::"Extension Counter");
        EmpHie.SetRange(Code, Rec."Extension Counter Code");
        if EmpHie.FindFirst then
            ExtensionName := EmpHie.Description;

        EmpHie.Reset;
        EmpHie.SetRange(Type, EmpHie.Type::"Extension Counter");
        EmpHie.SetRange(Code, Rec."Extension Counter (To)");
        if EmpHie.FindFirst then
            ExtensionNameTo := EmpHie.Description;
    end;

    procedure GetTransferEditibility()
    begin
        TransferCategoryEditable := Rec."Transfer Category" in [Rec."Transfer Category"::Officiating, Rec."Transfer Category"::"Temporary", Rec."Transfer Category"::General]; //Min 12.09.2022 -- General Option added;
    end;

    // local procedure OnNewTransferRecord()
    // begin
    //     Rec.FilterGroup(2);
    //     TypeFilter := Rec.GetFilter(Type);
    //     Rec.FilterGroup(0);
    //     case TypeFilter of
    //         Format(Rec.Type::"Employee Transfer"):
    //             Rec.Type := Rec.Type::"Employee Transfer";

    //         Format(Rec.Type::"HR Transfer"):
    //             Rec.Type := Rec.Type::"HR Transfer";
    //     end;
    //     Rec."Approval Status" := Rec."Approval Status"::Open;
    //     HRSetup.Get;
    //     Employee.Reset;
    //     Employee.SetRange("Functional Title", HRSetup."HR Head Functional Title");
    //     Employee.SetRange("Department Code", HRSetup."HR Department Code");
    //     Employee.SetRange(Status, Employee.Status::Active); //Min
    //     if Employee.FindFirst then
    //         Rec.Validate("Approver Code", Employee."No.");
    // end;
}
