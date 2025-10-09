codeunit 50004 "Travel Mgt."
{
    procedure OpenTravelRequest(EmpCode: Code[20]; ToExtend: Boolean; TravelNo: Code[20]; EmployeeAct: Enum "Employee Activity Type")
    var
        TravelRequest, TravelRequest1, TravelRequest2 : Record "Travel Request";
    begin
        Employee.get(EmpCode);
        TravelRequest1.Reset();
        TravelRequest1.SetRange("Employee No.", EmpCode);
        TravelRequest1.SetRange("Approval Status", TravelRequest1."Approval Status"::open);
        TravelRequest1.SetRange(Type, EmployeeAct);
        if ToExtend then begin
            TravelRequest1.SetRange("Travel Order No.", TravelNo);
        end;
        if TravelRequest1.Findfirst() then begin
            Message('This Employee Already has open Travel Request.Click Ok to Open');
            PAGE.Run(PAGE::"Travel Request Form", TravelRequest1)
        end else begin
            TravelRequest.Init;
            TravelRequest.Validate("Employee No.", EmpCode);
            TravelRequest.Validate("Functional Title", Employee."Functional Title");
            TravelRequest.Validate(Type, TravelRequest.Type::"Travel Request");
            TravelRequest.Validate("Approval Status", TravelRequest."Approval Status"::Open);
            TravelRequest.Validate("Requested Date", Today);
            Employee.Get(EmpCode);
            TravelRequest.Validate("Shortcut Dimension 1 Code", Employee."Branch Code");
            TravelRequest.Validate(Department, Employee."Department Code");
            if ToExtend then begin
                Clear(TravelRequest2);
                TravelRequest2.Get(TravelNo);
                TravelRequest.Validate("Travel Order No.", TravelNo);
                TravelRequest.Validate("Total No. of Days", TravelRequest."No. of Days" + CalcExtendDays(TravelRequest2."No. of Days", TravelRequest2."Travel Order No."));
                TravelRequest.Validate("Travel With", TravelRequest2."Travel With");
                TravelRequest.Validate("Start Date", TravelRequest2."End Date" + 1);
                TravelRequest."Travel Countries" := TravelRequest2."Travel Countries";
                TravelRequest."Fooding Allowance Limit" := TravelRequest2."Fooding Allowance Limit";
                TravelRequest."Lodging Allowance Limit" := TravelRequest2."Lodging Allowance Limit";
                TravelRequest."Fooding Per Day Limit" := TravelRequest2."Fooding Per Day Limit";
                TravelRequest."Lodging per Day Limit" := TravelRequest2."Lodging Per day Limit";
                TravelRequest.Destination := TravelRequest2.Destination;
                TravelRequest."Type Of Visit" := TravelRequest2."Type Of Visit";
                TravelRequest.Validate("Departure From", TravelRequest2."Departure From");
                Clear(TravelRequest."Total Estimated Cost");
                Clear(TravelRequest."Estimated Lodging Cost");
            end;
            TravelRequest.Insert(true);
            PAGE.Run(PAGE::"Travel Request Form", TravelRequest);
        end;
    end;

    procedure CalculateNoOfDaysTravel(StartDate: Date; EndDate: Date): Decimal
    var
        DateError: Label 'Start Date (%1) must be less than End Date (%2).';
        Difference: Decimal;
    begin
        if StartDate > EndDate then
            Error(DateError, StartDate, EndDate)
        else
            exit(EndDate - StartDate + 1);
    end;

    procedure CalcExtendDays(NoOfDays: Decimal; TravelOrderNo: Code[20]): Decimal
    var
        TravelRequest: Record "Travel Request";
    begin
        if TravelOrderNo <> '' then
            if TravelRequest.Get(TravelOrderNo) then
                exit(TravelRequest."Total No. of Days");
    end;

    procedure ApplyForTravel(var TravelReq: Record "Travel Request"): Boolean
    var
        TravelRequest: Record "Travel Request";
        ConfirmTravel: Label 'Do you want to send travel request ?';
        ErrorNoOfDays: Label 'No. of Travel days must be greater than 0.';
        TravelRequest2: Record "Travel Request";
        Date: Record Date;
        SalaryLevel1: Record "Salary Level";
        SalaryLevel: Record "Salary Level";
        Employee: Record Employee;
        TravelRequest1: Record "Travel Request";
        IsHandled: Boolean;
    begin
        if GuiAllowed then
            if not Confirm(ConfirmTravel, false) then
                exit;
        TravelReq.TestField("Start Date");
        TravelReq.TestField("End Date");
        TravelReq.TestField("Type Of Visit");
        TravelReq.TestField("Departure From");
        TravelReq.TestField(Destination);
        TravelReq.TestField("Purpose of Travel");
        TravelRequest.Reset;
        TravelRequest.SetRange("Employee No.", TravelReq."Employee No.");
        TravelRequest.SetRange(Type, TravelRequest.Type::"Travel Request");
        TravelRequest.SetFilter("Approval Status", '<>%1&<>%2&<>%3', TravelRequest."Approval Status"::Rejected, TravelRequest."Approval Status"::Open, TravelRequest."Approval Status"::Withdrawn);
        TravelRequest.SetRange("Cancelled No.", '');
        TravelRequest.SetRange(Cancelled, false);
        TravelRequest.FilterGroup(-1);
        TravelRequest.SetRange("Start Date", TravelReq."Start Date", TravelReq."End Date");
        TravelRequest.SetRange("End Date", TravelReq."Start Date", TravelReq."End Date");
        TravelRequest.FilterGroup(0);
        if TravelRequest.Count <> 0 then
            Error('Travel request has already been requested between %1 to %2', TravelReq."Start Date", TravelReq."End Date");

        if TravelReq."No. of Days" <= 0 then
            Error(ErrorNoOfDays);
        Employee.Reset();
        Employee.Get(TravelReq."Employee No.");
        SalaryLevel.Get(Employee."Salary Level");
        if TravelReq."Travel With" <> '' then begin//AT
            Employee1.Get(TravelReq."Travel With");
            if not SalaryLevel."Travel With Not Eligible" then
                SalaryLevel1.Get(Employee1."Salary Level");
        end;
        if TravelReq.extended then begin
            TravelRequest1.Get(TravelReq."Travel Order No.");
            TravelReq.Validate("Travel With", TravelRequest1."Travel With");
            if not (TravelReq."Travel Countries" = TravelReq."Travel Countries"::Nepal) then
                TravelReq.Validate("Departure From", TravelRequest1."Departure From");

        end;
        //TravelReq.TestField("Approver Code");
        TravelReq.Validate("Total No. of Days", TravelReq."No. of Days" + CalcExtendDays(TravelReq."No. of Days", TravelReq."Travel Order No."));
        WithOutHigherSalaryLevel(TravelReq, SalaryLevel, IsHandled);
        if not IsHandled then begin
            if TravelReq."Travel Countries" = TravelReq."Travel Countries"::Nepal then begin
                if SalaryLevel1."Nepal Fooding Allowance" > SalaryLevel."Nepal Fooding Allowance" then begin//AT
                    TravelReq.Validate("Fooding Allowance Limit", SalaryLevel1."Nepal Fooding Allowance" * TravelReq."No. of Days");
                    TravelReq.Validate("Fooding Per Day Limit", SalaryLevel1."Nepal Fooding Allowance");
                end else begin
                    TravelReq.Validate("Fooding Allowance Limit", SalaryLevel."Nepal Fooding Allowance" * TravelReq."No. of Days");
                    TravelReq.Validate("Fooding Per Day Limit", SalaryLevel."Nepal Fooding Allowance");
                end;
                if SalaryLevel1."Nepal Lodging Allowance" > SalaryLevel."Nepal Lodging Allowance" then begin//AT
                    TravelReq.Validate("Lodging Allowance Limit", SalaryLevel1."Nepal Lodging Allowance" * (TravelReq."No. of Days" - 1));
                    TravelReq.Validate("Lodging Per Day Limit", SalaryLevel1."Nepal Lodging Allowance");
                end else begin
                    TravelReq.Validate("Lodging Allowance Limit", SalaryLevel."Nepal Lodging Allowance" * (TravelReq."No. of Days" - 1));
                    TravelReq.Validate("Lodging Per Day Limit", SalaryLevel."Nepal Lodging Allowance");
                end;
            end
            else if TravelReq."Travel Countries" = TravelReq."Travel Countries"::India then begin
                if SalaryLevel1."India Fooding Allowance" > SalaryLevel."India Fooding Allowance" then begin//AT
                    TravelReq.Validate("Fooding Allowance Limit", SalaryLevel1."India Fooding Allowance" * TravelReq."No. of Days");
                    TravelReq.Validate("Fooding Per Day Limit", SalaryLevel1."India Fooding Allowance");

                end else begin
                    TravelReq.Validate("Fooding Allowance Limit", SalaryLevel."India Fooding Allowance" * TravelReq."No. of Days");
                    TravelReq.Validate("Fooding Per Day Limit", SalaryLevel."India Fooding Allowance");

                end;
                if SalaryLevel1."India Lodging Allowance" > SalaryLevel."India Lodging Allowance" then begin//AT
                    TravelReq.Validate("Lodging Allowance Limit", SalaryLevel1."India Lodging Allowance" * (TravelReq."No. of Days" - 1));
                    TravelReq.Validate("Lodging Per Day Limit", SalaryLevel1."India Lodging Allowance");

                end else begin
                    TravelReq.Validate("Lodging Allowance Limit", SalaryLevel."India Lodging Allowance" * (TravelReq."No. of Days" - 1));
                    TravelReq.Validate("Lodging Per Day Limit", SalaryLevel."India Lodging Allowance");
                end;
            end;
        end;
        ApproverMgt.UpdateFirstApproverStatus(TravelReq."No.");
        //api>>
        if not GuiAllowed then
            if TravelReq."Advance Cash" > 0 then
                TravelReq."Advance Cash Required" := true;
        TravelReq.Validate("Approval Status", TravelReq."Approval Status"::Pending);
        TravelReq.Validate("User ID", UserId);
        if TravelReq."Advance Cash" > TravelReq."Total Estimated Cost" then
            Error('Advance cash amount cannot be greater than Total Estimated Cost');
        TravelReq.Modify();
        if not (TravelReq."Travel Order No." = '') then begin
            TravelRequest2.Get(TravelReq."Travel Order No.");
            TravelRequest2.TestField("Approval Status", TravelRequest2."Approval Status"::Approved);
            if TravelRequest2.Extended then
                Error('Travel order no. %1 has already been extended.', TravelRequest2."No.");
            TravelRequest2.Validate(Extended, true);
            TravelRequest2.Modify;
        end;
        HRmgt.SendMailFromTemplate(DATABASE::"Travel Request", TravelReq.Type::"Travel Request", TravelReq."Approval Status"::Open, TravelReq."Employee No.", TravelReq."No.", false);   //For email
        Message('Travel Request has been sent for apporval.');
        OnAfterApplyTravelRequest(TravelReq."No.");
        exit(true);
    end;

    procedure CheckLodgingAmtNepal(Empcode: Code[20]; Amt: Decimal; NoOfDays: Decimal; TravelWith: Code[20])
    var
        SalaryLevel: Record "Salary Level";
        ErrorLodgingError: Label 'Lodging Amount cannot be greater than %1.';
        SalaryLevel1: Record "Salary Level";
    begin
        Employee.Get(Empcode);
        SalaryLevel.Get(Employee."Salary Level");

        if Employee1.Get(TravelWith) then;
        if not SalaryLevel."Travel With Not Eligible" then
            if SalaryLevel1.Get(Employee1."Salary Level") then;
        if TravelWith <> '' then begin//AT

            if SalaryLevel1."Nepal Lodging Allowance" > SalaryLevel."Nepal Lodging Allowance" then begin
                if SalaryLevel1."Nepal Lodging Allowance" * NoOfDays < Amt then
                    Error(ErrorLodgingError, SalaryLevel1."Nepal Lodging Allowance" * NoOfDays);
            end
            else
                if SalaryLevel."Nepal Lodging Allowance" * NoOfDays < Amt then
                    Error(ErrorLodgingError, SalaryLevel."Nepal Lodging Allowance" * NoOfDays);
        end else
            if SalaryLevel."Nepal Lodging Allowance" * NoOfDays < Amt then
                Error(ErrorLodgingError, SalaryLevel."Nepal Lodging Allowance" * NoOfDays);
    end;

    procedure CheckFoodingAmtNepal(Empcode: Code[20]; Amt: Decimal; NoOfDays: Decimal; TravelWithEmp: Code[20])
    var
        SalaryLevel: Record "Salary Level";
        ErrorFoodingError: Label 'Fooding Amount cannot be greater than %1.';
        SalaryLevel1: Record "Salary Level";
    begin
        Employee.Get(Empcode);
        SalaryLevel.Get(Employee."Salary Level");
        if Employee1.Get(TravelWithEmp) then//AT
            if not SalaryLevel."Travel With Not Eligible" then
                if SalaryLevel1.Get(Employee1."Salary Level") then;
        if TravelWithEmp <> '' then begin

            if SalaryLevel1."Nepal Fooding Allowance" > SalaryLevel."Nepal Fooding Allowance" then begin
                if SalaryLevel1."Nepal Fooding Allowance" * NoOfDays < Amt then
                    Error(ErrorFoodingError, SalaryLevel1."Nepal Fooding Allowance" * NoOfDays);
            end
            else
                if SalaryLevel."Nepal Fooding Allowance" * NoOfDays < Amt then
                    Error(ErrorFoodingError, SalaryLevel."Nepal Fooding Allowance" * NoOfDays);
        end
        else
            if SalaryLevel."Nepal Fooding Allowance" * NoOfDays < Amt then
                Error(ErrorFoodingError, SalaryLevel."Nepal Fooding Allowance" * NoOfDays);
    end;

    procedure CheckLodgingAmtIndia(Empcode: Code[20]; Amt: Decimal; NoOfDays: Decimal; TravelWith: Code[20])
    var
        SalaryLevel: Record "Salary Level";
        ErrorLodgingError: Label 'Lodging Amount cannot be greater than %1.';
        SalaryLevel1: Record "Salary Level";
    begin
        Employee.Get(Empcode);
        SalaryLevel.Get(Employee."Salary Level");
        if TravelWith <> '' then begin//AT
            Employee1.Get(TravelWith);
            if not SalaryLevel."Travel With Not Eligible" then
                SalaryLevel1.Get(Employee1."Salary Level");
            if SalaryLevel1."India Lodging Allowance" > SalaryLevel."India Lodging Allowance" then begin
                if SalaryLevel1."India Lodging Allowance" * NoOfDays < Amt then
                    Error(ErrorLodgingError, SalaryLevel1."India Lodging Allowance" * NoOfDays);
            end
            else
                if SalaryLevel."India Lodging Allowance" * NoOfDays < Amt then
                    Error(ErrorLodgingError, SalaryLevel."India Lodging Allowance" * NoOfDays);
        end
        else begin
            if SalaryLevel."India Lodging Allowance" * NoOfDays < Amt then
                Error(ErrorLodgingError, SalaryLevel."India Lodging Allowance" * NoOfDays);
        end;
    end;

    procedure CheckFoodingAmtIndia(Empcode: Code[20]; Amt: Decimal; NoOfDays: Decimal; TravelWithEmp: Code[20])
    var
        SalaryLevel: Record "Salary Level";
        ErrorFoodingError: Label 'Fooding Amount cannot be greater than %1.';
        SalaryLevel1: Record "Salary Level";
    begin
        Employee.Get(Empcode);
        SalaryLevel.Get(Employee."Salary Level");
        if TravelWithEmp <> '' then begin
            if Employee1.Get(TravelWithEmp) then//AT
                if not SalaryLevel."Travel With Not Eligible" then
                    SalaryLevel1.Get(Employee1."Salary Level");
            if SalaryLevel1."India Fooding Allowance" > SalaryLevel."India Fooding Allowance" then begin
                if SalaryLevel1."India Fooding Allowance" * NoOfDays < Amt then
                    Error(ErrorFoodingError, SalaryLevel1."India Fooding Allowance" * NoOfDays);
            end
            else
                if SalaryLevel."India Fooding Allowance" * NoOfDays < Amt then
                    Error(ErrorFoodingError, SalaryLevel."India Fooding Allowance" * NoOfDays);
        end
        else begin
            if SalaryLevel."India Fooding Allowance" * NoOfDays < Amt then
                Error(ErrorFoodingError, SalaryLevel."India Fooding Allowance" * NoOfDays);
        end;
    end;

    procedure CheckLodgingAmtOther(Empcode: Code[20]; Amt: Decimal; NoOfDays: Decimal; TravelWith: Code[20])
    var
        SalaryLevel: Record "Salary Level";
        ErrorLodgingError: Label 'Lodging Amount cannot be greater than %1.';
        SalaryLevel1: Record "Salary Level";
        IsHandled: Boolean;
    begin
        Employee.Get(Empcode);
        SalaryLevel.Get(Employee."Salary Level");
        IsHandled := false;
        if Employee1.Get(TravelWith) then;
        if not SalaryLevel."Travel With Not Eligible" then
            if SalaryLevel1.Get(Employee1."Salary Level") then;
        OnBeforeCheckLodgingAmtOther(Empcode, Amt, NoOfDays, TravelWith, SalaryLevel, SalaryLevel1, IsHandled);
        if not IsHandled then
            if TravelWith <> '' then begin//AT
                if SalaryLevel1."Others Lodging Allowance" > SalaryLevel."Others Lodging Allowance" then begin
                    if SalaryLevel1."Others Lodging Allowance" * NoOfDays < Amt then
                        Error(ErrorLodgingError, SalaryLevel1."Others Lodging Allowance" * NoOfDays);
                end
                else
                    if SalaryLevel."Others Lodging Allowance" * NoOfDays < Amt then
                        Error(ErrorLodgingError, SalaryLevel."Others Lodging Allowance" * NoOfDays);
            end else
                if SalaryLevel."Others Lodging Allowance" * NoOfDays < Amt then
                    Error(ErrorLodgingError, SalaryLevel."Others Lodging Allowance" * NoOfDays);
    end;

    procedure CheckFoodingAmtOther(Empcode: Code[20]; Amt: Decimal; NoOfDays: Decimal; TravelWithEmp: Code[20])
    var
        SalaryLevel: Record "Salary Level";
        ErrorFoodingError: Label 'Fooding Amount cannot be greater than %1.';
        SalaryLevel1: Record "Salary Level";
    begin
        Employee.Get(Empcode);
        SalaryLevel.Get(Employee."Salary Level");
        if Employee1.Get(TravelWithEmp) then//AT
            if not SalaryLevel."Travel With Not Eligible" then
                if SalaryLevel1.Get(Employee1."Salary Level") then;
        if TravelWithEmp <> '' then begin

            if SalaryLevel1."Others Fooding Allowance" > SalaryLevel."Others Fooding Allowance" then begin
                if SalaryLevel1."Others Fooding Allowance" * NoOfDays < Amt then
                    Error(ErrorFoodingError, SalaryLevel1."Others Fooding Allowance" * NoOfDays);
            end
            else
                if SalaryLevel."Others Fooding Allowance" * NoOfDays < Amt then
                    Error(ErrorFoodingError, SalaryLevel."Others Fooding Allowance" * NoOfDays);
        end
        else
            if SalaryLevel."Others Fooding Allowance" * NoOfDays < Amt then
                Error(ErrorFoodingError, SalaryLevel."Others Fooding Allowance" * NoOfDays);
    end;

    local procedure "-----Travel Claimed-----"()
    begin
    end;

    procedure OpenTravelClaimed(EmpCode: Code[20]; TravelOrderNo: Code[20]; TravelWith: Code[20]; TravelCountry: Enum "Travel Countries")
    var
        TravelRequest, TravelRequest2 : Record "Travel Request";
        SalaryLevel, SalaryLevel1 : Record "Salary Level";
        Employee1: Record Employee;
        ApprovalEntry: Record "Approval HRMS";
        IsHandled, IsHandled1 : Boolean;
    begin
        ApprovalEntry.Reset();
        ApprovalEntry.SetRange("Document Type", ApprovalEntry."Document Type"::"Travel Claim");
        ApprovalEntry.SetRange("Document No.", '');
        ApprovalEntry.SetRange("Employee No", EmpCode);
        ApprovalEntry.DeleteAll();

        TravelRequest2.Reset();
        TravelRequest2.SetRange("Employee No.", EmpCode);
        TravelRequest2.SetRange(Type, TravelRequest2.Type::"Travel Claim");
        TravelRequest2.SetRange("Approval Status", TravelRequest2."Approval Status"::open);
        if TravelRequest2.Findfirst() then begin
            Message('This Employee Already has open Travel claim Request. Click Ok to Open');
            PAGE.Run(PAGE::"Request Travel Claim", TravelRequest2)
        end else begin
            TravelRequest.Init;
            Employee.Get(EmpCode);

            SalaryLevel.Get(Employee."Salary Level");
            if TravelWith <> '' then begin//AT
                Employee1.Get(TravelWith);
                if not SalaryLevel."Travel With Not Eligible" then
                    SalaryLevel1.Get(Employee1."Salary Level");
            end;
            TravelRequest2.Get(TravelOrderNo);
            TravelRequest.TransferFields(TravelRequest2);
            TravelRequest."No." := '';
            TravelRequest.Validate("Employee No.", EmpCode);
            TravelRequest.Validate("Functional Title", Employee."Functional Title");
            TravelRequest.Validate(Type, TravelRequest.Type::"Travel Claim");
            TravelRequest.Validate("No. of Days", CalculateTotalNoDays(TravelOrderNo));
            TravelRequest.Validate("Travel Countries", TravelCountry);
            TravelRequest.Validate("Claimed Country", Format(TravelCountry));
            TravelRequest.Validate("Approval Status", TravelRequest."Approval Status"::Open);
            TravelRequest.Validate(Status, '');
            TravelRequest.Validate("Start Date", GetTravelStartDate(TravelOrderNo));
            TravelRequest.Validate("End Date", GetTravelEndDate(TravelOrderNo));
            TravelRequest.Validate("Requested Date", Today);
            TravelRequest.Validate("Travel Order No.", TravelOrderNo);
            TravelRequest."Travel With" := TravelWith;
            //EmpAct.VALIDATE("Claimed Country", );
            TravelRequest.Validate("Estimated Conveyance Expense", CalculateTotalEstimatedConv(TravelOrderNo));
            TravelRequest.Validate("Estimated Fooding Cost", CalculateTotalFooding(TravelOrderNo));
            TravelRequest.Validate("Estimated Lodging Cost", CalculateTotalLodging(TravelOrderNo));
            TravelRequest.Validate("Estimated Transportation Cost", CalculateTotalTransport(TravelOrderNo));
            TravelRequest.Validate("Other Estimated Cost", CalculateTotalOtherExpense(TravelOrderNo));
            TravelRequest.Validate("Total Estimated Cost", CalculateTotalEstimatedCost(TravelOrderNo));
            TravelRequest.Validate("Advance Cash", CalculateTotalAdvance(TravelOrderNo));
            GetFoodingLimit(TravelRequest, SalaryLevel1, SalaryLevel);
            GetLodgingLimit(TravelRequest, SalaryLevel1, SalaryLevel);
            TravelRequest."Arrival Time" := GetArrivalTime(TravelOrderNo);
            TravelRequest."Departure Time" := GetDepatureTime(TravelOrderNo);
            TravelRequest."Actual Travel Start Date" := GetTravelStartDate(TravelOrderNo);
            TravelRequest."Actual Travel End Date" := GetTravelEndDate(TravelOrderNo);
            TravelRequest."Actual Travel Start Time" := GetDepatureTime(TravelOrderNo);
            TravelRequest."Actual Travel End Time" := GetArrivalTime(TravelOrderNo);
            TravelRequest.Validate("Type Of Visit", TravelRequest2."Type Of Visit");
            OnBeforeGetFoodingLimit(TravelRequest, SalaryLevel1, SalaryLevel, IsHandled);
            if not IsHandled then
                GetFoodingLimit(TravelRequest, SalaryLevel1, SalaryLevel);
            OnBeforeGetLodgingLimit(TravelRequest, SalaryLevel1, SalaryLevel, IsHandled1);
            if not IsHandled1 then
                GetLodgingLimit(TravelRequest, SalaryLevel1, SalaryLevel);
            // TravelRequest.Validate("Out of Pocket Expense", GetOutOfPocket(TravelCountry, SalaryLevel) *
            //   GetOutofExpenseDuration(TravelRequest."Actual Travel Start Time", TravelRequest."Actual Travel End Time", TravelRequest."Start Date", TravelRequest."End Date"));

            if TravelRequest."Advance Cash" <> 0 then
                TravelRequest."Advance Cash Required" := true;
            TravelRequest.Insert(true);
            GenerateTravelClaimAttachment(TravelRequest);
            Commit();
            PAGE.Run(PAGE::"Request Travel Claim", TravelRequest);
        end;
    end;

    procedure CalculateTotalNoDays(TravelOrderNo: Code[20]): Decimal
    var
        TravelRequest: Record "Travel Request";
        AdvAmt: Decimal;
    begin
        Clear(AdvAmt);
        if TravelRequest.Get(TravelOrderNo) then begin
            if not (TravelRequest."Travel Order No." = '') then
                AdvAmt := CalculateTotalNoDays(TravelRequest."Travel Order No.");
            exit(AdvAmt + TravelRequest."No. of Days");
        end;
    end;

    procedure CalculateTotalEstimatedConv(TravelOrderNo: Code[20]): Decimal
    var
        TravelRequest: Record "Travel Request";
        AdvAmt: Decimal;
    begin
        Clear(AdvAmt);
        if TravelRequest.Get(TravelOrderNo) then begin
            if not (TravelRequest."Travel Order No." = '') then
                AdvAmt := CalculateTotalEstimatedConv(TravelRequest."Travel Order No.");
            exit(AdvAmt + TravelRequest."Estimated Conveyance Expense");
        end;
    end;

    procedure CalculateTotalFooding(TravelOrderNo: Code[20]): Decimal
    var
        TravelRequest: Record "Travel Request";
        AdvAmt: Decimal;
    begin
        Clear(AdvAmt);
        if TravelRequest.Get(TravelOrderNo) then begin
            if not (TravelRequest."Travel Order No." = '') then
                AdvAmt := CalculateTotalFooding(TravelRequest."Travel Order No.");
            exit(AdvAmt + TravelRequest."Estimated Fooding Cost");
        end;
    end;

    procedure CalculateTotalAdvance(TravelOrderNo: Code[20]): Decimal
    var
        TravelRequest: Record "Travel Request";
        AdvAmt: Decimal;
    begin
        Clear(AdvAmt);
        if TravelRequest.Get(TravelOrderNo) then begin
            if not (TravelRequest."Travel Order No." = '') then
                AdvAmt := CalculateTotalAdvance(TravelRequest."Travel Order No.");
            exit(AdvAmt + TravelRequest."Advance Cash");
        end;
    end;

    procedure CalculateTotalLodging(TravelOrderNo: Code[20]): Decimal
    var
        TravelRequest: Record "Travel Request";
        AdvAmt: Decimal;
    begin
        Clear(AdvAmt);
        if TravelRequest.Get(TravelOrderNo) then begin
            if not (TravelRequest."Travel Order No." = '') then
                AdvAmt := CalculateTotalLodging(TravelRequest."Travel Order No.");
            exit(AdvAmt + TravelRequest."Estimated Lodging Cost");
        end;
    end;

    procedure CalculateTotalOtherExpense(TravelOrderNo: Code[20]): Decimal
    var
        TravelRequest: Record "Travel Request";
        AdvAmt: Decimal;
    begin
        Clear(AdvAmt);
        if TravelRequest.Get(TravelOrderNo) then begin
            if not (TravelRequest."Travel Order No." = '') then
                AdvAmt := CalculateTotalOtherExpense(TravelRequest."Travel Order No.");
            exit(AdvAmt + TravelRequest."Other Estimated Cost");
        end;
    end;

    procedure CalculateTotalTransport(TravelOrderNo: Code[20]): Decimal
    var
        TravelRequest: Record "Travel Request";
        AdvAmt: Decimal;
    begin
        Clear(AdvAmt);
        if TravelRequest.Get(TravelOrderNo) then begin
            if not (TravelRequest."Travel Order No." = '') then
                AdvAmt := CalculateTotalTransport(TravelRequest."Travel Order No.");
            exit(AdvAmt + TravelRequest."Estimated Transportation Cost");
        end;
    end;

    procedure CalculateTotalEstimatedCost(TravelOrderNo: Code[20]): Decimal
    var
        TravelRequest: Record "Travel Request";
        AdvAmt: Decimal;
    begin
        Clear(AdvAmt);
        if TravelRequest.Get(TravelOrderNo) then begin
            if not (TravelRequest."Travel Order No." = '') then
                AdvAmt := CalculateTotalEstimatedCost(TravelRequest."Travel Order No.");
            exit(AdvAmt + TravelRequest."Total Estimated Cost");
        end;
    end;

    procedure GetTravelStartDate(TravelOrderNo: Code[20]): Date
    var
        TravelRequest: Record "Travel Request";
    begin
        if TravelRequest.Get(TravelOrderNo) then begin
            if not (TravelRequest."Travel Order No." = '') then
                exit(GetTravelStartDate(TravelRequest."Travel Order No."))
            else
                exit(TravelRequest."Start Date");
        end;
    end;

    procedure GetTravelEndDate(TravelOrderNo: Code[20]): Date
    var
        TravelRequest: Record "Travel Request";
    begin
        if TravelRequest.Get(TravelOrderNo) then begin
            exit(TravelRequest."End Date");
        end;
    end;

    procedure GetOutOfExpenseDuration(DepartureTime: Time; ArrivalTime: Time; DepartureDate: Date; ArrivalDate: Date): Decimal
    var
        TotalDuration: Decimal;
        NoofDays: Integer;
    begin
        if (DepartureDate = 0D) or (ArrivalDate = 0D) then
            exit;
        HRSetup.Get;
        //Duration1 :=(CREATEDATETIME(TODAY,0T) - CREATEDATETIME(TODAY-1,DepatureTime));
        //Duration2 := (CREATEDATETIME(TODAY,ArrivalTime) - (CREATEDATETIME(TODAY,0T)));
        TotalDuration := (CreateDateTime(ArrivalDate, ArrivalTime) - CreateDateTime(DepartureDate, DepartureTime)) / 1000 / 60 / 60;

        NoofDays := Round(TotalDuration / 24, 1, '<');
        TotalDuration := TotalDuration mod 24;

        if TotalDuration >= HRSetup."Full Limit (out expense)" then
            exit(NoofDays + HRSetup."Full Limit Value")
        else if TotalDuration >= HRSetup."Half Limit (out expense)" then
            exit(NoofDays + HRSetup."Half Limit Value")
        else
            exit(NoofDays);
    end;

    procedure GetDepatureTime(TravelOrderNo: Code[20]): Time
    var
        TravelRequest: Record "Travel Request";
    begin
        if TravelRequest.Get(TravelOrderNo) then begin
            if not (TravelRequest."Travel Order No." = '') then
                exit(GetDepatureTime(TravelRequest."Travel Order No."))
            else
                exit(TravelRequest."Departure Time");
        end;
    end;

    procedure GetArrivalTime(TravelOrderNo: Code[20]): Time
    var
        TravelRequest: Record "Travel Request";
    begin
        if TravelRequest.Get(TravelOrderNo) then begin
            exit(TravelRequest."Arrival Time");
        end;
    end;

    procedure ApplyForTravelClaim(var TravelRequest: Record "Travel Request"): Boolean
    var
        ConfirmTravel: Label 'Do you want to send travel request ?';
        ErrorNoOfDays: Label 'No. of Travel days must be greater than 0.';
        TravelRequest2: Record "Travel Request";
        SalaryLevel1: Record "Salary Level";
        SalaryLevel: Record "Salary Level";
        IsHandled: Boolean;
        IsHandled1: Boolean;
    begin
        if GuiAllowed then
            if not Confirm(ConfirmTravel, false) then
                exit(false);
        if not GuiAllowed then begin
            TravelRequest.TestField("Start Date");
            TravelRequest.TestField("End Date");
        end;
        ApproverMgt.UpdateFirstApproverStatus(TravelRequest."No.");
        if TravelRequest2.Get(TravelRequest."Travel Order No.") then
            if (TravelRequest2."Travel Claimed") then
                Error('Travel order no. %1 has already been claimed.', TravelRequest2."No.");

        // TravelReq.TestField("Purpose of Travel");
        if TravelRequest."No. of Days" <= 0 then
            Error(ErrorNoOfDays);
        Employee.Get(TravelRequest."Employee No.");
        // Clear(TravelRequest);
        SalaryLevel.Get(Employee."Salary Level");
        ApplyForTravelClaimWithEmployeeSalary(TravelRequest, TravelRequest2, IsHandled);
        if not IsHandled then begin
            if TravelRequest."Travel With" <> '' then begin//AT
                Employee1.Get(TravelRequest."Travel With");
                if not SalaryLevel."Travel With Not Eligible" then
                    SalaryLevel1.Get(Employee1."Salary Level");
            end;
            // TravelRequest.Init;
            // TravelRequest.TransferFields(TravelReq);
            TravelRequest.Validate("Travel With", TravelRequest2."Travel With");
            TravelRequest.Validate("Type Of Visit", TravelRequest2."Type Of Visit");
            TravelRequest.Validate(Destination, TravelRequest2.Destination);
            TravelRequest.Validate("Departure From", TravelRequest2."Departure From");
            TravelRequest.Validate(Description, TravelRequest2.Description);
            TravelRequest.Validate("Mode Of Travel", TravelRequest2."Mode Of Travel");
            TravelRequest.Validate("Estimated Conveyance Expense", CalculateTotalEstimatedConv(TravelRequest."Travel Order No."));
            TravelRequest.Validate("Estimated Fooding Cost", CalculateTotalFooding(TravelRequest."Travel Order No."));
            TravelRequest.Validate("Estimated Lodging Cost", CalculateTotalLodging(TravelRequest."Travel Order No."));
            TravelRequest.Validate("Estimated Transportation Cost", CalculateTotalTransport(TravelRequest."Travel Order No."));
            TravelRequest.Validate("Total Estimated Cost", CalculateTotalEstimatedCost(TravelRequest."Travel Order No."));
            TravelRequest.Validate("Other Estimated Cost", CalculateTotalOtherExpense(TravelRequest."Travel Order No."));
            TravelRequest.Validate("Advance Cash", CalculateTotalAdvance(TravelRequest."Travel Order No."));
            // TravelRequest.Validate("Advance Cash", TravelRequest2."Advance Cash" + TravelReq."Advance Cash");
            // if GuiAllowed then begin
            OnBeforeGetFoodingLimit(TravelRequest, SalaryLevel1, SalaryLevel, IsHandled);
            if not IsHandled then
                GetFoodingLimit(TravelRequest, SalaryLevel1, SalaryLevel);
            OnBeforeGetLodgingLimit(TravelRequest, SalaryLevel1, SalaryLevel, IsHandled1);
            if not IsHandled1 then
                GetLodgingLimit(TravelRequest, SalaryLevel1, SalaryLevel);
            TravelRequest.Validate("Requested Date", Today);
            TravelRequest.Validate("Total Claimed Amount");
            TravelRequest.Validate("Approval Status", TravelRequest."Approval Status"::Pending);
            TravelRequest.Modify();
            // TravelRequest.Insert(true);
            HRmgt.SendMailFromTemplate(DATABASE::"Employee Activity", TravelRequest.Type::"Travel Claim", TravelRequest."Approval Status"::Open, TravelRequest."Employee No.", TravelRequest."No.");   //For email
            Message('Travel Claim has been sent for apporval.');
            TravelRequest2."Travel Claimed" := true;
            TravelRequest2.Modify;
            OnAfterApplyTravelClaim(TravelRequest."No.");
        end;
    end;

    procedure TravelApproved(TravelCode: Code[20])
    var
        TravelRequest: Record "Travel Request";
        LeaveEarn: Record "Leave Earn";
        ApprovalStatusError: Label 'Approval Status must be %1 or %2.';
        ErrorReject: Label 'Approval Status must be in %1 or %2.';
        EmpAttendActivity: Record "Employee Attendance & Activity";
        LeaveTypeSetup: Record "Leave Type Setup";
    begin
        TravelRequest.Get(TravelCode);
        if TravelRequest.Type = TravelRequest.Type::"Travel Request" then begin
            //changes in employee attendance and activity
            EmpAttendActivity.Reset;
            EmpAttendActivity.SetRange("Employee No.", TravelRequest."Employee No.");
            EmpAttendActivity.SetRange("Attendance Date", TravelRequest."Start Date", TravelRequest."End Date");
            if EmpAttendActivity.Find('-') then
                repeat
                    EmpAttendActivity."Absent Day" := 0;
                    EmpAttendActivity."Present Day" := 1;
                    EmpAttendActivity."Tour Day" := 1;
                    EmpAttendActivity."Leave Day" := 0;
                    EmpAttendActivity."Source No." := TravelRequest."No.";
                    EmpAttendActivity."Employee Activity Found" := true;
                    EmpAttendActivity."Created Datetime" := CurrentDateTime;
                    EmpAttendActivity.Modify;
                until EmpAttendActivity.Next = 0;
            Employee.Get(TravelRequest."Employee No.");
            Employee.Validate("Attendance Missed On", LeaveMgt.CheckLeaveCount(Employee."No."));
            AttendanceSetup.Get;
            Employee.Get(TravelRequest."Employee No.");
            Employee.Validate("Attendance Missed On", LeaveMgt.CheckLeaveCount(Employee."No."));
            if AttendanceSetup."Activate Punch in Date" <> 0D then begin
                if (Employee."Attendance Missed On" < AttendanceSetup."Activate Punch in Date") and (not AttendanceSetup."Deactivate Punch in Count") then
                    Employee.Validate("Attendance Missed Count", LeaveMgt.ReturnLeaveCount(Employee."No.", AttendanceSetup."Activate Punch in Date" - 1))
                else
                    Employee.Validate("Attendance Missed Count", LeaveMgt.ReturnLeaveCount(Employee."No.", Employee."Attendance Missed On"));
            end else
                Employee.Validate("Attendance Missed Count", LeaveMgt.ReturnLeaveCount(Employee."No.", Employee."Attendance Missed On"));
            Employee.Modify;
        end;
        TravelRequest."Approved Date" := Today;
        TravelRequest.Modify();
        HRMgt.SendMailFromTemplate(DATABASE::"Travel Request", TravelRequest.Type, TravelRequest."Approval Status"::Approved, HrMgt.getEmployeeNo(), TravelRequest."No.", false);   //For email
    end;

    procedure TravelClaimApproved(TravelCode: Code[20])
    var
        TravelRequest: Record "Travel Request";
        TravelRequest2: Record "Travel Request";
    begin
        if TravelRequest.Get(TravelCode) then begin
            TravelRequest."Travel Claimed" := true;
            TravelRequest."Approved Date" := Today;
            TravelRequest.Modify();
        end;
    end;

    procedure TravelClaimReject(TravelCode: Code[20])
    var
        TravelRequest: Record "Travel Request";
        TravelRequest2: Record "Travel Request";
    begin
        TravelRequest.Get(TravelCode);
        if TravelRequest2.Get(TravelRequest."Travel Order No.") then
            TravelRequest2."Travel Claimed" := false;
        TravelRequest2.Modify();
        OnAfterRejectTravelClaim(TravelCode);
    end;

    procedure GetAllowanceFoodingLodging(EmpTravel: Record "Travel Request"; allType: Enum "Allowance Type"; NoofDays: Decimal): Decimal
    var
        SalaryLevel1: Record "Salary Level";
        EmpVar: Record Employee;
        SalaryLevel: Record "Salary Level";
    begin
        EmpVar.Get(EmpTravel."Employee No.");
        SalaryLevel.Get(EmpVar."Salary Level");
        if EmpTravel."Travel With" <> '' then begin//AT
            if Employee.Get(EmpTravel."Travel With") then;
            if not SalaryLevel."Travel With Not Eligible" then
                if SalaryLevel1.Get(Employee."Salary Level") then;
        end;

        case EmpTravel."Travel Countries" of
            EmpTravel."Travel Countries"::Nepal:
                begin
                    if allType = allType::Fooding then begin
                        if SalaryLevel1."Nepal Fooding Allowance" > SalaryLevel."Nepal Fooding Allowance" then//AT
                            exit(SalaryLevel1."Nepal Fooding Allowance" * NoofDays)
                        else
                            exit(SalaryLevel."Nepal Fooding Allowance" * NoofDays);
                    end else if allType = allType::Lodging then begin
                        if SalaryLevel1."Nepal Lodging Allowance" > SalaryLevel."Nepal Lodging Allowance" then//AT
                            exit(SalaryLevel1."Nepal Lodging Allowance" * (NoofDays - 1))
                        else
                            exit(SalaryLevel."Nepal Lodging Allowance" * (NoofDays - 1));
                    end else if allType = allType::OutofExpense then
                            exit(SalaryLevel."Out of Pocket Expense(Nepal)" * EmpTravel."Total No. of Days");
                end;

            EmpTravel."Travel Countries"::India:
                begin
                    if allType = allType::Fooding then begin
                        if SalaryLevel1."India Fooding Allowance" > SalaryLevel."India Fooding Allowance" then//AT
                            exit(SalaryLevel1."India Fooding Allowance" * NoofDays)
                        else
                            exit(SalaryLevel."India Fooding Allowance" * NoofDays);
                    end else if allType = allType::Lodging then begin
                        if SalaryLevel1."India Lodging Allowance" > SalaryLevel."India Lodging Allowance" then//AT
                            exit(SalaryLevel1."India Lodging Allowance" * (NoofDays - 1))
                        else
                            exit(SalaryLevel."India Lodging Allowance" * (NoofDays - 1));
                    end else if allType = allType::OutofExpense then
                            exit(SalaryLevel."Out of Pocket Expense(India)" * EmpTravel."Total No. of Days");
                end;

            EmpTravel."Travel Countries"::"Other Countries":
                begin
                    if allType = allType::Fooding then begin
                        if SalaryLevel1."Others Fooding Allowance" > SalaryLevel."Others Fooding Allowance" then//AT
                            exit(SalaryLevel1."Others Fooding Allowance" * NoofDays)
                        else
                            exit(SalaryLevel."Others Fooding Allowance" * NoofDays);
                    end else if allType = allType::Lodging then begin
                        if SalaryLevel1."Others Lodging Allowance" > SalaryLevel."Others Lodging Allowance" then//AT
                            exit(SalaryLevel1."Others Lodging Allowance" * (NoofDays - 1))
                        else
                            exit(SalaryLevel."Others Lodging Allowance" * (NoofDays - 1));
                    end else if allType = allType::OutofExpense then
                            exit(SalaryLevel."Out of Pocket Expense(Other)" * EmpTravel."Total No. of Days");
                end;
        end;
        OnAfterGetTravelAllowance(EmpTravel, allType, NoofDays, SalaryLevel, SalaryLevel1)
    end;

    procedure GetAllowanceFoodingLodingLimit(EmpTravel: Record "Travel Request"; allType: Enum "Allowance Type"; perDay: Boolean; NoOfDays: Decimal): Decimal
    var
        SalaryLevel1: Record "Salary Level";
        EmpVar: Record Employee;
        Days: Integer;
        SalaryLevel: Record "Salary Level";
    begin
        EmpVar.Get(EmpTravel."Employee No.");
        SalaryLevel.Get(EmpVar."Salary Level");
        if EmpTravel."Travel With" <> '' then begin//AT
            if Employee.Get(EmpTravel."Travel With") then;
            if not SalaryLevel."Travel With Not Eligible" then
                if SalaryLevel1.Get(Employee."Salary Level") then;
        end;

        if perDay then
            Days := 1
        else begin
            if allType = allType::Fooding then
                // Days := EmpActivity."Total No. of Days"
                Days := NoOfDays
            else if allType = allType::Lodging then
                //Days := EmpActivity."Total No. of Days" -1;
                Days := NoOfDays - 1;
        end;
        case EmpTravel."Travel Countries" of
            EmpTravel."Travel Countries"::Nepal:
                begin
                    if allType = allType::Fooding then begin
                        if SalaryLevel1."Nepal Fooding Allowance" > SalaryLevel."Nepal Fooding Allowance" then//AT
                            exit(SalaryLevel1."Nepal Fooding Allowance" * Days)
                        else
                            exit(SalaryLevel."Nepal Fooding Allowance" * Days);
                    end else if allType = allType::Lodging then begin
                        if SalaryLevel1."Nepal Lodging Allowance" > SalaryLevel."Nepal Lodging Allowance" then//AT
                            exit(SalaryLevel1."Nepal Lodging Allowance" * (Days))
                        else
                            exit(SalaryLevel."Nepal Lodging Allowance" * (Days));
                    end else if allType = allType::OutofExpense then
                            exit(SalaryLevel."Out of Pocket Expense(Nepal)" * Days);
                end;

            EmpTravel."Travel Countries"::India:
                begin
                    if allType = allType::Fooding then begin
                        if SalaryLevel1."India Fooding Allowance" > SalaryLevel."India Fooding Allowance" then//AT
                            exit(SalaryLevel1."India Fooding Allowance" * Days)
                        else
                            exit(SalaryLevel."India Fooding Allowance" * Days);
                    end else if allType = allType::Lodging then begin
                        if SalaryLevel1."India Lodging Allowance" > SalaryLevel."India Lodging Allowance" then//AT
                            exit(SalaryLevel1."India Lodging Allowance" * (Days))
                        else
                            exit(SalaryLevel."India Lodging Allowance" * (Days));
                    end else if allType = allType::OutofExpense then
                            exit(SalaryLevel."Out of Pocket Expense(Nepal)" * Days);
                end;

            EmpTravel."Travel Countries"::"Other Countries":
                begin
                    if allType = allType::Fooding then begin
                        if SalaryLevel1."Others Fooding Allowance" > SalaryLevel."Others Fooding Allowance" then//AT
                            exit(SalaryLevel1."Others Fooding Allowance" * Days)
                        else
                            exit(SalaryLevel."Others Fooding Allowance" * Days);
                    end else if allType = allType::Lodging then begin
                        if SalaryLevel1."Others Lodging Allowance" > SalaryLevel."Others Lodging Allowance" then//AT
                            exit(SalaryLevel1."Others Lodging Allowance" * (Days))
                        else
                            exit(SalaryLevel."Others Fooding Allowance" * (Days));
                    end else if allType = allType::OutofExpense then
                            exit(SalaryLevel."Out of Pocket Expense(Other)" * Days);
                end;
        end;
    end;

    procedure GetFoodingLimit(var TravelRequest: Record "Travel Request"; SalaryLevel1: Record "Salary Level"; SalaryLevel: Record "Salary Level")
    var
    begin
        if TravelRequest."Travel Countries" = TravelRequest."Travel Countries"::Nepal then begin
            if SalaryLevel1."Nepal Fooding Allowance" > SalaryLevel."Nepal Fooding Allowance" then begin//AT
                // TravelRequest.Validate("Fooding Allowance", SalaryLevel1."Nepal Fooding Allowance" * TravelRequest."No. of Days");
                TravelRequest.Validate("Fooding Allowance Limit", SalaryLevel1."Nepal Fooding Allowance" * TravelRequest."No. of Days");
                TravelRequest.Validate("Fooding Per Day Limit", SalaryLevel1."Nepal Fooding Allowance");
            end else begin
                // TravelRequest.Validate("Fooding Allowance", SalaryLevel."Nepal Fooding Allowance" * TravelRequest."No. of Days");
                TravelRequest.Validate("Fooding Allowance Limit", SalaryLevel."Nepal Fooding Allowance" * TravelRequest."No. of Days");
                TravelRequest.Validate("Fooding Per Day Limit", SalaryLevel."Nepal Fooding Allowance");
            end;
        end
        else if TravelRequest."Travel Countries" = TravelRequest."Travel Countries"::India then begin
            if SalaryLevel1."India Fooding Allowance" > SalaryLevel."India Fooding Allowance" then begin//AT
                // TravelRequest.Validate("Fooding Allowance", SalaryLevel1."India Fooding Allowance" * TravelRequest."No. of Days");
                TravelRequest.Validate("Fooding Allowance Limit", SalaryLevel1."India Fooding Allowance" * TravelRequest."No. of Days");
                TravelRequest.Validate("Fooding Per Day Limit", SalaryLevel1."India Fooding Allowance");
            end else begin
                // TravelRequest.Validate("Fooding Allowance", SalaryLevel."India Fooding Allowance" * TravelRequest."No. of Days");
                TravelRequest.Validate("Fooding Allowance Limit", SalaryLevel."India Fooding Allowance" * TravelRequest."No. of Days");
                TravelRequest.Validate("Fooding Per Day Limit", SalaryLevel."India Fooding Allowance");
            end;
        end
        else if TravelRequest."Travel Countries" = TravelRequest."Travel Countries"::"Other Countries" then begin
            if SalaryLevel1."Others Fooding Allowance" > SalaryLevel."Others Fooding Allowance" then begin//AT
                // TravelRequest.Validate("Fooding Allowance", SalaryLevel1."Others Fooding Allowance" * TravelRequest."No. of Days");
                TravelRequest.Validate("Fooding Allowance Limit", SalaryLevel1."Others Fooding Allowance" * TravelRequest."No. of Days");
                TravelRequest.Validate("Fooding Per Day Limit", SalaryLevel1."Others Fooding Allowance");
            end else begin
                // TravelRequest.Validate("Fooding Allowance", SalaryLevel."Others Fooding Allowance" * TravelRequest."No. of Days");
                TravelRequest.Validate("Fooding Allowance Limit", SalaryLevel."Others Fooding Allowance" * TravelRequest."No. of Days");
                TravelRequest.Validate("Fooding Per Day Limit", SalaryLevel."Others Fooding Allowance");
            end;
        end;
    end;

    procedure GetLodgingLimit(var TravelRequest: Record "Travel Request"; SalaryLevel1: Record "Salary Level"; SalaryLevel: Record "Salary Level")
    var
    begin
        if TravelRequest."Travel Countries" = TravelRequest."Travel Countries"::Nepal then begin
            if SalaryLevel1."Nepal Lodging Allowance" > SalaryLevel."Nepal Lodging Allowance" then begin//AT
                // TravelRequest.Validate("Lodging Allowance", SalaryLevel1."Nepal Lodging Allowance" * (TravelRequest."No. of Days" - 1));
                TravelRequest.Validate("Lodging Allowance Limit", SalaryLevel1."Nepal Lodging Allowance" * (TravelRequest."No. of Days" - 1));
                TravelRequest.Validate("Lodging Per Day Limit", SalaryLevel1."Nepal Lodging Allowance");
            end else begin
                // TravelRequest.Validate("Lodging Allowance", SalaryLevel."Nepal Lodging Allowance" * (TravelRequest."No. of Days" - 1));
                TravelRequest.Validate("Lodging Allowance Limit", SalaryLevel."Nepal Lodging Allowance" * (TravelRequest."No. of Days" - 1));
                TravelRequest.Validate("Lodging Per Day Limit", SalaryLevel."Nepal Lodging Allowance");
            end;
        end
        else if TravelRequest."Travel Countries" = TravelRequest."Travel Countries"::India then begin
            if SalaryLevel1."India Lodging Allowance" > SalaryLevel."India Lodging Allowance" then begin//AT
                // TravelRequest.Validate("Lodging Allowance", SalaryLevel1."India Lodging Allowance" * (TravelRequest."No. of Days" - 1));
                TravelRequest.Validate("Lodging Allowance Limit", SalaryLevel1."India Lodging Allowance" * (TravelRequest."No. of Days" - 1));
                TravelRequest.Validate("Lodging Per Day Limit", SalaryLevel1."India Lodging Allowance");

            end else begin
                // TravelRequest.Validate("Lodging Allowance", SalaryLevel."India Lodging Allowance" * (TravelRequest."No. of Days" - 1));
                TravelRequest.Validate("Lodging Allowance Limit", SalaryLevel."India Lodging Allowance" * (TravelRequest."No. of Days" - 1));
                TravelRequest.Validate("Lodging Per Day Limit", SalaryLevel."India Lodging Allowance");
            end;
        end
        else if TravelRequest."Travel Countries" = TravelRequest."Travel Countries"::"Other Countries" then begin
            if SalaryLevel1."Others Lodging Allowance" > SalaryLevel."Others Lodging Allowance" then begin//AT
                // TravelRequest.Validate("Lodging Allowance", SalaryLevel1."Others Lodging Allowance" * (TravelRequest."No. of Days" - 1));
                TravelRequest.Validate("Lodging Allowance Limit", SalaryLevel1."Others Lodging Allowance" * (TravelRequest."No. of Days" - 1));
                TravelRequest.Validate("Lodging Per Day Limit", SalaryLevel1."Others Lodging Allowance");

            end else begin
                // TravelRequest.Validate("Lodging Allowance", SalaryLevel."Others Lodging Allowance" * (TravelRequest."No. of Days" - 1));
                TravelRequest.Validate("Lodging Allowance Limit", SalaryLevel."Others Lodging Allowance" * (TravelRequest."No. of Days" - 1));
                TravelRequest.Validate("Lodging Per Day Limit", SalaryLevel."Others Lodging Allowance");
            end;
        end;
    end;

    procedure GetOutOfPocket(TravelCountries: Enum "Travel Countries"; SalaryLevel: Record "Salary Level"): Decimal
    begin
        if TravelCountries = TravelCountries::Nepal then begin
            exit(SalaryLevel."Out of Pocket Expense(Nepal)");
        end
        else if TravelCountries = TravelCountries::India then begin
            exit(SalaryLevel."Out of Pocket Expense(India)");
        end
        else if TravelCountries = TravelCountries::"Other Countries" then begin
            exit(SalaryLevel."Out of Pocket Expense(Other)");
        end;
    end;

    procedure GenerateTravelClaimAttachment(TravelRequest: Record "Travel Request")
    var
        TempIncomingDoc: Record "Incoming Document";
        AttachmentSetup: Record "Attachment Setup";
    begin
        // Delete existing Attachment Line Of Travel <<Santosh<< 4-22-25
        TempIncomingDoc.Reset;
        TempIncomingDoc.SetRange("No.", TravelRequest."No.");
        TempIncomingDoc.DeleteAll();
        //
        TempIncomingDoc.Reset;
        TempIncomingDoc.SetRange("Employee Code", TravelRequest."Employee No.");
        TempIncomingDoc.SetRange(Type, TempIncomingDoc.Type::" ");
        TempIncomingDoc.SetRange("No.", '');
        if TempIncomingDoc.Find('-') then
            repeat
                if TempIncomingDoc."File Name" <> '' then
                    Clear(TempIncomingDoc."File Name");
            until TempIncomingDoc.Next = 0;
        TempIncomingDoc.DeleteAll;
        AttachmentSetup.Reset;
        AttachmentSetup.SetRange(Type, AttachmentSetup.Type::"Travel Claim");
        if AttachmentSetup.Find('-') then
            repeat
                TempIncomingDoc.Reset;
                TempIncomingDoc.Init;
                TempIncomingDoc.Validate(Type, TempIncomingDoc.Type::" ");
                TempIncomingDoc.Validate("No.", TravelRequest."No.");
                TempIncomingDoc.Validate("Employee Activity Type", TempIncomingDoc."Employee Activity Type"::"Travel Claim");
                TempIncomingDoc.Validate("Attachment Code", AttachmentSetup."Attachment Code");
                TempIncomingDoc.Validate(Description, Format(TravelRequest.Type) + ': ' + AttachmentSetup."Attachment Code");
                TempIncomingDoc.Validate("Employee Code", TravelRequest."Employee No.");
                TempIncomingDoc.Insert(true);
            until AttachmentSetup.Next = 0;
    end;

    procedure ValidateTravelRequestOverLap(TravelRequest1: Record "Travel Request")
    var
        TravelRequest: Record "Travel Request";
    begin
        TravelRequest.Reset;
        TravelRequest.SetRange("Employee No.", TravelRequest1."Employee No.");
        TravelRequest.SetRange(Type, TravelRequest.Type::"Travel Request");
        TravelRequest.SetFilter("No.", '<>%1', TravelRequest1."No.");
        TravelRequest.SetFilter("Approval Status", '<>%1&<>%2&<>%3', TravelRequest."Approval Status"::Rejected, TravelRequest."Approval Status"::Open,
                               TravelRequest."Approval Status"::Withdrawn);
        if TravelRequest.FindSet then
            repeat
                if ((TravelRequest1."Start Date" > TravelRequest."Start Date") and (TravelRequest1."Start Date" < TravelRequest."End Date")) or ((TravelRequest1."End Date" > TravelRequest."Start Date") and (TravelRequest1."End Date" < TravelRequest."End Date")) then
                    Error('Travel Request overlaps with existing request %1 from %2 to %3 for %4', TravelRequest."No.", TravelRequest."Start Date", TravelRequest."End Date", TravelRequest1."Employee Name");
            until TravelRequest.Next = 0;
    end;

    var
        Employee, Employee1 : Record Employee;
        HRMgt: Codeunit "HR Mgt.";
        HRSetup: Record "Human Resources Setup";
        LeaveMgt: Codeunit "Leave Mgt.";
        AttendanceSetup: Record "Attendance Setup";
        ApproverMgt: Codeunit "Approver Mgt";

    [IntegrationEvent(false, false)]
    procedure OnAfterApplyTravelClaim(TravelClaimNo: Code[20])
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnAfterRejectTravelClaim(TravelClaimNo: Code[20])
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnAfterGetTravelAllowance(EmpTravel: Record "Travel Request"; allType: Enum "Allowance Type"; NoofDays: Decimal; SalaryLevel: Record "Salary Level"; SalaryLevel1: Record "Salary Level")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnBeforeCheckLodgingAmtOther(Empcode: Code[20]; Amt: Decimal; NoOfDays: Decimal; TravelWith: Code[20]; SalaryLevel: Record "Salary Level"; SalaryLevel1: Record "Salary Level"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnBeforeGetFoodingLimit(Var TravelRequest: Record "Travel Request"; SalaryLevel1: Record "Salary Level"; SalaryLevel: Record "Salary Level"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnBeforeGetLodgingLimit(Var TravelRequest: Record "Travel Request"; SalaryLevel1: Record "Salary Level"; SalaryLevel: Record "Salary Level"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnAfterApplyTravelRequest(TravelRequestNo: Code[20])
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure ApplyForTravelClaimWithEmployeeSalary(Var TravelRequest: Record "Travel Request"; var TravelRequest2: Record "Travel Request"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure WithOutHigherSalaryLevel(Var TravelRequest: Record "Travel Request"; var SalaryLevel: Record "Salary Level"; var IsHandled: Boolean)
    begin
    end;


}
