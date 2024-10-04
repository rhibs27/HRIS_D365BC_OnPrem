report 50066 "Travel Request Processing"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep33019867.TravelRequestProcessing.rdl';
    ApplicationArea = All;

    dataset
    {
        dataitem("Employee Activity"; "Employee Activity")
        {
            DataItemTableView = where(Type = const("Travel Request"));
            column(CompanyInfoName; CompanyInfo.Name) { }
            column(CompanyInfoPic; CompanyInfo.Picture) { }
            column(Title; Title) { }
            column(No_; "No.") { }
            column(EmployeeNo_; "Employee No.") { }
            column(EmployeeName_; "Employee Name") { }
            column(BranchName_; "Branch Name") { }
            column(SalaryLevelCode_; SalaryLevel.Description) { }
            column(StartDate_; "Start Date") { }
            column(EndDate_; "End Date") { }
            column(FunctionalTitle_; FunctionalTitle.Description) { }
            column(RequestedDate_; "Requested Date") { }
            column(TravelWith_; TravelWithText) { }
            column(ApprovalStatus_; "Approval Status") { }
            column(ActualTravelStartDate_; "Actual Travel Start Date") { }
            column(ActualTravelEndDate_; "Actual Travel End Date") { }
            column(ActualTravelStartTime_; "Actual Travel Start Time") { }
            column(ActualTravelEndTime_; "Actual Travel End Time") { }
            column(StartDateBS_; "Start Date (BS)") { }
            column(EndDateBS_; "End Date (BS)") { }
            column(DepartmentName_; "Department Name") { }
            column(TravelClaimed_; "Travel Claimed") { }
            column(ScreenerRemarks_; "Screener Remarks") { }
            column(TravelCountries_; "Travel Countries") { }
            column(TotalEstimatedCost_; "Total Estimated Cost") { }
            column(TotalNoofDays_; "Total No. of Days") { }
            column(ClaimType_; "Claim Type") { }
            column(ClaimedCountry_; "Claimed Country") { }
            column(FoodingAllowance_; "Fooding Allowance") { }
            column(EstimatedTransportationCost_; "Estimated Transportation Cost") { }
            column(EstimatedLodgingCost_; "Estimated Lodging Cost") { }
            column(EstimatedFoodingCost_; "Estimated Fooding Cost") { }
            column(EstimatedConveyanceExpense_; "Estimated Conveyance Expense") { }
            column(OtherEstimatedCost_; "Other Estimated Cost") { }
            column(LodgingAllowance_; "Lodging Allowance") { }
            column(ConveyanceExpense_; "Conveyance Expense") { }
            column(TotalClaimedAmount_; "Total Claimed Amount") { }
            column(OtherExpense_; "Other Expense") { }
            column(NetReceivablePayable_; "Net Receivable/Payable") { }
            column(OutofPocketExpense_; "Out of Pocket Expense") { }
            column(RoadAirFare_; "Road/Air Fare") { }
            column(Reimbursable_; ReimbursableText) { }
            column(FoodingAllowanceLimit_; "Fooding Allowance Limit") { }
            column(DepatureTime_; "Depature Time") { }
            column(ArrivalTime_; "Arrival Time") { }
            column(LodgingAllowanceLimit_; "Lodging Allowance Limit") { }
            column(FoodingPerDayLimit_; "Fooding Per Day Limit") { }
            column(LodgingPerDayLimit_; "Lodging Per Day Limit") { }
            column(TimeDuration_; "Time Duration") { }
            column(EstimatedHours_; "Estimated Hours") { }
            column(ActualHours_; "Actual Hours") { }
            column(ScreenerID_; "Screener ID") { }
            column(ScreenerDate_; "Screener Date") { }
            column(ScreenerName_; "Screener Name") { }
            column(FinalApprover_; "Final Approver") { }
            column(FinalApproverName_; "Final Approver Name") { }
            column(FinalApproverDate_; "Final Approver Date") { }
            column(TypeOfVisit_; "Type Of Visit") { }
            column(ModeOfTravel_; "Mode Of Travel") { }
            column(DepatureFrom_; "Depature From") { }
            column(Destination_; Destination) { }
            column(Description_; Description) { }
            column(PurposeofTravel_; "Purpose of Travel") { }
            column(TravelOrderNo_; "Travel Order No.") { }
            column(Remarks_; Remarks) { }
            column(AdvanceCashRequired_; Format("Advance Cash Required")) { }
            column(AdvanceCash_; "Advance Cash") { }
            column(RecommenderName_; "Recommender Name") { }
            column(ApproverName_; "Approver Name") { }
            column(BankAccountNo_; "Bank Account No.") { }
            column(NoofDays_; "No. of Days") { }
            column(OutofPocketDailyLimit_; SalaryLevel."Out of Pocket Expense") { }
            column(RecommenderCode_; "Recommender Code") { }
            column(ApproverCode_; "Approver Code") { }
            column(PreviousTravelDescription; PreviousTravelDescription) { }

            trigger OnAfterGetRecord()
            begin
                Clear(PreviousTravelDescription);
                if "Employee Activity".Reimbursable then
                    ReimbursableText := '(Reimbursable)'
                else
                    ReimbursableText := '(Not Reimbursable)';

                if SalaryLevel.Get("Salary Level Code") then;
                if FunctionalTitle.Get("Employee Activity"."Functional Title") then;
                Clear(TravelWithVar);
                Clear(TravelWithText);
                if TravelWithVar.Get("Employee Activity"."Travel With") then
                    TravelWithText := StrSubstNo('%1(%2)', TravelWithVar."Full Name", TravelWithVar."No.");

                PreviousTravelDescription := GetPreviousTravelDescription("Travel Order No.");
            end;
        }
    }

    requestpage
    {
        layout { }

        actions { }
    }

    labels { }

    trigger OnPreReport()
    begin
        CompanyInfo.Get;
        CompanyInfo.CalcFields(Picture);
    end;

    var
        CompanyInfo: Record "Company Information";
        Title: Label 'Travel Request Processing System';
        ReimbursableText: Text;
        SalaryLevel: Record "Salary Level";
        FunctionalTitle: Record "Functional Title";
        TravelWithVar: Record Employee;
        TravelWithText: Text;
        PreviousTravelDescription: Text;

    local procedure GetPreviousTravelDescription(TravelOrderNo: Code[20]): Text
    var
        PreviousTravelOrder: Record "Employee Activity";
    begin
        if PreviousTravelOrder.Get(TravelOrderNo) then begin
            if (PreviousTravelOrder."Travel Order No." = '') then
                exit(PreviousTravelOrder.Description);
            exit(GetPreviousTravelDescription(PreviousTravelOrder."Travel Order No.") + '. ' + PreviousTravelOrder.Description);
        end;
    end;
}
