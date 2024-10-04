report 33019860 "Transfer Reports"
{
    // //Min -- Added Column "Incoming Supervisor" and "Incoming Supervisor Name" in Report Layout.
    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep33019860.TransferReports.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Employee Activity"; "Employee Activity")
        {
            DataItemTableView = where(Type = filter("Employee Transfer" | "HR Transfer"), "Employee No." = filter(<> ''));
            column(EmployeeNo_; "Employee No.") { }
            column(No_; "No.") { }
            column(EmployeeName_; "Employee Name") { }
            column(SalaryLevelCode_; "Salary Level Code") { }
            column(SalaryDescription; SalaryLevel.Description) { }
            column(TransferCategory_; "Transfer Category") { }
            column(TransferType_; "Transfer Type") { }
            column(TransferEffectiveDate_; "Transfer Effective Date") { }
            column(FunctionalTitle_; "Functional Title") { }
            column(RequestedDate_; "Requested Date") { }
            column(FromFunctionalDescription_; FromFunctionTitle.Description) { }
            column(ToFunctionalDescription_; ToFunctionalTitle.Description) { }
            column(DeputationOnOutgoing_; "Deputation On") { }
            column(DeputationOnToIncoming_; "Deputation On (To)") { }
            column(ApprovedDate_; "Approved Date") { }
            column(ApprovalStatus_; "Approval Status") { }
            column(AcknowledgedDate_; "Date of Joining Of Transfer") { }
            column(Title; Title) { }
            column(TransferFrom; TransferFrom) { }
            column(TransferTo; TransferTo) { }
            column(FilterCaption; FilterCaption) { }
            column(StartDate_; "Start Date") { }
            column(EndDate_; "End Date") { }
            column(IncomingSupervisior_; "Incoming Supervisior") { }
            column(ApproverCode_; "Approver Code") { }
            column(ScreenerID_; "Screener ID") { }
            column(ScreenerDate_; "Screener Date") { }
            column(IncomingSupervisiorName_EmployeeActivity; "Employee Activity"."Incoming Supervisior Name") { }

            trigger OnAfterGetRecord()
            begin
                Clear(SalaryLevel);
                Clear(FromFunctionTitle);
                Clear(ToFunctionalTitle);
                if SalaryLevel.Get("Salary Level Code") then;
                if FromFunctionTitle.Get("Functional Title") then;
                if ToFunctionalTitle.Get("Functional Title (To)") then
                    TransferFrom := ExitTransferDeputationWise("Employee Activity"."Deputation On", true);
                TransferTo := ExitTransferDeputationWise("Employee Activity"."Deputation On (To)", false);
            end;

            trigger OnPreDataItem()
            begin
                Clear(FilterCaption);
                case ReportType of
                    ReportType::List:
                        begin
                            if (EffectiveEndDate <> 0D) and (EffectiveStartDate <> 0D) then begin
                                if EffectiveStartDate > EffectiveEndDate then
                                    Error('Effective Start date cannot be greater than effective end date');
                                SetFilter("Transfer Effective Date", '%1..%2', EffectiveStartDate, EffectiveEndDate);
                            end else if EffectiveEndDate <> 0D then
                                    SetFilter("Transfer Effective Date", '..%1', EffectiveEndDate)
                            else if EffectiveStartDate <> 0D then
                                SetFilter("Transfer Effective Date", '%1..', EffectiveStartDate);

                            if TransferCategory <> TransferCategory::" " then
                                SetRange("Transfer Category", TransferCategory);
                            FilterCaption := 'Date filter: ' + Format(EffectiveStartDate) + ' To ' + Format(EffectiveEndDate);
                            if TransferCategory <> TransferCategory::" " then
                                FilterCaption += ', Transfer Category: ' + Format(TransferCategory);
                            if RequestedDate <> 0D then
                                SetFilter("Requested Date", '%1', RequestedDate);
                        end;

                    ReportType::Monthly:
                        begin
                            if Year = 0 then
                                Error('Please type the Year.');
                            if Month = Month::" " then
                                Error('Please choose the month.');
                            EngNepDate.Reset;
                            EngNepDate.SetRange("Nepali Year", Year);
                            EngNepDate.SetRange("Nepali Month", Month);
                            if EngNepDate.FindFirst then
                                Startdate := EngNepDate."English Date";

                            Clear(EngNepDate);
                            EngNepDate.Reset;
                            EngNepDate.SetRange("Nepali Year", Year);
                            EngNepDate.SetRange("Nepali Month", Month);
                            if EngNepDate.FindLast then
                                EndDate := EngNepDate."English Date";
                            FilterCaption := 'Year: ' + Format(Year);
                            FilterCaption += ', Month: ' + Format(Month);
                            SetRange("Transfer Effective Date", Startdate, EndDate);
                        end;

                    ReportType::DeputationWise:
                        begin

                            if (EffectiveEndDate <> 0D) and (EffectiveStartDate <> 0D) then begin
                                if EffectiveStartDate > EffectiveEndDate then
                                    Error('Effective Start date cannot be greater than effective end date');
                                SetFilter("Transfer Effective Date", '%1..%2', EffectiveStartDate, EffectiveEndDate);
                            end else if EffectiveEndDate <> 0D then
                                    SetFilter("Transfer Effective Date", '..%1', EffectiveEndDate)
                            else if EffectiveStartDate <> 0D then
                                SetFilter("Transfer Effective Date", '%1..', EffectiveStartDate);

                            if DeputOn = DeputOn::" " then
                                Error('Please select Deputation on');
                            if Filteron = '' then
                                Error('Please select filter on');
                            if TransferCategory <> TransferCategory::" " then
                                SetRange("Transfer Category", TransferCategory);
                            if "Incoming/Outgoing" = "Incoming/Outgoing"::Incoming then
                                "Employee Activity".SetRange("Deputation On (To)", DeputOn)
                            else if "Incoming/Outgoing" = "Incoming/Outgoing"::Outgoing then
                                "Employee Activity".SetRange("Deputation On", DeputOn)
                            else begin
                                "Employee Activity".FilterGroup(-1);
                                "Employee Activity".SetRange("Deputation On", DeputOn);
                                "Employee Activity".SetRange("Deputation On (To)", DeputOn);
                                "Employee Activity".FilterGroup(0);
                            end;
                            FilterCaption := 'Date filter: ' + Format(EffectiveStartDate) + ' To ' + Format(EffectiveEndDate);
                            if TransferCategory <> TransferCategory::" " then
                                FilterCaption += ', Transfer Category: ' + Format(TransferCategory);
                            FilterCaption += ', Deputation on: ' + Format(DeputOn);

                            if RequestedDate <> 0D then
                                SetFilter("Requested Date", '%1', RequestedDate);
                            EmployeeActivityFilter;
                            FilterCaption += ', ' + Filteron;
                        end;
                end;
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                field("Report Type"; ReportType)
                {
                    ToolTip = 'Specifies the value of the ReportType field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        if ReportType = ReportType::List then begin
                            ListVisible := true;
                            MonthlyVisible := false;
                            DeputationVisbile := false;
                        end else if ReportType = ReportType::Monthly then begin
                            ListVisible := false;
                            MonthlyVisible := true;
                            DeputationVisbile := false;
                        end else begin
                            ListVisible := false;
                            MonthlyVisible := false;
                            DeputationVisbile := true;
                        end;
                    end;
                }
                group(List)
                {
                    Visible = ListVisible;
                    field("Effective Start Date"; EffectiveStartDate)
                    {
                        Caption = 'Tranfer Effective Start Date';
                        ToolTip = 'Specifies the value of the Tranfer Effective Start Date field.';
                        ApplicationArea = All;
                    }
                    field("Effective End Date"; EffectiveEndDate)
                    {
                        Caption = 'Tranfer Effective End Date';
                        ToolTip = 'Specifies the value of the Tranfer Effective End Date field.';
                        ApplicationArea = All;
                    }
                    field("Transfer Category"; TransferCategory)
                    {
                        ToolTip = 'Specifies the value of the TransferCategory field.';
                        ApplicationArea = All;
                    }
                    field("Requested Date"; RequestedDate)
                    {
                        ToolTip = 'Specifies the value of the RequestedDate field.';
                        ApplicationArea = All;
                    }
                }
                group(Monthly)
                {
                    Visible = MonthlyVisible;
                    field(Year; Year)
                    {
                        Caption = 'Nepali Year';
                        ToolTip = 'Specifies the value of the Nepali Year field.';
                        ApplicationArea = All;
                    }
                    field(Month; Month)
                    {
                        ToolTip = 'Specifies the value of the Month field.';
                        ApplicationArea = All;
                    }
                }
                group(DeputationWise)
                {
                    Visible = DeputationVisbile;
                    field(EffectiveStartDates; EffectiveStartDate)
                    {
                        Caption = 'Tranfer Start Effective Date';
                        ToolTip = 'Specifies the value of the Tranfer Start Effective Date field.';
                        ApplicationArea = All;
                    }
                    field("Effective End Dates"; EffectiveEndDate)
                    {
                        Caption = 'Tranfer Effective Start Date';
                        ToolTip = 'Specifies the value of the Tranfer Effective Start Date field.';
                        ApplicationArea = All;
                    }
                    field("Transfers Category"; TransferCategory)
                    {
                        Caption = 'Transfer Category';
                        ToolTip = 'Specifies the value of the Transfer Category field.';
                        ApplicationArea = All;
                    }
                    field("Deputation on"; DeputOn)
                    {
                        ToolTip = 'Specifies the value of the DeputOn field.';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            Clear(Filteron);
                        end;
                    }
                    field(RequestedDate1; RequestedDate)
                    {
                        Caption = 'Requested Date';
                        ToolTip = 'Specifies the value of the Requested Date field.';
                        ApplicationArea = All;
                    }
                    field("Filter On"; Filteron)
                    {
                        ToolTip = 'Specifies the value of the Filteron field.';
                        ApplicationArea = All;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            case DeputOn of
                                DeputOn::Branch:
                                    begin
                                        DimValue.Reset;
                                        DimValue.SetRange("Dimension Code", GLSetup."Global Dimension 1 Code");
                                        Clear(PageDimValue);
                                        PageDimValue.SetRecord(DimValue);
                                        PageDimValue.SetTableView(DimValue);
                                        PageDimValue.LookupMode(true);
                                        if PageDimValue.RunModal = Action::LookupOK then begin
                                            PageDimValue.GetRecord(DimValue);
                                            Filteron := DimValue.Code;
                                        end;
                                    end;

                                DeputOn::Department:
                                    begin
                                        Clear(Depart);
                                        Clear(PageDepart);
                                        PageDepart.LookupMode(true);
                                        if PageDepart.RunModal = Action::LookupOK then begin
                                            PageDepart.GetRecord(Depart);
                                            Filteron := Depart.Code;
                                        end;
                                    end;

                                DeputOn::"Extension Counter":
                                    begin
                                        Clear(EmpHie);
                                        EmpHie.SetRange(Type, EmpHie.Type::"Extension Counter");
                                        Clear(PageEmpHie);
                                        PageEmpHie.SetRecord(EmpHie);
                                        PageEmpHie.SetTableView(EmpHie);
                                        PageEmpHie.LookupMode(true);
                                        if PageEmpHie.RunModal = Action::LookupOK then begin
                                            PageEmpHie.GetRecord(EmpHie);
                                            Filteron := EmpHie.Code;
                                        end;
                                    end;

                                DeputOn::Province:
                                    begin
                                        Clear(Province);
                                        Clear(PageProvince);
                                        PageProvince.LookupMode(true);
                                        if PageProvince.RunModal = Action::LookupOK then begin
                                            PageProvince.GetRecord(Province);
                                            Filteron := Province.Code;
                                        end;
                                    end;

                                DeputOn::"Sub Province":
                                    begin
                                        Clear(SubProvince);
                                        Clear(PageSubProvince);
                                        PageSubProvince.LookupMode(true);
                                        if PageSubProvince.RunModal = Action::LookupOK then begin
                                            PageSubProvince.GetRecord(SubProvince);
                                            Filteron := SubProvince.Code;
                                        end;
                                    end;

                                DeputOn::Unit:
                                    begin
                                        Clear(EmpHie);
                                        EmpHie.SetRange(Type, EmpHie.Type::Unit);
                                        Clear(PageEmpHie);
                                        PageEmpHie.SetRecord(EmpHie);
                                        PageEmpHie.SetTableView(EmpHie);
                                        PageEmpHie.LookupMode(true);
                                        if PageEmpHie.RunModal = Action::LookupOK then begin
                                            PageEmpHie.GetRecord(EmpHie);
                                            Filteron := EmpHie.Code;
                                        end;
                                    end;
                            end;
                        end;
                    }
                }
            }
        }

        actions { }

        trigger OnOpenPage()
        begin
            ListVisible := true;
            MonthlyVisible := false;
            DeputationVisbile := false
        end;
    }

    labels { }

    trigger OnInitReport()
    begin
        GLSetup.Get;
    end;

    var
        SalaryLevel: Record "Salary Level";
        FromFunctionTitle: Record "Functional Title";
        ToFunctionalTitle: Record "Functional Title";
        TransferFrom: Text;
        TransferTo: Text;
        GLSetup: Record "General Ledger Setup";
        Title: Label 'Transfer Report';
        ReportType: Option List,Monthly,DeputationWise;
        EffectiveStartDate: Date;
        EffectiveEndDate: Date;
        TransferCategory: Option " ",General,"Temporary",Officiating;
        Year: Integer;
        Month: Enum "Nepali Month";
        DeputOn: Option " ",Branch,"Extension Counter","Sub Province",Province,Unit,Department;
        Filteron: Text;
        [InDataSet]
        ListVisible: Boolean;
        [InDataSet]
        MonthlyVisible: Boolean;
        [InDataSet]
        DeputationVisbile: Boolean;
        "Incoming/Outgoing": Option " ",Incoming,Outgoing;
        Startdate: Date;
        EndDate: Date;
        EngNepDate: Record "English-Nepali Date";
        DimValue: Record "Dimension Value";
        Depart: Record Department;
        EmpHie: Record "Employee Hierarchy Master";
        Province: Record Province;
        SubProvince: Record "Sub Province";
        PageDimValue: Page "Dimension Values";
        PageProvince: Page "Provinces List";
        PageSubProvince: Page SubProvinceList;
        PageEmpHie: Page "Employee Hierarchy Master";
        PageDepart: Page Departments;
        FilterCaption: Text;
        RequestedDate: Date;

    local procedure ExitTransferDeputationWise(DeputationOn: Option " ",Branch,"Extension Counter","Sub Province",Province,Unit,Department; OutGoing: Boolean): Text
    begin
        Clear(DimValue);
        Clear(Depart);
        Clear(EmpHie);
        Clear(SubProvince);
        Clear(Province);
        case DeputationOn of
            DeputationOn::Branch:
                begin
                    if OutGoing then begin
                        if DimValue.Get(GLSetup."Global Dimension 1 Code", "Employee Activity"."Shortcut Dimension 1 Code") then
                            exit(DimValue.Name);
                    end else
                        if DimValue.Get(GLSetup."Global Dimension 1 Code", "Employee Activity"."Shortcut Dimension 1 Code (To)") then
                            exit(DimValue.Name);
                end;

            DeputationOn::Department:
                begin
                    if OutGoing then begin
                        if Depart.Get("Employee Activity".Department) then
                            exit(Depart.Name);
                    end else
                        if Depart.Get("Employee Activity"."Department Code (To)") then
                            exit(Depart.Name);
                end;

            DeputationOn::"Extension Counter":
                begin
                    EmpHie.Reset;
                    EmpHie.SetRange(Type, EmpHie.Type::"Extension Counter");
                    if OutGoing then
                        EmpHie.SetRange(Code, "Employee Activity"."Extension Counter Code")
                    else
                        EmpHie.SetRange(Code, "Employee Activity"."Extension Counter (To)");
                    if EmpHie.FindFirst then
                        exit(EmpHie.Description);
                end;

            DeputationOn::"Sub Province":
                begin
                    if OutGoing then begin
                        SubProvince.Reset;
                        SubProvince.SetRange(Code, "Employee Activity"."Sub Province Code")
                    end else begin
                        SubProvince.Reset;
                        SubProvince.SetRange(Code, "Employee Activity"."Sub Province Code (To)");
                    end;
                    if SubProvince.FindFirst then
                        exit(SubProvince.City);
                end;

            DeputationOn::Unit:
                begin
                    EmpHie.Reset;
                    EmpHie.SetRange(Type, EmpHie.Type::Unit);
                    if OutGoing then
                        EmpHie.SetRange(Code, "Employee Activity"."Extension Counter Code")
                    else
                        EmpHie.SetRange(Code, "Employee Activity"."Extension Counter (To)");
                    if EmpHie.FindFirst then
                        exit(EmpHie.Description);
                end;

            DeputationOn::Province:
                begin
                    if OutGoing then begin
                        if Province.Get("Employee Activity"."Province Code") then
                            exit(Province.Description);
                    end else
                        if Province.Get("Employee Activity"."Province Code (To)") then
                            exit(Province.Description);
                end;
        end;
    end;

    local procedure EmployeeActivityFilter()
    begin
        case DeputOn of
            DeputOn::Branch:
                begin
                    if "Incoming/Outgoing" = "Incoming/Outgoing"::Incoming then
                        "Employee Activity".SetRange("Shortcut Dimension 1 Code (To)", Filteron)
                    else if "Incoming/Outgoing" = "Incoming/Outgoing"::Outgoing then
                        "Employee Activity".SetRange("Shortcut Dimension 1 Code", Filteron)
                    else begin
                        "Employee Activity".FilterGroup(-1);
                        "Employee Activity".SetRange("Shortcut Dimension 1 Code", Filteron);
                        "Employee Activity".SetRange("Shortcut Dimension 1 Code (To)", Filteron);
                        "Employee Activity".FilterGroup(0);
                    end;
                end;

            DeputOn::Department:
                begin
                    if "Incoming/Outgoing" = "Incoming/Outgoing"::Incoming then
                        "Employee Activity".SetRange("Department Code (To)", Filteron)
                    else if "Incoming/Outgoing" = "Incoming/Outgoing"::Outgoing then
                        "Employee Activity".SetRange(Department, Filteron)
                    else begin
                        "Employee Activity".FilterGroup(-1);
                        "Employee Activity".SetRange(Department, Filteron);
                        "Employee Activity".SetRange("Department Code (To)", Filteron);
                        "Employee Activity".FilterGroup(0);
                    end;
                end;

            DeputOn::"Extension Counter":
                begin
                    if "Incoming/Outgoing" = "Incoming/Outgoing"::Incoming then
                        "Employee Activity".SetRange("Extension Counter (To)", Filteron)
                    else if "Incoming/Outgoing" = "Incoming/Outgoing"::Outgoing then
                        "Employee Activity".SetRange("Extension Counter Code", Filteron)
                    else begin
                        "Employee Activity".FilterGroup(-1);
                        "Employee Activity".SetRange("Extension Counter Code", Filteron);
                        "Employee Activity".SetRange("Extension Counter (To)", Filteron);
                        "Employee Activity".FilterGroup(0);
                    end;
                end;

            DeputOn::Province:
                begin
                    if "Incoming/Outgoing" = "Incoming/Outgoing"::Incoming then
                        "Employee Activity".SetRange("Province Code (To)", Filteron)
                    else if "Incoming/Outgoing" = "Incoming/Outgoing"::Outgoing then
                        "Employee Activity".SetRange("Province Code", Filteron)
                    else begin
                        "Employee Activity".FilterGroup(-1);
                        "Employee Activity".SetRange("Province Code", Filteron);
                        "Employee Activity".SetRange("Province Code (To)", Filteron);
                        "Employee Activity".FilterGroup(0);
                    end;
                end;

            DeputOn::"Sub Province":
                begin
                    if "Incoming/Outgoing" = "Incoming/Outgoing"::Incoming then
                        "Employee Activity".SetRange("Sub Province Code (To)", Filteron)
                    else if "Incoming/Outgoing" = "Incoming/Outgoing"::Outgoing then
                        "Employee Activity".SetRange("Sub Province Code", Filteron)
                    else begin
                        "Employee Activity".FilterGroup(-1);
                        "Employee Activity".SetRange("Sub Province Code", Filteron);
                        "Employee Activity".SetRange("Sub Province Code (To)", Filteron);
                        "Employee Activity".FilterGroup(0);
                    end;
                end;

            DeputOn::Unit:
                begin
                    if "Incoming/Outgoing" = "Incoming/Outgoing"::Incoming then
                        "Employee Activity".SetRange("Unit (To)", Filteron)
                    else if "Incoming/Outgoing" = "Incoming/Outgoing"::Outgoing then
                        "Employee Activity".SetRange("Unit Code", Filteron)
                    else begin
                        "Employee Activity".FilterGroup(-1);
                        "Employee Activity".SetRange("Unit (To)", Filteron);
                        "Employee Activity".SetRange("Unit Code", Filteron);
                        "Employee Activity".FilterGroup(0);
                    end;
                end;
        end;
    end;
}
