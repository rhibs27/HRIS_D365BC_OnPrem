page 50171 "Temp Employee Activity Entity"
{
    EntityName = 'tempemployeeactivity';
    EntitySetName = 'tempemployeeactivities';
    PageType = API;
    APIVersion = 'v2.0';
    DelayedInsert = true;
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    SourceTable = "Employee Activity";
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(No; Rec."No.") { }
                field(type; Rec.Type) { }
                field(employeeno; Rec."Employee No.")
                {
                    Editable = true;
                }
                field(employeename; Rec."Employee Name") { }
                field(salaryLevel; Rec."Salary Level Code") { }
                field(department; Rec.Department) { }
                field(departmenname; Rec."Department Name") { }
                field(branchcode; Rec."Shortcut Dimension 1 Code") { }
                field(branchname; Rec."Branch Name") { }
                field(functionaltitle; Rec."Functional Title") { }
                field(leavecode; Rec."Leave Code") { }
                field(cancelled; Rec.Cancelled) { }
                field(startdate; Rec."Start Date") { }
                field(startdateBS; Rec."Start Date (BS)") { }
                field(enddate; Rec."End Date") { }
                field(enddateBS; Rec."End Date (BS)") { }
                field(noofdays; Rec."No. of Days")
                {
                    Editable = true;
                }
                field(requesteddate; Rec."Requested Date") { }
                field(fiscalyear; Rec."Fiscal Year") { }
                field(approvalstatus; Rec."Approval Status") { }
                field(cancelledNo; Rec."Cancelled No.") { }
                field(cancelledDocNo; Rec."Cancelled Document No.")
                {
                    Editable = true;
                }
                field(approverType; Rec."Approver Type") { }
                field(reasonCode; Rec."Reason Code") { }
                field(reasonDescription; Rec."Reason Description") { }
                field(remarks; Rec.Remarks) { }
            }
            // group(Leave)
            // {
            //     field(leavedescription; Rec."Leave Description") { }
            //     field(leavetype; Rec."Leave Type") { }
            //     field(paytype; Rec."Pay Type") { }
            //     field(starttime; Rec."Start Time") { }
            //     field(endtime; Rec."End Time") { }
            //     field(compensatorydate; Rec."Compensatory Date") { }
            //     field(childGender; Rec."Child's Gender") { }
            //     field(forDeathOf; Rec."For Death Of") { }
            //     field(contactNo; Rec."Contact No.") { }
            //     field(remarks; Rec.Remarks) { }
            // }
            // group("Travel Request")
            // {
            //     field(PurposeOfTravel; Rec."Purpose of Travel") { }
            //     field(TypeOfVisit; Rec."Type Of Visit") { }
            //     field(ModeOfTravel; Rec."Mode Of Travel") { }
            //     field(Traveltype; Rec."Travel Countries") { }
            //     field(TravelWith; Rec."Travel With") { }
            //     field(DepatureFrom; Rec."Depature From") { }
            //     field(Destination; Rec.Destination) { }
            //     field(Description; Rec.Description) { }
            //     field(AdvanceCashRequired; Rec."Advance Cash Required") { }
            //     field(EstimatedTransportationCost; Rec."Estimated Transportation Cost") { }
            //     field(EstimatedLodgingCost; Rec."Estimated Lodging Cost") { }
            //     field(EstimatedFoodingCost; Rec."Estimated Fooding Cost") { }
            //     field(EstimatedConveyanceExpense; Rec."Estimated Conveyance Expense") { }
            //     field(OtherEstimatedCost; Rec."Other Estimated Cost") { }
            //     field(AuthAccountNo; Rec."Auth. Account No.") { }
            //     field(Extended; Rec.Extended) { }
            //     field(TravelOrderNo; Rec."Travel Order No.")
            //     {
            //         Editable = true;

            //         trigger OnValidate()
            //         var
            //             EmpActivity: Record "Employee Activity";
            //         begin
            //             if Rec."Travel Order No." <> '' then
            //                 if EmpActivity.Get(Rec."Travel Order No.") then
            //                     Rec.Validate("Travel With", EmpActivity."Travel With")
            //         end;
            //     }
            //     field(TotalNoofDays; Rec."Total No. of Days") { }
            //     field(CurrencyCode; Rec."Currency Code") { }
            //     field(ExchangeRate; Rec."Exchange Rate") { }
            //     field(DepatureTime; Rec."Depature Time") { }
            //     field(ArrivalTime; Rec."Arrival Time") { }
            //     field(TotalEstimatedCost; Rec."Total Estimated Cost") { }
            // }
            // group("Travel Claim")
            // {
            //     field(FoodingAllowanceLimit; Rec."Fooding Allowance Limit") { }
            //     field(LodgingAllowanceLimit; Rec."Lodging Allowance Limit") { }
            //     field(FoodingPerDayLimit; Rec."Fooding Per Day Limit") { }
            //     field(LodgingPerDayLimit; Rec."Lodging Per Day Limit") { }
            //     field(ActualTravelStartDate; Rec."Actual Travel Start Date") { }
            //     field(ActualTravelEndDate; Rec."Actual Travel End Date") { }
            //     field(ActualTravelStartTime; Rec."Actual Travel Start Time") { }
            //     field(ActualTravelEndTime; Rec."Actual Travel End Time") { }
            //     field(ClaimType; Rec."Claim Type") { }
            //     field(ClaimedCountry; Rec."Claimed Country") { }
            //     field(RoadandAirFare; Rec."Road/Air Fare") { }
            //     field(Reimbursable; Rec.Reimbursable) { }
            //     field(OutofPocketExpense; Rec."Out of Pocket Expense")
            //     {
            //         Editable = true;
            //     }
            //     field(FoodingAllowance; Rec."Fooding Allowance")
            //     {
            //         Editable = true;
            //     }
            //     field(LodgingAllowance; Rec."Lodging Allowance")
            //     {
            //         Editable = true;
            //     }
            //     field(ConveyanceExpense; Rec."Conveyance Expense") { }
            //     field(OtherExpense; Rec."Other Expense") { }
            //     field(TotalClaimedAmount; Rec."Total Claimed Amount") { }
            //     field(NetReceivablePayable; Rec."Net Receivable/Payable") { }
            //     field(AdvanceCash; Rec."Advance Cash") { }
            // }
            // group(Overtime)
            // {
            //     field(TimeDuration; Rec."Time Duration") { }
            //     field(EstimatedHours; Rec."Estimated Hours") { }
            //     field(ActualHours; Rec."Actual Hours") { }
            // }
            group(Transfer)
            {
                field(TransferType; Rec."Transfer Type") { }
                field(ExtensionCounterCode; Rec."Extension Counter Code") { }
                field(ShortcutDimension1CodeTo; Rec."Shortcut Dimension 1 Code (To)") { }
                // field(SubProvinceCodeTo; Rec."Sub Province Code (To)") { }
                field(ProvinceCodeTo; Rec."Province Code (To)") { }
                field(UnitTo; Rec."Unit (To)") { }
                field(OfficeCode; Rec."Office Code") { }
                // field(DepartmentCodeTo; Rec."Department Code (To)") { }
                // field(ReportingLine1To; Rec."Reporting Line 1 (To)") { }
                // field(ReportingLine2To; Rec."Reporting Line 2 (To)") { }
                field(UnitCode; Rec."Unit Code") { }
                // field(SubProvinceCode; Rec."Sub Province Code") { }
                field(FunctionalTitleTo; Rec."Functional Title (To)") { }
                // field(EcoSystemTo; Rec."Eco-System (To)") { }
                // field(OfficeTo; Rec."Office (To)") { }
                field(ExtensionCounterTo; Rec."Extension Counter (To)") { }
                field(ProposedTransferDate; Rec."Transfer Effective Date") { }
                field(TransferRemarks; Rec."Transfer Remarks") { }
                field(Reviewer; Rec.Reviewer) { }
                field(ReviewerName; Rec."Reviewer Name") { }
                field(IncomingSupervisior; Rec."Incoming Supervisior") { }
                field(IncomingSupervisiorName; Rec."Incoming Supervisior Name") { }
                field(DateofJoiningOfTransfer; Rec."Date of Joining Of Transfer") { }
                field(ReviewerRemarks; Rec."Reviewer Remarks") { }
            }
            group("Transfer Claim")
            {
                field(TransferClaimReviewer; Rec."Transfer Claim Reviewer") { }
                field(TransferClaimRecommender; Rec."Transfer Claim Recommender") { }
                field(TransferClaimReviewerName; Rec."Transfer Claim Reviewer Name") { }
                field(TransferClaimRecommenderName; RecommederName) { }
                field(RelocationAllow; Rec."Relocation Allow.") { }
                field(OutstationDiscomfortAllow; Rec."Outstation/Discomfort Allow.") { }
                field(BMAccomodationAllow; Rec."BM Accomodation Allow.") { }
                field(RemoteAreaAllow; Rec."Remote Area Allow.") { }
                field(OfficiatingAllow; Rec."Officiating Allow.") { }
                field(RelocationDistance; Rec."Relocation Distance") { }
                field(OutstationDistance; Rec."Outstation Distance") { }
                field(BMAFDistance; Rec."BMAF Distance") { }
                field(TransferAllowanceApproval; Rec."Transfer Allowance Approval") { }
                field(BloodGroup; Rec."Blood Group")
                {
                    trigger OnValidate()
                    begin
                        // if Rec.Type = Rec.Type::"Changes in employee" then
                        //     HRMgt.sendChangeforEmpforApproval(Rec);
                    end;
                }
            }
            group(Resignation)
            {
                field(proposedDateofResignation; Rec."Proposed Date of Resignation") { }
                field(supervisorProposedDate; Rec."Supervisor Proposed Date") { }
                field(hRProposedDate; Rec."HR Proposed Date") { }
                field(applyForWaiver; Rec."Apply for Waiver") { }
                field(waiverCase; Rec."Waiver Case") { }
                field(reasonforResignation; Rec."Reason for Resignation") { }
            }
            part(Attachment; "Attachment Subform")
            {
                EntityName = 'attachmentEntity';
                EntitySetName = 'attachmentEntities';
                SubPageLink = "No." = field("No.");
            }
            group(Insurance)
            {
                field(insuranceClaim; Rec."Insurance Claim") { }
                field(fatherName; Rec."Father Name") { }
                field(motherName; Rec."Mother Name") { }
                field(spouseName; Rec."Spouse Name") { }
                field(childName; Rec."Child Name") { }
                field(totalInsuranceClaimAmount; Rec."Total Insurance Claim Amount") { }
                field(medicalPrescriptionDate; Rec."Medical Prescription Date") { }
                field(dischargeDate; Rec."Discharge Date")
                {
                    trigger OnValidate()
                    var
                        EmpActivity: Record "Employee Activity";
                    begin
                        if Rec.Type = Rec.Type::"Medical Insurance Claim" then begin
                            Rec."Insurance Status" := Rec."Insurance Status"::"Request to DTMD";
                            EmpActivity.Init;
                            EmpActivity.Copy(Rec);
                            EmpActivity.Insert(true);
                        end;
                    end;
                }
            }
            group(Approval)
            {
                field(recommendercode; Rec."Recommender Code")
                {
                    trigger OnValidate()
                    begin
                        // if Rec.Type = Rec.Type::Resignation then
                        // HRMgt.SendResignationApproval(Rec);
                        // if Rec.Type = Rec.Type::"Employee Transfer" then
                        //     TransferMgt.SendTransferApproval(Rec);
                    end;
                }
                field(recommnedername; Rec."Recommender Name") { }
                field(approvercode; Rec."Approver Code")
                {
                    trigger OnValidate()
                    begin
                        case Rec.Type of
                        // Rec.Type::"Leave Request":
                        //     begin
                        //         if Rec.Cancelled then
                        //             HRMgt.ApplyCancelEmployeeActivity(Rec)
                        //         // else
                        //         //     HRMgt.ApplyForLeave(Rec); NIlesh
                        //     end;
                        // Rec.Type::"Travel Request": //nilesh
                        //     HRMgt.ApplyForTravel(Rec); //nilesh
                        // Rec.Type::"Travel Claim": //nilesh
                        //     HRMgt.ApplyForTravelClaim(Rec); //nilesh
                        // Rec.Type::"Out of Office", Rec.Type::Overtime, Rec.Type::"Bulk Cash":
                        //     TransferMgt.ApplyForApprovalForms(Rec);
                        // Rec.Type::"Attendance Missed":
                        //     HRMgt.ApplyCancelEmployeeActivity(Rec);
                        end;
                    end;
                }
                field(approvername; Rec."Approver Name") { }
            }
        }
    }

    actions { }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Approval Status" := Rec."Approval Status"::Pending;
    end;

    trigger OnOpenPage()
    begin
        Rec.CalcFields("Transfer Claim Reviewer Name");
        if Employee.Get(Rec."Transfer Claim Recommender") then
            RecommederName := Employee."Full Name"
        else
            RecommederName := '';
    end;

    var
        HRMgt: Codeunit "HR Mgt.";
        TransferMgt: Codeunit "Transfer Mgt.";
        ResignationMgt: Codeunit "Resignation Mgt";
        RecommederName: Text;
        Employee: Record Employee;
}
