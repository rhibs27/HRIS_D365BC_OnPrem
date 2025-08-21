report 50134 "Extra Working Hour Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/6.Report/Rep33019935.ExtraWorkingHourReport.rdl';
    ApplicationArea = All;

    dataset
    {
        dataitem(Employee; Employee)
        {
            DataItemTableView = where(Status = const(Active));
            column(No_Employee; Employee."No.") { }
            column(FullName_Employee; Employee."Full Name") { }
            column(DateFilter; Format(DateFilter)) { }
            column(BranchFilter; BranchFilter) { }
            column(ProvinceCode_Employee; Employee."Province Code") { }
            // column(SubProvinceCode_Employee; Employee."Sub Province Code") { }
            column(GlobalDimension1Code_Employee; Employee."Global Dimension 1 Code") { }
            // column(EcoSystem_Employee; Employee."Eco-System") { }
            column(DepartmentName_Employee; Employee."Department Name") { }
            column(BranchCode; BranchCode) { }
            column(ProvinceCode; ProvinceCode) { }
            column(SubProvinceCode; SubProvinceCode) { }
            column(DepartmentCode; DepartmentCode) { }
            column(BranchName_Employee; Employee."Branch Name") { }
            column(ProvinceName_Employee; Employee."Province Name") { }
            // column(SubProvinceName_Employee; Employee."Sub Province Name") { }
            column(TotalCount; Format(TotalCount)) { }
            column(EarlyPunchIn; EarlyPunchIn) { }
            column(EcoSystemCode; EcoSystemCode) { }
            column(EcoSystemDescription; EcoSystemDescription) { }
            dataitem("Employee Attendance & Activity"; "Employee Attendance & Activity")
            {
                DataItemLink = "Employee No." = field("No.");
                column(LatePunchOut; LatePunchOut) { }
                column(SN; SN) { }
                column(AttendanceDate_EmployeeAttendanceActivity; "Employee Attendance & Activity"."Attendance Date") { }
                column(CheckInTime_EmployeeAttendanceActivity; Format("Employee Attendance & Activity"."Check In Time")) { }
                column(CheckOutTime_EmployeeAttendanceActivity; Format("Employee Attendance & Activity"."Check Out Time")) { }
                column(PunchoutRemarks_EmployeeAttendanceActivity; "Employee Attendance & Activity"."Punch out Remarks") { }

                trigger OnAfterGetRecord()
                begin
                    PayrollGeneralSetup.Get;
                    if "Employee Attendance & Activity"."Day Type" = "Employee Attendance & Activity"."Day Type"::"Working Day" then begin
                        if Date2DWY("Employee Attendance & Activity"."Attendance Date", 1) = 5 then begin
                            if ("Employee Attendance & Activity"."Check In Time" > PayrollGeneralSetup."OT Start Time") and ("Employee Attendance & Activity"."Check Out Time" < PayrollGeneralSetup."Friday OT End Time") then
                                CurrReport.Skip;
                        end else begin
                            if ("Employee Attendance & Activity"."Check In Time" > PayrollGeneralSetup."OT Start Time") and ("Employee Attendance & Activity"."Check Out Time" < PayrollGeneralSetup."OT End Time") then
                                CurrReport.Skip;
                        end;
                    end;
                    //SN := SN + 1;
                    /*IF "Employee Attendance & Activity"."Day Type"="Employee Attendance & Activity"."Day Type"::"Working Day" THEN begin
                      IF "Employee Attendance & Activity"."Check In Time" < PayrollGeneralSetup."OT Start Time" THEN
                        SETFILTER("Employee Attendance & Activity"."Check In Time",'<%1',PayrollGeneralSetup."OT Start Time")
                      ELSE IF "Employee Attendance & Activity"."Check Out Time" > PayrollGeneralSetup."OT End Time" THEN
                        SETFILTER("Employee Attendance & Activity"."Check Out Time",'>%1',PayrollGeneralSetup."OT End Time");
                    end;*/
                end;

                trigger OnPreDataItem()
                begin
                    SetRange("Attendance Date", Today - 1);
                    //SN := 0;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                /*PayrollGeneralSetup.GET;
                EmpAttenAct.Reset();
                EmpAttenAct.SetRange("Attendance Date",071822D);
                //EmpAttenAct.SetRange("Employee No.",Employee."No.");
                EmpAttenAct.SETFILTER("Check In Time",'<%1',PayrollGeneralSetup."OT Start Time");
                EmpAttenAct.SETFILTER("Check Out Time",'>%1',PayrollGeneralSetup."OT End Time");
                IF EmpAttenAct.FINDSET THEN
                  EarlyPunchIn := EmpAttenAct.COUNT;

                IF EmpAttenAct.FIND('-') THEN repeat
                  TotalCount := TotalCount +1;
                until EmpAttenAct.NEXT = 0;*/
            end;

            trigger OnPreDataItem()
            begin
                SetFilter("Employment Date", '<=%1', Today - 1);
                SetRange(Status, Employee.Status::Active);
                if BranchCode <> '' then
                    SetRange("Global Dimension 1 Code", BranchCode)
                else if ProvinceCode <> '' then
                    SetRange("Province Code", ProvinceCode)
                // else if SubProvinceCode <> '' then
                //     SetRange("Sub Province Code", SubProvinceCode)
                else if DepartmentCode <> '' then
                    SetRange("Department Code", DepartmentCode);
                // if EcoSystemCode <> '' then begin
                //     SetRange("Eco-System", EcoSystemCode);
                //     Department.Reset;
                //     Department.SetRange("Eco-System", EcoSystemCode);
                //     if Department.FindFirst then
                //         EcoSystemDescription := Department."Eco-System Description";
                // end;
                /*IF ProvinceFilter <>'' THEN
                 SetRange(Employee."Province Code",ProvinceFilter)
                ELSE IF SubProvinceFilter <> '' THEN
                  SetRange(Employee."Sub Province Code",SubProvinceFilter)
                ELSE IF BranchFilter <> '' THEN
                  SetRange(Employee."Global Dimension 1 Code",BranchFilter)
                ELSE IF DepartmentCodeFilter <> '' THEN
                  SetRange(Employee."Department Code",DepartmentCodeFilter);
                SubProvinceCode := 'SPO55';*/
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content) { }
        }

        actions { }
    }

    labels { }

    trigger OnPreReport()
    begin
        DateFilter := Today - 1; //TODAY-1 -- 082322D
    end;

    var
        DateFilter: Date;
        ProvinceCode: Code[20];
        SubProvinceCode: Code[20];
        BranchFilter: Code[20];
        PayrollGeneralSetup: Record "Payroll General Setup";
        SN: Integer;
        BranchCode: Code[20];
        TotalCount: Integer;
        LatePunchOut: Integer;
        EarlyPunchIn: Integer;
        DepartmentCode: Code[20];
        EcoSystemCode: Code[20];
        // Department: Record Department;
        EcoSystemDescription: Text[100];

    procedure PassBranchEmailSend(branchCod: Code[20])
    begin
        BranchCode := branchCod;
    end;

    procedure PassProvinceEmailSend(provinceCod: Code[20])
    begin
        ProvinceCode := provinceCod;
    end;

    procedure PassSubProvinceEmailSend(subProvinceCod: Code[20])
    begin
        SubProvinceCode := subProvinceCod;
    end;

    procedure PassDepartmentEmailSend(departmentCod: Code[20])
    begin
        DepartmentCode := departmentCod;
    end;

    procedure PassEcoSystemEmailSend(ecosystemCod: Code[20])
    begin
        EcoSystemCode := ecosystemCod;
    end;
}
