report 50030 "Service Duration Report"
{
    ApplicationArea = All;
    Caption = 'Service Duration Report';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep50030.ServiceDurationReport.rdl';
    dataset
    {
        dataitem(Employee; Employee)
        {
            DataItemTableView = where(Status = const(Active));
            RequestFilterFields = "No.", "Branch Code", "Department Code", "Functional Title", "Salary Level";

            column(No_Employee; "No.")
            {
            }
            column(EmployeeAttendanceID_Employee; "Employee Attendance ID")
            {
            }
            column(FullName_Employee; "Full Name")
            {
            }
            column(ReportCaption; ReportCaption) { }
            column(FilterText; FilterText) { }
            column(FilterFields1captions; FilterFields1captions) { }
            column(FilterFields2captions; FilterFields2captions) { }
            column(FilterFields3captions; FilterFields3captions) { }
            column(FilterFields4captions; FilterFields4captions) { }
            column(FilterFields1captionsDesc; FilterFields1captionsDesc) { }
            column(FilterFields2captionsDesc; FilterFields2captionsDesc) { }
            column(FilterFields3captionsDesc; FilterFields3captionsDesc) { }
            column(FilterFields4captionsDesc; FilterFields4captionsDesc) { }
            column(CompanyName; companyNameAddress[1]) { }
            column(CompanyAddress; companyNameAddress[2]) { }
            column(CompanyCommunicationAddr; companyNameAddress[3]) { }
            column(ShowSummaryOnly; ShowSummaryOnly) { }


            dataitem(EmployeeServiceHistory; "Employee Service History")
            {
                DataItemLinkReference = Employee;
                DataItemLink = "Employee No." = field("No.");

                DataItemTableView = SORTING("Service History Code");

                column(FilterField1; FilterField1) { }
                column(FilterField2; FilterField2) { }
                column(FilterField3; FilterField3) { }
                column(FilterField4; FilterField4) { }
                column(FilterField1Desc; FilterField1Desc) { }
                column(FilterField2Desc; FilterField2Desc) { }
                column(FilterField3Desc; FilterField3Desc) { }
                column(FilterField4Desc; FilterField4Desc) { }
                column(ServiceDuration; ServiceDuration) { }
                column(ServiceDurationDecimal; ServiceDurationDecimal) { }
                column(InitialserviceEventDate; Format(InitialserviceEventDate)) { }
                column(TotalServiceDuration; TotalServiceDuration) { }

                trigger OnAfterGetRecord()
                begin
                    ClearFilterFields();
                    if EmployeeServiceHistory."Employee No." <> LastEmployeeNo then begin
                        InitialserviceEventDate := EmployeeServiceHistory."Effective Date";
                        TotalServiceDuration := '';
                        LastEmployeeNo := EmployeeServiceHistory."Employee No.";
                    end;

                    case SinceInThe of
                        SinceInThe::Branch:
                            begin
                                FilterField1 := Employee."Branch Code";
                                FilterField1Desc := Employee."Branch Name";
                                FilterField2 := EmployeeServiceHistory."Salary Level (To)";
                                filterField2Desc := EmployeeServiceHistory."Salary Level Desc. (To)";
                            end;

                        SinceInThe::Department:
                            FilterField2 := Employee."Department Code";
                        SinceInThe::"Functional Title":
                            FilterField3 := Employee."Functional Title";
                        SinceInThe::"Salary Level":
                            begin
                                FilterField1 := Employee."Salary Level";
                                FilterField1Desc := Employee."Salary Level Description";
                                FilterField2 := EmployeeServiceHistory."Branch Code (To)";
                                FilterField2Desc := EmployeeServiceHistory."Branch Description (To)";
                            end;

                    end;
                    NextServiceDate := GetnextServiceEventDate(EmployeeServiceHistory."Employee No.", EmployeeServiceHistory."Effective Date");
                    ServiceDuration := EmployeeServiceHistory.GetServiceDuration(EmployeeServiceHistory."Employee No.", EmployeeServiceHistory."Effective Date", NextServiceDate);
                    ServiceDurationDecimal := Round((NextServiceDate - EmployeeServiceHistory."Effective Date" + 1) / 365.0, 0.01, '=');

                    TotalServiceDuration := EmployeeServiceHistory.GetServiceDuration(EmployeeServiceHistory."Employee No.", InitialserviceEventDate, WorkDate());
                end;

                trigger OnPreDataItem()
                begin
                    EmployeeServiceHistory.SetCurrentKey("Effective Date");
                    case SinceInThe of
                        SinceInThe::Branch:
                            begin
                                if Employee."Branch Code" <> '' then
                                    EmployeeServiceHistory.SetRange("Branch Code (To)", Employee."Branch Code");
                                EmployeeServiceHistory.SetFilter("Effective Date", '>=%1', LastTransferDate);
                            end;
                        SinceInThe::Department:
                            begin
                                if Employee."Department Code" <> '' then
                                    EmployeeServiceHistory.SetRange("Department Code (To)", Employee."Department Code");
                            end;
                        SinceInThe::"Functional Title":
                            begin
                                if Employee."Functional Title" <> '' then
                                    EmployeeServiceHistory.SetRange("Functional Title (To)", Employee."Functional Title");
                            end;
                    // SinceInThe::"Salary Level":
                    //     begin
                    //         if Employee."Job Title Code" <> '' then
                    //             EmployeeServiceHistory.SetRange("Salary Level (To)", Employee."Job Title Code");
                    //         EmployeeServiceHistory.SetFilter("Effective Date", '>=%1', LastTransferDate);
                    //     end;

                    end;
                end;
            }
            trigger OnAfterGetRecord()
            var
                EmpServiceHistoryRec: Record "Employee Service History";
            begin
                LastTransferDate := 0D;
                // LastEmployeeNo := '';

                case SinceInThe of
                    SinceInThe::Branch:
                        begin
                            if Employee."Branch Code" = '' then
                                CurrReport.Skip();
                        end;
                    SinceInThe::Department:
                        begin
                            if Employee."Department Code" = '' then
                                CurrReport.Skip();
                        end;
                    SinceInThe::"Functional Title":
                        begin
                            if Employee."Functional Title" = '' then
                                CurrReport.Skip();
                        end;
                    SinceInThe::"Salary Level":
                        begin
                            if Employee."Salary Level" = '' then
                                CurrReport.Skip();
                        end;
                end;

                EmpServiceHistoryRec.SetCurrentKey("Effective Date");
                EmpServiceHistoryRec.SetRange("Employee No.", Employee."No.");
                if SinceInThe = SinceInThe::Branch then begin
                    EmpServiceHistoryRec.SetRange("Service Event", EmpServiceHistoryRec."Service Event"::Transfer);
                    EmpServiceHistoryRec.SetRange("Branch Code (To)", Employee."Branch Code");
                end;

                if SinceInThe = SinceInThe::"Salary Level" then begin
                    EmpServiceHistoryRec.SetRange("Salary Level (To)", Employee."Salary Level");
                    EmpServiceHistoryRec.SetRange("Service Event", EmpServiceHistoryRec."Service Event"::Promotion);
                end;

                if EmpServiceHistoryRec.FindLast() then
                    LastTransferDate := EmpServiceHistoryRec."Effective Date"
                else
                    LastTransferDate := Employee."Employment Date";

                // LastEmployeeNo := Employee."No.";
            end;
        }

    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field("Since In The"; SinceInThe)
                    {
                        ApplicationArea = All;
                        ValuesAllowed = "Branch", "Salary Level";
                        Caption = 'Since In The..';
                        ToolTip = 'Specifies the criteria to calculate the duration since the employee has been in the selected branch, department, functional title, or job title.';
                    }
                    field(ShowSummaryOnly; ShowSummaryOnly)
                    {
                        ApplicationArea = All;
                        Caption = 'Show Summary Only';
                        ToolTip = 'Specifies whether to show only the summary of the service duration in the report.';
                    }
                }
            }

        }

    }

    trigger OnPreReport()
    begin
        SetFilterFieldCaptions();
    end;

    var
        SinceInThe: Option "Branch","Department","Functional Title","Salary Level";
        ServiceDuration, FilterField1, FilterField2, FilterField3, FilterField4 : Text[100];
        FilterField1Desc, FilterField2Desc, FilterField3Desc, FilterField4Desc : Text[100];
        ReportCaption, FilterText, FilterFields1captions, FilterFields2captions, FilterFields3captions, FilterFields4captions : Text[100];
        FilterFields1captionsDesc, FilterFields2captionsDesc, FilterFields3captionsDesc, FilterFields4captionsDesc : Text[100];
        LastTransferDate, NextServiceDate : Date;
        LastEmployeeNo: Code[20];
        ServiceDurationDecimal: Decimal;
        HrMgt: Codeunit "HR Mgt.";
        CompanyNameAddress: array[3] of Text;
        ShowSummaryOnly: Boolean;
        TotalServiceDuration: Text;
        InitialserviceEventDate: Date;


    procedure ClearFilterFields()
    begin
        FilterField1 := '';
        FilterField2 := '';
        FilterField3 := '';
        FilterField4 := '';
        ServiceDuration := '';
        ServiceDurationDecimal := 0;
    end;

    procedure SetFilterFieldCaptions()
    begin
        HrMgt.GetCompanyOneLineAddress(CompanyNameAddress[1], CompanyNameAddress[2], CompanyNameAddress[3]);
        FilterText := Employee.GetFilters();
        case SinceInThe of
            SinceInThe::Branch:
                begin
                    ReportCaption := 'Since in the Branch';
                    FilterFields1captions := 'Branch Code';
                    FilterFields2captions := 'Salary Level';
                    // FilterFields3captions := '';
                    // FilterFields4captions := '';
                    FilterFields1captionsDesc := 'Branch Description';
                    FilterFields2captionsDesc := 'Salary Level Description';
                    // FilterFields3captionsDesc := '';
                    // FilterFields4captionsDesc := '';
                end;
            // SinceInThe::Department:
            //     begin
            //         ReportCaption := 'Since in the Department';
            //         FilterFields1captions := 'Department Code';
            //         FilterFields2captions := 'Branch Code';
            //         FilterFields3captions := '';
            //         FilterFields4captions := '';
            //         FilterFields1captionsDesc := 'Department Description';
            //         FilterFields2captionsDesc := 'Branch Description';
            //         FilterFields3captionsDesc := '';
            //         FilterFields4captionsDesc := '';
            //     end;
            // SinceInThe::"Functional Title":
            //     begin
            //         ReportCaption := 'Since in the Functional Title';
            //         FilterFields1captions := 'Functional Title';
            //         FilterFields2captions := 'Branch Code';
            //         FilterFields3captions := 'Department Code';
            //         FilterFields4captions := 'Salary Level';
            //     end;
            SinceInThe::"Salary Level":
                begin
                    ReportCaption := 'Since in the Salary Level';
                    FilterFields1captions := 'Salary Level';
                    FilterFields2captions := 'Branch Code';
                    // FilterFields3captions := '';
                    // FilterFields4captions := '';
                    FilterFields1captionsDesc := 'Salary Level Description';
                    FilterFields2captionsDesc := 'Branch Description';
                    // FilterFields3captionsDesc := 'Department Description';
                    // FilterFields4captionsDesc := '';
                end;
        end;
    end;

    procedure GetnextServiceEventDate(EmployeeNo: Code[20]; FromDate: Date): Date
    var
        EmpServiceHistoryRec: Record "Employee Service History";
    begin
        EmpServiceHistoryRec.SetLoadFields("Employee No.", "Effective Date");
        EmpServiceHistoryRec.SetCurrentKey("Effective Date");
        EmpServiceHistoryRec.SetRange("Employee No.", EmployeeNo);
        EmpServiceHistoryRec.SetFilter("Effective Date", '>%1', FromDate);
        if EmpServiceHistoryRec.FindFirst() then
            exit(EmpServiceHistoryRec."Effective Date")
        else
            exit(WorkDate());
    end;
}