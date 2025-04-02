page 50341 "Employee Transfer Entity"
{
    APIGroup = 'HRMS';
    APIPublisher = 'Agile';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'Employee Transfer Entity';
    DelayedInsert = true;
    EntityName = 'employeeTransfer';
    EntitySetName = 'employeeTransferEntity';
    PageType = API;
    SourceTable = "Employee/HR Transfer";

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(no; Rec."No.") { }
                field(type; Rec.Type)
                {
                    trigger OnValidate()
                    begin
                        // if Rec.Type = Rec.Type::"Access Control" then begin
                        //     HRSetup.Get;
                        //     HRSetup.TestField("Access Control No.");
                        //     //  "No." := NoSeriesMgt.GetNextNo(HRSetup."Access Control No.",TODAY,TRUE);
                        //     Rec."No. Series" := HRSetup."Access Control No.";
                        //     Rec.Rename(NoSeriesMgt.GetNextNo(HRSetup."Access Control No.", Today, true));
                        //     //NoSeriesMgt.InitSeries(HRSetup."Access Control No.",xRec."No. Series","Requested Date","No.","No. Series");
                        // end;
                        // if Rec.Type = Rec.Type::"Changes in employee" then begin
                        //     HRSetup.Get;
                        //     HRSetup.TestField("Employee Change No. Series");
                        //     Rec."Approval Status" := Rec."Approval Status"::"Pending";
                        //     Rec."No. Series" := HRSetup."Employee Change No. Series";
                        //     // Noseries := NoSeriesMgt.GetNextNo(HRSetup."Employee Change No. Series", Today, true);
                        //     // Rec.Rename(Noseries);
                        // end;
                    end;
                }
                field(employeeNo; Rec."Employee No.")
                {
                    Editable = true;
                }
                field(employeeName; Rec."Employee Name") { }
                field(salaryLevel; Rec."Salary Level Code") { }
                field(department; Rec.Department) { }
                field(departmenName; Rec."Department Name") { }
                field(branchCode; Rec."Shortcut Dimension 1 Code") { }
                field(branchName; Rec."Branch Name") { }
                field(functionalTitle; Rec."Functional Title") { }
                field(startDate; Rec."Start Date") { }
                field(startDateBS; Rec."Start Date (BS)") { }
                field(endDate; Rec."End Date") { }
                field(endDateBS; Rec."End Date (BS)") { }
                field(noOfdays; Rec."No. of Days") { }
                field(requestedDate; Rec."Requested Date") { }
                field(fiscalYear; Rec."Fiscal Year") { }
                field(approvalStatus; Rec."Approval Status") { }
                field(status;rec.Status)
                {
                }
                field(isTransferDetailsAdded;Rec."Is Transfer Details Added")
                {
                }
                field(transferProposeDate;rec."Transfer Propose Date")
                {
                }
                field(cancelled; Rec.Cancelled) { }
                // field(cancelledNo; Rec."Cancelled No.") { }
                // field(cancelledDocNo; Rec."Cancelled Document No.") { }
                // field(approverType; Rec."Approver Type") { }
                field(reasonCode; Rec."Reason Code") { }
                field(reasonDescription; Rec."Reason Description") { }
                field(reasonForTransfer; Rec."Reason for Transfer") { }
                field(subProvinceCode;Rec."Sub Province Code") { }
                field(subProvinceName;SubProvinceName) { }
                field(provinceCode;Rec."Province Code") { }
                field(unitCode;Rec."Unit Code") { }
                field(unitName;UnitName) { }
                field(departmentName;DepartmentName) { }
                field(ExtensionName;ExtensionName) { }
                field(branchCodeTo;Rec."To Branch") { }
                field(remarks; Rec.Remarks) { }
                field(screenerRemarks; Rec."Screener Remarks") { }
                field(rejectionRemarks; Rec."Rejection Remarks") { }


            }
            group(Transfer)
            {
                field(transferType; Rec."Transfer Type") { }
                field(deputationOn; Rec."Deputation On") { }
                field(extensionCounterCode; Rec."Extension Counter Code") { }
                field(shortcutDimension1CodeTo; Rec."Shortcut Dimension 1 Code (To)") { }
                field(subProvinceCodeTo; Rec."Sub Province Code (To)") { }
                field(functionalTitleTo; Rec."Functional Title (To)") { }
                field(provinceCodeTo; Rec."Province Code (To)") { }
                field(unitTo; Rec."Unit (To)") { }
                field(departmentCodeTo; Rec."Department Code (To)") { }
                field(reportingLine1To; Rec."Reporting Line 1 (To)") { }
                field(reportingLine2To; Rec."Reporting Line 2 (To)") { }
                field(officeCode; Rec."Office Code") { }
                field(ecoSystemTo; Rec."Eco-System (To)") { }
                field(officeTo; Rec."Office (To)") { }
                field(extensionCounterTo; Rec."Extension Counter (To)") { }
                field(deputationOnTo; Rec."Deputation On (To)") { }
                field(extensionNameTo; ExtensionNameTo)
                {
                    Editable = false;
                }
                field(branchNameTo; BranchNameTo)
                {
                    Editable = false;
                }
                field(subProvinceNameTo; SubProvinceNameTo)
                {
                    Editable = false;
                }
                field(provinceNameTo; ProvinceNameTo)
                {
                    Editable = false;
                }
                field(unitNameTo; UnitNameTo)
                {
                    Editable = false;
                }
                field(departmentNameTo; DepartmentNameTo)
                {
                    Editable = false;
                }
                field(incomingSupervisior; Rec."Incoming Supervisior") { }
                field(incomingSupervisiorName; Rec."Incoming Supervisior Name") { }
                field(outgoingBranchRepPerson; Rec."Outgoing Branch Rep. Person")
                {
                    trigger OnValidate()
                    begin
                        Rec.CalcFields("Outgoing Reporting Person Name");
                    end;
                }
                field(outgoingReportingPersonName; Rec."Outgoing Reporting Person Name") { }
                // field(reviewer; Rec.Reviewer) { }
                // field(reviewerName; Rec."Reviewer Name") { }
                // field(dateofJoiningOfTransfer; Rec."Date of Joining Of Transfer") { }
                // field(reviewerRemarks; Rec."Reviewer Remarks") { }
                field(description; rec.Description)
                {
                }
                field(transferClaim;Rec."Transfer Claim")
                {
                }

            }
            group("Transfer Claim")
            {
                field(transferRemarks; Rec."Transfer Remarks") { }
                // field(transferClaimRecommenderName; RecommederName) { }
                field(relocationAllow; Rec."Relocation Allow.") { }
                field(outstationDiscomfortAllow; Rec."Outstation/Discomfort Allow.") { }
                field(BMAccomodationAllow; Rec."BM Accomodation Allow.") { }
                field(remoteAreaAllow; Rec."Remote Area Allow.") { }
                field(officiatingAllow; Rec."Officiating Allow.") { }
                field(relocationDistance; Rec."Relocation Distance") { }
                field(outstationDistance; Rec."Outstation Distance") { }
                field(bmafDistance; Rec."BMAF Distance") { }
                field(transferRequestNo;Rec."Transfer Request No")
                {
                }
                // field(transferAllowanceApproval; Rec."Transfer Allowance Approval") { }
                // field(forTransferClaimApproval; forTransferClaimApproval)
                // {
                //     trigger OnValidate()
                //     begin
                //         if Rec.Type in [Rec.Type::"Employee Transfer", Rec.Type::"HR Transfer",Rec.Type::"Transfer Claim"] then
                //             if forTransferClaimApproval then
                //                 TransferMgt.RequestTransferAllowanceClaim(Rec);
                //     end;
                // }
            }
            // group(Approval)
            // {
                // field(recommenderCode; Rec."Recommender Code")
                // {
                //     trigger OnValidate()
                //     begin
                //         if Rec.Type = Rec.Type::"Access Control" then begin
                //             HRSetup.Get;
                //             Employee.Reset;
                //             Employee.SetRange("Functional Title", HRSetup."HR Head Functional Title");
                //             if Employee.FindFirst then;
                //             Rec.Validate("Approver Code", Employee."No.");
                //             //HRMgt.SendAccessControlApproval(Rec);
                //             Rec."Approval Status" := Rec."Approval Status"::"Pending Approval";
                //         end;
                //     end;
                // }
                // field(recommnederName; Rec."Recommender Name") { }
                // field(approverCode; Rec."Approver Code") { }
                // field(approverName; Rec."Approver Name") { }
                // field(DischargeDate;Rec."Discharge Date")
                // {
                //     ApplicationArea = All;
                // }
                // field("Medical Prescription Date";Rec."Medical Prescription Date")
                // {
                //     ApplicationArea = All;
                // }
                // field(transferClaimApporverRemarks; TransferClaimApproverRemarks)
                // {
                //     trigger OnValidate()
                //     begin
                //         if ReasonCode.Get(Rec."No.") then begin
                //             ReasonCode."Transf. Claim Apporver Remarks" := TransferClaimApproverRemarks;
                //             ReasonCode.Modify;
                //         end else begin
                //             ReasonCode.Init;
                //             ReasonCode.Validate(Code, Rec."No.");
                //             ReasonCode."Transf. Claim Apporver Remarks" := TransferClaimApproverRemarks;
                //             ReasonCode.Insert;
                //         end;
                //     end;
                // }
            part(Attachment; "Attachment Subform")
            {
                EntityName = 'attachmentEntity';
                EntitySetName = 'attachmentEntities';
                SubPageLink = "No." = field("No.");
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

    trigger OnAfterGetRecord()
    begin
        GetTransferName;
        //SetControlAppearance;
        // Rec.CalcFields("Transfer Claim Reviewer Name");
        // if Employee.Get(Rec."Transfer Claim Recommender") then
        //     RecommederName := Employee."Full Name"
        // else
        //     RecommederName := '';

        // if ReasonCode.Get(Rec."Reason Code") then begin
        //     TransferClaimReviewerRemarks := ReasonCode."Transf. Claim Reviewer Remarks";
        //     TransferClaimRecommenderRemarks := ReasonCode."Transf. Claim Recomm. Remarks";
        //     TransferClaimApproverRemarks := ReasonCode."Transf. Claim Apporver Remarks";
        // end;
    end;

    // local procedure SetControlAppearance()
    // var
    //     EmpVar: Record Employee;
    //     DocApprover: Record "Document Approver";
    //     EmpActFilter: Text;
    //     AccessControlLine: Record "Access Control Request Line";
    //     SystemAccessControl: Record "System Access Control";
    // begin

    //     if Rec.Type = Rec.Type::Resignation then begin
    //         HRSetup.Get;
    //         ClearnceStatement := HRSetup."Clearance Statement I" + HRSetup."Clearance Statement II";
    //         Clear(EmpActFilter);
    //         EmpVar.Reset;
    //         EmpVar.SetRange("No.", Rec.GetFilter("Employee No."));
    //         if EmpVar.FindFirst then begin
    //             DocApprover.Reset;
    //             DocApprover.SetRange("Document Type", DocApprover."Document Type"::Resignation);
    //             DocApprover.SetRange("Employee No.", EmpVar."No.");
    //             if DocApprover.Find('-') then begin
    //                 repeat
    //                     if EmpActFilter = '' then
    //                         EmpActFilter := DocApprover."Document No."
    //                     else
    //                         EmpActFilter += '|' + DocApprover."Document No.";
    //                 until DocApprover.Next = 0;
    //                 Rec.FilterGroup(-1);
    //                 if EmpActFilter = '' then
    //                     Rec.SetRange("No.", EmpActFilter)
    //                 else
    //                     Rec.SetFilter("No.", EmpActFilter);
    //                 Rec.SetRange("Employee No.", EmpVar."No.");
    //                 // Rec.SetRange("Approver Code", EmpVar."No.");
    //                 // Rec.SetRange("Recommender Code", EmpVar."No.");
    //                 Rec.FilterGroup(0);
    //             end;
    //         end;
    //     end;

    //     if Rec.Type = Rec.Type::"Access Control" then begin
    //         Clear(EmpActFilter);
    //         EmpVar.Reset;
    //         EmpVar.SetRange("No.", Rec.GetFilter("Employee No."));
    //         if EmpVar.FindFirst then begin
    //             if not EmpVar."System Owner" then begin
    //                 Rec.FilterGroup(-1);
    //                 Rec.SetRange("Employee No.", EmpVar."No.");
    //                 Rec.SetRange("Recommender Code", EmpVar."No.");
    //                 Rec.SetRange("Approver Code", EmpVar."No.");
    //                 Rec.FilterGroup(0);
    //             end else begin
    //                 AccessControlLine.Reset;
    //                 //AccessControlLine.SETRANGE("Document No.","No.");
    //                 if AccessControlLine.FindFirst then
    //                     repeat
    //                         SystemAccessControl.Reset;
    //                         SystemAccessControl.SetRange(Code, AccessControlLine."System Type");
    //                         SystemAccessControl.SetRange("Type of Masters", SystemAccessControl."Type of Masters"::"System Control Setup");
    //                         SystemAccessControl.SetRange("System Department Owner", EmpVar."Department Code");
    //                         if SystemAccessControl.FindFirst then begin
    //                             if EmpActFilter = '' then
    //                                 EmpActFilter := AccessControlLine."Document No."
    //                             else
    //                                 EmpActFilter += '|' + AccessControlLine."Document No.";
    //                         end;
    //                     until AccessControlLine.Next = 0;
    //                 Rec.FilterGroup(-1);
    //                 Rec.SetRange("Employee No.", EmpVar."No.");
    //                 Rec.SetRange("Recommender Code", EmpVar."No.");
    //                 Rec.SetRange("Approver Code", EmpVar."No.");
    //                 if EmpActFilter <> '' then
    //                     Rec.SetFilter("No.", EmpActFilter);
    //                 Rec.FilterGroup(0);
    //             end;
    //         end;
    //     end;
    // end;
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
 

