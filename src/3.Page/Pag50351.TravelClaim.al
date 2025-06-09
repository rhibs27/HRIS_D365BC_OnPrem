page 50351 "Travel Claim"
{

    PageType = Card;
    SourceTable = "Travel Request";
    ApplicationArea = All;
    InsertAllowed = false;
    //Editable = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Employee No."; Rec."Employee No.")
                {

                    ToolTip = 'Specifies the value of the Employee No. field.';
                    ApplicationArea = All;
                    Editable = false;
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
                field("Start Date"; Rec."Start Date")
                {
                    ToolTip = 'Specifies the value of the Start Date field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Departure Time"; Rec."Departure Time")
                {
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Departure Time field.';
                    ApplicationArea = All;
                }
                field("End Date"; Rec."End Date")
                {
                    ToolTip = 'Specifies the value of the End Date field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Arrival Time"; Rec."Arrival Time")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Arrival Time field.';
                    ApplicationArea = All;
                }
                field("No. of Days"; Rec."No. of Days")
                {
                    ToolTip = 'Specifies the value of the No. of Days field.';
                    ApplicationArea = All;
                }
                field("Requested Date"; Rec."Requested Date")
                {
                    ToolTip = 'Specifies the value of the Requested Date field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Start Date (BS)"; Rec."Start Date (BS)")
                {
                    ToolTip = 'Specifies the value of the Start Date (BS) field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("End Date (BS)"; Rec."End Date (BS)")
                {
                    ToolTip = 'Specifies the value of the End Date (BS) field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.';
                    ApplicationArea = All;
                    Visible = ApprovalStatusView;
                    Editable = false;
                }
                field(Status; Rec.Status)
                {
                    Caption = 'Approval Status';
                    ToolTip = 'Specifies the value of the Approval Status field.';
                    ApplicationArea = All;
                    Visible = StatusView;
                    Editable = false;
                }
                field("Travel With"; Rec."Travel With")
                {
                    ToolTip = 'Specifies the value of the Travel With field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Department; Rec.Department)
                {
                    ToolTip = 'Specifies the value of the Department field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Branch Name"; Rec."Branch Name")
                {
                    ToolTip = 'Specifies the value of the Branch Name field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Department Name"; Rec."Department Name")
                {
                    ToolTip = 'Specifies the value of the Department Name field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Functional Title"; Rec."Functional Title")
                {
                    ToolTip = 'Specifies the value of the Functional Title field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Purpose of Travel"; Rec."Purpose of Travel")
                {
                    ToolTip = 'Specifies the value of the Purpose of Travel field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Rejection Remarks"; Rec."Rejection Remarks")
                {
                    ToolTip = 'Specifies the value of the Rejection Remarks field.';
                    ApplicationArea = All;
                    Editable = IsPending;
                    trigger OnValidate()
                    var
                    begin
                        CurrPage.Update();
                        RecRef.GetTable(Rec);
                    end;
                }
            }
            group("Travel Claim")
            {
                Editable = false;
                field("Actual Travel Start Date"; Rec."Actual Travel Start Date")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Actual Travel Start Date field.';
                    ApplicationArea = All;
                }
                field("Actual Travel End Date"; Rec."Actual Travel End Date")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Actual Travel End Date field.';
                    ApplicationArea = All;
                }
                field("Actual Travel Start Time"; Rec."Actual Travel Start Time")
                {
                    ToolTip = 'Specifies the value of the Actual Travel Start Time field.';
                    ApplicationArea = All;
                }
                field("Actual Travel End Time"; Rec."Actual Travel End Time")
                {
                    ToolTip = 'Specifies the value of the Actual Travel End Time field.';
                    ApplicationArea = All;
                }
                field("Mode Of Travel"; Rec."Mode Of Travel")
                {
                    ToolTip = 'Specifies the value of the Mode Of Travel field.';
                    ApplicationArea = All;
                }
                field("Type Of Visit"; Rec."Type Of Visit")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Type Of Visit field.';
                    ApplicationArea = All;
                }
                field("Claim Type"; Rec."Claim Type")
                {
                    ToolTip = 'Specifies the value of the Claim Type field.';
                    ApplicationArea = All;
                }

                field("Travel Countries"; Rec."Travel Countries")
                {
                    ToolTip = 'Specifies the value of the Claimed Country field.';
                    ApplicationArea = All;
                }
                field("Road/Air Fare"; Rec."Road/Air Fare")
                {
                    ToolTip = 'Specifies the value of the Road/Air Fare field.';
                    ApplicationArea = All;
                }
                field(Reimbursable; Rec.Reimbursable)
                {
                    ToolTip = 'Specifies the value of the Reimbursable field.';
                    ApplicationArea = All;
                }
                field("Out of Pocket Expense"; Rec."Out of Pocket Expense")
                {
                    ToolTip = 'Specifies the value of the Out of Pocket Expense field.';
                    ApplicationArea = All;
                }


                field("Conveyance Expense"; Rec."Conveyance Expense")
                {
                    ToolTip = 'Specifies the value of the Conveyance Expense field.';
                    ApplicationArea = All;
                }
                field("Other Expense"; Rec."Other Expense")
                {
                    ToolTip = 'Specifies the value of the Other Expense field.';
                    ApplicationArea = All;
                }
                field("Total Claimed Amount"; Rec."Total Claimed Amount")
                {
                    ToolTip = 'Specifies the value of the Total Claimed Amount field.';
                    ApplicationArea = All;
                }
                field("Advance Cash"; Rec."Advance Cash")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Advance Cash field.';
                    ApplicationArea = All;
                }
                field("Net Receivable/Payable"; Rec."Net Receivable/Payable")
                {
                    ToolTip = 'Specifies the value of the Net Receivable/Payable field.';
                    ApplicationArea = All;
                }
                Group("Allowance Limit")
                {

                    field("Fooding Per Day Limit"; Rec."Fooding Per Day Limit")
                    {
                        ToolTip = 'Specifies the value of the Fooding Per Day Limit field.';
                        ApplicationArea = All;
                    }
                    field("Fooding Allowance Limit"; Rec."Fooding Allowance Limit")
                    {
                        ToolTip = 'Specifies the value of the Fooding Allowance Limit field.';
                        ApplicationArea = All;
                    }
                    field("Lodging Allowance Limit"; Rec."Lodging Allowance Limit")
                    {
                        ToolTip = 'Specifies the value of the Lodging Allowance Limit field.';
                        ApplicationArea = All;
                    }
                    field("Lodging Per Day Limit"; Rec."Lodging Per Day Limit")
                    {
                        ToolTip = 'Specifies the value of the Lodging Per Day Limit field.';
                        ApplicationArea = All;
                    }

                }
                Group(Allowance)
                {
                    field("Actual Fooding Allowance"; Rec."Fooding Allowance")
                    {
                        Editable = true;
                        ToolTip = 'Specifies the value of the Fooding Allowance field.';
                        ApplicationArea = All;
                    }

                    field("Actual Lodging Allowance"; Rec."Lodging Allowance")
                    {
                        Editable = true;
                        ToolTip = 'Specifies the value of the Lodging Allowance field.';
                        ApplicationArea = All;
                    }

                }
            }
            part(Attachment; "Attachment Subform")
            {
                SubPageLink = "No." = field("No."),
                                "Employee Activity Type" = field(Type),
                              "Employee Code" = field("Employee No.");
                ApplicationArea = All;
                Editable = false;
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
            action("Apply Travel Claim")
            {
                Image = Apply;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Apply Travel Claim action.';
                ApplicationArea = All;
                Visible = IsOpen;

                trigger OnAction()
                begin
                    TravelMgt.ApplyForTravelClaim(Rec);
                    CurrPage.Close;
                end;
            }
            action("Recommend Travel Request")
            {
                Image = Register;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;
                ToolTip = 'Executes the Recommend Travel Request action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    // if Confirm('Do you want to recommend the travel claim?', false) then
                    //     TravelMgt.RecommendEmployeeTravel(Rec."No.");
                end;
            }
            action("Approve Travel Request")
            {
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = IsPending;
                ToolTip = 'Executes the Approve Travel Request action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if Confirm('Do you want to approve the travel claim?', false) then begin
                        ApprovalMgt.ApproveRejectDocument(RecRef, true);
                        Message('Travel Claim is Approved by %1', HRMgt.GetEmpName());
                    end;

                end;
            }
            action("Reject Travel Request")
            {
                Image = Reject;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Reject Travel Request action.';
                ApplicationArea = All;
                Visible = IsPending;

                trigger OnAction()
                begin
                    if Confirm('Do you want to reject travel claim?', false) then begin
                        IF REC."Rejection Remarks" = '' then
                            Error('Rejection Remarks is Empty')
                        else begin
                            ApprovalMgt.ApproveRejectDocument(RecRef, false);
                            Message('Travel Claim is Rejected by %1', HRMgt.GetEmpName());
                        end;
                    end;
                end;
            }
            action(Screen)
            {
                Image = "Action";
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;
                ToolTip = 'Executes the Screen action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    // TravelMgt.ScreenResignationforTravel(Rec);
                    // CurrPage.Close;
                end;
            }
            action("Final Approve Request")
            {
                Caption = 'Final Approve';
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;
                ToolTip = 'Executes the Final Approve action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    // TravelMgt.FinalApproveForTravel(Rec);
                    // CurrPage.Close;
                end;
            }
        }
        // area(Navigation)
        // {
        //     action(Open)
        //     {
        //         Promoted = true;
        //         PromotedCategory = Category4;
        //         PromotedIsBig = true;
        //         ToolTip = 'Executes the Open action.';
        //         ApplicationArea = All;

        //         trigger OnAction()
        //         begin
        //             Rec.FilterGroup(2);
        //             ClearAll();
        //             Rec.SetFilter("Approval Status", '%1|%2', Rec."Approval Status"::" ", Rec."Approval Status"::Open);
        //             Rec.FilterGroup(0);
        //         end;
        //     }
        //     action(Screened)
        //     {
        //         Promoted = true;
        //         PromotedCategory = Category4;
        //         PromotedIsBig = true;
        //         ToolTip = 'Executes the Screened action.';
        //         ApplicationArea = All;
        //         Visible = false;

        //         trigger OnAction()
        //         begin
        //             // Rec.FilterGroup(2);
        //             // ClearAll();
        //             // Rec.SetRange("Approval Status", Rec."Approval Status"::Screened);
        //             // Rec.FilterGroup(0);
        //         end;
        //     }
        //     action("Pending Approval")
        //     {
        //         Image = PendingApproval;
        //         Promoted = true;
        //         PromotedCategory = Category4;
        //         PromotedIsBig = true;
        //         ToolTip = 'Executes the Pending Approval action.';
        //         ApplicationArea = All;

        //         trigger OnAction()
        //         begin
        //             Rec.FilterGroup(2);
        //             ClearAll();
        //             Rec.SetRange("Approval Status", Rec."Approval Status"::Pending);
        //             Rec.FilterGroup(0);
        //         end;
        //     }
        //     action(Recommended)
        //     {
        //         Image = Approve;
        //         Promoted = true;
        //         PromotedCategory = Category4;
        //         PromotedIsBig = true;
        //         ToolTip = 'Executes the Recommended action.';
        //         ApplicationArea = All;
        //         Visible = false;

        //         trigger OnAction()
        //         begin
        //             // Rec.FilterGroup(2);
        //             // ClearAll();
        //             // Rec.SetRange("Approval Status", Rec."Approval Status"::Recommended);

        //             // Rec.FilterGroup(0);
        //         end;
        //     }
        //     action(Approved)
        //     {
        //         Image = Approve;
        //         Promoted = true;
        //         PromotedCategory = Category4;
        //         PromotedIsBig = true;
        //         ToolTip = 'Executes the Approved action.';
        //         ApplicationArea = All;
        //         trigger OnAction()
        //         begin
        //             Rec.FilterGroup(2);
        //             ClearAll();
        //             Rec.SetRange("Approval Status", Rec."Approval Status"::Approved);
        //             Rec.FilterGroup(0);
        //         end;
        //     }
        //     action(Rejected)
        //     {
        //         Image = DeleteQtyToHandle;
        //         Promoted = true;
        //         PromotedCategory = Category4;
        //         PromotedIsBig = true;
        //         ToolTip = 'Executes the Rejected action.';
        //         ApplicationArea = All;

        //         trigger OnAction()
        //         begin
        //             Rec.FilterGroup(2);
        //             ClearAll();
        //             Rec.SetRange("Approval Status", Rec."Approval Status"::Rejected);
        //             Rec.FilterGroup(0);
        //         end;
        //     }
        //     action("Final Approve")
        //     {
        //         Image = Flow;
        //         Promoted = true;
        //         PromotedCategory = Category4;
        //         PromotedIsBig = true;
        //         PromotedOnly = true;
        //         ToolTip = 'Executes the Final Approve action.';
        //         ApplicationArea = All;
        //         Visible = false;

        //         trigger OnAction()
        //         begin
        //             // Rec.FilterGroup(2);
        //             // ClearAll();
        //             // Rec.SetRange("Approval Status", Rec."Approval Status"::"Final Approved & Forwarded to Finance Department");
        //             // Rec.FilterGroup(0);
        //         end;
        //     }
        // }
        area(Reporting)
        {
            action("Print Travel Claim")
            {
                Image = Travel;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Print Travel Claim action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if not Confirm('Do you want to print travel claim ?', false) then
                        exit;
                    //CurrPage.SetSelectionFilter(Rec);
                    Report.Run(Report::"Travel Claim Processing Report", true, false, Rec);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        IsOpen := Rec."Approval Status" = Rec."Approval Status"::open;
        if (Rec."Approval Status" = Rec."Approval Status"::pending) and not (rec.Status = '') then
            StatusView := true
        else
            ApprovalStatusView := true;
        IsPending := Rec."Approval Status" = Rec."Approval Status"::Pending;
        IsApproved := Rec."Approval Status" = Rec."Approval Status"::Approved;
        // IsScreened := Rec."Approval Status" = Rec."Approval Status"::Screened;
        // if Salarylevel.Get(Rec."Salary Level Code") then;
        // if TravelWith.Get(Rec."Travel With") then;
    end;

    trigger OnOpenPage()

    begin
        IsOpen := Rec."Approval Status" = Rec."Approval Status"::open;
        if (Rec."Approval Status" = Rec."Approval Status"::pending) and not (rec.Status = '') then
            StatusView := true
        else
            ApprovalStatusView := true;
        IsPending := Rec."Approval Status" = Rec."Approval Status"::Pending;
        IsApproved := Rec."Approval Status" = Rec."Approval Status"::Approved;
        RecRef.GetTable(Rec);
    end;

    var
        HRMgt: Codeunit "HR Mgt.";
        TravelMgt: Codeunit "Travel Mgt.";
        IsPending: Boolean;
        RecRef: RecordRef;
        ApprovalMgt: Codeunit "Approver Mgt";
        IsOpen: Boolean;
        ApprovalStatusView: Boolean;
        StatusView: Boolean;
        //IsApplied: Boolean;
        //IsRecommended: Boolean;
        IsApproved: Boolean;
    //IsScreened: Boolean;
}

