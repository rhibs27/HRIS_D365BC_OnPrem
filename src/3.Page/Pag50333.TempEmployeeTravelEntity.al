page 50333 "Temp Employee Travel  Entity"
{
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'tempEmployeeTravelEntity';
    DelayedInsert = true;
    EntityName = 'tempEmployeeTravel';
    EntitySetName = 'tempEmployeeTravelEntity';
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
                // field(leavecode; Rec."Leave Code") { }
                field(cancelled; Rec.Cancelled) { }
                field(startDate; Rec."Start Date") { }
                field(startDateBS; Rec."Start Date (BS)") { }
                field(endDate; Rec."End Date") { }
                field(endDateBS; Rec."End Date (BS)") { }
                field(noOfDays; Rec."No. of Days")
                {
                    Editable = true;
                }
                field(requestedDate; Rec."Requested Date") { }
                field(fiscalYear; Rec."Fiscal Year") { }
                field(approvalStatus; Rec."Approval Status") { }
                field(cancelledNo; Rec."Cancelled No.") { }
                field(cancelledDocNo; Rec."Cancelled Document No.")
                {
                    Editable = true;
                }
                field(approverType; Rec."Approver Type") { }
                field(reasonCode; Rec."Reason Code") { }
                field(reasonDescription; Rec."Reason Description") { }
            }
            group("Travel Request")
            {
                field(purposeOfTravel; Rec."Purpose of Travel") { }
                field(typeOfVisit; Rec."Type Of Visit") { }
                field(modeOfTravel; Rec."Mode Of Travel") { }
                field(travelType; Rec."Travel Countries") { }
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
                field(travelOrderNo; Rec."Travel Order No.")
                {
                    Editable = true;

                    trigger OnValidate()
                    var
                        EmpActivity: Record "Employee Activity";
                    begin
                        if Rec."Travel Order No." <> '' then
                            if EmpActivity.Get(Rec."Travel Order No.") then
                                Rec.Validate("Travel With", EmpActivity."Travel With")
                    end;
                }
                field(totalNoOfDays; Rec."Total No. of Days") { }
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
                field(actualTravelStartDate; Rec."Actual Travel Start Date") { }
                field(actualTravelEndDate; Rec."Actual Travel End Date") { }
                field(actualTravelStartTime; Rec."Actual Travel Start Time") { }
                field(actualTravelEndTime; Rec."Actual Travel End Time") { }
                field(claimType; Rec."Claim Type") { }
                field(claimedCountry; Rec."Claimed Country") { }
                field(roadAndAirFare; Rec."Road/Air Fare") { }
                field(reimbursable; Rec.Reimbursable) { }
                field(outOfPocketExpense; Rec."Out of Pocket Expense")
                {
                    Editable = true;
                }
                field(foodingAllowance; Rec."Fooding Allowance")
                {
                    Editable = true;
                }
                field(lodgingAllowance; Rec."Lodging Allowance")
                {
                    Editable = true;
                }
                field(conveyanceExpense; Rec."Conveyance Expense") { }
                field(otherExpense; Rec."Other Expense") { }
                field(totalClaimedAmount; Rec."Total Claimed Amount") { }
                field(netReceivablePayable; Rec."Net Receivable/Payable") { }
                field(advanceCash; Rec."Advance Cash") { }
            }
            group(Approval)
            {
                field(recommenderCode; Rec."Recommender Code")
                {
                    trigger OnValidate()
                    begin
                        // if Rec.Type = Rec.Type::Resignation then
                        //     ResignationMgt.SendResignationApproval(Rec);
                        // if Rec.Type = Rec.Type::"Employee Transfer" then
                        //     TransferMgt.SendTransferApproval(Rec);
                    end;
                }
                field(recommenderName; Rec."Recommender Name") { }
                field(approverCode; Rec."Approver Code")
                {
                    trigger OnValidate()
                    begin
                        case Rec.Type of
                            Rec.Type::"Travel Request": //nilesh
                                TravelMgt.ApplyForTravel(Rec); //nilesh
                            Rec.Type::"Travel Claim": //nilesh
                                TravelMgt.ApplyForTravelClaim(Rec); //nilesh
                        end;
                    end;
                }
                field(approverName; Rec."Approver Name") { }
            }
        }
    }
    var
        HRMgt: Codeunit "HR Mgt.";
        TravelMgt: CodeUnit "Travel Mgt.";

}

