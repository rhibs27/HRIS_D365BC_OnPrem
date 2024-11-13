codeunit 50004 "Travel Mgt."
{
    procedure OpenTravelRequest(EmpCode: Code[20]; ToExtend: Boolean; TravelNo: Code[20])
    var
        // EmpAct: Record "Employee Activity" temporary;
        TravelRequest: Record "Travel Request" temporary;
        TravelRequest2: Record "Travel Request";
    //EmpAct2: Record "Employee Activity";
    begin
        TravelRequest.Init;
        TravelRequest.Validate("Employee No.", EmpCode);
        TravelRequest.Validate("Functional Title", Employee."Functional Title");
        TravelRequest.Validate(Type, TravelRequest.Type::"Travel Request");
        TravelRequest.Validate("Approval Status", TravelRequest."Approval Status"::Open);
        TravelRequest.Validate("Requested Date", Today);
        Employee.Get(EmpCode);
        TravelRequest.Validate("Shortcut Dimension 1 Code", Employee."Global Dimension 1 Code");
        TravelRequest.Validate(Department, Employee."Department Code");
        if ToExtend then begin
            Clear(TravelRequest2);
            TravelRequest2.Get(TravelNo);
            TravelRequest.Validate("Travel Order No.", TravelNo);
            TravelRequest.Validate("Start Date", TravelRequest2."End Date" + 1);
        end;
        TravelRequest.Insert;
        PAGE.Run(PAGE::"Travel Request Form", TravelRequest);
    end;

    procedure CalculateNoOfDaysTravel(StartDate: Date; EndDate: Date; Empcode: Code[20]): Decimal
    var
        DateError: Label 'Start Date (%1) must be less than End Date (%2).';
        LeaveTypeSetup: Record "Leave Type Setup";
        Difference: Decimal;
    begin
        if StartDate > EndDate then
            Error(DateError, StartDate, EndDate)
        else
            exit(EndDate - StartDate + 1);
    end;

    procedure CalcExtendDays(NoOfDays: Decimal; TravelOrderNo: Code[20]): Decimal
    var
        EmpAct: Record "Employee Activity";
    begin
        if EmpAct.Get(TravelOrderNo) then
            exit(EmpAct."Total No. of Days");
    end;

    procedure ApplyForTravel(TravelReq: Record "Travel Request" temporary): Boolean
    var
        TravelRequest: Record "Travel Request";
        ConfirmTravel: Label 'Do you want to send travel request ?';
        ErrorNoOfDays: Label 'No. of Travel days must be greater than 0.';
        TravelRequest2: Record "Travel Request";
        Date: Record Date;
    begin
        if GuiAllowed then
            if not Confirm(ConfirmTravel, false) then
                exit;
        TravelReq.TestField("Start Date");
        TravelReq.TestField("End Date");
        //TempEmpAct.TESTFIELD("Travel Countries");
        TravelReq.TestField("Type Of Visit");
        TravelReq.TestField("Depature Time");
        TravelReq.TestField("Arrival Time");
        TravelReq.TestField("Depature From");
        TravelReq.TestField(Destination);
        TravelReq.TestField("Purpose of Travel");
        //CheckLeaveConflict(TempEmpAct."Employee No.",TempEmpAct."Start Date",TempEmpAct."End Date");

        TravelRequest.Reset;
        TravelRequest.SetRange("Employee No.", TravelReq."Employee No.");
        TravelRequest.SetRange(Type, TravelRequest.Type::"Travel Request");
        TravelRequest.SetFilter("Approval Status", '<>%1', TravelRequest."Approval Status"::Rejected);
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

        TravelRequest.Init;
        TravelRequest.TransferFields(TravelReq);
        TravelRequest.TestField("Approver Code");
        TravelRequest.Validate("Total No. of Days", TravelRequest."No. of Days" + CalcExtendDays(TravelRequest."No. of Days", TravelRequest."Travel Order No."));
        //api>>
        if not GuiAllowed then
            if TravelRequest."Advance Cash" > 0 then
                TravelRequest."Advance Cash Required" := true;
        //<<api



        if TravelRequest."Recommender Code" = '' then
            TravelRequest.Validate("Approval Status", TravelRequest."Approval Status"::Recommended)
        else
            TravelRequest.Validate("Approval Status", TravelRequest."Approval Status"::"Pending Approval");
        TravelRequest.Validate("User ID", UserId);
        TravelRequest.Insert(true);
        if not (TravelReq."Travel Order No." = '') then begin
            TravelRequest2.Get(TravelReq."Travel Order No.");
            TravelRequest2.TestField("Approval Status", TravelRequest2."Approval Status"::Approved);
            if TravelRequest2.Extended then
                Error('Travel order no. %1 has already been extended.', TravelRequest2."No.");
            TravelRequest2.Validate(Extended, true);
            TravelRequest2.Modify;
        end;
        HRmgt.SendMailFromTemplate(DATABASE::"Employee Activity", TravelRequest.Type::"Travel Request", TravelRequest."Approval Status"::Open, '', TravelRequest."Employee No.", TravelRequest."No.", 0);   //For email
        Message('Travel Request has been sent for apporval.');
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

    local procedure "-----Travel Claimed-----"()
    begin
    end;

    procedure OpenTravelClaimed(EmpCode: Code[20]; TravelOrderNo: Code[20]; TravelWith: Code[20]; TravelCountry: Option Nepal,India,"Other Countries")
    var
        EmpAct: Record "Employee Activity" temporary;
        TravelRequest: Record "Travel Request" temporary;
        SalaryLevel: Record "Salary Level";
        Employee1: Record Employee;
        SalaryLevel1: Record "Salary Level";
        //EmpAct2: Record "Employee Activity";
        TravelRequest2: Record "Travel Request";
    begin
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
        TravelRequest.Validate("Travel Countries", TravelCountry);
        TravelRequest.Validate("Claimed Country", Format(TravelCountry));
        TravelRequest.Validate("Approval Status", TravelRequest."Approval Status"::Open);
        TravelRequest.Validate("Start Date", GetTravelStartDate(TravelOrderNo));
        TravelRequest.Validate("End Date", GetTravelEndDate(TravelOrderNo));
        TravelRequest.Validate("Requested Date", Today);
        TravelRequest.Validate("Travel Order No.", TravelOrderNo);
        TravelRequest.Validate("No. of Days", CalculateTotalNoDays(TravelOrderNo));
        TravelRequest."Travel With" := TravelWith;
        //EmpAct.VALIDATE("Claimed Country", );
        TravelRequest.Validate("Estimated Conveyance Expense", CalculateTotalEstimatedConv(TravelOrderNo));
        TravelRequest.Validate("Estimated Fooding Cost", CalculateTotalFooding(TravelOrderNo));
        TravelRequest.Validate("Estimated Lodging Cost", CalculateTotalLodging(TravelOrderNo));
        TravelRequest.Validate("Estimated Transportation Cost", CalculateTotalTransport(TravelOrderNo));
        TravelRequest.Validate("Other Estimated Cost", CalculateTotalOtherExpense(TravelOrderNo));
        TravelRequest.Validate("Total Estimated Cost", CalculateTotalEstimatedCost(TravelOrderNo));
        TravelRequest.Validate("Advance Cash", CalculateTotalAdvance(TravelOrderNo));
        if TravelRequest."Travel Countries" = TravelRequest."Travel Countries"::Nepal then begin
            if SalaryLevel1."Nepal Fooding Allowance" > SalaryLevel."Nepal Fooding Allowance" then begin//AT
                TravelRequest.Validate("Fooding Allowance", SalaryLevel1."Nepal Fooding Allowance" * TravelRequest."No. of Days");
                TravelRequest.Validate("Fooding Allowance Limit", SalaryLevel1."Nepal Fooding Allowance" * TravelRequest."No. of Days");
                TravelRequest.Validate("Fooding Per Day Limit", SalaryLevel1."Nepal Fooding Allowance");
            end else begin
                TravelRequest.Validate("Fooding Allowance Limit", SalaryLevel."Nepal Fooding Allowance" * TravelRequest."No. of Days");
                TravelRequest.Validate("Fooding Per Day Limit", SalaryLevel."Nepal Fooding Allowance");
            end;
            if SalaryLevel1."Nepal Lodging Allowance" > SalaryLevel."Nepal Lodging Allowance" then begin//AT
                TravelRequest.Validate("Lodging Allowance", SalaryLevel1."Nepal Lodging Allowance" * (TravelRequest."No. of Days" - 1));
                TravelRequest.Validate("Lodging Allowance Limit", SalaryLevel1."Nepal Lodging Allowance" * (TravelRequest."No. of Days" - 1));
                TravelRequest.Validate("Lodging Per Day Limit", SalaryLevel1."Nepal Lodging Allowance");
            end else begin
                TravelRequest.Validate("Lodging Allowance", SalaryLevel."Nepal Lodging Allowance" * (TravelRequest."No. of Days" - 1));
                TravelRequest.Validate("Lodging Allowance Limit", SalaryLevel."Nepal Lodging Allowance" * (TravelRequest."No. of Days" - 1));
                TravelRequest.Validate("Lodging Per Day Limit", SalaryLevel."Nepal Lodging Allowance");
            end;
        end
        else if TravelRequest."Travel Countries" = TravelRequest."Travel Countries"::India then begin
            if SalaryLevel1."India Fooding Allowance" > SalaryLevel."India Fooding Allowance" then begin//AT
                TravelRequest.Validate("Fooding Allowance", SalaryLevel1."India Fooding Allowance" * TravelRequest."No. of Days");
                TravelRequest.Validate("Fooding Allowance Limit", SalaryLevel1."India Fooding Allowance" * TravelRequest."No. of Days");
                TravelRequest.Validate("Fooding Per Day Limit", SalaryLevel1."India Fooding Allowance");

            end else begin
                TravelRequest.Validate("Fooding Allowance", SalaryLevel."India Fooding Allowance" * TravelRequest."No. of Days");
                TravelRequest.Validate("Fooding Allowance Limit", SalaryLevel."India Fooding Allowance" * TravelRequest."No. of Days");
                TravelRequest.Validate("Fooding Per Day Limit", SalaryLevel."India Fooding Allowance");

            end;
            if SalaryLevel1."India Lodging Allowance" > SalaryLevel."India Lodging Allowance" then begin//AT
                TravelRequest.Validate("Lodging Allowance", SalaryLevel1."India Lodging Allowance" * (TravelRequest."No. of Days" - 1));
                TravelRequest.Validate("Lodging Allowance Limit", SalaryLevel1."India Lodging Allowance" * (TravelRequest."No. of Days" - 1));
                TravelRequest.Validate("Lodging Per Day Limit", SalaryLevel1."India Lodging Allowance");

            end else begin
                TravelRequest.Validate("Lodging Allowance", SalaryLevel."India Lodging Allowance" * (TravelRequest."No. of Days" - 1));
                TravelRequest.Validate("Lodging Allowance Limit", SalaryLevel."India Lodging Allowance" * (TravelRequest."No. of Days" - 1));
                TravelRequest.Validate("Lodging Per Day Limit", SalaryLevel."India Lodging Allowance");

            end;
        end;
        TravelRequest."Arrival Time" := GetArrivalTime(TravelOrderNo);
        TravelRequest."Depature Time" := GetDepatureTime(TravelOrderNo);
        TravelRequest."Actual Travel Start Date" := GetTravelStartDate(TravelOrderNo);
        TravelRequest."Actual Travel End Date" := GetTravelEndDate(TravelOrderNo);
        TravelRequest."Actual Travel Start Time" := GetDepatureTime(TravelOrderNo);
        TravelRequest."Actual Travel End Time" := GetArrivalTime(TravelOrderNo);
        TravelRequest.Validate("Out of Pocket Expense", (SalaryLevel."Out of Pocket Expense" *
              GetOutofExpneseDuration(TravelRequest."Actual Travel Start Time", TravelRequest."Actual Travel End Time", TravelRequest."Start Date", TravelRequest."End Date")));

        if TravelRequest."Advance Cash" <> 0 then
            TravelRequest."Advance Cash Required" := true;
        TravelRequest.Insert;
        PAGE.RunModal(PAGE::"Request Travel Claim", TravelRequest);
    end;

    procedure CalculateTotalNoDays(TravelOrderNo: Code[20]): Decimal
    var
        //EmpAct: Record "Employee Activity";
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
        //EmpAct: Record "Employee Activity";
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
        //EmpAct: Record "Employee Activity";
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
        //EmpAct: Record "Employee Activity";
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
        // EmpAct: Record "Employee Activity";
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
        // EmpAct: Record "Employee Activity";
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
        // EmpAct: Record "Employee Activity";
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
        // EmpAct: Record "Employee Activity";
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
        // EmpAct: Record "Employee Activity";
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
        // EmpAct: Record "Employee Activity";
        TravelRequest: Record "Travel Request";
    begin
        if TravelRequest.Get(TravelOrderNo) then begin
            exit(TravelRequest."End Date");
        end;
    end;

    procedure GetOutofExpneseDuration(DepatureTime: Time; ArrivalTime: Time; DepartureDate: Date; ArrivalDate: Date): Decimal
    var
        Duration1: Duration;
        Duration2: Duration;
        TotalDuration: Decimal;
        NoofDays: Integer;
    begin
        if (DepartureDate = 0D) or (ArrivalDate = 0D) then
            exit;
        HRSetup.Get;
        //Duration1 :=(CREATEDATETIME(TODAY,0T) - CREATEDATETIME(TODAY-1,DepatureTime));
        //Duration2 := (CREATEDATETIME(TODAY,ArrivalTime) - (CREATEDATETIME(TODAY,0T)));
        TotalDuration := (CreateDateTime(ArrivalDate, ArrivalTime) - CreateDateTime(DepartureDate, DepatureTime)) / 1000 / 60 / 60;

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
        // EmpAct: Record "Employee Activity";
        TravelRequest: Record "Travel Request";
    begin
        if TravelRequest.Get(TravelOrderNo) then begin
            if not (TravelRequest."Travel Order No." = '') then
                exit(GetDepatureTime(TravelRequest."Travel Order No."))
            else
                exit(TravelRequest."Depature Time");
        end;
    end;

    procedure GetArrivalTime(TravelOrderNo: Code[20]): Time
    var
        // EmpAct: Record "Employee Activity";
        TravelRequest: Record "Travel Request";
    begin
        if TravelRequest.Get(TravelOrderNo) then begin
            exit(TravelRequest."Arrival Time");
        end;
    end;

    procedure ApplyForTravelClaim(TravelReq: Record "Travel Request" temporary): Boolean
    var
        TravelRequest: Record "Travel Request";
        ConfirmTravel: Label 'Do you want to send travel request ?';
        ErrorNoOfDays: Label 'No. of Travel days must be greater than 0.';
        TravelRequest2: Record "Travel Request";
        SalaryLevel1: Record "Salary Level";
        SalaryLevel: Record "Salary Level";
    begin
        if GuiAllowed then
            if not Confirm(ConfirmTravel, false) then
                exit(false);
        TravelReq.TestField("Start Date");
        TravelReq.TestField("End Date");
        TravelReq.TestField("Claim Type");
        if TravelRequest2.Get(TravelReq."Travel Order No.") then
            if (TravelRequest2."Travel Claimed") then
                Error('Travel order no. %1 has already been claimed.', TravelRequest2."No.");

        TravelReq.TestField("Purpose of Travel");
        if TravelReq."No. of Days" <= 0 then
            Error(ErrorNoOfDays);
        Employee.Get(TravelReq."Employee No.");
        Clear(TravelRequest);
        SalaryLevel.Get(Employee."Salary Level");
        if TravelReq."Travel With" <> '' then begin//AT
            Employee1.Get(TravelReq."Travel With");
            if not SalaryLevel."Travel With Not Eligible" then
                SalaryLevel1.Get(Employee1."Salary Level");
        end;


        TravelRequest.Init;
        TravelRequest.TransferFields(TravelReq);
        TravelRequest.Validate("Travel With", TravelRequest2."Travel With");
        TravelRequest.Validate("Type Of Visit", TravelRequest2."Type Of Visit");
        TravelRequest.Validate(Destination, TravelRequest2.Destination);
        TravelRequest.Validate("Depature From", TravelRequest2."Depature From");
        TravelRequest.Validate(Description, TravelRequest2.Description);
        TravelRequest.Validate("Mode Of Travel", TravelRequest2."Mode Of Travel");
        TravelRequest.Validate("Estimated Conveyance Expense", CalculateTotalEstimatedConv(TravelRequest2."No."));
        TravelRequest.Validate("Estimated Fooding Cost", CalculateTotalFooding(TravelRequest2."No."));
        TravelRequest.Validate("Estimated Lodging Cost", CalculateTotalLodging(TravelRequest2."No."));
        TravelRequest.Validate("Estimated Transportation Cost", CalculateTotalTransport(TravelRequest2."No."));
        TravelRequest.Validate("Total Estimated Cost", CalculateTotalEstimatedCost(TravelRequest2."No."));
        TravelRequest.Validate("Other Estimated Cost", CalculateTotalOtherExpense(TravelRequest2."No."));

        if TravelRequest."Travel Countries" = TravelRequest."Travel Countries"::Nepal then begin
            if SalaryLevel1."Nepal Fooding Allowance" > SalaryLevel."Nepal Fooding Allowance" then begin//AT
                TravelRequest.Validate("Fooding Allowance Limit", SalaryLevel1."Nepal Fooding Allowance" * TravelRequest."No. of Days");
                TravelRequest.Validate("Fooding Per Day Limit", SalaryLevel1."Nepal Fooding Allowance");
            end else begin
                TravelRequest.Validate("Fooding Allowance Limit", SalaryLevel."Nepal Fooding Allowance" * TravelRequest."No. of Days");
                TravelRequest.Validate("Fooding Per Day Limit", SalaryLevel."Nepal Fooding Allowance");
            end;
            if SalaryLevel1."Nepal Lodging Allowance" > SalaryLevel."Nepal Lodging Allowance" then begin//AT
                TravelRequest.Validate("Lodging Allowance Limit", SalaryLevel1."Nepal Lodging Allowance" * (TravelRequest."No. of Days" - 1));
                TravelRequest.Validate("Lodging Per Day Limit", SalaryLevel1."Nepal Lodging Allowance");
            end else begin
                TravelRequest.Validate("Lodging Allowance Limit", SalaryLevel."Nepal Lodging Allowance" * (TravelRequest."No. of Days" - 1));
                TravelRequest.Validate("Lodging Per Day Limit", SalaryLevel."Nepal Lodging Allowance");
            end;
        end
        else if TravelRequest."Travel Countries" = TravelRequest."Travel Countries"::India then begin
            if SalaryLevel1."India Fooding Allowance" > SalaryLevel."India Fooding Allowance" then begin//AT
                TravelRequest.Validate("Fooding Allowance Limit", SalaryLevel1."India Fooding Allowance" * TravelRequest."No. of Days");
                TravelRequest.Validate("Fooding Per Day Limit", SalaryLevel1."India Fooding Allowance");

            end else begin
                TravelRequest.Validate("Fooding Allowance Limit", SalaryLevel."India Fooding Allowance" * TravelRequest."No. of Days");
                TravelRequest.Validate("Fooding Per Day Limit", SalaryLevel."India Fooding Allowance");

            end;
            if SalaryLevel1."India Lodging Allowance" > SalaryLevel."India Lodging Allowance" then begin//AT
                TravelRequest.Validate("Lodging Allowance Limit", SalaryLevel1."India Lodging Allowance" * (TravelRequest."No. of Days" - 1));
                TravelRequest.Validate("Lodging Per Day Limit", SalaryLevel1."India Lodging Allowance");

            end else begin
                TravelRequest.Validate("Lodging Allowance Limit", SalaryLevel."India Lodging Allowance" * (TravelRequest."No. of Days" - 1));
                TravelRequest.Validate("Lodging Per Day Limit", SalaryLevel."India Lodging Allowance");

            end;
        end;

        HRSetup.Get;
        Employee1.Reset;
        Employee1.SetRange("Functional Title", HRSetup."HR Head Functional Title");
        Employee1.SetRange(Status, Employee1.Status::Active); //Min
        if Employee1.FindFirst then
            TravelRequest.Validate("Final Approver", Employee1."No.");

        TravelRequest.Validate("Requested Date", Today);
        TravelRequest.Validate("Approval Status", TravelRequest."Approval Status"::"Pending Approval");
        TravelRequest.Validate("User ID", UserId);
        TravelRequest.TestField("Approver Code");
        if TravelRequest."Recommender Code" = '' then
            TravelRequest.Validate("Approval Status", TravelRequest."Approval Status"::Recommended)
        else
            TravelRequest.Validate("Approval Status", TravelRequest."Approval Status"::"Pending Approval");
        TravelRequest.Validate("Total Claimed Amount");
        TravelRequest.Insert(true);
        HRmgt.SendMailFromTemplate(DATABASE::"Employee Activity", TravelRequest.Type::"Travel Claim", TravelRequest."Approval Status"::Open, '', TravelRequest."Employee No.", TravelRequest."No.", 0);   //For email
        Message('Travel Claim has been sent for apporval.');
        TravelRequest2."Travel Claimed" := true;
        TravelRequest2.Modify;
        exit(true);
    end;

    procedure FinalApproveForTravel(var Travel: Record "Travel Request")
    var
        ConfirmScreen: Label 'Do you want to confirm screen this document?';
        FunctionalTitle: Record "Functional Title";
    begin
        //check authorized user
        if Travel.Type = Travel.Type::"Travel Claim" then begin
            HRSetup.Get;
            if Employee.Get(HRmgt.GetEmployeeNo) then;

            if Employee."No." <> Travel."Final Approver" then
                Error('Not authorized Approver.');//AT
            Travel.TestField(Travel."Approval Status", Travel."Approval Status"::Screened);
            if not Confirm('Do you want to final approve this document?', false) then
                exit;

            Travel.Validate("Approval Status", Travel."Approval Status"::"Final Approved & Forwarded to Finance Department");
            Travel.Modify;
        end;
    end;

    procedure FinalApproveForTravelAPI(var Travel: Record "Travel Request"; ApproverID: code[20])
    var
        ConfirmScreen: Label 'Do you want to confirm screen this document?';
        FunctionalTitle: Record "Functional Title";
    begin
        //check authorized user
        if Travel.Type = Travel.Type::"Travel Claim" then begin
            if Employee.Get(ApproverID) then;

            if Employee."No." <> Travel."Final Approver" then
                Error('Not authorized Approver.');//AT
            Travel.TestField(Travel."Approval Status", Travel."Approval Status"::Recommended);
            // if not Confirm('Do you want to final approve this document?', false) then
            //     exit;

            Travel.Validate("Approval Status", Travel."Approval Status"::"Final Approved & Forwarded to Finance Department");
            Travel.Modify;
        end;
    end;

    procedure PopUpChangingApprover(EmployeeActivity: Record "Employee Activity")
    var
        TravelClaimPageBuilder: FilterPageBuilder;
        EmpAct: Record "Employee Activity";
    begin
        TravelClaimPageBuilder.AddRecord('Change Approver', EmpAct);
        TravelClaimPageBuilder.ADdField('Change Approver', EmpAct."Final Approver");
        if TravelClaimPageBuilder.RunModal then begin
            EmpAct.SetView(TravelClaimPageBuilder.GetView('Change Approver'));

            if EmpAct.GetFilter("Final Approver") = '' then
                Error('Approver Code cannot be blank.');

            EmployeeActivity.Validate("Final Approver", EmpAct.GetFilter("Final Approver"));
            EmployeeActivity.Modify;
            Message('Updated');
        end;
    end;

    procedure ReturnTravelClaim(EmpActivity: Record "Employee Activity")
    var
        EmpActivityRec: Record "Employee Activity";
    begin
        // TESTFIELD("Approval Status","Approval Status"::"Forwarded To HR");
        if EmpActivity."Approval Status" = EmpActivity."Approval Status"::"Final Approved & Forwarded to Finance Department" then
            Error('Cannot return approved docuement');
        Employee.Reset;
        Employee.SetRange("NAV Login ID", UserId);
        Employee.FindFirst;
        if not Employee.Screener then
            Error('You are not eligible to return this document.');
        if Confirm('Do you want to return travel claim?', false) then begin
            EmpActivity.Validate("Approval Status", EmpActivity."Approval Status"::Open);
            EmpActivityRec.Reset; //Min -- For re-initiate returned travel claim.
            EmpActivityRec.SetRange("No.", EmpActivity."Travel Order No.");
            EmpActivityRec.SetRange(Type, EmpActivity.Type::"Travel Request");
            if EmpActivityRec.FindFirst then begin
                EmpActivityRec."Travel Claimed" := false;
                EmpActivityRec.Modify;
            end;
            EmpActivity.Modify;
            Message('Travel Claimed Retruned.');
        end;
    end;

    procedure RecommendEmployeeTravel(EmpTravelCode: Code[20])
    var
        //EmpAct: Record "Employee Activity";
        EmpTravel: Record "Travel Request";
    begin
        EmpTravel.Get(EmpTravelCode);
        EmpTravel.TestField("Approval Status", EmpTravel."Approval Status"::"Pending Approval");
        CheckEmployeeTravelApproval(EmpTravel);
        EmpTravel.Validate("Approval Status", EmpTravel."Approval Status"::Recommended);
        EmpTravel.Modify;
        Message('The document has been recommended.');
    end;

    procedure RecommendEmployeeTravelAPI(EmpTravelCode: Code[20]; ApproverCode: Code[20])
    var
        //EmpAct: Record "Employee Activity";
        EmpTravel: Record "Travel Request";
    begin
        EmpTravel.Get(EmpTravelCode);
        EmpTravel.TestField("Approval Status", EmpTravel."Approval Status"::"Pending Approval");
        CheckEmployeeTravelApprovalAPI(EmpTravel, ApproverCode);
        EmpTravel.Validate("Approval Status", EmpTravel."Approval Status"::Recommended);
        EmpTravel.Modify;
        Message('The document has been recommended.');
    end;

    local procedure CheckEmployeeTravelApproval("Travel Request": Record "Travel Request")
    var
        ApproveNotEligibleError: Label 'You are not Eligible to approve or reject this document ';
        RecommendNotEligibleError: Label 'You are not Eligible to recommend or reject this document ';
        AcknowledgeError: Label 'You are not Eligible to acknowledge this document.';
    begin
        Employee.Reset;
        Employee.SetRange("NAV Login ID", UserId);
        Employee.FindFirst;
        if "Travel Request"."Approval Status" = "Travel Request"."Approval Status"::"Pending Approval" then
            if StrPos("Travel Request"."Recommender Code", Employee."No.") = 0 then
                Error(RecommendNotEligibleError);
        if "Travel Request"."Approval Status" = "Travel Request"."Approval Status"::Recommended then
            if StrPos("Travel Request"."Approver Code", Employee."No.") = 0 then
                Error(ApproveNotEligibleError);

        //IF EmpAct."Approval Status" = EmpAct."Approval Status"::Approved THEN
        //IF STRPOS(EmpAct."Incoming Branch Rep. Person", Employee."No.") = 0 THEN
        //ERROR(AcknowledgeError);
    end;

    local procedure CheckEmployeeTravelApprovalAPI("Travel Request": Record "Travel Request"; ApproverCode: Code[20])
    var
        ApproveNotEligibleError: Label 'You are not Eligible to approve or reject this document ';
        RecommendNotEligibleError: Label 'You are not Eligible to recommend or reject this document ';
        AcknowledgeError: Label 'You are not Eligible to acknowledge this document.';
    begin
        Employee.Reset;
        Employee.SetRange("No.", ApproverCode);
        Employee.FindFirst;
        if "Travel Request"."Approval Status" = "Travel Request"."Approval Status"::"Pending Approval" then
            if StrPos("Travel Request"."Recommender Code", Employee."No.") = 0 then
                Error(RecommendNotEligibleError);
        if "Travel Request"."Approval Status" = "Travel Request"."Approval Status"::Recommended then
            if StrPos("Travel Request"."Approver Code", Employee."No.") = 0 then
                Error(ApproveNotEligibleError);

        //IF EmpAct."Approval Status" = EmpAct."Approval Status"::Approved THEN
        //IF STRPOS(EmpAct."Incoming Branch Rep. Person", Employee."No.") = 0 THEN
        //ERROR(AcknowledgeError);
    end;

    procedure ApprovedRejectTravelApproval(Approved: Boolean; TravelCode: Code[20])
    var

        //EmpAct: Record "Employee Activity";
        TravelRequest: Record "Travel Request";
        LeaveEarn: Record "Leave Earn";
        ApprovalStatusError: Label 'Approval Status must be %1 or %2.';
        ErrorReject: Label 'Approval Status must be in %1 or %2.';
        EmpAttendActivity: Record "Employee Attendance & Activity";
        LeaveTypeSetup: Record "Leave Type Setup";
        //EmpAct2: Record "Employee Activity";
        TravelRequest2: Record "Travel Request";
    begin
        TravelRequest.Get(TravelCode);

        if TravelRequest.Type = TravelRequest.Type::"Travel Request" then begin
            if Approved then begin
                TravelRequest.TestField("Approval Status", TravelRequest."Approval Status"::Recommended);
                CheckEmployeeTravelApproval(TravelRequest);
                TravelRequest.Validate("Approval Status", TravelRequest."Approval Status"::Approved);
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

                HRMgt.SendMailFromTemplate(DATABASE::"Travel Request", TravelRequest.Type, TravelRequest."Approval Status"::Approved, '', TravelRequest."Approver Code", TravelRequest."No.", 0);   //For email
                Message('The document has been approved.');
            end else
                if (TravelRequest."Approval Status" in [TravelRequest."Approval Status"::"Pending Approval", TravelRequest."Approval Status"::Recommended]) then begin
                    TravelRequest.TestField("Rejection Remarks");
                    if TravelRequest.Type = TravelRequest.Type::"Travel Claim" then begin
                        TravelRequest.TestField("Travel Order No.");
                        TravelRequest2.Get(TravelRequest."Travel Order No.");
                        TravelRequest2.Validate("Travel Claimed", false);
                        TravelRequest2.Modify;
                    end;
                    CheckEmployeeTravelApproval(TravelRequest);
                    if TravelRequest."Approval Status" = TravelRequest."Approval Status"::"Pending Approval" then
                        HRMgt.SendMailFromTemplate(DATABASE::"Travel Request", TravelRequest.Type, TravelRequest."Approval Status"::Rejected, '', TravelRequest."Recommender Code", TravelRequest."No.", 0)  //For email
                    else
                        HRMgt.SendMailFromTemplate(DATABASE::"Travel Request", TravelRequest.Type, TravelRequest."Approval Status"::Rejected, '', TravelRequest."Approver Code", TravelRequest."No.", 0);   //For email
                    TravelRequest.Validate("Approval Status", TravelRequest."Approval Status"::Rejected);
                    Message('The document has been rejected.');
                end else
                    Error('Cannot reject the document.');
        end;
        TravelRequest.Posted := true;
        TravelRequest."Approved Date" := Today;
        TravelRequest.Modify;
    end;

    procedure ApprovedRejectTravelApprovalAPI(Approved: Boolean; TravelCode: Code[20]; ApproverCode: Code[20])
    var

        //EmpAct: Record "Employee Activity";
        TravelRequest: Record "Travel Request";
        LeaveEarn: Record "Leave Earn";
        ApprovalStatusError: Label 'Approval Status must be %1 or %2.';
        ErrorReject: Label 'Approval Status must be in %1 or %2.';
        EmpAttendActivity: Record "Employee Attendance & Activity";
        LeaveTypeSetup: Record "Leave Type Setup";
        //EmpAct2: Record "Employee Activity";
        TravelRequest2: Record "Travel Request";
    begin
        TravelRequest.Get(TravelCode);
        if Approved then begin
            TravelRequest.TestField("Approval Status", TravelRequest."Approval Status"::Recommended);
            CheckEmployeeTravelApprovalAPI(TravelRequest, ApproverCode);
            TravelRequest.Validate("Approval Status", TravelRequest."Approval Status"::Approved);
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

            HRMgt.SendMailFromTemplate(DATABASE::"Travel Request", TravelRequest.Type, TravelRequest."Approval Status"::Approved, '', TravelRequest."Approver Code", TravelRequest."No.", 0);   //For email
            Message('The document has been approved.');
        end else
            if (TravelRequest."Approval Status" in [TravelRequest."Approval Status"::"Pending Approval", TravelRequest."Approval Status"::Recommended]) then begin
                TravelRequest.TestField("Rejection Remarks");
                if TravelRequest.Type = TravelRequest.Type::"Travel Claim" then begin
                    TravelRequest.TestField("Travel Order No.");
                    TravelRequest2.Get(TravelRequest."Travel Order No.");
                    TravelRequest2.Validate("Travel Claimed", false);
                    TravelRequest2.Modify;
                end;
                CheckEmployeeTravelApprovalAPI(TravelRequest, ApproverCode);
                if TravelRequest."Approval Status" = TravelRequest."Approval Status"::"Pending Approval" then
                    HRMgt.SendMailFromTemplate(DATABASE::"Travel Request", TravelRequest.Type, TravelRequest."Approval Status"::Rejected, '', TravelRequest."Recommender Code", TravelRequest."No.", 0)  //For email
                else
                    HRMgt.SendMailFromTemplate(DATABASE::"Travel Request", TravelRequest.Type, TravelRequest."Approval Status"::Rejected, '', TravelRequest."Approver Code", TravelRequest."No.", 0);   //For email
                TravelRequest.Validate("Approval Status", TravelRequest."Approval Status"::Rejected);
                Message('The document has been rejected.');
            end else
                Error('Cannot reject the document.');

        TravelRequest.Posted := true;
        TravelRequest."Approved Date" := Today;
        TravelRequest.Modify;
    end;

    procedure ScreenResignationforTravel(var TravelReq: Record "Travel Request")
    var
        ConfirmScreen: Label 'Do you want to screen this document?';
        FunctionalTitle: Record "Functional Title";
    begin
        //check authorized user
        Employee.Get(HrMgt.GetEmployeeNo());
        if TravelReq.Type = TravelReq.Type::Resignation then begin
            if not Employee.Screener then           //resignation approver replaced with screener
                Error('Not authorized screener.');
            TravelReq.TestField("Approval Status", TravelReq."Approval Status"::"Forwarded To HR");
            //  EmpAct.TESTFIELD("Screener Remarks");
            HrMgt.CheckDocumentApprover(TravelReq."No.");
            CheckResignationAttachmentMandatoryforTravel(TravelReq);
            if not Confirm(ConfirmScreen, false) then
                exit;

            TravelReq.Validate("Approval Status", TravelReq."Approval Status"::Screened);
            TravelReq.Modify;
        end
        else if TravelReq.Type = TravelReq.Type::"Travel Claim" then begin
            /*HRSetup.GET;
            Employee.RESET;
            Employee.SETRANGE("Functional Title", HRSetup."HR Head Functional Title");
            Employee.SETRANGE("NAV Login ID", USERID);
            IF NOT Employee.FINDFIRST THEN
                ERROR('Not authorized screener.');*///AT
            if not (TravelReq."Approval Status" = TravelReq."Approval Status"::Recommended) then
                Error('Approval Status must be Recommended before screening.');
            if not Confirm(ConfirmScreen, false) then
                exit;

            TravelReq.Validate("Approval Status", TravelReq."Approval Status"::Screened);
            TravelReq.Modify;
        end else if TravelReq.Type = TravelReq.Type::Overtime then begin
            TravelReq.TestField("Approval Status", TravelReq."Approval Status"::Approved);
            if not Confirm(ConfirmScreen, false) then
                exit;

            TravelReq.Validate("Approval Status", TravelReq."Approval Status"::Screened);
            TravelReq.Modify;
        end;
    end;

    procedure CheckResignationAttachmentMandatoryforTravel(var TravelReq: Record "Travel Request")
    var
        AttachmentSetup: Record "Attachment Setup";
        IncomingDocument: Record "Incoming Document";
    begin

        IncomingDocument.Reset;
        IncomingDocument.SetRange("No.", TravelReq."No.");
        IncomingDocument.SetRange("File Name", '');
        if IncomingDocument.FindFirst then
            repeat
                AttachmentSetup.Reset;
                AttachmentSetup.SetRange(Mandatory, true);
                AttachmentSetup.SetFilter(Type, Format(TravelReq.Type));
                AttachmentSetup.SetRange("Attachment Code", IncomingDocument."Attachment Code");
                if AttachmentSetup.FindFirst then
                    Error('Upload attachment for %1', IncomingDocument."Attachment Code");

            until IncomingDocument.Next = 0;
    end;





    var
        Employee: Record Employee;
        HRMgt: Codeunit "HR Mgt.";
        Employee1: Record Employee;
        HRSetup: Record "Human Resources Setup";
        LeaveMgt: Codeunit "Leave Mgt.";
        AttendanceSetup: Record "Attendance Setup";


}
