page 33019965 "Employee Activity Entity"
{
    // version APINICASIA1.00

    EntityName = 'employeeactivity';
    EntitySetName = 'employeeactivities';
    PageType = API;
    APIVersion = 'v2.0';
    APIPublisher = 'Agile';
    APIGroup = 'HRMS';
    DelayedInsert = true;
    SourceTable = "Employee Activity";
    SourceTableView = sorting("No.")
                      order(descending);

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(number; Rec."No.") { }
                field(type; Rec.Type)
                {
                    trigger OnValidate()
                    begin
                        if Rec.Type = Rec.Type::"Access Control" then begin
                            HRSetup.Get;
                            HRSetup.TestField("Access Control No.");
                            //  "No." := NoSeriesMgt.GetNextNo(HRSetup."Access Control No.",TODAY,TRUE);
                            Rec."No. Series" := HRSetup."Access Control No.";
                            Rec.Rename(NoSeriesMgt.GetNextNo(HRSetup."Access Control No.", Today, true));
                            //NoSeriesMgt.InitSeries(HRSetup."Access Control No.",xRec."No. Series","Requested Date","No.","No. Series");
                        end;
                        if Rec.Type = Rec.Type::"Changes in employee" then begin
                            HRSetup.Get;
                            HRSetup.TestField("Employee Change No. Series");
                            Rec."Approval Status" := Rec."Approval Status"::"Pending Approval";
                            Rec."No. Series" := HRSetup."Employee Change No. Series";
                            // Noseries := NoSeriesMgt.GetNextNo(HRSetup."Employee Change No. Series", Today, true);
                            // Rec.Rename(Noseries);
                        end;
                    end;
                }
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
                field(startdate; Rec."Start Date") { }
                field(startdateBS; Rec."Start Date (BS)") { }
                field(enddate; Rec."End Date") { }
                field(enddateBS; Rec."End Date (BS)") { }
                field(noofdays; Rec."No. of Days") { }
                field(requesteddate; Rec."Requested Date") { }
                field(fiscalyear; Rec."Fiscal Year") { }
                field(approvalstatus; Rec."Approval Status") { }
                field(cancelled; Rec.Cancelled) { }
                field(cancelledNo; Rec."Cancelled No.") { }
                field(cancelledDocNo; Rec."Cancelled Document No.") { }
                field(approverType; Rec."Approver Type") { }
                field(reasonCode; Rec."Reason Code") { }
                field(reasonDescription; Rec."Reason Description") { }
            }
            group(Leave)
            {
                field(leavecode; Rec."Leave Code") { }
                field(leavedescription; Rec."Leave Description") { }
                field(leavetype; Rec."Leave Type") { }
                field(paytype; Rec."Pay Type") { }
                field(starttime; Rec."Start Time") { }
                field(endtime; Rec."End Time") { }
                field(compensatorydate; Rec."Compensatory Date") { }
                field(childGender; Rec."Child's Gender") { }
                field(forDeathOf; Rec."For Death Of") { }
                field(contactNo; Rec."Contact No.") { }
                field(remarks; Rec.Remarks) { }
                field(screenerRemarks; Rec."Screener Remarks") { }
                field(rejectionRemarks; Rec."Rejection Remarks") { }
            }
            group("Travel Request")
            {
                field(PurposeOfTravel; Rec."Purpose of Travel") { }
                field(TypeOfVisit; Rec."Type Of Visit") { }
                field(ModeOfTravel; Rec."Mode Of Travel") { }
                field(UnitCode; Rec."Unit Code") { }
                field(SubProvinceCode; Rec."Sub Province Code") { }
                field(ActualTravelStartDate; Rec."Actual Travel Start Date") { }
                field(ActualTravelEndDate; Rec."Actual Travel End Date") { }
                field(ActualTravelStartTime; Rec."Actual Travel Start Time") { }
                field(ActualTravelEndTime; Rec."Actual Travel End Time") { }
                field(TravelWith; Rec."Travel With") { }
                field(DepatureFrom; Rec."Depature From") { }
                field(Destination; Rec.Destination) { }
                field(Description; Rec.Description) { }
                field(AdvanceCashRequired; Rec."Advance Cash Required") { }
                field(EstimatedTransportationCost; Rec."Estimated Transportation Cost") { }
                field(EstimatedLodgingCost; Rec."Estimated Lodging Cost") { }
                field(EstimatedFoodingCost; Rec."Estimated Fooding Cost") { }
                field(EstimatedConveyanceExpense; Rec."Estimated Conveyance Expense") { }
                field(OtherEstimatedCost; Rec."Other Estimated Cost") { }
                field(AuthAccountNo; Rec."Auth. Account No.") { }
                field(Extended; Rec.Extended) { }
                field(TravelOrderNo; Rec."Travel Order No.") { }
                field(TotalNoofDays; Rec."Total No. of Days") { }
                field(Traveltype; Rec."Travel Countries") { }
                field(CurrencyCode; Rec."Currency Code") { }
                field(ExchangeRate; Rec."Exchange Rate") { }
                field(DepatureTime; Rec."Depature Time") { }
                field(ArrivalTime; Rec."Arrival Time") { }
                field(TotalEstimatedCost; Rec."Total Estimated Cost") { }
            }
            group("Travel Claim")
            {
                field(FoodingAllowanceLimit; Rec."Fooding Allowance Limit") { }
                field(LodgingAllowanceLimit; Rec."Lodging Allowance Limit") { }
                field(FoodingPerDayLimit; Rec."Fooding Per Day Limit") { }
                field(LodgingPerDayLimit; Rec."Lodging Per Day Limit") { }
                field(ClaimType; Rec."Claim Type") { }
                field(ClaimedCountry; Rec."Claimed Country") { }
                field(RoadandAirFare; Rec."Road/Air Fare") { }
                field(Reimbursable; Rec.Reimbursable) { }
                field(OutofPocketExpense; Rec."Out of Pocket Expense") { }
                field(FoodingAllowance; Rec."Fooding Allowance") { }
                field(LodgingAllowance; Rec."Lodging Allowance") { }
                field(ConveyanceExpense; Rec."Conveyance Expense") { }
                field(OtherExpense; Rec."Other Expense") { }
                field(TotalClaimedAmount; Rec."Total Claimed Amount") { }
                field(AdvanceCash; Rec."Advance Cash") { }
                field(NetReceivablePayable; Rec."Net Receivable/Payable") { }
                field(TravelClaimed; Rec."Travel Claimed") { }
            }
            group(Overtime)
            {
                field(TimeDuration; Rec."Time Duration") { }
                field(ActualHours; Rec."Actual Hours") { }
                field(EstimatedHours; Rec."Estimated Hours") { }
                field(EncashmentCode; Rec."Encashment Code") { }
                field(OTAmount; Rec."OT Amount") { }
                field(OTDisbursed; Rec."OT Disbursed") { }
            }
            group(Transfer)
            {
                field(TransferType; Rec."Transfer Type") { }
                field(DeputationOn; Rec."Deputation On") { }
                field(ExtensionCounterCode; Rec."Extension Counter Code") { }
                field(ShortcutDimension1CodeTo; Rec."Shortcut Dimension 1 Code (To)") { }
                field(SubProvinceCodeTo; Rec."Sub Province Code (To)") { }
                field(FunctionalTitleTo; Rec."Functional Title (To)") { }
                field(ProvinceCodeTo; Rec."Province Code (To)") { }
                field(UnitTo; Rec."Unit (To)") { }
                field(DepartmentCodeTo; Rec."Department Code (To)") { }
                field(ReportingLine1To; Rec."Reporting Line 1 (To)") { }
                field(ReportingLine2To; Rec."Reporting Line 2 (To)") { }
                field(OfficeCode; Rec."Office Code") { }
                field(EcoSystemTo; Rec."Eco-System (To)") { }
                field(OfficeTo; Rec."Office (To)") { }
                field(ExtensionCounterTo; Rec."Extension Counter (To)") { }
                field(DeputationOnTo; Rec."Deputation On (To)") { }
                field(ProposedTransferDate; Rec."Transfer Effective Date") { }
                field(ExtensionNameTo; ExtensionNameTo)
                {
                    Editable = false;
                }
                field(BranchNameTo; BranchNameTo)
                {
                    Editable = false;
                }
                field(SubProvinceNameTo; SubProvinceNameTo)
                {
                    Editable = false;
                }
                field(ProvinceNameTo; ProvinceNameTo)
                {
                    Editable = false;
                }
                field(UnitNameTo; UnitNameTo)
                {
                    Editable = false;
                }
                field(DepartmentNameTo; DepartmentNameTo)
                {
                    Editable = false;
                }
                field(IncomingSupervisior; Rec."Incoming Supervisior") { }
                field(IncomingSupervisiorName; Rec."Incoming Supervisior Name") { }
                field(OutgoingBranchRepPerson; Rec."Outgoing Branch Rep. Person")
                {
                    trigger OnValidate()
                    begin
                        Rec.CalcFields("Outgoing Reporting Person Name");
                    end;
                }
                field(OutgoingReportingPersonName; Rec."Outgoing Reporting Person Name") { }
                field(Reviewer; Rec.Reviewer) { }
                field(ReviewerName; Rec."Reviewer Name") { }
                field(DateofJoiningOfTransfer; Rec."Date of Joining Of Transfer") { }
                field(ReviewerRemarks; Rec."Reviewer Remarks") { }
            }
            group("Transfer Claim")
            {
                field(TransferRemarks; Rec."Transfer Remarks") { }
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
                field(forTransferClaimApproval; forTransferClaimApproval)
                {
                    trigger OnValidate()
                    begin
                        // if Rec.Type in [Rec.Type::"Employee Transfer", Rec.Type::"HR Transfer"] then
                        //     if forTransferClaimApproval then
                        //         TransferMgt.RequestTransferAllowanceClaim(Rec);
                    end;
                }
            }
            group("Change in employee")
            {
                field(MobileNo; Rec."Mobile No.") { }
                field(MaritalStatus; Rec."Marital Status") { }
                field(EmailPersonal; Rec."Email (Personal)") { }
                field(PassportNo; Rec."Passport No.") { }
                field(DifferentlyAble; Rec."Differently Able") { }
                field(VehicleType; Rec."Vehicle Type") { }
                field(TemporaryAddress; Rec."Temporary Address") { }
                field(TemporaryProvince; Rec."Temporary Province") { }
                field(VDC; Rec.VDC) { }
                field(TemporaryDistrict; Rec."Temporary District") { }
                field(House; Rec.House) { }
                field(BloodGroup; Rec."Blood Group") { }
            }
            group(Resignation)
            {
                field(proposedDateofResignation; Rec."Proposed Date of Resignation") { }
                field(supervisorProposedDate; Rec."Supervisor Proposed Date") { }
                field(hRProposedDate; Rec."HR Proposed Date") { }
                field(waiverCase; Rec."Waiver Case") { }
                field(reasonforResignation; Rec."Reason for Resignation") { }
                field(clearnceStatement; ClearnceStatement) { }
                field(applyForWaiver; Rec."Apply for Waiver") { }
            }
            group("Access Control")
            {
                field(requestCase; Rec."Request Case") { }
            }
            part(Attachment; "Attachment Subform")
            {
                EntityName = 'attachmentEntity';
                EntitySetName = 'attachmentEntities';
                SubPageLink = "No." = field("No.");
            }
            part(docApproverEntities; "Document Approver Resignation")
            {
                EntityName = 'docApproverEntity';
                EntitySetName = 'docApproverEntities';
                SubPageLink = "Document No." = field("No.");
            }
            part(reqAccessControlEmployeeEntities; "Access Control Emp Subforms")
            {
                EntityName = 'reqAccessControlEmployeeEntity';
                EntitySetName = 'reqAccessControlEmployeeEntities';
                SubPageLink = "Document No." = field("No.");
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
                        if Rec.Type = Rec.Type::"Access Control" then begin
                            HRSetup.Get;
                            Employee.Reset;
                            Employee.SetRange("Functional Title", HRSetup."HR Head Functional Title");
                            if Employee.FindFirst then;
                            Rec.Validate("Approver Code", Employee."No.");
                            HRMgt.SendAccessControlApproval(Rec);
                            Rec."Approval Status" := Rec."Approval Status"::"Pending Approval";
                        end;
                    end;
                }
                field(recommnedername; Rec."Recommender Name") { }
                field(approvercode; Rec."Approver Code") { }
                field(approvername; Rec."Approver Name") { }
                // field(DischargeDate;Rec."Discharge Date")
                // {
                //     ApplicationArea = All;
                // }
                // field("Medical Prescription Date";Rec."Medical Prescription Date")
                // {
                //     ApplicationArea = All;
                // }
                field(transferClaimApporverRemarks; TransferClaimApproverRemarks)
                {
                    trigger OnValidate()
                    begin
                        if ReasonCode.Get(Rec."No.") then begin
                            ReasonCode."Transf. Claim Apporver Remarks" := TransferClaimApproverRemarks;
                            ReasonCode.Modify;
                        end else begin
                            ReasonCode.Init;
                            ReasonCode.Validate(Code, Rec."No.");
                            ReasonCode."Transf. Claim Apporver Remarks" := TransferClaimApproverRemarks;
                            ReasonCode.Insert;
                        end;
                    end;
                }
                field(transferClaimRecommenderRemarks; TransferClaimRecommenderRemarks)
                {
                    trigger OnValidate()
                    begin
                        if ReasonCode.Get(Rec."No.") then begin
                            ReasonCode."Transf. Claim Recomm. Remarks" := TransferClaimRecommenderRemarks;
                            ReasonCode.Modify;
                        end else begin
                            ReasonCode.Init;
                            ReasonCode.Validate(Code, Rec."No.");
                            ReasonCode."Transf. Claim Recomm. Remarks" := TransferClaimRecommenderRemarks;
                            ReasonCode.Insert;
                        end;
                    end;
                }
                field(transferClaimReviewerRemarks; TransferClaimReviewerRemarks)
                {
                    trigger OnValidate()
                    begin
                        if ReasonCode.Get(Rec."No.") then begin
                            ReasonCode."Transf. Claim Reviewer Remarks" := TransferClaimReviewerRemarks;
                            ReasonCode.Modify;
                        end else begin
                            ReasonCode.Init;
                            ReasonCode.Validate(Code, Rec."No.");
                            ReasonCode."Transf. Claim Reviewer Remarks" := TransferClaimReviewerRemarks;
                            ReasonCode.Insert;
                        end;
                    end;
                }
            }
        }
    }

    actions { }

    trigger OnAfterGetRecord()
    begin
        SetControlAppearance;
        Rec.CalcFields("Transfer Claim Reviewer Name");
        if Employee.Get(Rec."Transfer Claim Recommender") then
            RecommederName := Employee."Full Name"
        else
            RecommederName := '';

        // if ReasonCode.Get(Rec."Reason Code") then begin
        //     TransferClaimReviewerRemarks := ReasonCode."Transf. Claim Reviewer Remarks";
        //     TransferClaimRecommenderRemarks := ReasonCode."Transf. Claim Recomm. Remarks";
        //     TransferClaimApproverRemarks := ReasonCode."Transf. Claim Apporver Remarks";
        // end;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Approval Status" := Rec."Approval Status"::Open;
    end;

    trigger OnOpenPage()
    begin
        SetControlAppearance;
    end;

    var
        ClearnceStatement: Text;
        HRSetup: Record "Human Resources Setup";
        RecommederName: Text;
        Employee: Record Employee;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        HRMgt: Codeunit "HR Mgt.";
        TransferMgt: Codeunit "Transfer Mgt.";
        forTransferClaimApproval: Boolean;
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
        TransferClaimReviewerRemarks: Text;
        TransferClaimRecommenderRemarks: Text;
        TransferClaimApproverRemarks: Text;
        ReasonCode: Record "Reason Code";

    local procedure SetControlAppearance()
    var
        EmpVar: Record Employee;
        DocApprover: Record "Document Approver";
        EmpActFilter: Text;
        AccessControlLine: Record "Access Control Request Line";
        SystemAccessControl: Record "System Access Control";
    begin

        if Rec.Type = Rec.Type::Resignation then begin
            HRSetup.Get;
            ClearnceStatement := HRSetup."Clearance Statement I" + HRSetup."Clearance Statement II";
            Clear(EmpActFilter);
            EmpVar.Reset;
            EmpVar.SetRange("No.", Rec.GetFilter("Employee No."));
            if EmpVar.FindFirst then begin
                DocApprover.Reset;
                DocApprover.SetRange("Document Type", DocApprover."Document Type"::Resignation);
                DocApprover.SetRange("Employee No.", EmpVar."No.");
                if DocApprover.Find('-') then begin
                    repeat
                        if EmpActFilter = '' then
                            EmpActFilter := DocApprover."Document No."
                        else
                            EmpActFilter += '|' + DocApprover."Document No.";
                    until DocApprover.Next = 0;
                    Rec.FilterGroup(-1);
                    if EmpActFilter = '' then
                        Rec.SetRange("No.", EmpActFilter)
                    else
                        Rec.SetFilter("No.", EmpActFilter);
                    Rec.SetRange("Employee No.", EmpVar."No.");
                    Rec.SetRange("Approver Code", EmpVar."No.");
                    Rec.SetRange("Recommender Code", EmpVar."No.");
                    Rec.FilterGroup(0);
                end;
            end;
        end;

        if Rec.Type = Rec.Type::"Access Control" then begin
            Clear(EmpActFilter);
            EmpVar.Reset;
            EmpVar.SetRange("No.", Rec.GetFilter("Employee No."));
            if EmpVar.FindFirst then begin
                if not EmpVar."System Owner" then begin
                    Rec.FilterGroup(-1);
                    Rec.SetRange("Employee No.", EmpVar."No.");
                    Rec.SetRange("Recommender Code", EmpVar."No.");
                    Rec.SetRange("Approver Code", EmpVar."No.");
                    Rec.FilterGroup(0);
                end else begin
                    AccessControlLine.Reset;
                    //AccessControlLine.SETRANGE("Document No.","No.");
                    if AccessControlLine.FindFirst then
                        repeat
                            SystemAccessControl.Reset;
                            SystemAccessControl.SetRange(Code, AccessControlLine."System Type");
                            SystemAccessControl.SetRange("Type of Masters", SystemAccessControl."Type of Masters"::"System Control Setup");
                            SystemAccessControl.SetRange("System Department Owner", EmpVar."Department Code");
                            if SystemAccessControl.FindFirst then begin
                                if EmpActFilter = '' then
                                    EmpActFilter := AccessControlLine."Document No."
                                else
                                    EmpActFilter += '|' + AccessControlLine."Document No.";
                            end;
                        until AccessControlLine.Next = 0;
                    Rec.FilterGroup(-1);
                    Rec.SetRange("Employee No.", EmpVar."No.");
                    Rec.SetRange("Recommender Code", EmpVar."No.");
                    Rec.SetRange("Approver Code", EmpVar."No.");
                    if EmpActFilter <> '' then
                        Rec.SetFilter("No.", EmpActFilter);
                    Rec.FilterGroup(0);
                end;
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
}
