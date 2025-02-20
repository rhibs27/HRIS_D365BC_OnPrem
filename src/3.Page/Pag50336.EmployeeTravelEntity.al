page 50336 "Employee Travel Entity"
{
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'employeeTravelEntity';
    DelayedInsert = true;
    EntityName = 'employeeTravel';
    EntitySetName = 'employeeTravelEntity';
    PageType = API;
    SourceTable = "Travel Request";

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(no; Rec."No.") { }
                field(type; Rec.Type) { }
                field(employeeNo; Rec."Employee No.")
                {
                    Editable = true;
                }
                field(employeeName; Rec."Employee Name") { }
                field(salaryLevel; Rec."Salary Level Code") { }
                field(department; Rec.Department) { }
                field(departmentName; Rec."Department Name") { }
                field(branchCode; Rec."Shortcut Dimension 1 Code") { }
                field(branchName; Rec."Branch Name") { }
                field(functionalTitle; Rec."Functional Title") { }
                field(startDate; Rec."Start Date") { }
                field(startDateBS; Rec."Start Date (BS)") { }
                field(endDate; Rec."End Date") { }
                field(endDateBS; Rec."End Date (BS)") { }
                field(noOfDays; Rec."No. of Days") { }
                field(requestedDate; Rec."Requested Date") { }
                field(fiscalYear; Rec."Fiscal Year") { }
                field(approvalStatus; Rec."Approval Status") { }
                field(cancelled; Rec.Cancelled) { }
                field(cancelledNo; Rec."Cancelled No.") { }
                field(cancelledDocNo; Rec."Cancelled Document No.") { }
                field(approverType; Rec."Approver Type") { }
                field(status; Rec.Status)
                {
                }
                // field(reasonCode; Rec."Reason Code") { }
                // field(reasonDescription; Rec."Reason Description") { }
                field(remarks; Rec.Remarks) { }
                // field(screenerRemarks; Rec."Screener Remarks") { }
                field(rejectionRemarks; Rec."Rejection Remarks") { }
            }
            group("Travel Request")
            {
                field(purposeOfTravel; Rec."Purpose of Travel") { }
                field(typeOfVisit; Rec."Type Of Visit") { }
                field(modeOfTravel; Rec."Mode Of Travel") { }
                field(unitCode; Rec."Unit Code") { }
                field(subProvinceCode; Rec."Sub Province Code") { }
                field(actualTravelStartDate; Rec."Actual Travel Start Date") { }
                field(actualTravelEndDate; Rec."Actual Travel End Date") { }
                field(actualTravelStartTime; Rec."Actual Travel Start Time") { }
                field(actualTravelEndTime; Rec."Actual Travel End Time") { }
                field(travelWith; Rec."Travel With") { }
                field(departureFrom; Rec."Depature From") { }
                field(destination; Rec.Destination) { }
                field(description; Rec.Description) { }
                field(advanceCashRequired; Rec."Advance Cash Required") { }
                field(estimatedTransportationCost; Rec."Estimated Transportation Cost") { }
                field(estimatedLodgingCost; Rec."Estimated Lodging Cost") { }
                field(estimatedFoodingCost; Rec."Estimated Fooding Cost") { }
                field(estimatedConveyanceExpense; Rec."Estimated Conveyance Expense") { }
                field(otherEstimatedCost; Rec."Other Estimated Cost") { }
                field(authAccountNo; Rec."Auth. Account No.") { }
                field(extended; Rec.Extended) { }
                field(travelOrderNo; Rec."Travel Order No.") { }
                field(totalNoOfDays; Rec."Total No. of Days") { }
                field(travelType; Rec."Travel Countries") { }
                field(currencyCode; Rec."Currency Code") { }
                field(exchangeRate; Rec."Exchange Rate") { }
                field(departureTime; Rec."Depature Time") { }
                field(arrivalTime; Rec."Arrival Time") { }
                field(totalEstimatedCost; Rec."Total Estimated Cost") { }
            }
            group("Travel Claim")
            {
                field(foodingAllowanceLimit; Rec."Fooding Allowance Limit") { }
                field(lodgingAllowanceLimit; Rec."Lodging Allowance Limit") { }
                field(foodingPerDayLimit; Rec."Fooding Per Day Limit") { }
                field(lodgingPerDayLimit; Rec."Lodging Per Day Limit") { }
                field(claimType; Rec."Claim Type") { }
                field(claimedCountry; Rec."Claimed Country") { }
                field(roadAndAirFare; Rec."Road/Air Fare") { }
                field(reimbursable; Rec.Reimbursable) { }
                field(outOfPocketExpense; Rec."Out of Pocket Expense") { }
                field(foodingAllowance; Rec."Fooding Allowance") { }
                field(lodgingAllowance; Rec."Lodging Allowance") { }
                field(conveyanceExpense; Rec."Conveyance Expense") { }
                field(otherExpense; Rec."Other Expense") { }
                field(totalClaimedAmount; Rec."Total Claimed Amount") { }
                field(advanceCash; Rec."Advance Cash") { }
                field(netReceivablePayable; Rec."Net Receivable/Payable") { }
                field(travelClaimed; Rec."Travel Claimed") { }
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Approval Status" := Rec."Approval Status"::Open;
    end;

    trigger OnOpenPage()
    var
        HrMgt: Codeunit "HR Mgt.";
    begin
        Rec.SetRange("Employee No.", HrMgt.GetEmployeeNo());
        Rec.SetAscending("No.", false);
    end;
}
