codeunit 50005 "Transfer Mgt."
{
    procedure OpenTransferRequest(EmpCode: Code[10])
    var
        //EmpAct4: Record "Employee Activity" temporary;
        EmpTransfer: Record "Employee/HR Transfer" temporary;
        RequestError: Label 'You are not eligible to request for a transfer.';
    begin
        Clear(Employee);
        Employee.Get(EmpCode);
        Employee.TestField("Confirmation Date");
        if Today > CalcDate('<2Y>', Employee."Confirmation Date") then
            Error(RequestError);

        HRSetup.Get;
        Employee1.Reset;
        Employee1.SetRange("Functional Title", HRSetup."HR Head Functional Title");
        Employee1.SetRange(Status, Employee1.Status::Active); //Min
        if Employee.FindFirst then;
        EmpTransfer.Init;
        EmpTransfer.Validate(Type, EmpTransfer.Type::"Employee Transfer");
        EmpTransfer.Validate("Employee No.", EmpCode);
        EmpTransfer.Validate("Approval Status", EmpTransfer."Approval Status"::Open);
        EmpTransfer.Insert;
        PAGE.Run(PAGE::"Transfer Card", EmpTransfer);
    end;

    procedure OpenOutofOfficeForms(EmpCode: Code[20])
    var
        //EmpAct: Record "Employee Activity" temporary;
        OverTime: Record OverTime temporary;
    begin
        Clear(Employee);
        Employee.Get(EmpCode);
        OverTime.Init;
        OverTime.Validate("Employee No.", EmpCode);
        OverTime.Validate("Functional Title", Employee."Functional Title");
        OverTime.Validate(Type, OverTime.Type::"Out of Office");
        OverTime.Validate("Approval Status", OverTime."Approval Status"::Open);
        OverTime.Validate("Requested Date", Today);
        OverTime.Validate("Shortcut Dimension 1 Code", Employee."Global Dimension 1 Code");
        OverTime.Validate(Department, Employee."Department Code");
        OverTime.Insert;
        PAGE.Run(PAGE::"Overtime Card", OverTime);
    end;

    procedure SendTransferApproval(TempEmpHRtransfer: Record "Employee/HR Transfer" temporary): Boolean
    var
        EmphrTransfer: Record "Employee/HR Transfer";
        ConfirmTransfer: Label 'Do you want to send transfer request ?';
        ErrorNoOfDays: Label 'No. of leave days must be greater than 0.';
        TransferSent: Label 'Transfer request approval has been sent.';
        NoRecommender: Label 'No Recommender Code.';
        NoApprover: Label 'No Approver Code.';
        IncomingDoc: Record "Incoming Document";
        AttachSetup: Record "Attachment Setup";
    begin
        if not GuiAllowed then
            TempEmphrtransfer."Transfer Category" := TempEmphrtransfer."Transfer Category"::General;
        TempEmphrtransfer.TestField(Description);
        TempEmphrtransfer.TestField("Reason for Resignation"); //here reason for transfer
        TempEmphrtransfer.TestField("Transfer Category");

        if TempEmphrtransfer."Transfer Category" = TempEmphrtransfer."Transfer Category"::"Temporary" then begin
            TempEmphrtransfer.TestField("Start Date");
            TempEmphrtransfer.TestField("End Date");
        end;
        EmphrTransfer.Reset;
        EmphrTransfer.SetFilter(Type, '%1', EmphrTransfer.Type::"HR Transfer");
        EmphrTransfer.SetFilter("Approval Status", '<>%1', EmphrTransfer."Approval Status"::Acknowledged);
        EmphrTransfer.SetRange("Employee No.", TempEmphrtransfer."Employee No.");
        EmphrTransfer.SetFilter("No.", '<>%1', TempEmphrtransfer."No.");
        if EmphrTransfer.FindFirst then
            Error('Transfer card of employee %1 is still open or pending.', EmphrTransfer."Employee Name");

        EmphrTransfer.Reset;
        EmphrTransfer.Init;
        EmphrTransfer.Validate("Requested Date", Today);
        EmphrTransfer.TransferFields(TempEmphrtransfer);
        EmphrTransfer.Validate("Approval Status", EmphrTransfer."Approval Status"::"Pending Approval");
        EmphrTransfer.Validate("User ID", UserId);
        Employee.Get(EmphrTransfer."Employee No.");
        EmphrTransfer.VALIDATE("Recommender Code", Employee."Approver Code");
        HRSetup.Get;
        HRSetup.TestField("HR Head Functional Title");
        HRSetup.TestField("HR Department Code");

        Employee.Reset;
        Employee.SetRange("Functional Title", HRSetup."HR Head Functional Title");
        Employee.SetRange("Department Code", HRSetup."HR Department Code");
        Employee.SetRange(Status, Employee.Status::Active); //Min
        if Employee.FindFirst then
            EmphrTransfer.Validate("Approver Code", Employee."No.");
        if EmphrTransfer.Type = EmphrTransfer.Type::"Employee Transfer" then
            if EmphrTransfer."Recommender Code" = '' then
                Error(NoRecommender);
        if EmphrTransfer."Approver Code" = '' then
            Error(NoApprover);

        EmphrTransfer.Insert(true);

        HRMgt.SendMailFromTemplate(DATABASE::"Employee/HR Transfer", EmphrTransfer.Type::"Employee Transfer", EmphrTransfer."Approval Status"::Open, '', EmphrTransfer."Employee No.", EmphrTransfer."No.", 0);   //For email
        Message(TransferSent);
        exit(true);
    end;

    procedure RecommendTransfer(var EmpHrTransfer: Record "Employee/HR Transfer")
    var
        ConfirmApprove: Label 'Confirm Approve?';
        ConfirmReject: Label 'Confirm Reject?';
    begin
        if StrPos(EmpHrTransfer."Recommender Code", HRMgt.GetEmployeeNo) = 0 then
            Error('You are not eligible to recommend this document');
        EmpHrTransfer.TestField("Approval Status", EmpHrTransfer."Approval Status"::"Pending Approval");
        EmpHrTransfer.Validate("Approval Status", EmpHrTransfer."Approval Status"::Recommended);
        EmpHrTransfer.Modify;
        Message('Document has been recommended');
    end;

    procedure RecommendTransferAPI(var EmpHrTransfer: Record "Employee/HR Transfer"; employeeNo: Code[20])
    begin
        if StrPos(EmpHrTransfer."Recommender Code", employeeNo) = 0 then
            Error('You are not eligible to recommend this document');
        EmpHrTransfer.TestField("Approval Status", EmpHrTransfer."Approval Status"::"Pending Approval");
        EmpHrTransfer.Validate("Approval Status", EmpHrTransfer."Approval Status"::Recommended);
        EmpHrTransfer.Modify;
        Message('Document has been recommended');
    end;


    procedure ReviewTransfer(var EmpHrTransfer: Record "Employee/HR Transfer")
    var
        ConfirmApprove: Label 'Confirm Approve?';
        ConfirmReject: Label 'Confirm Reject?';
    begin
        if EmpHrTransfer.Reviewer <> HRMgt.GetEmployeeNo then
            Error('You are not elibile to review this document');
        EmpHrTransfer.TestField("Approval Status", EmpHrTransfer."Approval Status"::Recommended);
        EmpHrTransfer.Validate("Approval Status", EmpHrTransfer."Approval Status"::Reviewed);
        EmpHrTransfer.Modify;
        Message('Document has been reviewed.');
    end;

    procedure ReviewTransferAPI(var EmpHrTransfer: Record "Employee/HR Transfer"; employeeNo: Code[20])
    begin
        if EmpHrTransfer.Reviewer <> employeeNo then
            Error('You are not elibile to review this document');
        EmpHrTransfer.TestField("Approval Status", EmpHrTransfer."Approval Status"::Recommended);
        EmpHrTransfer.Validate("Approval Status", EmpHrTransfer."Approval Status"::Reviewed);
        EmpHrTransfer.Modify;
        Message('Document has been reviewed.');
    end;

    procedure ScreenTransfer(var EmpHrTransfer: Record "Employee/HR Transfer")
    var
        ConfirmApprove: Label 'Confirm Approve?';
        ConfirmReject: Label 'Confirm Reject?';
    begin
        EmpHrTransfer.TestField("Transfer Category");
        EmpHrTransfer.TestField("Transfer Effective Date");
        EmpHrTransfer.TestField("Functional Title (To)");
        EmpHrTransfer.TestField("Deputation On (To)");
        EmpHrTransfer.TestField(Description);
        EmpHrTransfer.TestField("Transfer Type");
        EmpHrTransfer.TestField("Reason for Resignation");
        EmpHrTransfer.TestField("Notify to"); //Min
        if EmpHrTransfer."Transfer Category" in [EmpHrTransfer."Transfer Category"::"Temporary", EmpHrTransfer."Transfer Category"::Officiating] then begin
            EmpHrTransfer.TestField("Start Date");
            EmpHrTransfer.TestField("End Date");
        end;
        Employee.Get(HRMgt.GetEmployeeNo);
        case EmpHrTransfer."Deputation On (To)" of
            EmpHrTransfer."Deputation On (To)"::Branch:
                EmpHrTransfer.TestField("Shortcut Dimension 1 Code (To)");
            EmpHrTransfer."Deputation On (To)"::Department:
                EmpHrTransfer.TestField("Department Code (To)");
            EmpHrTransfer."Deputation On (To)"::"Extension Counter":
                EmpHrTransfer.TestField("Extension Counter (To)");
            EmpHrTransfer."Deputation On (To)"::Province:
                EmpHrTransfer.TestField("Province Code (To)");
            EmpHrTransfer."Deputation On (To)"::"Sub Province":
                EmpHrTransfer.TestField("Sub Province Code (To)");
            EmpHrTransfer."Deputation On (To)"::Unit:
                EmpHrTransfer.TestField("Unit (To)");
        end;
        if not Employee.Screener then
            Error('You are not eligible to screen this document');
        if EmpHrTransfer.Type = EmpHrTransfer.Type::"Employee Transfer" then
            EmpHrTransfer.TestField("Approval Status", EmpHrTransfer."Approval Status"::Reviewed)
        else if EmpHrTransfer.Type = EmpHrTransfer.Type::"HR Transfer" then
            EmpHrTransfer.TestField("Approval Status", EmpHrTransfer."Approval Status"::Open);
        EmpHrTransfer.Validate("Approval Status", EmpHrTransfer."Approval Status"::Screened);
        EmpHrTransfer.Modify;
        Message('Document has been screened');
    end;

    procedure ScreenTransferAPI(var EmpHrTransfer: Record "Employee/HR Transfer"; employeeNo: Code[20])
    var
        ConfirmApprove: Label 'Confirm Approve?';
        ConfirmReject: Label 'Confirm Reject?';
    begin
        EmpHrTransfer.TestField("Transfer Category");
        EmpHrTransfer.TestField("Transfer Effective Date");
        EmpHrTransfer.TestField("Functional Title (To)");
        EmpHrTransfer.TestField("Deputation On (To)");
        EmpHrTransfer.TestField(Description);
        EmpHrTransfer.TestField("Transfer Type");
        EmpHrTransfer.TestField("Reason for Resignation");
        EmpHrTransfer.TestField("Notify to"); //Min
        if EmpHrTransfer."Transfer Category" in [EmpHrTransfer."Transfer Category"::"Temporary", EmpHrTransfer."Transfer Category"::Officiating] then begin
            EmpHrTransfer.TestField("Start Date");
            EmpHrTransfer.TestField("End Date");
        end;
        Employee.Get(employeeNo);
        case EmpHrTransfer."Deputation On (To)" of
            EmpHrTransfer."Deputation On (To)"::Branch:
                EmpHrTransfer.TestField("Shortcut Dimension 1 Code (To)");
            EmpHrTransfer."Deputation On (To)"::Department:
                EmpHrTransfer.TestField("Department Code (To)");
            EmpHrTransfer."Deputation On (To)"::"Extension Counter":
                EmpHrTransfer.TestField("Extension Counter (To)");
            EmpHrTransfer."Deputation On (To)"::Province:
                EmpHrTransfer.TestField("Province Code (To)");
            EmpHrTransfer."Deputation On (To)"::"Sub Province":
                EmpHrTransfer.TestField("Sub Province Code (To)");
            EmpHrTransfer."Deputation On (To)"::Unit:
                EmpHrTransfer.TestField("Unit (To)");
        end;
        if not Employee.Screener then
            Error('You are not eligible to screen this document');
        if EmpHrTransfer.Type = EmpHrTransfer.Type::"Employee Transfer" then
            EmpHrTransfer.TestField("Approval Status", EmpHrTransfer."Approval Status"::Reviewed)
        else if EmpHrTransfer.Type = EmpHrTransfer.Type::"HR Transfer" then
            EmpHrTransfer.TestField("Approval Status", EmpHrTransfer."Approval Status"::Open);
        EmpHrTransfer.Validate("Approval Status", EmpHrTransfer."Approval Status"::Screened);
        EmpHrTransfer.Modify;
        Message('Document has been screened');
    end;

    procedure ApproveTransfer(var EmpHrTransfer: Record "Employee/HR Transfer")
    var
        ConfirmApprove: Label 'Confirm Approve?';
        ConfirmReject: Label 'Confirm Reject?';
        ServiceHistoryCode: Code[20];
        ServiceHistory: Record "Employee Service History";
        PreviousServiceHistory: Record "Employee Service History";
    begin
        if EmpHrTransfer."Approver Code" <> HRMgt.GetEmployeeNo then
            Error('You are not eligible to approved this document');
        if Today > EmpHrTransfer."Transfer Effective Date" then //Min 8.7.2022 + 1
            Error(TransferError, EmpHrTransfer."Transfer Effective Date", Today);
        EmpHrTransfer.TestField("Approval Status", EmpHrTransfer."Approval Status"::Screened);
        EmpHrTransfer.Validate("Approval Status", EmpHrTransfer."Approval Status"::Approved);
        EmpHrTransfer.Validate("Approved Date", Today);
        /*IF "Transfer Category" = "Transfer Category"::"Temporary" THEN //Min 1.4 >>
          ServiceHistoryCode := AddToServiceHistory(EmpAct."Employee No.",ServiceHistory."Service Event"::"Temporary Deputation",EmpAct.Remarks,"Transfer Effective Date");
        IF "Transfer Category" = "Transfer Category"::Officiating THEN
          ServiceHistoryCode := AddToServiceHistory(EmpAct."Employee No.",ServiceHistory."Service Event"::"Officiating Arrangement",EmpAct.Remarks,"Transfer Effective Date");
        IF "Transfer Category" = "Transfer Category"::General THEN
          ServiceHistoryCode := AddToServiceHistory(EmpAct."Employee No.",ServiceHistory."Service Event"::Transfer,EmpAct.Remarks,"Transfer Effective Date");*/
        EmpHrTransfer.Modify;
        /*ValidateTransferField(EmpAct); //Min 1.4 >>
      IF ServiceHistory.GET(ServiceHistoryCode) THEN BEGIN //Min 1.4 >>
        ServiceHistory.VALIDATE("Functional Title (To)","Functional Title (To)");
        ServiceHistory.VALIDATE("Salary Level (To)",Employee."Salary Level");
        ServiceHistory.VALIDATE("Deputation On (To)","Deputation On (To)");
        ServiceHistory.VALIDATE("Deputation Code (To)",ExitTransferDeputationWiseCode(ServiceHistory."Deputation On (To)",ServiceHistory."Employee No."));
        ServiceHistory.VALIDATE("Deputation Value (To)",ExitTransferDeputationWiseValue(ServiceHistory."Deputation On (To)",ServiceHistory."Employee No."));
        ServiceHistory.VALIDATE("Document No.","No.");
          PreviousServiceHistory.RESET;
          PreviousServiceHistory.SETRANGE("Employee No.",ServiceHistory."Employee No.");
          PreviousServiceHistory.SETFILTER("Service History Code",'<>%1',ServiceHistoryCode);
          PreviousServiceHistory.SETCURRENTKEY("Effective Date");
          IF (PreviousServiceHistory.FINDLAST) THEN
            IF (ServiceHistory."Deputation Code (From)" = ServiceHistory."Deputation Code (To)") OR
              ("Transfer Category" IN ["Transfer Category"::Officiating,"Transfer Category"::"Temporary"]) THEN
            ServiceHistory."Outstation Eligible" := PreviousServiceHistory."Outstation Eligible";
        ServiceHistory.MODIFY;
      END;*/
        HRMgt.SendMailFromTemplate(DATABASE::"Employee Activity", EmpHrTransfer.Type::"Employee Transfer", EmpHrTransfer."Approval Status"::Approved, EmpHrTransfer.Remarks, '', EmpHrTransfer."No.", 0);
        //UpdatePortalTransferEffDate("Transfer Effective Date","Employee No."); //Min 4.27.2022
        if EmpHrTransfer."Transfer Effective Date" <= Today then begin //Min -- For Disable Punchin
            if EmployeeRec.Get(EmpHrTransfer."Employee No.") then begin
                EmployeeRec."Disable Punch in" := true;
                EmployeeRec.Modify;
            end;
        end;
        Message('Document has been approved.');

    end;

    procedure ApproveTransferAPI(var EmpHrTransfer: Record "Employee/HR Transfer"; employeeNo: Code[20])
    var
        ConfirmApprove: Label 'Confirm Approve?';
        ConfirmReject: Label 'Confirm Reject?';
        ServiceHistoryCode: Code[20];
        ServiceHistory: Record "Employee Service History";
        PreviousServiceHistory: Record "Employee Service History";
    begin
        if EmpHrTransfer."Approver Code" <> employeeNo then
            Error('You are not eligible to approved this document');
        if Today > EmpHrTransfer."Transfer Effective Date" then //Min 8.7.2022 + 1
            Error(TransferError, EmpHrTransfer."Transfer Effective Date", Today);
        EmpHrTransfer.TestField("Approval Status", EmpHrTransfer."Approval Status"::Screened);
        EmpHrTransfer.Validate("Approval Status", EmpHrTransfer."Approval Status"::Approved);
        EmpHrTransfer.Validate("Approved Date", Today);
        /*IF "Transfer Category" = "Transfer Category"::"Temporary" THEN //Min 1.4 >>
          ServiceHistoryCode := AddToServiceHistory(EmpAct."Employee No.",ServiceHistory."Service Event"::"Temporary Deputation",EmpAct.Remarks,"Transfer Effective Date");
        IF "Transfer Category" = "Transfer Category"::Officiating THEN
          ServiceHistoryCode := AddToServiceHistory(EmpAct."Employee No.",ServiceHistory."Service Event"::"Officiating Arrangement",EmpAct.Remarks,"Transfer Effective Date");
        IF "Transfer Category" = "Transfer Category"::General THEN
          ServiceHistoryCode := AddToServiceHistory(EmpAct."Employee No.",ServiceHistory."Service Event"::Transfer,EmpAct.Remarks,"Transfer Effective Date");*/
        EmpHrTransfer.Modify;
        /*ValidateTransferField(EmpAct); //Min 1.4 >>
      IF ServiceHistory.GET(ServiceHistoryCode) THEN BEGIN //Min 1.4 >>
        ServiceHistory.VALIDATE("Functional Title (To)","Functional Title (To)");
        ServiceHistory.VALIDATE("Salary Level (To)",Employee."Salary Level");
        ServiceHistory.VALIDATE("Deputation On (To)","Deputation On (To)");
        ServiceHistory.VALIDATE("Deputation Code (To)",ExitTransferDeputationWiseCode(ServiceHistory."Deputation On (To)",ServiceHistory."Employee No."));
        ServiceHistory.VALIDATE("Deputation Value (To)",ExitTransferDeputationWiseValue(ServiceHistory."Deputation On (To)",ServiceHistory."Employee No."));
        ServiceHistory.VALIDATE("Document No.","No.");
          PreviousServiceHistory.RESET;
          PreviousServiceHistory.SETRANGE("Employee No.",ServiceHistory."Employee No.");
          PreviousServiceHistory.SETFILTER("Service History Code",'<>%1',ServiceHistoryCode);
          PreviousServiceHistory.SETCURRENTKEY("Effective Date");
          IF (PreviousServiceHistory.FINDLAST) THEN
            IF (ServiceHistory."Deputation Code (From)" = ServiceHistory."Deputation Code (To)") OR
              ("Transfer Category" IN ["Transfer Category"::Officiating,"Transfer Category"::"Temporary"]) THEN
            ServiceHistory."Outstation Eligible" := PreviousServiceHistory."Outstation Eligible";
        ServiceHistory.MODIFY;
      END;*/
        HRMgt.SendMailFromTemplate(DATABASE::"Employee/HR Transfer", EmpHrTransfer.Type::"Employee Transfer", EmpHrTransfer."Approval Status"::Approved, EmpHrTransfer.Remarks, '', EmpHrTransfer."No.", 0);
        //UpdatePortalTransferEffDate("Transfer Effective Date","Employee No."); //Min 4.27.2022
        if EmpHrTransfer."Transfer Effective Date" <= Today then begin //Min -- For Disable Punchin
            if EmployeeRec.Get(EmpHrTransfer."Employee No.") then begin
                EmployeeRec."Disable Punch in" := true;
                EmployeeRec.Modify;
            end;
        end;
        Message('Document has been approved.');

    end;

    procedure HoldTransfer(var EmpHrTransfer: Record "Employee/HR Transfer")
    var
        ConfirmApprove: Label 'Confirm Approve?';
        ConfirmReject: Label 'Confirm Reject?';
        TransferPageBuilder: FilterPageBuilder;
        EmpHrTrsfer: Record "Employee/HR Transfer";
        GetDate: Date;
        EmpServiceActivityRec: Record "Employee Service History";
    begin
        Employee.Get(HRMgt.GetEmployeeNo);
        if not Employee.Screener then
            Error('You are not eligible to put this document on hold');
        EmpHrTrsfer.TestField("Approval Status", EmpHrTrsfer."Approval Status"::Approved);

        TransferPageBuilder.AddRecord('Transfer Document', EmpHrTrsfer);
        TransferPageBuilder.ADdField('Transfer Document', EmpHrTrsfer."On Hold Date");
        TransferPageBuilder.ADdField('Transfer Document', EmpHrTrsfer."Reason For Hold");
        if TransferPageBuilder.RunModal then begin
            EmpHrTrsfer.SetView(TransferPageBuilder.GetView('Transfer Document'));
            //IF EmpActivity.FINDFIRST THEN;
            Evaluate(GetDate, EmpHrTrsfer.GetFilter("On Hold Date"));
            if GetDate = 0D then
                Error('Please enter on hold date.');
            if EmpHrTrsfer.GetFilter("Reason For Hold") = '' then
                Error('Please enter reason.');
            EmpHrTrsfer.Validate("On Hold Date", GetDate);
            EmpHrTrsfer.Validate("Transfer Effective Date", GetDate);
            EmpHrTrsfer.Validate("Reason For Hold", EmpHrTrsfer.GetFilter("Reason For Hold"));
            EmpHrTrsfer.Validate("Approval Status", EmpHrTrsfer."Approval Status"::"On Hold");
            EmpHrTrsfer.Modify;
            HRMgt.SendMailFromTemplate(DATABASE::"Employee Activity", EmpHrTrsfer.Type::"Employee Transfer", EmpHrTrsfer."Approval Status"::"On Hold", EmpHrTrsfer.Remarks, '', EmpHrTrsfer."No.", 0);
            HRMgt.ReinstateCancelTransfer(EmpHrTrsfer); //Min -- Reinstate while Hold transfer
            EmpServiceActivityRec.Reset; //Min 3.13.2022 -- For Remove Transfer Hold Doc. line
            EmpServiceActivityRec.SetRange("Document No.", EmpHrTrsfer."No.");
            if EmpServiceActivityRec.FindFirst then
                EmpServiceActivityRec.Delete;
            if EmployeeRec.Get(EmpHrTrsfer."Employee No.") then begin //Min -- For Enable Punchin
                EmployeeRec."Disable Punch in" := false;
                EmployeeRec.Modify;
            end;
            Message('Document has been put on hold.');
        end;
    end;

    procedure CancelTransfer(var EmphrTransfer: Record "Employee/HR Transfer")
    var
        ConfirmApprove: Label 'Confirm Approve?';
        ConfirmReject: Label 'Confirm Reject?';
        TransferPageBuilder: FilterPageBuilder;
        EmpHrTrnsferVar: Record "Employee/HR Transfer";
        GetDate: Date;
        EmpServiceActivity: Record "Employee Service History";
    begin
        Employee.Get(HRMgt.GetEmployeeNo);
        if not Employee.Screener then
            Error('You are not eligible to cancel this document.');
        EmpHrTrnsferVar.TestField("Approval Status", EmpHrTrnsferVar."Approval Status"::Approved);
        TransferPageBuilder.AddRecord('Transfer Document', EmpHrTrnsferVar);
        TransferPageBuilder.ADdField('Transfer Document', EmpHrTrnsferVar."Cancelled Date");
        TransferPageBuilder.ADdField('Transfer Document', EmpHrTrnsferVar."Reason For Cancel");
        if TransferPageBuilder.RunModal then begin
            EmpHrTrnsferVar.SetView(TransferPageBuilder.GetView('Transfer Document'));

            Evaluate(GetDate, EmpHrTrnsferVar.GetFilter("Cancelled Date"));
            if GetDate = 0D then
                Error('Please enter on cancel date.');
            if EmpHrTrnsferVar.GetFilter("Reason For Cancel") = '' then
                Error('Please enter reason.');
            EmpHrTrnsferVar.Validate("Cancelled Date", GetDate);
            EmpHrTrnsferVar.Validate("Reason For Cancel", EmpHrTrnsferVar.GetFilter("Reason For Cancel"));
            EmpHrTrnsferVar.Validate("Approval Status", EmpHrTrnsferVar."Approval Status"::Cancelled);
            EmpHrTrnsferVar.Modify;
            HRMgt.SendMailFromTemplate(DATABASE::"Employee Activity", EmpHrTrnsferVar.Type::"Employee Transfer", EmpHrTrnsferVar."Approval Status"::Cancelled, EmpHrTrnsferVar.Remarks, '', EmpHrTrnsferVar."No.", 0);
            HRMgt.ReinstateCancelTransfer(EmpHrTrnsferVar); //Min -- Reinstate while cancel transfer
            EmpServiceActivity.Reset; //Min 3.13.2022 -- For Remove cancel Doc. line
            EmpServiceActivity.SetRange("Document No.", EmpHrTrnsferVar."No.");
            if EmpServiceActivity.FindFirst then
                EmpServiceActivity.Delete;
            EmpServiceActivity.Reset;//Min 3.13.2022 -- For Update Last Placement Date in Employee Table.
            EmpServiceActivity.SetCurrentKey("Effective Date");
            EmpServiceActivity.SetRange("Employee No.", EmpHrTrnsferVar."Employee No.");
            EmpServiceActivity.SetRange("Service Event", EmpServiceActivity."Service Event"::Transfer);
            if EmpServiceActivity.FindLast then begin
                if EmployeeRec.Get(EmpHrTrnsferVar."Employee No.") then begin
                    EmployeeRec."Last Placement Date" := EmpServiceActivity."Effective Date";
                    EmployeeRec.Modify;
                end;
            end;
            if EmployeeRec.Get(EmpHrTrnsferVar."Employee No.") then begin //Min -- For Enable Punchin
                EmployeeRec."Disable Punch in" := false;
                EmployeeRec.Modify;
            end;
            Message('Document has been Cancelled.');
        end;
    end;

    procedure RejectTransfer(var EmpHrTransfer: Record "Employee/HR Transfer")
    var
        ConfirmApprove: Label 'Confirm Approve?';
        ConfirmReject: Label 'Confirm Reject?';
    begin
        EmpHrTransfer.TestField("Rejection Remarks");
        case EmpHrTransfer."Approval Status" of
            EmpHrTransfer."Approval Status"::"Pending Approval":
                begin
                    if StrPos(EmpHrTransfer."Recommender Code", HRMgt.GetEmployeeNo) = 0 then
                        Error('You are not eligible to reject this document');
                end;

            EmpHrTransfer."Approval Status"::Recommended:
                begin
                    if EmpHrTransfer.Reviewer <> HRMgt.GetEmployeeNo then
                        Error('You are not eligible to reject this document.');
                end;

            EmpHrTransfer."Approval Status"::Reviewed, EmpHrTransfer."Approval Status"::"On Hold":
                begin
                    Employee.Get(HRMgt.GetEmployeeNo);
                    if not Employee.Screener then
                        Error('You are not eligible to reject this document.');
                end;

            EmpHrTransfer."Approval Status"::Screened:
                begin
                    if EmpHrTransfer."Approver Code" <> HRMgt.GetEmployeeNo then
                        Error('You are eligible to reject this document.');
                end;
        end;
        EmpHrTransfer.Validate("Approval Status", EmpHrTransfer."Approval Status"::Rejected);
        EmpHrTransfer.Modify;
        if EmployeeRec.Get(EmpHrTransfer."Employee No.") then begin //Min -- For Enable Punchin
            EmployeeRec."Disable Punch in" := false;
            EmployeeRec.Modify;
        end;
        Message('Document has been rejected.');

    end;

    procedure RejectTransferAPI(var EmpHrTransfer: Record "Employee/HR Transfer"; employeeNo: Code[20])
    var
        ConfirmApprove: Label 'Confirm Approve?';
        ConfirmReject: Label 'Confirm Reject?';
    begin
        EmpHrTransfer.TestField("Rejection Remarks");
        case EmpHrTransfer."Approval Status" of
            EmpHrTransfer."Approval Status"::"Pending Approval":
                begin
                    if StrPos(EmpHrTransfer."Recommender Code", employeeNo) = 0 then
                        Error('You are not eligible to reject this document');
                end;

            EmpHrTransfer."Approval Status"::Recommended:
                begin
                    if EmpHrTransfer.Reviewer <> employeeNo then
                        Error('You are not eligible to reject this document.');
                end;

            EmpHrTransfer."Approval Status"::Reviewed, EmpHrTransfer."Approval Status"::"On Hold":
                begin
                    Employee.Get(employeeNo);
                    if not Employee.Screener then
                        Error('You are not eligible to reject this document.');
                end;

            EmpHrTransfer."Approval Status"::Screened:
                begin
                    if EmpHrTransfer."Approver Code" <> employeeNo then
                        Error('You are eligible to reject this document.');
                end;
        end;
        EmpHrTransfer.Validate("Approval Status", EmpHrTransfer."Approval Status"::Rejected);
        EmpHrTransfer.Modify;
        if EmployeeRec.Get(EmpHrTransfer."Employee No.") then begin //Min -- For Enable Punchin
            EmployeeRec."Disable Punch in" := false;
            EmployeeRec.Modify;
        end;
        Message('Document has been rejected.');

    end;

    procedure RequestTransferAllowanceClaim(var EmpHrTransfer: Record "Employee/HR Transfer")
    var
        BMandOutStationError: Label 'You cannot apply for both BM Accomodation Allowance and Outstation/Discomfort Allowance.';
        UnauthorizedApprover: Label 'You are not authorized to approve.';
    begin

        EmpHrTransfer.TestField("Approval Status", EmpHrTransfer."Approval Status"::Acknowledged);
        if (EmpHrTransfer."Outstation/Discomfort Allow." <> 0) and (EmpHrTransfer."BM Accomodation Allow." <> 0) then
            Error(BMandOutStationError);

        //IF GetEmployeeNo <> "Transfer Claim Recommender" THEN
        //ERROR(UnauthorizedApprover);
        if EmpHrTransfer."Transfer Claim Recommender" = '' then
            EmpHrTransfer.Validate("Transfer Allowance Approval", EmpHrTransfer."Transfer Allowance Approval"::Recommended)
        else
            EmpHrTransfer.Validate("Transfer Allowance Approval", EmpHrTransfer."Transfer Allowance Approval"::"Pending Approval");
        EmpHrTransfer.Modify(true);
    end;

    local procedure CheckTransferClaimApproval(EmpHrTransfer: Record "Employee/HR Transfer")
    var
        ApproveNotEligibleError: Label 'You are not Eligible to approve or reject this document ';
        RecommendNotEligibleError: Label 'You are not Eligible to recommend or reject this document ';
        AcknowledgeError: Label 'You are not Eligible to acknowledge this document.';
    begin
        Employee.Reset;
        Employee.SetRange("NAV Login ID", UserId);
        Employee.FindFirst;
        if EmpHrTransfer."Transfer Allowance Approval" = EmpHrTransfer."Transfer Allowance Approval"::"Pending Approval" then
            if StrPos(EmpHrTransfer."Transfer Claim Recommender", Employee."No.") = 0 then
                Error(RecommendNotEligibleError);
        if EmpHrTransfer."Transfer Allowance Approval" = EmpHrTransfer."Transfer Allowance Approval"::Recommended then
            if StrPos(EmpHrTransfer."Transfer Claim Reviewer", Employee."No.") = 0 then
                Error(ApproveNotEligibleError);
        if EmpHrTransfer."Transfer Allowance Approval" = EmpHrTransfer."Transfer Allowance Approval"::Reviewed then
            if not Employee.Screener then
                Error(ApproveNotEligibleError);
    end;

    procedure ApproveRejectTransferClaim(Approve: Boolean; var EmpHrTransfer: Record "Employee/HR Transfer"; remarksText: Text)
    var
        ServiceHistory: Record "Employee Service History";
        ReasonCode: Record "Reason Code";
    begin
        CheckTransferClaimApproval(EmpHrTransfer);
        //CheckEmployeeActivityApproval(EmpAct);
        if EmpHrTransfer."Transfer Allowance Approval" = EmpHrTransfer."Transfer Allowance Approval"::"Pending Approval" then begin
            if ReasonCode.Get(EmpHrTransfer."No.") then begin
                ReasonCode.Validate("Transf. Claim Recomm. Remarks", remarksText);
                ReasonCode.Modify;
            end else begin
                ReasonCode.Init;
                ReasonCode.Validate("Transf. Claim Recomm. Remarks", remarksText);
                ReasonCode.Validate(Code, EmpHrTransfer."No.");
                ReasonCode.Insert;
            end;
        end else if EmpHrTransfer."Transfer Allowance Approval" = EmpHrTransfer."Transfer Allowance Approval"::Recommended then begin
            if ReasonCode.Get(EmpHrTransfer."No.") then begin
                ReasonCode.Validate("Transf. Claim Reviewer Remarks", remarksText);
                ReasonCode.Modify;
            end else begin
                ReasonCode.Init;
                ReasonCode.Validate("Transf. Claim Reviewer Remarks", remarksText);
                ReasonCode.Validate(Code, EmpHrTransfer."No.");
                ReasonCode.Insert;
            end;
        end else if EmpHrTransfer."Transfer Allowance Approval" = EmpHrTransfer."Transfer Allowance Approval"::Reviewed then begin
            if ReasonCode.Get(EmpHrTransfer."No.") then begin
                ReasonCode.Validate("Transf. Claim Apporver Remarks", remarksText);
                ReasonCode.Modify;
            end else begin
                ReasonCode.Init;
                ReasonCode.Validate("Transf. Claim Apporver Remarks", remarksText);
                ReasonCode.Validate(Code, EmpHrTransfer."No.");
                ReasonCode.Insert;
            end;
        end;

        if Approve then begin
            if EmpHrTransfer."Transfer Allowance Approval" = EmpHrTransfer."Transfer Allowance Approval"::"Pending Approval" then
                EmpHrTransfer.Validate("Transfer Allowance Approval", EmpHrTransfer."Transfer Allowance Approval"::Recommended)
            else if EmpHrTransfer."Transfer Allowance Approval" = EmpHrTransfer."Transfer Allowance Approval"::Recommended then
                EmpHrTransfer.Validate("Transfer Allowance Approval", EmpHrTransfer."Transfer Allowance Approval"::Reviewed)

            else if EmpHrTransfer."Transfer Allowance Approval" = EmpHrTransfer."Transfer Allowance Approval"::Reviewed then begin
                EmpHrTransfer.Validate("Transfer Allowance Approval", EmpHrTransfer."Transfer Allowance Approval"::Approved);
                ServiceHistory.Reset;
                ServiceHistory.SetRange("Document No.", EmpHrTransfer."No.");
                if ServiceHistory.FindFirst then begin
                    if EmpHrTransfer."Outstation/Discomfort Allow." <> 0 then
                        ServiceHistory."Outstation Eligible" := true;
                    ServiceHistory.Modify;
                end;
            end;
        end
        else begin
            EmpHrTransfer.Validate("Transfer Allowance Approval", EmpHrTransfer."Transfer Allowance Approval"::Open);
        end;

        EmpHrTransfer.Modify;
    end;

    procedure ReturnTransfer(EmpHrTransfer: Record "Employee/HR Transfer")
    begin

        if EmpHrTransfer.Type in [EmpHrTransfer.Type::"HR Transfer", EmpHrTransfer.Type::"Employee Transfer"] then
            Error('It is not transfer document.');
        EmpHrTransfer.TestField("Approval Status", EmpHrTransfer."Approval Status"::Screened);
        Employee.Get(HRMgt.GetEmployeeNo);
        if not Employee.Screener then
            Error('You are not authorized to return this document.');
        EmpHrTransfer."Approval Status" := EmpHrTransfer."Approval Status"::Open;
        EmpHrTransfer.Modify;
        Message('Document Returned.');
    end;

    procedure CalculateAllowance(var EmpTransfer: Record "Employee/HR Transfer")
    var
        Employee: Record Employee;
        TotalDays: Integer;
        GrossSalary: Decimal;
        SalaryLevel1: Record "Salary Level";
        RemoteArea: Record "Remote Area Category";
        DimensionValue: Record "Dimension Value";
        SalaryLevel: Record "Salary Level";
        SalaryGrade: Record "Salary Grade";
    begin
        EmpTransfer.TestField("Transfer Effective Date");

        TotalDays := CalcDate('CM', EmpTransfer."Transfer Effective Date") - EmpTransfer."Transfer Effective Date";

        EmpTransfer."Relocation Allow." := 0;
        EmpTransfer."Outstation/Discomfort Allow." := 0;
        EmpTransfer."BM Accomodation Allow." := 0;
        EmpTransfer."Remote Area Allow." := 0;
        EmpTransfer."Officiating Allow." := 0;
        //"transfer claim approver" := '';

        //  GetTransferClaimApprover(EmpAct);

        CalculateRelocationAllowance(EmpTransfer);

        CalculateOutstationAllowance(EmpTransfer);

        CalculateBMAccomodationAllowance(EmpTransfer);

        CalculateOfficiatingAllowance(EmpTransfer);

        CalculateRemoteAreaAllowance(EmpTransfer);

        EmpTransfer.Modify;
    end;

    local procedure CalculateRelocationAllowance(var EmpTransfer: Record "Employee/HR Transfer")
    var
        DimensionValueCurrent: Record "Dimension Value";
        LevelWiseAttribute: Record "Level Wise Attributes";
    begin

        HRSetup.Get;
        HRSetup.TestField("Relocation Dist. Criteria (H)");
        HRSetup.TestField("Relocation Dist. Criteria (T)");
        Employee.Get(EmpTransfer."Employee No.");
        LevelWiseAttribute.Get(Employee."Salary Grade", Employee."Salary Level");
        if EmpTransfer."Relocation Distance" = 0 then begin
            EmpTransfer."Relocation Allow." := 0;
            exit;
        end;
        if Employee."Inside/Outisde Valley" = Employee."Inside/Outisde Valley"::Outside then begin

            if Employee."Posting Region" = Employee."Posting Region"::Hilly then begin
                if EmpTransfer."Relocation Distance" >= HRSetup."Relocation Dist. Criteria (H)" then
                    EmpTransfer."Relocation Allow." := LevelWiseAttribute."Total Basic Salary";
            end else if Employee."Posting Region" = Employee."Posting Region"::Terai then begin
                if EmpTransfer."Relocation Distance" >= HRSetup."Relocation Dist. Criteria (T)" then
                    EmpTransfer."Relocation Allow." := LevelWiseAttribute."Total Basic Salary";
            end;
        end;
    end;

    local procedure CalculateOutstationAllowance(var EmpTransfer: Record "Employee/HR Transfer")
    var
        DimensionValueCurrent: Record "Dimension Value";
        LevelWiseAttribute: Record "Level Wise Attributes";
    begin
        if EmpTransfer."Outstation Distance" = 0 then begin
            EmpTransfer."Outstation/Discomfort Allow." := 0;
            exit;
        end;
        Employee.Get(EmpTransfer."Employee No.");
        if Employee."Employment Type" = Employee."Employment Type"::Contract then
            exit;


        HRSetup.Get;
        HRSetup.TestField("Outstation Dist. Criteria (H)");
        HRSetup.TestField("Outstation Dist. Criteria (T)");
        LevelWiseAttribute.Get(Employee."Salary Grade", Employee."Salary Level");

        // TESTFIELD("Outstation Distance");
        if Employee."Posting Region" = Employee."Posting Region"::Hilly then begin
            if EmpTransfer."Outstation Distance" >= HRSetup."Outstation Dist. Criteria (H)" then
                EmpTransfer."Outstation/Discomfort Allow." := LevelWiseAttribute."Total Basic Salary" * 25 / 100;
        end else if Employee."Posting Region" = Employee."Posting Region"::Terai then begin
            if EmpTransfer."Outstation Distance" >= HRSetup."Outstation Dist. Criteria (T)" then
                EmpTransfer."Outstation/Discomfort Allow." := LevelWiseAttribute."Total Basic Salary" * 25 / 100;
        end;
    end;

    local procedure CalculateBMAccomodationAllowance(var EmpTransfer: Record "Employee/HR Transfer")
    var
        DimensionValueCurrent: Record "Dimension Value";
        RemoteArea: Record "Remote Area Category";
        PGSetup: Record "Payroll General Setup";
    begin
        if EmpTransfer."BMAF Distance" = 0 then begin
            EmpTransfer."BM Accomodation Allow." := 0;
            exit;
        end;
        PGSetup.Get;
        PGSetup.TestField("BM Functional Title");
        if EmpTransfer."Functional Title (To)" <> PGSetup."BM Functional Title" then
            exit;
        if DimensionValueCurrent.Get('BRANCH', EmpTransfer."Shortcut Dimension 1 Code") then
            if not DimensionValue.Get('BRANCH', EmpTransfer."Shortcut Dimension 1 Code (To)") then
                exit;
        if DimensionValueCurrent."Inside/Outisde Valley" = DimensionValueCurrent."Inside/Outisde Valley"::Inside then
            if DimensionValue."Inside/Outisde Valley" = DimensionValue."Inside/Outisde Valley"::Inside then
                exit;

        HRSetup.Get;
        HRSetup.TestField("BMAF Dist. Criteria (H)");
        HRSetup.TestField("BMAF Dist. Criteria (T)");
        if RemoteArea.Get(DimensionValue."Remote Area Category") then begin
            if DimensionValue."Inside/Outisde Valley" = DimensionValue."Inside/Outisde Valley"::Outside then begin
                //  TESTFIELD("BMAF Distance");
                if DimensionValue."Posting Region" = DimensionValue."Posting Region"::Hilly then begin
                    if EmpTransfer."BMAF Distance" >= HRSetup."BMAF Dist. Criteria (H)" then
                        EmpTransfer."BM Accomodation Allow." := RemoteArea."BM Accomodation Amount";
                end else if DimensionValue."Posting Region" = DimensionValue."Posting Region"::Terai then begin
                    if EmpTransfer."BMAF Distance" >= HRSetup."BMAF Dist. Criteria (T)" then
                        EmpTransfer."BM Accomodation Allow." := RemoteArea."BM Accomodation Amount";
                end;
            end;
        end;
    end;

    local procedure CalculateOfficiatingAllowance(var EmpTransfer: Record "Employee/HR Transfer")
    var
        DimensionValueCurrent: Record "Dimension Value";
        SalaryLevel1: Record "Salary Level";
        GrossSalary: Decimal;
        SalaryLevel: Record "Salary Level";
        SalaryGrade: Record "Salary Grade";
    begin
        Employee.Get(EmpTransfer."Employee No.");
        if Employee."Employment Type" = Employee."Employment Type"::Contract then
            exit;
        if EmpTransfer."Transfer Type" <> EmpTransfer."Transfer Type"::"Intra Provincial" then
            exit;
        Employee.Get(EmpTransfer."Employee No.");
        SalaryLevel.Get(Employee."Salary Level");

        SalaryLevel1.Reset;
        SalaryLevel1.SetCurrentKey(Rank);
        SalaryLevel1.SetFilter(Rank, '>%1', SalaryLevel.Rank);
        if SalaryLevel1.FindFirst then begin
            SalaryGrade.Get(0);
            GrossSalary := SalaryLevel1."Basic Salary" +
                            SalaryLevel1.Allowance + SalaryGrade."Grade Percentage" / 100 * SalaryLevel1."Basic Salary";
            EmpTransfer."Officiating Allow." := GrossSalary;
        end;
    end;

    local procedure CalculateRemoteAreaAllowance(var EmpTransfer: Record "Employee/HR Transfer")
    var
        DimensionValueCurrent: Record "Dimension Value";
        SalaryLevel1: Record "Salary Level";
        GrossSalary: Decimal;
        SalaryLevel: Record "Salary Level";
        SalaryGrade: Record "Salary Grade";
        RemoteArea: Record "Remote Area Category";
    begin
        if DimensionValue.Get('BRANCH', EmpTransfer."Shortcut Dimension 1 Code (To)") then begin
            if RemoteArea.Get(DimensionValue."Remote Area Category") then begin
                Employee.Get(EmpTransfer."Employee No.");
                SalaryLevel.Get(Employee."Salary Level");
                SalaryGrade.Get(Employee."Salary Grade");
                GrossSalary := SalaryLevel."Basic Salary" +
                                  SalaryLevel.Allowance + SalaryGrade."Grade Percentage" / 100 * SalaryLevel."Basic Salary";
                EmpTransfer."Remote Area Allow." := RemoteArea."Remote allowance Percentage" / 100 * GrossSalary;
                if RemoteArea."Remote Allowance Amount" < EmpTransfer."Remote Area Allow." then
                    EmpTransfer."Remote Area Allow." := RemoteArea."Remote Allowance Amount";

            end;
        end;
    end;

    procedure AcknowledgeTransfer(var EmpHrTransfer: Record "Employee/HR Transfer")
    var
        ConfirmAcknowledge: Label 'Do you want to acknowledge this transfer?';
        Acknowledged: Label 'Acknowledged.';
        IncomingDoc: Record "Incoming Document";
        AttachmentSetup: Record "Attachment Setup";
        Province: Record Province;
        GLSetup: Record "General Ledger Setup";
        FunctionalTitle: Record "Functional Title";
        SubProv: Record "Sub Province";
        EmpHie: Record "Employee Hierarchy Master";
        Depart: Record Department;
        ServiceHistoryCode: Code[20];
        ServiceHistory: Record "Employee Service History";
        PreviousServiceHistory: Record "Employee Service History";
    begin
        if not (EmpHrTransfer."Approval Status" in [EmpHrTransfer."Approval Status"::Approved, EmpHrTransfer."Approval Status"::"On Hold"]) then
            Error('Approval Status must be approved or on hold');
        EmpHrTransfer.TestField("Date of Joining Of Transfer");
        EmpHrTransfer.TestField("Transfer Remarks");
        EmpHrTransfer.Validate("Acknowledged Date", Today);
        /*IF "Transfer Category" = "Transfer Category"::"Temporary" THEN //Min 1.1 >>
            ServiceHistoryCode := AddToServiceHistory(EmpAct."Employee No.",ServiceHistory."Service Event"::"Temporary Deputation",EmpAct.Remarks,"Date of Joining Of Transfer");
        IF "Transfer Category" = "Transfer Category"::Officiating THEN
          ServiceHistoryCode := AddToServiceHistory(EmpAct."Employee No.",ServiceHistory."Service Event"::"Officiating Arrangement",EmpAct.Remarks,"Date of Joining Of Transfer");
        IF "Transfer Category" = "Transfer Category"::General THEN
          ServiceHistoryCode := AddToServiceHistory(EmpAct."Employee No.",ServiceHistory."Service Event"::Transfer,EmpAct.Remarks,"Date of Joining Of Transfer");*/
        GLSetup.Get;
        //checking for attachment mandatory
        if EmpHrTransfer."Date of Joining Of Transfer" > Today then
            Error('You Cannot Acknowledge Before Date of Joining');
        AttachmentSetup.Reset;
        AttachmentSetup.SetRange(Type, AttachmentSetup.Type::Transfer);
        AttachmentSetup.SetRange("Transfer Category", EmpHrTransfer."Transfer Category");
        AttachmentSetup.SetRange(Mandatory, true);
        if AttachmentSetup.Find('-') then
            repeat
                IncomingDoc.Reset;
                IncomingDoc.SetRange("Attachment Code", AttachmentSetup."Attachment Code");
                IncomingDoc.SetRange("No.", EmpHrTransfer."No.");
                IncomingDoc.SetRange("File Name", '');
                if IncomingDoc.FindFirst then
                    Error('Please upload file for attachment %1', AttachmentSetup."Attachment Code");
            until AttachmentSetup.Next = 0;

        //  CheckEmployeeActivityApproval(EmpAct);
        // /*Employee1.GET(GetEmployeeNo);
        // IF ("Incoming Supervisior" <> Employee1."No.") AND (NOT Employee1.Screener) THEN
        //   ERROR('You are not eligible to acknowledge this transfer');*/
        if Employee1.Screener then
            EmpHrTransfer."Transfer Remarks" += 'by screener (' + Employee1."No." + ')';
        if GuiAllowed then
            if not Confirm(ConfirmAcknowledge, false) then
                exit;
        EmpHrTransfer.Validate("Approval Status", EmpHrTransfer."Approval Status"::Acknowledged);
        EmpHrTransfer.Modify;

        /*ValidateTransferField(EmpAct); //Min 1.1 >>

         IF ServiceHistory.GET(ServiceHistoryCode) THEN BEGIN
           ServiceHistory.VALIDATE("Functional Title (To)","Functional Title (To)");
           ServiceHistory.VALIDATE("Salary Level (To)",Employee."Salary Level");
           ServiceHistory.VALIDATE("Deputation On (To)","Deputation On (To)");
           ServiceHistory.VALIDATE("Deputation Code (To)",ExitTransferDeputationWiseCode(ServiceHistory."Deputation On (To)",ServiceHistory."Employee No."));
           ServiceHistory.VALIDATE("Deputation Value (To)",ExitTransferDeputationWiseValue(ServiceHistory."Deputation On (To)",ServiceHistory."Employee No."));
           ServiceHistory.VALIDATE("Document No.","No.");
             PreviousServiceHistory.RESET;
             PreviousServiceHistory.SETRANGE("Employee No.",ServiceHistory."Employee No.");
             PreviousServiceHistory.SETFILTER("Service History Code",'<>%1',ServiceHistoryCode);
             PreviousServiceHistory.SETCURRENTKEY("Effective Date");
             IF (PreviousServiceHistory.FINDLAST) THEN
               IF (ServiceHistory."Deputation Code (From)" = ServiceHistory."Deputation Code (To)") OR
                 ("Transfer Category" IN ["Transfer Category"::Officiating,"Transfer Category"::"Temporary"]) THEN
               ServiceHistory."Outstation Eligible" := PreviousServiceHistory."Outstation Eligible";
           ServiceHistory.MODIFY;
         END;*/ //Min 1.1 >>
                //UpdatePortalTransferEffDate(0D,"Employee No."); //Min 4.27.2022
        if EmployeeRec.Get(EmpHrTransfer."Employee No.") then begin //Min -- For Enable Punchin
            EmployeeRec."Disable Punch in" := false;
            EmployeeRec."Global Dimension 1 Code" := EmpHrTransfer."Shortcut Dimension 1 Code (To)";
            EmployeeRec."Deputation on" := EmpHrTransfer."Deputation On (To)";
            EmployeeRec."Extension Counter Code" := EmpHrTransfer."Extension Counter (To)";
            EmployeeRec."Functional Title" := EmpHrTransfer."Functional Title (To)";
            EmployeeRec."Province Code" := EmpHrTransfer."Province Code (To)";
            EmployeeRec."Unit Code" := EmpHrTransfer."Unit (To)";
            EmployeeRec."Department Code" := EmpHrTransfer."Department Code (To)";
            EmployeeRec.Modify;
        end;
        Message(Acknowledged);
        HRMgt.SendMailFromTemplate(DATABASE::"Employee Activity", EmpHrTransfer.Type::"Employee Transfer", EmpHrTransfer."Approval Status"::Acknowledged, '', EmpHrTransfer."Incoming Supervisior", EmpHrTransfer."No.", 0);
        /*IF "Transfer Category" IN ["Transfer Category"::Officiating, "Transfer Category"::"Temporary"] THEN BEGIN
          IF "End Date" < TODAY THEN
            ReinstateTransfer(EmpAct);
        END;*/ //Min 1.1 >>

    end;

    procedure PopUpChangingTransferApprover(EmployeehrTransfer: Record "Employee/HR Transfer")
    var
        EmpActPageBuilder: FilterPageBuilder;
        EmpAct: Record "Employee Activity";
    begin
        EmpActPageBuilder.AddRecord('Change Approver', EmpAct);
        EmpActPageBuilder.ADdField('Change Approver', EmpAct."Approver Code");
        if EmpActPageBuilder.RunModal then begin
            EmpAct.SetView(EmpActPageBuilder.GetView('Change Approver'));

            if EmployeehrTransfer."Approval Status" <> EmployeehrTransfer."Approval Status"::Screened then
                Error('Approval Status must be screened.');
            Employee.Get(HRMgt.GetEmployeeNo);
            if not Employee.Screener then
                Error('Only Screener can change approver');
            if EmpAct.GetFilter("Approver Code") = '' then
                Error('Approver Code cannot be blank.');

            EmployeehrTransfer.Validate("Approver Code", EmpAct.GetFilter("Approver Code"));
            EmployeehrTransfer.Modify;
            Message('Updated');
        end;
    end;

    var
        Employee: Record Employee;
        HRSetup: Record "Human Resources Setup";
        Employee1: Record Employee;
        PayrollSetup: Record "Payroll General Setup";
        HRMgt: Codeunit "HR Mgt.";
        EmployeeRec: Record Employee;
        OverTimeMgt: Codeunit "OverTime Mgt";
        DimensionValue: Record "Dimension Value";
        TransferError: Label 'You cannot Approve HR Transfer of Effective Date %1 in %2.';


}
