query 50002 "Travel Query"
{
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    APIVersion = 'v2.0';
    EntityName = 'travelApproval';
    EntitySetName = 'travelApprovalEntity';
    QueryType = API;
    OrderBy = descending(no);

    elements
    {
        dataitem(employee; Employee)
        {
            column(empNo; "No.")
            {
            }
            column(navLoginID; "NAV Login ID")
            {
            }
            column(fullName; "Full Name")
            {
            }
            dataitem(ApprovalHRMS; "Approval HRMS")
            {
                DataItemLink = "Approver No" = employee."No.";
                column(no; "Document No.")
                {

                }
                column(approverCode; "Approver No")
                {

                }
                column(approverName; "Approver Name")
                {

                }
                column(approvalSequence; "Approval Sequence")
                {

                }
                column(approvalStatusLine; "Approval Status")
                {

                }
                dataitem(TravelRequest; "Travel Request")
                {
                    DataItemLink = "No." = ApprovalHRMS."Document No.";
                    column(employeeNo; "Employee No.")
                    {
                    }
                    column(employeeName; "Employee Name")
                    {
                    }
                    column(startDate; "Start Date")
                    {
                    }

                    column(endDate; "End Date")
                    {
                    }
                    column(startDateBS; "Start Date (BS)")
                    {
                    }
                    column(endDateBS; "End Date (BS)")
                    {
                    }
                    column(type; Type)
                    {
                    }
                    column(noOfDays; "No. of Days")
                    {
                    }
                    column(requestedDate; "Requested Date")
                    {
                    }
                    column(approverType; "Approver Type")
                    {
                    }
                    column(remarks; Remarks)
                    {
                    }
                    column(approvalStatus; "Approval Status")
                    {
                    }
                    column(Status; Status)
                    {
                    }
                    column(rejectionRemarks; "Rejection Remarks")
                    {
                    }
                    //Travel Request
                    column(purposeOfTravel; "Purpose of Travel") { }
                    column(typeOfVisit; "Type Of Visit") { }
                    column(modeOfTravel; "Mode Of Travel") { }
                    column(unitCode; "Unit Code") { }
                    column(actualTravelStartDate; "Actual Travel Start Date") { }
                    column(actualTravelEndDate; "Actual Travel End Date") { }
                    column(actualTravelStartTime; "Actual Travel Start Time") { }
                    column(actualTravelEndTime; "Actual Travel End Time") { }
                    column(travelWith; "Travel With") { }
                    column(departureFrom; "Departure From") { }
                    column(destination; Destination) { }
                    column(description; Description) { }
                    column(advanceCashRequired; "Advance Cash Required") { }
                    column(estimatedTransportationCost; "Estimated Transportation Cost") { }
                    column(estimatedLodgingCost; "Estimated Lodging Cost") { }
                    column(estimatedFoodingCost; "Estimated Fooding Cost") { }
                    column(estimatedConveyanceExpense; "Estimated Conveyance Expense") { }
                    column(otherEstimatedCost; "Other Estimated Cost") { }
                    column(authAccountNo; "Auth. Account No.") { }
                    column(extended; Extended) { }
                    column(travelOrderNo; "Travel Order No.") { }
                    column(totalNoOfDays; "Total No. of Days") { }
                    column(travelType; "Travel Countries") { }
                    column(currencyCode; "Currency Code") { }
                    column(exchangeRate; "Exchange Rate") { }
                    column(departureTime; "Departure Time") { }
                    column(arrivalTime; "Arrival Time") { }
                    column(totalEstimatedCost; "Total Estimated Cost") { }

                    //Travel Claim
                    column(foodingAllowanceLimit; "Fooding Allowance Limit") { }
                    column(lodgingAllowanceLimit; "Lodging Allowance Limit") { }
                    column(foodingPerDayLimit; "Fooding Per Day Limit") { }
                    column(lodgingPerDayLimit; "Lodging Per Day Limit") { }
                    column(claimType; "Claim Type") { }
                    column(claimedCountry; "Claimed Country") { }
                    column(roadAndAirFare; "Road/Air Fare") { }
                    column(reimbursable; Reimbursable) { }
                    column(outOfPocketExpense; "Out of Pocket Expense") { }
                    column(foodingAllowance; "Fooding Allowance") { }
                    column(lodgingAllowance; "Lodging Allowance") { }
                    column(conveyanceExpense; "Conveyance Expense") { }
                    column(otherExpense; "Other Expense") { }
                    column(totalClaimedAmount; "Total Claimed Amount") { }
                    column(advanceCash; "Advance Cash") { }
                    column(netReceivablePayable; "Net Receivable/Payable") { }
                    column(travelClaimed; "Travel Claimed") { }
                }
            }

        }
    }

    trigger OnBeforeOpen()
    var
        HrMgt: Codeunit "HR Mgt.";
    begin
        CurrQuery.SetRange(empNo, HrMgt.GetEmployeeNo());
        CurrQuery.SetFilter(type, '%1|%2', type::"Travel Request", type::"Travel Claim");
    end;
}
