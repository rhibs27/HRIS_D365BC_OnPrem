report 33019824 "Travel Settlement"
{
    // version ATNICASIA1.00

    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep33019824.TravelSettlement.rdl';
    Caption = 'Travel Settlement';
    ApplicationArea = All;

    dataset
    {
        dataitem("Employee Activity"; "Employee Activity")
        {
            DataItemTableView = where(Type = filter("Travel Claim"));
            column(ReportTiltle; ReportTiltle) { }
            column(No_EmployeeActivity; "Employee Activity"."No.")
            {
                IncludeCaption = true;
            }
            column(Type_EmployeeActivity; "Employee Activity".Type)
            {
                IncludeCaption = true;
            }
            column(EmployeeNo_EmployeeActivity; "Employee Activity"."Employee No.")
            {
                IncludeCaption = true;
            }
            column(EmployeeName_EmployeeActivity; "Employee Activity"."Employee Name")
            {
                IncludeCaption = true;
            }
            column(StartDate_EmployeeActivity; "Employee Activity"."Start Date")
            {
                IncludeCaption = true;
            }
            column(EndDate_EmployeeActivity; "Employee Activity"."End Date")
            {
                IncludeCaption = true;
            }
            column(NoofDays_EmployeeActivity; "Employee Activity"."No. of Days")
            {
                IncludeCaption = true;
            }
            column(RequestedDate_EmployeeActivity; "Employee Activity"."Requested Date")
            {
                IncludeCaption = true;
            }
            column(DepartmentName_EmployeeActivity; "Employee Activity"."Department Name")
            {
                IncludeCaption = true;
            }
            column(RecommenderName_EmployeeActivity; "Employee Activity"."Recommender Name")
            {
                IncludeCaption = true;
            }
            column(ApproverName_EmployeeActivity; "Employee Activity"."Approver Name")
            {
                IncludeCaption = true;
            }
            column(StartDateBS_EmployeeActivity; "Employee Activity"."Start Date (BS)")
            {
                IncludeCaption = true;
            }
            column(EndDateBS_EmployeeActivity; "Employee Activity"."End Date (BS)")
            {
                IncludeCaption = true;
            }
            column(Remarks_EmployeeActivity; "Employee Activity".Remarks)
            {
                IncludeCaption = true;
            }
            column(ApprovalStatus_EmployeeActivity; "Employee Activity"."Approval Status")
            {
                IncludeCaption = true;
            }
            column(ShortcutDimension1Code_EmployeeActivity; "Employee Activity"."Shortcut Dimension 1 Code")
            {
                IncludeCaption = true;
            }
            column(BranchName_EmployeeActivity; "Employee Activity"."Branch Name")
            {
                IncludeCaption = true;
            }
            column(RejectionRemarks_EmployeeActivity; "Employee Activity"."Rejection Remarks")
            {
                IncludeCaption = true;
            }
            column(FunctionalTitle_EmployeeActivity; "Employee Activity"."Functional Title")
            {
                IncludeCaption = true;
            }
            column(TypeOfVisit_EmployeeActivity; "Employee Activity"."Type Of Visit")
            {
                IncludeCaption = true;
            }
            column(ModeOfTravel_EmployeeActivity; "Employee Activity"."Mode Of Travel")
            {
                IncludeCaption = true;
            }
            column(DepatureFrom_EmployeeActivity; "Employee Activity"."Depature From")
            {
                IncludeCaption = true;
            }
            column(Destination_EmployeeActivity; "Employee Activity".Destination)
            {
                IncludeCaption = true;
            }
            column(Description_EmployeeActivity; "Employee Activity".Description)
            {
                IncludeCaption = true;
            }
            column(PurposeofTravel_EmployeeActivity; "Employee Activity"."Purpose of Travel")
            {
                IncludeCaption = true;
            }
            column(AdvanceCash_EmployeeActivity; "Employee Activity"."Advance Cash")
            {
                IncludeCaption = true;
            }
            column(EstimatedTransportationCost_EmployeeActivity; "Employee Activity"."Estimated Transportation Cost")
            {
                IncludeCaption = true;
            }
            column(EstimatedLodgingCost_EmployeeActivity; "Employee Activity"."Estimated Lodging Cost")
            {
                IncludeCaption = true;
            }
            column(EstimatedFoodingCost_EmployeeActivity; "Employee Activity"."Estimated Fooding Cost")
            {
                IncludeCaption = true;
            }
            column(EstimatedConveyanceExpense_EmployeeActivity; "Employee Activity"."Estimated Conveyance Expense")
            {
                IncludeCaption = true;
            }
            column(OtherEstimatedCost_EmployeeActivity; "Employee Activity"."Other Estimated Cost")
            {
                IncludeCaption = true;
            }
            column(Extended_EmployeeActivity; "Employee Activity".Extended)
            {
                IncludeCaption = true;
            }
            column(ExtendedTravel_EmployeeActivity; "Employee Activity"."Travel Order No.")
            {
                IncludeCaption = true;
            }
            column(Traveltype_EmployeeActivity; "Employee Activity"."Travel Countries")
            {
                IncludeCaption = true;
            }
            column(DepatureTime_EmployeeActivity; "Employee Activity"."Depature Time")
            {
                IncludeCaption = true;
            }
            column(ArrivalTime_EmployeeActivity; "Employee Activity"."Arrival Time")
            {
                IncludeCaption = true;
            }
            column(TotalEstimatedCost_EmployeeActivity; "Employee Activity"."Total Estimated Cost")
            {
                IncludeCaption = true;
            }
            column(FoodingAllowance_EmployeeActivity; "Employee Activity"."Fooding Allowance")
            {
                IncludeCaption = true;
            }
            column(LodgingAllowance_EmployeeActivity; "Employee Activity"."Lodging Allowance")
            {
                IncludeCaption = true;
            }
            column(ConveyanceExpense_EmployeeActivity; "Employee Activity"."Conveyance Expense")
            {
                IncludeCaption = true;
            }
            column(TotalClaimedAmount_EmployeeActivity; "Employee Activity"."Total Claimed Amount")
            {
                IncludeCaption = true;
            }
            column(OtherExpense_EmployeeActivity; "Employee Activity"."Other Expense")
            {
                IncludeCaption = true;
            }
            column(NetReceivablePayable_EmployeeActivity; "Employee Activity"."Net Receivable/Payable")
            {
                IncludeCaption = true;
            }
            column(TravelOrderNo_EmployeeActivity; "Employee Activity"."Travel Order No.")
            {
                IncludeCaption = true;
            }
        }
    }

    requestpage
    {
        layout { }

        actions { }
    }

    labels { }

    var
        ReportTiltle: Label 'TRAVEL CLAIM REPORT';
}
