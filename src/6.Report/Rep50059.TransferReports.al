report 50059 "Transfer Reports"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep33019860.TransferReports.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Employee Transfer"; "Employee Transfer")
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
            // column(ApproverCode_; "Approver Code") { }
            // column(ScreenerID_; "Screener ID") { }
            // column(ScreenerDate_; "Screener Date") { }
            column(IncomingSupervisiorName_EmployeeActivity; "Employee Transfer"."Incoming Supervisior Name") { }

            trigger OnAfterGetRecord()
            begin
                Clear(SalaryLevel);
                Clear(FromFunctionTitle);
                Clear(ToFunctionalTitle);
                if SalaryLevel.Get("Salary Level Code") then;
                if FromFunctionTitle.Get("Functional Title") then;
                if ToFunctionalTitle.Get("Functional Title (To)") then
                    TransferFrom := ExitTransferDeputationWise("Employee Transfer"."Deputation On", true);
                TransferTo := ExitTransferDeputationWise("Employee Transfer"."Deputation On (To)", false);
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
                                "Employee Transfer".SetRange("Deputation On (To)", DeputOn)
                            else if "Incoming/Outgoing" = "Incoming/Outgoing"::Outgoing then
                                "Employee Transfer".SetRange("Deputation On", DeputOn)
                            else begin
                                "Employee Transfer".FilterGroup(-1);
                                "Employee Transfer".SetRange("Deputation On", DeputOn);
                                "Employee Transfer".SetRange("Deputation On (To)", DeputOn);
                                "Employee Transfer".FilterGroup(0);
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
                                        OrganizationStructureList.Reset;
                                        OrganizationStructureList.SetRange(type, OrganizationStructureList.Type::Branch);
                                        Clear(organizationStructureListPage);
                                        organizationStructureListPage.SetRecord(OrganizationStructureList);
                                        organizationStructureListPage.SetTableView(OrganizationStructureList);
                                        organizationStructureListPage.LookupMode(true);
                                        if organizationStructureListPage.RunModal = Action::LookupOK then begin
                                            organizationStructureListPage.GetRecord(OrganizationStructureList);
                                            Filteron := OrganizationStructureList.Code;
                                        end;
                                    end;

                                DeputOn::Department:
                                    begin
                                        Clear(OrganizationStructureList);
                                        OrganizationStructureList.SetRange(type, OrganizationStructureList.Type::Department);
                                        Clear(organizationStructureListPage);
                                        organizationStructureListPage.LookupMode(true);
                                        if organizationStructureListPage.RunModal = Action::LookupOK then begin
                                            organizationStructureListPage.GetRecord(OrganizationStructureList);
                                            Filteron := OrganizationStructureList.Code;
                                        end;
                                    end;

                                DeputOn::"Extension Counter":
                                    begin
                                        Clear(OrganizationStructureList);
                                        Clear(organizationStructureListPage);
                                        OrganizationStructureList.SetRange(Type, OrganizationStructureList.Type::"Extension Counter");
                                        organizationStructureListPage.SetRecord(OrganizationStructureList);
                                        organizationStructureListPage.SetTableView(OrganizationStructureList);
                                        organizationStructureListPage.LookupMode(true);
                                        if organizationStructureListPage.RunModal = Action::LookupOK then begin
                                            organizationStructureListPage.GetRecord(OrganizationStructureList);
                                            Filteron := OrganizationStructureList.Code;
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

                                // DeputOn::"Sub Province":
                                //     begin
                                //         Clear(SubProvince);
                                //         Clear(PageSubProvince);
                                //         PageSubProvince.LookupMode(true);
                                //         if PageSubProvince.RunModal = Action::LookupOK then begin
                                //             PageSubProvince.GetRecord(SubProvince);
                                //             Filteron := SubProvince.Code;
                                //         end;
                                //     end;

                                DeputOn::Unit:
                                    begin
                                        // Clear(EmpHie);
                                        // EmpHie.SetRange(Type, EmpHie.Type::Unit);
                                        // Clear(PageEmpHie);
                                        // PageEmpHie.SetRecord(EmpHie);
                                        // PageEmpHie.SetTableView(EmpHie);
                                        // PageEmpHie.LookupMode(true);
                                        // if PageEmpHie.RunModal = Action::LookupOK then begin
                                        //     PageEmpHie.GetRecord(EmpHie);
                                        //     Filteron := EmpHie.Code;
                                        // end;
                                        Clear(OrganizationStructureList);
                                        OrganizationStructureList.SetRange(Type, OrganizationStructureList.Type::Unit);
                                        Clear(organizationStructureListPage);
                                        organizationStructureListPage.SetRecord(OrganizationStructureList);
                                        organizationStructureListPage.SetTableView(OrganizationStructureList);
                                        organizationStructureListPage.LookupMode(true);
                                        if organizationStructureListPage.RunModal = Action::LookupOK then begin
                                            organizationStructureListPage.GetRecord(OrganizationStructureList);
                                            Filteron := OrganizationStructureList.Code;
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
        DeputOn: Enum "Deputation Type";
        Filteron: Text;

        ListVisible: Boolean;

        MonthlyVisible: Boolean;

        DeputationVisbile: Boolean;
        "Incoming/Outgoing": Option " ",Incoming,Outgoing;
        Startdate: Date;
        EndDate: Date;
        EngNepDate: Record "English-Nepali Date";
        // DimValue: Record "Dimension Value";
        // Depart: Record Department;
        // EmpHie: Record "Employee Hierarchy Master";
        Province: Record Province;
        // SubProvince: Record "Sub Province";
        // PageDimValue: Page "Dimension Values";
        PageProvince: Page "Provinces List";
        // PageSubProvince: Page SubProvinceList;
        // PageEmpHie: Page "Employee Hierarchy Master";
        // PageDepart: Page Departments;
        FilterCaption: Text;
        RequestedDate: Date;
        OrganizationStructureList: Record "Organization Structure List";
        organizationStructureListPage: page "Organization Structure list";

    local procedure ExitTransferDeputationWise(DeputationOn: Enum "Deputation Type"; OutGoing: Boolean): Text
    begin
        // Clear(DimValue);
        // Clear(Depart);
        // Clear(EmpHie);
        // Clear(SubProvince);
        Clear(Province);
        case DeputationOn of
            DeputationOn::Branch:
                begin
                    if OutGoing then begin
                        if OrganizationStructureList.Get(OrganizationStructureList.Type::Branch, "Employee Transfer"."Shortcut Dimension 1 Code") then
                            exit(OrganizationStructureList.Name);
                    end else
                        if OrganizationStructureList.Get(OrganizationStructureList.Type::Branch, "Employee Transfer"."Shortcut Dimension 1 Code (To)") then
                            exit(OrganizationStructureList.Name);
                end;

            DeputationOn::Department:
                begin
                    if OutGoing then begin
                        if OrganizationStructureList.Get(OrganizationStructureList.Type::Department, "Employee Transfer".Department) then
                            exit(OrganizationStructureList.Name);
                    end else
                        if OrganizationStructureList.Get(OrganizationStructureList.Type::Department, "Employee Transfer"."Department Code (To)") then
                            exit(OrganizationStructureList.Name);
                end;

            DeputationOn::"Extension Counter":
                begin
                    // EmpHie.Reset;
                    // EmpHie.SetRange(Type, EmpHie.Type::"Extension Counter");
                    // if OutGoing then
                    //     OrganizationStructureList.(Code, "Employee Transfer"."Extension Counter Code")
                    // else
                    //     EmpHie.SetRange(Code, "Employee Transfer"."Extension Counter (To)");
                    // if EmpHie.FindFirst then
                    //     exit(EmpHie.Description);
                    if OutGoing then begin
                        if OrganizationStructureList.Get(OrganizationStructureList.Type::"Extension Counter", "Employee Transfer"."Extension Counter Code") then
                            exit(OrganizationStructureList.Name);
                    end else
                        if OrganizationStructureList.Get(OrganizationStructureList.Type::Department, "Employee Transfer"."Extension Counter (To)") then
                            exit(OrganizationStructureList.Name);
                end;

            // DeputationOn::"Sub Province":
            //     begin
            //         if OutGoing then begin
            //             SubProvince.Reset;
            //             SubProvince.SetRange(Code, "Employee Transfer"."Sub Province Code")
            //         end else begin
            //             SubProvince.Reset;
            //             SubProvince.SetRange(Code, "Employee Transfer"."Sub Province Code (To)");
            //         end;
            //         if SubProvince.FindFirst then
            //             exit(SubProvince.City);
            //     end;

            DeputationOn::Unit:
                begin
                    // EmpHie.Reset;
                    // EmpHie.SetRange(Type, EmpHie.Type::Unit);
                    // if OutGoing then
                    //     EmpHie.SetRange(Code, "Employee Transfer"."Extension Counter Code")
                    // else
                    //     EmpHie.SetRange(Code, "Employee Transfer"."Extension Counter (To)");
                    // if EmpHie.FindFirst then
                    //     exit(EmpHie.Description);
                    if OutGoing then begin
                        if OrganizationStructureList.Get(OrganizationStructureList.Type::Unit, "Employee Transfer"."Unit Code") then
                            exit(OrganizationStructureList.Name);
                    end else
                        if OrganizationStructureList.Get(OrganizationStructureList.Type::Unit, "Employee Transfer"."Unit (To)") then
                            exit(OrganizationStructureList.Name);
                end;

            DeputationOn::Province:
                begin
                    if OutGoing then begin
                        if OrganizationStructureList.Get(OrganizationStructureList.Type::Province, "Employee Transfer"."Province Code") then
                            exit(OrganizationStructureList.Name);
                    end else
                        if OrganizationStructureList.Get(OrganizationStructureList.Type::Department, "Employee Transfer"."Province Code (To)") then
                            exit(OrganizationStructureList.Name);
                end;
        end;
    end;


    local procedure EmployeeActivityFilter()
    begin
        case DeputOn of
            DeputOn::Branch:
                begin
                    if "Incoming/Outgoing" = "Incoming/Outgoing"::Incoming then
                        "Employee Transfer".SetRange("Shortcut Dimension 1 Code (To)", Filteron)
                    else if "Incoming/Outgoing" = "Incoming/Outgoing"::Outgoing then
                        "Employee Transfer".SetRange("Shortcut Dimension 1 Code", Filteron)
                    else begin
                        "Employee Transfer".FilterGroup(-1);
                        "Employee Transfer".SetRange("Shortcut Dimension 1 Code", Filteron);
                        "Employee Transfer".SetRange("Shortcut Dimension 1 Code (To)", Filteron);
                        "Employee Transfer".FilterGroup(0);
                    end;
                end;

            DeputOn::Department:
                begin
                    if "Incoming/Outgoing" = "Incoming/Outgoing"::Incoming then
                        "Employee Transfer".SetRange("Department Code (To)", Filteron)
                    else if "Incoming/Outgoing" = "Incoming/Outgoing"::Outgoing then
                        "Employee Transfer".SetRange(Department, Filteron)
                    else begin
                        "Employee Transfer".FilterGroup(-1);
                        "Employee Transfer".SetRange(Department, Filteron);
                        "Employee Transfer".SetRange("Department Code (To)", Filteron);
                        "Employee Transfer".FilterGroup(0);
                    end;
                end;

            DeputOn::"Extension Counter":
                begin
                    if "Incoming/Outgoing" = "Incoming/Outgoing"::Incoming then
                        "Employee Transfer".SetRange("Extension Counter (To)", Filteron)
                    else if "Incoming/Outgoing" = "Incoming/Outgoing"::Outgoing then
                        "Employee Transfer".SetRange("Extension Counter Code", Filteron)
                    else begin
                        "Employee Transfer".FilterGroup(-1);
                        "Employee Transfer".SetRange("Extension Counter Code", Filteron);
                        "Employee Transfer".SetRange("Extension Counter (To)", Filteron);
                        "Employee Transfer".FilterGroup(0);
                    end;
                end;

            DeputOn::Province:
                begin
                    if "Incoming/Outgoing" = "Incoming/Outgoing"::Incoming then
                        "Employee Transfer".SetRange("Province Code (To)", Filteron)
                    else if "Incoming/Outgoing" = "Incoming/Outgoing"::Outgoing then
                        "Employee Transfer".SetRange("Province Code", Filteron)
                    else begin
                        "Employee Transfer".FilterGroup(-1);
                        "Employee Transfer".SetRange("Province Code", Filteron);
                        "Employee Transfer".SetRange("Province Code (To)", Filteron);
                        "Employee Transfer".FilterGroup(0);
                    end;
                end;

            // DeputOn::"Sub Province":
            //     begin
            //         if "Incoming/Outgoing" = "Incoming/Outgoing"::Incoming then
            //             "Employee Transfer".SetRange("Sub Province Code (To)", Filteron)
            //         else if "Incoming/Outgoing" = "Incoming/Outgoing"::Outgoing then
            //             "Employee Transfer".SetRange("Sub Province Code", Filteron)
            //         else begin
            //             "Employee Transfer".FilterGroup(-1);
            //             "Employee Transfer".SetRange("Sub Province Code", Filteron);
            //             "Employee Transfer".SetRange("Sub Province Code (To)", Filteron);
            //             "Employee Transfer".FilterGroup(0);
            //         end;
            //     end;

            DeputOn::Unit:
                begin
                    if "Incoming/Outgoing" = "Incoming/Outgoing"::Incoming then
                        "Employee Transfer".SetRange("Unit (To)", Filteron)
                    else if "Incoming/Outgoing" = "Incoming/Outgoing"::Outgoing then
                        "Employee Transfer".SetRange("Unit Code", Filteron)
                    else begin
                        "Employee Transfer".FilterGroup(-1);
                        "Employee Transfer".SetRange("Unit (To)", Filteron);
                        "Employee Transfer".SetRange("Unit Code", Filteron);
                        "Employee Transfer".FilterGroup(0);
                    end;
                end;
        end;
    end;
}
