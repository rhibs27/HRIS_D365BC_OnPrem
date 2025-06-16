page 50101 "Travel Form"
{
    PageType = Card;
    SourceTable = "Travel Request";
    ApplicationArea = All;
    InsertAllowed = false;

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
                field("Start Date"; Rec."Start Date")
                {
                    Editable = IsOpen and (rec."Travel Order No." = '');
                    ToolTip = 'Specifies the value of the Start Date field.';
                    ApplicationArea = All;
                }
                field("End Date"; Rec."End Date")
                {
                    Editable = IsOpen;
                    ToolTip = 'Specifies the value of the End Date field.';
                    ApplicationArea = All;
                }
                field("No. of Days"; Rec."No. of Days")
                {
                    ToolTip = 'Specifies the value of the No. of Days field.';
                    ApplicationArea = All;
                }
                field("Requested Date"; Rec."Requested Date")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Requested Date field.';
                    ApplicationArea = All;
                }
                field("Start Date (BS)"; Rec."Start Date (BS)")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Start Date (BS) field.';
                    ApplicationArea = All;
                }
                field("End Date (BS)"; Rec."End Date (BS)")
                {
                    ToolTip = 'Specifies the value of the End Date (BS) field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Departure Time"; Rec."Departure Time")
                {
                    Editable = IsOpen;
                    ToolTip = 'Specifies the value of the Departure Time field.';
                    ApplicationArea = All;
                }
                field("Arrival Time"; Rec."Arrival Time")
                {
                    Editable = IsOpen;
                    ToolTip = 'Specifies the value of the Arrival Time field.';
                    ApplicationArea = All;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    Visible = ApprovalStatusView;
                    Editable = false;
                    ToolTip = 'Specifies the value of the "Approval Status field.';
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    Caption = 'Approval Status';
                    Editable = false;
                    Visible = StatusView;
                    ToolTip = 'Specifies the value of the "Approval Status field.';
                    ApplicationArea = All;
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
                    Editable = false;
                    ToolTip = 'Specifies the value of the Branch Name field.';
                    ApplicationArea = All;
                }
                field("Department Name"; Rec."Department Name")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Department Name field.';
                    ApplicationArea = All;
                }
                field("Travel Order No."; Rec."Travel Order No.")
                {
                    ToolTip = 'Specifies the value of the Travel Order No. field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Total No. of Days"; Rec."Total No. of Days")
                {
                    ToolTip = 'Specifies the value of the Total No. of Days field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Rejection Remarks"; Rec."Rejection Remarks")
                {
                    ToolTip = 'Specifies the value of the Rejection Remarks field.';
                    ApplicationArea = All;
                    Editable = IsPending;
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                        RecRef.GetTable(Rec);
                    end;
                }
            }
            group(Travel)
            {
                field("Travel Countries"; Rec."Travel Countries")
                {
                    Editable = IsOpen;
                    ToolTip = 'Specifies the value of the Travel Countries field.';
                    ApplicationArea = All;
                }
                field("Type Of Visit"; Rec."Type Of Visit")
                {
                    Editable = IsOpen;
                    ToolTip = 'Specifies the value of the Type Of Visit field.';
                    ApplicationArea = All;
                }
                field("Travel With"; Rec."Travel With")
                {
                    ToolTip = 'Specifies the value of the Travel With field.';
                    ApplicationArea = All;
                    Editable = IsOpen and not Rec.Extended;
                }
                field("Travel With Name"; Rec."Travel With Name")
                {
                    ToolTip = 'Specifies the value of the Travel With Name field.';
                    ApplicationArea = All;
                }
                field("Mode Of Travel"; Rec."Mode Of Travel")
                {
                    Editable = IsOpen;
                    ToolTip = 'Specifies the value of the Mode Of Travel field.';
                    ApplicationArea = All;
                }
                field("Departure From"; Rec."Departure From")
                {
                    Editable = IsOpen;
                    ToolTip = 'Specifies the value of the Departure From field.';
                    ApplicationArea = All;
                }
                field(Destination; Rec.Destination)
                {
                    Editable = IsOpen and (Rec."Travel Countries" <> Rec."Travel Countries"::India);
                    ToolTip = 'Specifies the value of the Destination field.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    Editable = IsOpen;
                    MultiLine = true;
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = All;
                }
                field("Purpose of Travel"; Rec."Purpose of Travel")
                {
                    Editable = IsOpen;
                    MultiLine = true;
                    NotBlank = true;
                    ToolTip = 'Specifies the value of the Purpose of Travel field.';
                    ApplicationArea = All;
                }
                field("Estimated Transportation Cost"; Rec."Estimated Transportation Cost")
                {
                    Editable = IsOpen;
                    ToolTip = 'Specifies the value of the Estimated Transportation Cost field.';
                    ApplicationArea = All;
                }
                field("Estimated Lodging Cost"; Rec."Estimated Lodging Cost")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Estimated Lodging Cost field.';
                    ApplicationArea = All;
                }
                field("Estimated Fooding Cost"; Rec."Estimated Fooding Cost")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Estimated Fooding Cost field.';
                    ApplicationArea = All;
                }
                field("Estimated Conveyance Expense"; Rec."Estimated Conveyance Expense")
                {
                    Editable = IsOpen;
                    ToolTip = 'Specifies the value of the Estimated Conveyance Expense field.';
                    ApplicationArea = All;
                }
                field("Other Estimated Cost"; Rec."Other Estimated Cost")
                {
                    Editable = IsOpen;
                    ToolTip = 'Specifies the value of the Other Estimated Cost field.';
                    ApplicationArea = All;
                }
                field("Advance Cash Required"; Rec."Advance Cash Required")
                {
                    Editable = IsOpen;
                    ToolTip = 'Specifies the value of the Advance Cash Required field.';
                    ApplicationArea = All;
                }
                field("Currency Code"; rec."Currency Code")
                {
                    Editable = IsOpen and (rec."Travel Countries" <> rec."Travel Countries"::Nepal);
                    ToolTip = 'Specifies the Currency Code';
                    ApplicationArea = All;
                }
                field("Total Estimated Cost"; Rec."Total Estimated Cost")
                {
                    ToolTip = 'Specifies the value of the Total Estimated Cost field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Advance Cash"; Rec."Advance Cash")
                {
                    Editable = IsOpen and Rec."Advance Cash Required";
                    ToolTip = 'Specifies the value of the Advance Cash field.';
                    ApplicationArea = All;
                }
                field("Auth. Account No."; Rec."Auth. Account No.")
                {
                    Caption = 'Bank Account No';
                    ToolTip = 'Specifies the value of the Auth. Account No. field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Extended; Rec.Extended)
                {
                    ToolTip = 'Specifies the value of the Extended field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Travel Claimed"; Rec."Travel Claimed")
                {
                    ToolTip = 'Specifies the value of the Extended field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                // field("Currency Code"; Rec."Currency Code")
                // {
                //     ToolTip = 'Specifies the value of the Currency Code field.';
                //     ApplicationArea = All;
                //     Editable = IsOpen;
                // }
                // field("Exchange Rate"; Rec."Exchange Rate")
                // {
                //     ToolTip = 'Specifies the value of the Exchange Rate field.';
                //     ApplicationArea = All;
                //     Editable = IsOpen;
                // }
            }
            part("Approval Subform"; "HRMS Approval Entry")
            {
                ApplicationArea = all;
                SubPageLink = "Document No." = field("No.");
                Editable = false;
            }
            // group(Approval)
            // {
            //     Editable = false;
            //     field("Approval Status"; Rec."Approval Status")
            //     {
            //         Editable = false;
            //         ToolTip = 'Specifies the value of the Approval Status field.';
            //         ApplicationArea = All;
            //     }
            //     field("Recommender Code"; Rec."Recommender Code")
            //     {
            //         ToolTip = 'Specifies the value of the Recommender Code field.';
            //         ApplicationArea = All;
            //     }
            //     field("Recommender Name"; Rec."Recommender Name")
            //     {
            //         ToolTip = 'Specifies the value of the Recommender Name field.';
            //         ApplicationArea = All;
            //     }
            //     field("Approver Code"; Rec."Approver Code")
            //     {
            //         ToolTip = 'Specifies the value of the Approver Code field.';
            //         ApplicationArea = All;
            //     }
            //     field("Approver Name"; Rec."Approver Name")
            //     {
            //         ToolTip = 'Specifies the value of the Approver Name field.';
            //         ApplicationArea = All;
            //     }
            // }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Apply Travel Request")
            {
                Image = Apply;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Apply Travel Request action.';
                ApplicationArea = All;
                Visible = IsOpen;

                trigger OnAction()
                begin
                    TravelMgt.ApplyForTravel(Rec);
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
                    // if Confirm('Do you want to recommend the travel request?', false) then begin
                    //     TravelMgt.RecommendEmployeeTravel(Rec."No.");
                    //     CurrPage.Close;
                    // end;
                end;
            }
            action("Approve Travel Request")
            {
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = IsPending and not rec.Extended;
                ToolTip = 'Executes the Approve Travel Request action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if Confirm('Do you want to approve the travel request?', false) then begin
                        ApproverMgt.ApproveRejectDocument(RecRef, true);
                        Message('Travel Request is Approved by %1', HRMgt.GetEmpName());
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
                    if Confirm('Do you want to reject travel request?', false) then begin
                        Rec.TestField("Rejection Remarks");
                        ApproverMgt.ApproveRejectDocument(RecRef, false);
                        Message('Travel Request is Rejected by %1', HRMgt.GetEmpName());
                        // TravelMgt.ApprovedRejectTravelApproval(false, Rec."No.");
                        CurrPage.Close;
                    end;
                end;
            }
            action("Withdraw Travel")
            {
                Image = CancelLine;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the WithDraw Request action.';
                ApplicationArea = All;
                Visible = IsPending and (rec.Type = Rec.type::"Travel Request");
                trigger OnAction()
                begin
                    if Confirm('Do you want WithDraw the request?', false) then begin
                        ApproverMgt.WithDrawRequest(RecRef);
                        Message('Travel has been withdrew.');
                    end;
                end;
            }
            action(ExtendTravelRequest)
            {
                Caption = 'Extend Travel Request';
                Image = ExtendedDataEntry;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = IsApproved and not rec.Extended and not rec."Travel Claimed";
                ToolTip = 'Executes the Extend Travel Request action.';
                ApplicationArea = All;
                trigger OnAction()
                begin
                    TravelMgt.OpenTravelRequest(Rec."Employee No.", true, Rec."No.", Rec.Type);
                end;
            }
            action(ClaimTravel)
            {
                Caption = 'Claim Travel';
                Image = Check;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = IsApproved and not rec.Extended and not rec."Travel Claimed";
                ToolTip = 'Executes the Claim Travel action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if not Rec.Extended and not rec."Travel Claimed" then
                        TravelMgt.OpenTravelClaimed(Rec."Employee No.", Rec."No.", Rec."Travel With", Rec."Travel Countries")
                    else
                        Error(ErrorExtended, Rec.GetExtendedTravelNo);
                end;
            }
            action("Change Approver")
            {
                Image = Change;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Change Approver action.';
                ApplicationArea = All;
                Visible = false;

                trigger OnAction()
                begin
                    // if Confirm(CofirmApprover) then begin //Min -- for change Travel Approver.
                    //     if Rec."Approval Status" in [Rec."Approval Status"::"Pending Approval", Rec."Approval Status"::Recommended] then
                    //         HRMgt.PopUpChangingTravelApprover(Rec)
                    //     else
                    //         Error(ApproverMessage, Rec."Approval Status");
                    // end;
                end;
            }
            action("Change Recommender")
            {
                Image = Change;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Change Recommender action.';
                ApplicationArea = All;
                Visible = false;

                trigger OnAction()
                begin
                    // if Confirm(ConfirmRecommender) then begin //Min -- for change Travel Recommender.
                    //     if Rec."Approval Status" = Rec."Approval Status"::"Pending Approval" then
                    //         HRMgt.PopUpChangingTravelRecommender(Rec)
                    //     else
                    //         Error(RecommenderMessage, Rec."Approval Status");
                    // end;
                end;
            }
        }
        area(Reporting)
        {
            action("Print Report")
            {
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Print Report action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    CurrPage.SetSelectionFilter(Rec);
                    if Confirm('Do you want to print travel request report?', false) then
                        Report.Run(Report::"Travel Request Processing", true, false, Rec);
                end;
            }
        }
    }

    trigger OnDeleteRecord(): Boolean
    begin
        if not GuiAllowed then
            Error('Cannot be deleted')
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        if not GuiAllowed then
            Error('Cannot be inserted')
    end;

    trigger OnModifyRecord(): Boolean
    begin
        if not GuiAllowed then
            Error('Cannot be modified')
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Type := Rec.Type::"Travel Request";
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
        // IsRecommended := Rec."Approval Status" = Rec."Approval Status"::Recommended;
        // IsScreened := Rec."Approval Status" = Rec."Approval Status"::Screened;
        if not GuiAllowed then begin
            Rec.SetRange(Type, Rec.Type::"Travel Request");
            Rec.SetRange("Approval Status", Rec."Approval Status"::Approved);
        end;
        RecRef.GetTable(Rec);

    end;

    var
        HRMgt: Codeunit "HR Mgt.";

        [InDataSet]
        IsPending: Boolean;
        [InDataSet]
        IsApproved: Boolean;
        [InDataSet]
        IsOpen: Boolean;
        //IsScreened: Boolean;
        ErrorExtended: Label 'This Travel is order is Extended. Please try Travel order No %1.';
        //[InDataSet]
        //IsRecommended: Boolean;
        StatusView: Boolean;
        ApprovalStatusView: Boolean;
        TravelMgt: Codeunit "Travel Mgt.";
        ApproverMgt: Codeunit "Approver Mgt";
        RecRef: RecordRef;
        CofirmApprover: Label 'Do you want to modify approver of Travel Request ?';
        ConfirmRecommender: Label 'Do you want to modify recomender of Travel Request ?';
        ApproverMessage: Label 'Approver cannot be changed, when the travel request has been %1.';
        RecommenderMessage: Label 'Recommender cannot be changed, when the travel request has been %1.';
}
