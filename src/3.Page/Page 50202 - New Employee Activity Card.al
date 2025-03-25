page 50202 "New Employee Activity Card"
{


    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = false;
    ModifyAllowed = true;
    PageType = Card;
    SourceTable = "Employee Activity";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Editable = FieldEditable;
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                    ApplicationArea = All;
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
                field("Salary Level"; SalaryLevel.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = All;
                }
                field("Functional Title"; FunctionalTitle.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = All;
                }
                field("Deputation On"; Rec."Deputation On")
                {
                    ToolTip = 'Specifies the value of the Deputation On field.';
                    ApplicationArea = All;
                }
                field("Extension Counter"; ExtensionName)
                {
                    ToolTip = 'Specifies the value of the ExtensionName field.';
                    ApplicationArea = All;
                }
                field(Branch; BranchName)
                {
                    ToolTip = 'Specifies the value of the BranchName field.';
                    ApplicationArea = All;
                }
                field("Sub-Province"; SubProvinceName)
                {
                    ToolTip = 'Specifies the value of the SubProvinceName field.';
                    ApplicationArea = All;
                }
                field(Unit; UnitName)
                {
                    ToolTip = 'Specifies the value of the UnitName field.';
                    ApplicationArea = All;
                }
                field(Department; DepartmentName)
                {
                    ToolTip = 'Specifies the value of the DepartmentName field.';
                    ApplicationArea = All;
                }
                field(Province; ProvinceName)
                {
                    ToolTip = 'Specifies the value of the ProvinceName field.';
                    ApplicationArea = All;
                }
                field("Start Date"; Rec."Start Date")
                {
                    Visible = not IsTravelClaimVisible;
                    ToolTip = 'Specifies the value of the Start Date field.';
                    ApplicationArea = All;
                }
                field("Start Date (BS)"; Rec."Start Date (BS)")
                {
                    Visible = not IsTravelClaimVisible;
                    ToolTip = 'Specifies the value of the Start Date (BS) field.';
                    ApplicationArea = All;
                }
                field("End Date"; Rec."End Date")
                {
                    Visible = not IsTravelClaimVisible;
                    ToolTip = 'Specifies the value of the End Date field.';
                    ApplicationArea = All;
                }
                field("End Date (BS)"; Rec."End Date (BS)")
                {
                    Visible = not IsTravelClaimVisible;
                    ToolTip = 'Specifies the value of the End Date (BS) field.';
                    ApplicationArea = All;
                }
                field("No. of Days"; Rec."No. of Days")
                {
                    Visible = not IsTravelClaimVisible;
                    ToolTip = 'Specifies the value of the No. of Days field.';
                    ApplicationArea = All;
                }
                field("Requested Date"; Rec."Requested Date")
                {
                    Visible = not IsTravelClaimVisible;
                    ToolTip = 'Specifies the value of the Requested Date field.';
                    ApplicationArea = All;
                }
                field("Fiscal Year"; Rec."Fiscal Year")
                {
                    Visible = not IsTravelClaimVisible;
                    ToolTip = 'Specifies the value of the Fiscal Year field.';
                    ApplicationArea = All;
                }
                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field.';
                    ApplicationArea = All;
                }
            }
            group(Leave)
            {
                Editable = FieldEditable;
                Visible = IsLeaveVisible;
                field("Leave Code"; Rec."Leave Code")
                {
                    ToolTip = 'Specifies the value of the Leave Code field.';
                    ApplicationArea = All;
                }
                field("Leave Description"; Rec."Leave Description")
                {
                    ToolTip = 'Specifies the value of the Leave Description field.';
                    ApplicationArea = All;
                }
                field("Leave Type"; Rec."Leave Type")
                {
                    ToolTip = 'Specifies the value of the Leave Type field.';
                    ApplicationArea = All;
                }
                field("Pay Type"; Rec."Pay Type")
                {
                    ToolTip = 'Specifies the value of the Pay Type field.';
                    ApplicationArea = All;
                }
                field("Start Time"; Rec."Start Time")
                {
                    ToolTip = 'Specifies the value of the Start Time field.';
                    ApplicationArea = All;
                }
                field("End Time"; Rec."End Time")
                {
                    ToolTip = 'Specifies the value of the End Time field.';
                    ApplicationArea = All;
                }
                field("Compensatory Date"; Rec."Compensatory Date")
                {
                    ToolTip = 'Specifies the value of the Compensatory Date field.';
                    ApplicationArea = All;
                }
            }
            group("Travel Request")
            {
                Editable = FieldEditable;
                Visible = IsTravelReqVisible;
                field(PurposeOfTravel; Rec."Purpose of Travel")
                {
                    Caption = 'Purpose Of Travel';
                    ToolTip = 'Specifies the value of the Purpose Of Travel field.';
                    ApplicationArea = All;
                }
                field(TypeOfVisit; Rec."Type Of Visit")
                {
                    Caption = 'Type Of Visit';
                    Description = 'both request and claim';
                    ToolTip = 'Specifies the value of the Type Of Visit field.';
                    ApplicationArea = All;
                }
                field(ModeOfTravel; Rec."Mode Of Travel")
                {
                    Caption = 'Mode Of Travel';
                    Description = 'both request and claim';
                    ToolTip = 'Specifies the value of the Mode Of Travel field.';
                    ApplicationArea = All;
                }
                field("Depature From"; Rec."Depature From")
                {
                    ToolTip = 'Specifies the value of the Depature From field.';
                    ApplicationArea = All;
                }
                field(Destination; Rec.Destination)
                {
                    ToolTip = 'Specifies the value of the Destination field.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = All;
                }
                field("Advance Cash Required"; Rec."Advance Cash Required")
                {
                    ToolTip = 'Specifies the value of the Advance Cash Required field.';
                    ApplicationArea = All;
                }
                field("Estimated Transportation Cost"; Rec."Estimated Transportation Cost")
                {
                    ToolTip = 'Specifies the value of the Estimated Transportation Cost field.';
                    ApplicationArea = All;
                }
                field("Estimated Lodging Cost"; Rec."Estimated Lodging Cost")
                {
                    ToolTip = 'Specifies the value of the Estimated Lodging Cost field.';
                    ApplicationArea = All;
                }
                field("Estimated Fooding Cost"; Rec."Estimated Fooding Cost")
                {
                    ToolTip = 'Specifies the value of the Estimated Fooding Cost field.';
                    ApplicationArea = All;
                }
                field("Estimated Conveyance Expense"; Rec."Estimated Conveyance Expense")
                {
                    ToolTip = 'Specifies the value of the Estimated Conveyance Expense field.';
                    ApplicationArea = All;
                }
                field("Other Estimated Cost"; Rec."Other Estimated Cost")
                {
                    ToolTip = 'Specifies the value of the Other Estimated Cost field.';
                    ApplicationArea = All;
                }
                field("Auth. Account No."; Rec."Auth. Account No.")
                {
                    ToolTip = 'Specifies the value of the Auth. Account No. field.';
                    ApplicationArea = All;
                }
                field(Extended; Rec.Extended)
                {
                    ToolTip = 'Specifies the value of the Extended field.';
                    ApplicationArea = All;
                }
                field("Travel Order No."; Rec."Travel Order No.")
                {
                    ToolTip = 'Specifies the value of the Travel Order No. field.';
                    ApplicationArea = All;
                }
                field("Total No. of Days"; Rec."Total No. of Days")
                {
                    ToolTip = 'Specifies the value of the Total No. of Days field.';
                    ApplicationArea = All;
                }
                field("Travel Countries"; Rec."Travel Countries")
                {
                    ToolTip = 'Specifies the value of the Travel Countries field.';
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ToolTip = 'Specifies the value of the Currency Code field.';
                    ApplicationArea = All;
                }
                field("Exchange Rate"; Rec."Exchange Rate")
                {
                    ToolTip = 'Specifies the value of the Exchange Rate field.';
                    ApplicationArea = All;
                }
                field("Depature Time"; Rec."Depature Time")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Depature Time field.';
                    ApplicationArea = All;
                }
                field("Arrival Time"; Rec."Arrival Time")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Arrival Time field.';
                    ApplicationArea = All;
                }
                field("Total Estimated Cost"; Rec."Total Estimated Cost")
                {
                    ToolTip = 'Specifies the value of the Total Estimated Cost field.';
                    ApplicationArea = All;
                }
                field(AdvanceCash; Rec."Advance Cash")
                {
                    Caption = 'Advance Cash';
                    ToolTip = 'Specifies the value of the Advance Cash field.';
                    ApplicationArea = All;
                }
            }
            group("Travel Claim")
            {
                Visible = IsTravelClaimVisible;
                field(TravelOrderNo; Rec."Travel Order No.")
                {
                    ToolTip = 'Specifies the value of the Travel Order No. field.';
                    ApplicationArea = All;
                }
                field(FY; Rec."Fiscal Year")
                {
                    Caption = 'Fiscal Year';
                    ToolTip = 'Specifies the value of the Fiscal Year field.';
                    ApplicationArea = All;
                }
                field("Date of Request"; Rec."Requested Date")
                {
                    Caption = 'Requested Date';
                    Visible = not IsTravelClaimVisible;
                    ToolTip = 'Specifies the value of the Requested Date field.';
                    ApplicationArea = All;
                }
                field("Type Of Visit"; Rec."Type Of Visit")
                {
                    Description = 'both request and claim';
                    Editable = FieldEditable;
                    ToolTip = 'Specifies the value of the Type Of Visit field.';
                    ApplicationArea = All;
                }
                field("Claimed Country"; Rec."Claimed Country")
                {
                    Caption = 'Travel Claim Country';
                    Editable = FieldEditable;
                    ToolTip = 'Specifies the value of the Travel Claim Country field.';
                    ApplicationArea = All;
                }
                field("Mode Of Travel"; Rec."Mode Of Travel")
                {
                    Description = 'both request and claim';
                    Editable = FieldEditable;
                    ToolTip = 'Specifies the value of the Mode Of Travel field.';
                    ApplicationArea = All;
                }
                field("Departure From"; Rec."Depature From")
                {
                    ToolTip = 'Specifies the value of the Depature From field.';
                    ApplicationArea = All;
                }
                field("Arrival To"; Rec.Destination)
                {
                    Caption = 'Destination';
                    ToolTip = 'Specifies the value of the Destination field.';
                    ApplicationArea = All;
                }
                field("Purpose of Travel"; Rec."Purpose of Travel")
                {
                    Editable = FieldEditable;
                    ToolTip = 'Specifies the value of the Purpose of Travel field.';
                    ApplicationArea = All;
                }
                field("Travel Description"; Rec.Description)
                {
                    Caption = 'Description';
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = All;
                }
                field("Actual Travel Start Date"; Rec."Start Date")
                {
                    ToolTip = 'Specifies the value of the Start Date field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Clear(OutofPocketDays);
                    end;
                }
                field("Actual Travel Start Date (BS)"; Rec."Start Date (BS)")
                {
                    ToolTip = 'Specifies the value of the Start Date (BS) field.';
                    ApplicationArea = All;
                }
                field("Actual Travel Start Time"; Rec."Actual Travel Start Time")
                {
                    ToolTip = 'Specifies the value of the Actual Travel Start Time field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Clear(OutofPocketDays)
                    end;
                }
                field("Actual Travel End Date"; Rec."End Date")
                {
                    ToolTip = 'Specifies the value of the End Date field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Clear(OutofPocketDays);
                    end;
                }
                field("Actual Travel End Date (BS)"; Rec."End Date (BS)")
                {
                    ToolTip = 'Specifies the value of the End Date (BS) field.';
                    ApplicationArea = All;
                }
                field("Actual Travel End Time"; Rec."Actual Travel End Time")
                {
                    ToolTip = 'Specifies the value of the Actual Travel End Time field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        OutofPocketDays := TravelMgt.GetOutofExpneseDuration(Rec."Actual Travel Start Time", Rec."Actual Travel End Time", Rec."Start Date", Rec."End Date");
                    end;
                }
                field("Travel With"; Rec."Travel With")
                {
                    ToolTip = 'Specifies the value of the Travel With field.';
                    ApplicationArea = All;
                }
                field("Claim Type"; Rec."Claim Type")
                {
                    ToolTip = 'Specifies the value of the Claim Type field.';
                    ApplicationArea = All;
                }
                field("Actual No. of Days"; Rec."No. of Days")
                {
                    ToolTip = 'Specifies the value of the No. of Days field.';
                    ApplicationArea = All;
                }
                field("Fooding Per Day Limit"; Rec."Fooding Per Day Limit")
                {
                    ToolTip = 'Specifies the value of the Fooding Per Day Limit field.';
                    ApplicationArea = All;
                }
                field("Eligible days for Fooding"; Rec."No. of Days")
                {
                    ToolTip = 'Specifies the value of the No. of Days field.';
                    ApplicationArea = All;
                }
                field("Fooding Allowance Limit"; Rec."Fooding Allowance Limit")
                {
                    ToolTip = 'Specifies the value of the Fooding Allowance Limit field.';
                    ApplicationArea = All;
                }
                field("Actual Fooding Allowance"; Rec."Fooding Allowance")
                {
                    Editable = IsTravelClaimEditable;
                    ToolTip = 'Specifies the value of the Fooding Allowance field.';
                    ApplicationArea = All;
                }
                field("Lodging Per Day Limit"; Rec."Lodging Per Day Limit")
                {
                    ToolTip = 'Specifies the value of the Lodging Per Day Limit field.';
                    ApplicationArea = All;
                }
                field("Eligible days for Lodging"; Rec."No. of Days" - 1)
                {
                    ToolTip = 'Specifies the value of the No. of Days - 1 field.';
                    ApplicationArea = All;
                }
                field("Lodging Allowance Limit"; Rec."Lodging Allowance Limit")
                {
                    ToolTip = 'Specifies the value of the Lodging Allowance Limit field.';
                    ApplicationArea = All;
                }
                field("Actual Lodging Allowance"; Rec."Lodging Allowance")
                {
                    Editable = IsTravelClaimEditable;
                    ToolTip = 'Specifies the value of the Lodging Allowance field.';
                    ApplicationArea = All;
                }
                field("Out of Pocket Per day Limit"; SalaryLevel."Out of Pocket Expense")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Out of Pocket Expense field.';
                    ApplicationArea = All;
                }
                field("Eligible days for Out of Pocket"; OutofPocketDays)
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the OutofPocketDays field.';
                    ApplicationArea = All;
                }
                field("Out of Pocket Expense"; Rec."Out of Pocket Expense")
                {
                    Editable = not (Rec."Approval Status" = Rec."Approval Status"::"Final Approved & Forwarded to Finance Department");
                    ToolTip = 'Specifies the value of the Out of Pocket Expense field.';
                    ApplicationArea = All;
                }
                field("Road/Air Fare"; Rec."Road/Air Fare")
                {
                    Editable = RoadAirAmtEditable;
                    ToolTip = 'Specifies the value of the Road/Air Fare field.';
                    ApplicationArea = All;
                }
                field("Road/Air Fare Reimbursable"; Rec.Reimbursable)
                {
                    ToolTip = 'Specifies the value of the Reimbursable field.';
                    ApplicationArea = All;
                }
                field("Actual Conveyance Expense"; Rec."Conveyance Expense")
                {
                    Editable = IsTravelClaimEditable;
                    ToolTip = 'Specifies the value of the Conveyance Expense field.';
                    ApplicationArea = All;
                }
                field("Actual Other Expense"; Rec."Other Expense")
                {
                    Editable = IsTravelClaimEditable;
                    ToolTip = 'Specifies the value of the Other Expense field.';
                    ApplicationArea = All;
                }
                field("Total Claimed Amount"; Rec."Total Claimed Amount")
                {
                    Editable = FieldEditable;
                    ToolTip = 'Specifies the value of the Total Claimed Amount field.';
                    ApplicationArea = All;
                }
                field("Advance Cash"; Rec."Advance Cash")
                {
                    Editable = FieldEditable;
                    ToolTip = 'Specifies the value of the Advance Cash field.';
                    ApplicationArea = All;
                }
                field("Net Receivable/Payable"; Rec."Net Receivable/Payable")
                {
                    Editable = FieldEditable;
                    ToolTip = 'Specifies the value of the Net Receivable/Payable field.';
                    ApplicationArea = All;
                }
                field(DepartureTime; Rec."Depature Time")
                {
                    Caption = 'Departure Time';
                    Visible = false;
                    ToolTip = 'Specifies the value of the Departure Time field.';
                    ApplicationArea = All;
                }
                field(ArrivalTime; Rec."Arrival Time")
                {
                    Caption = 'Arrival Time';
                    Visible = false;
                    ToolTip = 'Specifies the value of the Arrival Time field.';
                    ApplicationArea = All;
                }
            }
            group(Overtime)
            {
                Editable = FieldEditable;
                Visible = IsOTVisible;
                field("Time Duration"; Rec."Time Duration")
                {
                    ToolTip = 'Specifies the value of the Time Duration field.';
                    ApplicationArea = All;
                }
                field("Estimated Hours"; Rec."Estimated Hours")
                {
                    ToolTip = 'Specifies the value of the Estimated Hours field.';
                    ApplicationArea = All;
                }
            }
            group("Bulk Cash")
            {
                Editable = FieldEditable;
                Visible = IsBulkCash;
                field("From Branch"; Rec."From Branch")
                {

                }
                field("To Branch"; Rec."To Branch")
                {

                }
                field("Total Cash"; Rec."Total Cash")
                {

                }
                field("Total Distance (In KM)"; Rec."Total Distance (In KM)")
                {

                }
                field("Total Estimate Time (In Hour)"; Rec."Total Estimate Time (In Hour)")
                {

                }
            }
            group(Transfer)
            {
                Editable = FieldEditable;
                Visible = IsTransferVisible;
                field("Transfer Type"; Rec."Transfer Type")
                {
                    ToolTip = 'Specifies the value of the Transfer Type field.';
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 1 Code (To)"; Rec."Shortcut Dimension 1 Code (To)")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code (To) field.';
                    ApplicationArea = All;
                }
                field("Sub Province Code (To)"; Rec."Sub Province Code (To)")
                {
                    ToolTip = 'Specifies the value of the Sub Province Code (To) field.';
                    ApplicationArea = All;
                }
                field("Province Code (To)"; Rec."Province Code (To)")
                {
                    ToolTip = 'Specifies the value of the Province Code (To) field.';
                    ApplicationArea = All;
                }
                field("Unit (To)"; Rec."Unit (To)")
                {
                    ToolTip = 'Specifies the value of the Unit (To) field.';
                    ApplicationArea = All;
                }
                field("Department Code (To)"; Rec."Department Code (To)")
                {
                    ToolTip = 'Specifies the value of the Department Code (To) field.';
                    ApplicationArea = All;
                }
                field("Reporting Line 1 (To)"; Rec."Reporting Line 1 (To)")
                {
                    ToolTip = 'Specifies the value of the Reporting Line 1 (To) field.';
                    ApplicationArea = All;
                }
                field("Reporting Line 2 (To)"; Rec."Reporting Line 2 (To)")
                {
                    ToolTip = 'Specifies the value of the Reporting Line 2 (To) field.';
                    ApplicationArea = All;
                }
                field("Eco-System (To)"; Rec."Eco-System (To)")
                {
                    ToolTip = 'Specifies the value of the Eco-System (To) field.';
                    ApplicationArea = All;
                }
                field("Office (To)"; Rec."Office (To)")
                {
                    ToolTip = 'Specifies the value of the Office (To) field.';
                    ApplicationArea = All;
                }
                field("Extension Counter (To)"; Rec."Extension Counter (To)")
                {
                    ToolTip = 'Specifies the value of the Extension Counter (To) field.';
                    ApplicationArea = All;
                }
                field("Transfer Effective Date"; Rec."Transfer Effective Date")
                {
                    ToolTip = 'Specifies the value of the Transfer Effective Date field.';
                    ApplicationArea = All;
                }
            }
            group(Approval)
            {
                field("Approval Status"; Rec."Approval Status")
                {
                    Editable = FieldEditable;
                    ToolTip = 'Specifies the value of the Approval Status field.';
                    ApplicationArea = All;
                }
                field("Recommender Code"; Rec."Recommender Code")
                {
                    Editable = FieldEditable;
                    ToolTip = 'Specifies the value of the Recommender Code field.';
                    ApplicationArea = All;
                }
                field("Recommender Name"; Rec."Recommender Name")
                {
                    ToolTip = 'Specifies the value of the Recommender Name field.';
                    ApplicationArea = All;
                }
                field("Approver Code"; Rec."Approver Code")
                {
                    Editable = FieldEditable;
                    ToolTip = 'Specifies the value of the Approver Code field.';
                    ApplicationArea = All;
                }
                field("Approver Name"; Rec."Approver Name")
                {
                    ToolTip = 'Specifies the value of the Approver Name field.';
                    ApplicationArea = All;
                }
                field("Screener Date"; Rec."Screener Date")
                {
                    ToolTip = 'Specifies the value of the Screener Date field.';
                    ApplicationArea = All;
                }
                field("Screener Remarks"; Rec."Screener Remarks")
                {
                    Editable = IsTravelClaimEditable;
                    ToolTip = 'Specifies the value of the Screener Remarks field.';
                    ApplicationArea = All;
                }
                field("Screener ID"; Rec."Screener ID")
                {
                    ToolTip = 'Specifies the value of the Screener ID field.';
                    ApplicationArea = All;
                }
                field("Screener Name"; Rec."Screener Name")
                {
                    ToolTip = 'Specifies the value of the Screener Name field.';
                    ApplicationArea = All;
                }
                field("Final Approver"; Rec."Final Approver")
                {
                    Visible = IsTravelClaimVisible;
                    ToolTip = 'Specifies the value of the Final Approver field.';
                    ApplicationArea = All;
                }
                field("Final Approver Name"; Rec."Final Approver Name")
                {
                    Visible = IsTravelClaimVisible;
                    ToolTip = 'Specifies the value of the Final Approver Name field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Recommend)
            {
                Image = Register;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = ForRecommend;
                ToolTip = 'Executes the Recommend action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if Confirm('Do you want to recommend the travel request?', false) then begin
                        HRMgt.RecommendEmployeeActivity(Rec."No.");
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
                Visible = ForApprove;
                ToolTip = 'Executes the Approve action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if Confirm('Do you want to approve the travel request?', false) then begin
                        HRMgt.ApprovedRejectApproval(true, Rec."No.");
                        CurrPage.Close;
                    end;
                end;
            }
            action(Reject)
            {
                Image = Reject;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = ForReject;
                ToolTip = 'Executes the Reject action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if Confirm('Do you want to reject travel requet?', false) then begin
                        HRMgt.ApprovedRejectApproval(false, Rec."No.");
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
                Visible = ForScreen;
                ToolTip = 'Executes the Screen action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    //ResignationMgt.ScreenResignation(Rec);
                    CurrPage.Close;
                end;
            }
            action("Final Approve")
            {
                Caption = 'Final Approve';
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Final Approve action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    // TravelMgt.FinalApprove(Rec); santosh 
                    // CurrPage.Close;
                end;
            }
            action("Change Approver")
            {
                Image = Change;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = IsTravelClaimVisible;
                ToolTip = 'Executes the Change Approver action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if Confirm('Do you want to modify approver?') then begin
                        TravelMgt.PopUpChangingApprover(Rec);
                    end;
                end;
            }
            action("Return Travel Claim")
            {
                Image = Return;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = IsTravelClaimVisible;
                ToolTip = 'Executes the Return Travel Claim action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    TravelMgt.ReturnTravelClaim(Rec);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        IsTravelClaimEditable := ForScreen;
    end;

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

    trigger OnOpenPage()
    begin
        if not GuiAllowed then begin
            Rec.SetRange(Type, Rec.Type::"Travel Claim");
            Rec.SetRange("Approval Status", Rec."Approval Status"::Approved);
        end;
        IsLeaveVisible := false;
        IsOTVisible := false;
        IsTransferVisible := false;
        IsTravelClaimVisible := false;
        IsTravelReqVisible := false;
        IsBulkCash := false;
        if Rec.Type = Rec.Type::"Leave Request" then
            IsLeaveVisible := true
        else if Rec.Type = Rec.Type::"Travel Claim" then
            IsTravelClaimVisible := true
        else if Rec.Type = Rec.Type::"Travel Request" then
            IsTravelReqVisible := true
        else if Rec."Type Of Visit" = Rec.Type::"Employee Transfer" then
            IsTransferVisible := true
        else if Rec."Type Of Visit" = Rec.Type::Overtime then
            IsOTVisible := true
        else if Rec."Type" = Rec.Type::"Bulk Cash" then
            IsBulkCash := true;
        SetVisibility;
        IsScreeenerRemarksVisible := Rec."Approval Status" in [Rec."Approval Status"::Approved, Rec."Approval Status"::Screened];
        if SalaryLevel.Get(Rec."Salary Level Code") then;
        if FunctionalTitle.Get(Rec."Functional Title") then;
        OutofPocketDays := TravelMgt.GetOutofExpneseDuration(Rec."Actual Travel Start Time", Rec."Actual Travel End Time", Rec."Start Date", Rec."End Date");
    end;

    var
        [InDataSet]
        IsLeaveVisible: Boolean;
        [InDataSet]
        IsTravelReqVisible: Boolean;
        [InDataSet]
        IsTravelClaimVisible: Boolean;
        [InDataSet]
        IsTransferVisible: Boolean;
        [InDataSet]
        IsOTVisible: Boolean;
        [InDataSet]
        IsBulkCash: Boolean;
        HRMgt: Codeunit "HR Mgt.";
        ResignationMgt: Codeunit "Resignation Mgt";
        TravelMgt: Codeunit "Travel Mgt.";
        [InDataSet]
        ForApprove: Boolean;
        [InDataSet]
        ForRecommend: Boolean;
        [InDataSet]
        ForReject: Boolean;
        IsScreeenerRemarksVisible: Boolean;
        ForScreen: Boolean;
        ForFinalApprove: Boolean;
        IsTravelClaimEditable: Boolean;
        FieldEditable: Boolean;
        SalaryLevel: Record "Salary Level";
        FunctionalTitle: Record "Functional Title";
        BranchName: Text;
        DepartmentName: Text;
        ProvinceName: Text;
        SubProvinceName: Text;
        ExtensionName: Text;
        UnitName: Text;
        OutofPocketDays: Decimal;
        [InDataSet]
        RoadAirAmtEditable: Boolean;

    local procedure SetVisibility()
    begin
        case Rec."Approval Status" of
            Rec."Approval Status"::"Pending Approval":
                begin
                    ForRecommend := true;
                    ForReject := true;
                    ForApprove := false;
                    ForScreen := false;
                    ForFinalApprove := false;
                end;
            Rec."Approval Status"::Recommended:
                begin
                    ForRecommend := false;
                    ForReject := true;
                    ForApprove := true;
                    ForScreen := false;
                    ForFinalApprove := false;
                end;
            Rec."Approval Status"::Rejected, Rec."Approval Status"::Approved:
                begin
                    ForRecommend := false;
                    ForApprove := false;
                    ForReject := false;
                    ForScreen := true;
                    ForFinalApprove := false;
                    RoadAirAmtEditable := true;
                end;
            Rec."Approval Status"::Screened:
                begin
                    ForRecommend := false;
                    ForApprove := false;
                    ForReject := false;
                    ForScreen := false;
                    ForFinalApprove := true;
                end;
        end;
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
        Clear(DepartmentName);
        Clear(ProvinceName);
        Clear(SubProvinceName);
        Clear(UnitName);
        Clear(ExtensionName);
        GLSetup.Get;

        if DimValue.Get(GLSetup."Global Dimension 1 Code", Rec."Shortcut Dimension 1 Code") then
            BranchName := DimValue.Name;

        if DepartVar.Get(Rec.Department) then
            DepartmentName := DepartVar.Name;

        if ProvinceVar.Get(Rec."Province Code") then
            ProvinceName := ProvinceVar.Description;

        SubProvinceVar.Reset;
        SubProvinceVar.SetRange(Code, Rec."Sub Province Code");
        if SubProvinceVar.FindFirst then
            SubProvinceName := SubProvinceVar.City;

        EmpHie.Reset;
        EmpHie.SetRange(Type, EmpHie.Type::Unit);
        EmpHie.SetRange(Code, Rec."Unit Code");
        if EmpHie.FindFirst then
            UnitName := EmpHie.Description;

        EmpHie.Reset;
        EmpHie.SetRange(Type, EmpHie.Type::"Extension Counter");
        EmpHie.SetRange(Code, Rec."Extension Counter Code");
        if EmpHie.FindFirst then
            ExtensionName := EmpHie.Description;
    end;
}
