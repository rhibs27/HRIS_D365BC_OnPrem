table 50067 "Employee Activity"
{
    DataClassification = CustomerContent;
    // Fields for Leave (50000-50099)
    // Fields for Travel (60000-60099)
    //             travel request (60000-60049)
    //             travel claim  (60050-60099)
    // fields for transfer (80000-89999)
    // fields for OT (70000)
    // fields for Resignation (90000-90100)

    fields
    {
        field(1; "No."; Code[20])
        {
            trigger OnValidate()
            begin
                HRSetup.Get;
                if "No." <> xRec."No." then
                    if Cancelled then begin
                        NoSeriesMgt.TestManual(HRSetup."Cancel Document No. Series");
                        "No. Series" := '';
                    end else begin
                        case Type of

                            //employee change no. series
                            Type::"Employee Edit":
                                begin
                                    NoSeriesMgt.TestManual(HRSetup."Employee Change No. Series");
                                    "No. Series" := '';
                                end;

                            //for access grant
                            Type::"Access Control":
                                begin
                                    NoSeriesMgt.TestManual(HRSetup."Access Control No.");
                                    "No. Series" := '';
                                end;

                            //for leave
                            Type::"Leave Request":
                                begin
                                    NoSeriesMgt.TestManual(HRSetup."Leave No. Series");
                                    "No. Series" := '';
                                end;

                            //for travel request
                            Type::"Travel Request":
                                begin
                                    NoSeriesMgt.TestManual(HRSetup."Travel Request No.");
                                    "No. Series" := '';
                                end;

                            //for travel claimed
                            Type::"Travel Claim":
                                begin
                                    NoSeriesMgt.TestManual(HRSetup."Travel Claimed No.");
                                    "No. Series" := '';
                                end;

                            //for transfer
                            Type::"Employee Transfer", Type::"HR Transfer":
                                begin
                                    NoSeriesMgt.TestManual(HRSetup."Transfer No.");
                                    "No. Series" := '';
                                end;

                            //for OT
                            Type::Overtime:
                                begin
                                    NoSeriesMgt.TestManual(HRSetup."OT No.");
                                    "No. Series" := '';
                                end;

                            //for out of office
                            Type::"Out of Office":
                                begin
                                    NoSeriesMgt.TestManual(HRSetup."Out of office No.");
                                    "No. Series" := '';
                                end;

                            //for bulk cash
                            Type::"Bulk Cash":
                                begin
                                    NoSeriesMgt.TestManual(HRSetup."Bulk Cash No.");
                                    "No. Series" := '';
                                end;
                            //for resignation
                            Type::Resignation:
                                begin
                                    NoSeriesMgt.TestManual(HRSetup."Resignation No.");
                                    "No. Series" := '';
                                end;

                            //for medical insurance claim
                            Type::"Medical Insurance Claim":
                                begin
                                    NoSeriesMgt.TestManual(HRSetup."Medical Insurance No.");
                                    "No. Series" := '';
                                end;

                            //for promotion
                            Type::Promotion:
                                begin
                                    NoSeriesMgt.TestManual(HRSetup."Promotion No.");
                                    "No. Series" := '';
                                end;

                            //attendance missed
                            Type::"Attendance Missed":
                                begin
                                    NoSeriesMgt.TestManual(HRSetup."Attendance Missed No.");
                                    "No. Series" := '';
                                end;
                        end;
                    end;
            end;
        }
        field(2; Type; Enum "Employee Activity Type")
        {

        }
        field(3; "Employee No."; Code[20])
        {
            TableRelation = Employee;

            trigger OnValidate()
            begin
                if EmpVar.Get("Employee No.") then begin
                    Validate("Employee Name", EmpVar."Full Name");
                    Validate("Shortcut Dimension 1 Code", EmpVar."Global Dimension 1 Code");
                    Validate(Department, EmpVar."Department Code");
                    Validate("Deputation On", EmpVar."Deputation on");
                    Validate("Auth. Account No.", EmpVar."Bank Account No.");
                    Validate("Salary Level Code", EmpVar."Salary Level");
                    Validate("Functional Title", EmpVar."Functional Title");
                    // Validate("Sub Province Code", EmpVar."Sub Province Code");
                    Validate("Province Code", EmpVar."Province Code");
                    Validate("Unit Code", EmpVar."Unit Code");
                    Validate("Employee Work Shift", EmpVar."Employee Work Shift");
                    /*VALIDATE("Compensatory Days", EmpVar."Reporting Line 1");
                    VALIDATE("Reporting Line 2 Code", EmpVar."Reporting Line 2");*/
                    Validate("Extension Counter Code", EmpVar."Extension Counter Code");
                    // Validate(Ecosystem, EmpVar."Eco-System");
                    // Validate("Office Code", EmpVar.Office);
                    if Type = Type::Overtime then begin
                        if "Start Date" > 20221207D then begin
                            PayrollGenSetup.Get;
                            if EmployeeAttendanceActivity.Get("Employee No.", "Start Date") then begin
                                SalaryLevelRec.Get(EmployeeAttendanceActivity."Salary Level Code");
                                SalaryGrade.Get(EmployeeAttendanceActivity."Salary Grade");
                                if "Encashment Code" = PayrollGenSetup.Overtime then begin
                                    if EmpVar."Salary Level" = PayrollGenSetup."TA Salary Level" then
                                        "OT Amount" := (("Estimated Hours" * PayrollGenSetup."Over Time Calculation" / 100) * (SalaryLevelRec."TA OT Basic Salary" + (SalaryGrade."Grade Percentage" / 100 * SalaryLevelRec."TA OT Basic Salary")))
                                    else if EmpVar."Employment Type" = EmpVar."Employment Type"::Contract then
                                        "OT Amount" := (("Estimated Hours" * PayrollGenSetup."Over Time Calculation" / 100) * (EmpVar."Contract Salary Amount" + (SalaryGrade."Grade Percentage" / 100 * EmpVar."Contract Salary Amount")))
                                    else
                                        "OT Amount" := (("Estimated Hours" * PayrollGenSetup."Over Time Calculation" / 100) * (SalaryLevelRec."Basic Salary" + (SalaryGrade."Grade Percentage" / 100 * SalaryLevelRec."Basic Salary")));
                                end else begin
                                    if "Encashment Code" = PayrollGenSetup."Extra Mileage" then
                                        "OT Amount" := (("Estimated Hours" * PayrollGenSetup."Extra Mileage Calculation" / 100) * (SalaryLevelRec."Basic Salary" + (SalaryGrade."Grade Percentage" / 100 * SalaryLevelRec."Basic Salary")));
                                    if "Encashment Code" = PayrollGenSetup."Year End Encashment" then
                                        "OT Amount" := (("Estimated Hours" * PayrollGenSetup."Extra Mileage Calculation" / 100) * (SalaryLevelRec."Basic Salary" + (SalaryGrade."Grade Percentage" / 100 * SalaryLevelRec."Basic Salary")));
                                end;
                            end;
                        end;
                    end;
                    // if not (Type in [Type::"Employee Transfer", Type::"HR Transfer"]) then begin
                    //     Validate("Recommender Code", EmpVar."KPI Deputation Value");
                    //     Validate("Recommender Name", EmpVar."Recommender Name");
                    //     Validate("Approver Code", EmpVar."Approver Code");
                    //     Validate("Approver Name", EmpVar."Approver Name");
                    // end;
                    "Bank Account No." := EmpVar."Bank Account No.";
                    "Contact No." := EmpVar."Mobile Phone No.";

                    ValidateTransfer();
                end else begin
                    Clear("Employee Name");
                    Validate("Shortcut Dimension 1 Code", '');
                    Validate(Department, '');
                    Validate("Auth. Account No.", '');
                    Validate("Salary Level Code", '');
                end;
            end;
        }
        field(4; "Employee Name"; Text[50])
        {
            Editable = false;
        }
        field(5; Posted; Boolean) { }
        field(6; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(7; "Start Date"; Date)
        {
            trigger OnValidate()
            begin
                if Type <> Type::Overtime then
                    EmployeeRec.Get("Employee No.");
                if "Start Date" <> 0D then begin
                    if "Start Date" < EmployeeRec."Employment Date" then
                        Error('Cannot apply before your employment date');
                    if Type = Type::"Leave Request" then begin
                        if EmployeeRec."Confirmation Date" <> 0D then
                            if "Start Date" < EmployeeRec."Confirmation Date" then
                                Error('Cannot apply before your confirmation date.');
                    end;
                end;
                //>>check for leave
                if Type = Type::"Leave Request" then begin
                    if EmployeeRec."Contract Expiry Date" <> 0D then
                        if "Start Date" > EmployeeRec."Contract Expiry Date" then
                            Error('Cannot apply leave after contract expiry date');
                    EmpAttendanceActivity.Reset;
                    EmpAttendanceActivity.SetRange("Employee No.", "Employee No.");
                    EmpAttendanceActivity.SetFilter("Attendance Date", '%1..%2', "Start Date", "End Date");
                    if EmpAttendanceActivity.FindFirst then
                        repeat
                            if EmpAttendanceActivity."Present Day" = 1 then
                                Error(LeaveError, EmpAttendanceActivity."Attendance Date");
                        until EmpAttendanceActivity.Next = 0;
                end;
                //<<check for leave

                EngNepDate.Reset;
                EngNepDate.SetRange("English Date", "Start Date");
                if EngNepDate.FindFirst then
                    Validate("Start Date (BS)", EngNepDate."Nepali Date")
                else
                    Clear("Start Date (BS)");
                if "Start Date" <> xRec."Start Date" then begin
                    Clear("End Date");
                    Clear("End Date (BS)");
                    Validate("No. of Days", 0);
                end;

                //for travel claim
                if Type = Type::"Travel Claim" then begin
                    Clear("Actual Travel Start Time");
                    Clear("Actual Travel End Time");
                    Clear("Out of Pocket Expense");
                end;

                //for overtime
                if Type in [Type::Overtime, Type::"Out of Office", Type::"Bulk Cash"] then begin
                    if "Start Date" >= Today then
                        Error('You cannot apply OverTime in current and future date.');
                    Validate("End Date", "Start Date");
                end;
                //AT Travel Req Control
                if Type = Type::"Travel Request" then begin
                    EmpAct.Reset;
                    EmpAct.SetRange("Employee No.", "Employee No.");
                    EmpAct.SetRange(Type, EmpAct.Type::"Travel Request");
                    EmpAct.SetFilter("No.", '<>%1', "No.");
                    EmpAct.SetFilter("Approval Status", '<>%1', EmpAct."Approval Status"::Rejected);
                    EmpAct.SetRange("Start Date", "Start Date");
                    if EmpAct.FindFirst then
                        Error('Travel Request for Start Date = %1 already exists for %2', "Start Date", "Employee Name");
                end;

                if Type = Type::"Attendance Missed" then begin
                    EmpActivityRec.Reset;
                    EmpActivityRec.SetRange("Employee No.", "Employee No.");
                    EmpActivityRec.SetRange(Type, EmpActivityRec.Type::"Attendance Missed");
                    EmpActivityRec.SetRange("Start Date", Rec."Start Date");
                    EmpActivityRec.SetFilter("Approval Status", '<>%1', EmpActivityRec."Approval Status"::Rejected);
                    if EmpActivityRec.FindFirst then
                        Error('Missed Attendance already applied for date %1', Rec."Start Date");
                end;
            end;
        }
        field(8; "End Date"; Date)
        {
            trigger OnValidate()
            begin
                EngNepDate.Reset;
                EngNepDate.SetRange("English Date", "End Date");
                if EngNepDate.FindFirst then
                    Validate("End Date (BS)", EngNepDate."Nepali Date")
                else
                    Clear("End Date (BS)");
                if Type = Type::"Leave Request" then
                    TestField("Leave Code");
                if "End Date" <> 0D then
                    Validate("No. of Days", leaveMgt.CalculateNoOfDays("Start Date", "End Date", "Leave Code", Type, "Leave Type", "Employee No."))
                else begin
                    Clear("End Date (BS)");
                    Clear("No. of Days");
                end;
                if Type = Type::"Travel Claim" then begin
                    Clear("Out of Pocket Expense");
                end;
            end;
        }
        field(9; "No. of Days"; Decimal)
        {
            Editable = false;

            trigger OnValidate()
            begin
                if Type in [Type::"Travel Claim", Type::"Travel Request"] then begin
                    Validate("Total No. of Days", "No. of Days" + TravelMgt.CalcExtendDays("No. of Days", "Travel Order No."));
                    SalaryLevel.Get("Salary Level Code");
                    if "Travel Countries" = "Travel Countries"::Nepal then begin
                        if "Travel With" <> '' then begin
                            if EmployeeRec.Get("Travel With") then//AT
                                if not SalaryLevel."Travel With Not Eligible" then
                                    SalaryLevel1.Get(EmployeeRec."Salary Level");
                            if (SalaryLevel."Nepal Fooding Allowance" > SalaryLevel1."Nepal Fooding Allowance")
                              and (SalaryLevel."Nepal Lodging Allowance" > SalaryLevel1."Nepal Lodging Allowance") then begin
                                Validate("Estimated Fooding Cost", SalaryLevel."Nepal Fooding Allowance" * "No. of Days");
                                Validate("Estimated Lodging Cost", SalaryLevel."Nepal Lodging Allowance" * ("No. of Days" - 1));
                            end
                            else begin
                                Validate("Estimated Fooding Cost", SalaryLevel1."Nepal Fooding Allowance" * "No. of Days");
                                Validate("Estimated Lodging Cost", SalaryLevel1."Nepal Lodging Allowance" * ("No. of Days" - 1));
                            end;
                        end
                        else begin
                            Validate("Estimated Fooding Cost", SalaryLevel."Nepal Fooding Allowance" * "No. of Days");
                            Validate("Estimated Lodging Cost", SalaryLevel."Nepal Lodging Allowance" * ("No. of Days" - 1));
                        end;
                    end
                    else if "Travel Countries" = "Travel Countries"::India then begin
                        if "Travel With" <> '' then begin
                            if EmployeeRec.Get("Travel With") then//AT
                                if not SalaryLevel."Travel With Not Eligible" then
                                    SalaryLevel1.Get(EmployeeRec."Salary Level");
                            if (SalaryLevel."India Fooding Allowance" > SalaryLevel1."India Fooding Allowance")
                              and (SalaryLevel."India Lodging Allowance" > SalaryLevel1."India Lodging Allowance") then begin
                                Validate("Estimated Fooding Cost", SalaryLevel."India Fooding Allowance" * "No. of Days");
                                Validate("Estimated Lodging Cost", SalaryLevel."India Lodging Allowance" * ("No. of Days" - 1));
                            end
                            else begin
                                Validate("Estimated Fooding Cost", SalaryLevel1."India Fooding Allowance" * "No. of Days");
                                Validate("Estimated Lodging Cost", SalaryLevel1."India Lodging Allowance" * ("No. of Days" - 1));
                            end;
                        end
                        else begin
                            Validate("Estimated Fooding Cost", SalaryLevel."India Fooding Allowance" * "No. of Days");
                            Validate("Estimated Lodging Cost", SalaryLevel."India Lodging Allowance" * ("No. of Days" - 1));
                        end;
                    end;
                end;
                if not Cancelled then
                    if (Type = Type::"Leave Request") and ("End Date" <> 0D) then begin
                        leaveMgt.CheckForLimitDays("Leave Code", "No. of Days");
                        if LeaveTypeVar.Get("Leave Code") then;
                        if LeaveTypeVar."Leave Category" <> LeaveTypeVar."Leave Category"::Substitute then
                            leaveMgt.CheckLeaveConflict("Employee No.", "Start Date", "End Date");
                        leaveMgt.CheckForLeaveCriteria("Leave Code", "Start Date", "End Date", "Employee No.", "No. of Days");
                        leaveMgt.CheckForMulipleRequest("Leave Code", "Employee No.", "Start Date", "End Date", "No. of Days");
                    end;
            end;
        }
        field(10; "Requested Date"; Date)
        {
            trigger OnValidate()
            begin
                EngNepDate.Reset;
                EngNepDate.SetRange("English Date", "Requested Date");
                if EngNepDate.FindFirst then
                    Validate("Fiscal Year", EngNepDate."Fiscal Year")
                else
                    Clear("Fiscal Year");
            end;
        }
        field(11; "Fiscal Year"; Text[10])
        {
            Editable = false;
        }
        field(12; "Start Date (BS)"; Text[20])
        {
            Editable = false;
        }
        field(13; "End Date (BS)"; Text[20])
        {
            Editable = false;
        }
        field(14; Remarks; Text[100])
        {
            trigger OnLookup()
            begin
                Page.Run(Page::"Employee List");
            end;
        }
        field(15; "User ID"; Text[50])
        {
            Editable = false;
            TableRelation = "User Setup"."User ID";
        }
        field(16; "Approval Status"; Enum "Approval Status")
        {

            trigger OnValidate()
            begin
                if "Approval Status" = "Approval Status"::Approved then
                    if Type = Type::Resignation then begin
                        EmployeeRec.Get("Employee No.");
                        EmployeeRec.Validate("Resignation Date", "HR Proposed Date");
                        // EmployeeRec.VALIDATE(Status,EmployeeRec.Status::Inactive);
                        EmployeeRec.Modify;
                    end;
                if "Approval Status" = "Approval Status"::Screened then begin
                    Validate("Screener Date", Today);
                    Validate("Screener ID", HRMgt.GetEmployeeNo);
                end;
                if "Approval Status" = "Approval Status"::"Final Approved & Forwarded to Finance Department" then begin
                    Validate("Final Approver Date", Today);
                    Validate("Final Approver", HRMgt.GetEmployeeNo);
                end;
            end;
        }
        field(17; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));

            trigger OnValidate()
            begin
                GLSetup.Get;
                if DimValue.Get(GLSetup."Global Dimension 1 Code", "Shortcut Dimension 1 Code") then
                    Validate("Branch Name", DimValue.Name)
                else
                    Validate("Branch Name", '');
            end;
        }
        field(18; Department; Code[20])
        {
            Editable = false;
            TableRelation = "Organization Structure List".Code where("Type" = filter("Deputation Type"::Department));

            // trigger OnValidate()
            // var
            //     DeptVar: Record Department;
            // begin
            //     if DeptVar.Get(Department) then
            //         Validate("Department Name", DeptVar.Name)
            //     else
            //         Clear("Department Name");
            // end;
        }
        field(19; "Branch Name"; Text[50])
        {
            Editable = false;
        }
        field(20; "Department Name"; Text[50])
        {
            Editable = false;
        }
        field(21; "Functional Title"; Code[20])
        {
            Editable = false;
            TableRelation = "Functional Title";
        }
        field(22; "Recommender Code"; Code[50])
        {
            TableRelation = Employee;
            ValidateTableRelation = false;

            trigger OnLookup()
            begin
                EmpVar.Reset;
                if Page.RunModal(0, EmpVar) = Action::LookupOK then
                    if StrPos("Recommender Code", EmpVar."No.") = 0 then
                        Validate("Recommender Code", EmpVar."No.");
            end;

            trigger OnValidate()
            begin
                if "Recommender Code" = "Employee No." then
                    Error('You cannot choose your own Employee ID as Recommender.');
                HRMgt.GetEmployeeName("Recommender Code", "Recommender Name");
                if "Recommender Code" = '' then
                    Validate("Approver Type", "Approver Type"::Direct)
                else
                    Validate("Approver Type", "Approver Type"::"With Recommendation");
                //requirement not fixed
                if "Recommender Code" <> '' then begin
                    if Type <> Type::Overtime then
                        if "Recommender Code" = "Approver Code" then
                            Error('Recommender and Approver cannot be same person.');
                    EmployeeRec.Get("Recommender Code");
                    if SalaryLevel.Get("Salary Level Code") then;
                    if SalaryLevel1.Get(EmployeeRec."Salary Level") then;
                    if SalaryLevel.Rank >= SalaryLevel1.Rank then
                        Error('Salary level of recommender (%1) must be greater than salary level of employee (%2)', EmployeeRec."Full Name", "Employee Name");
                end;
            end;
        }
        field(23; "Approver Code"; Code[50])
        {
            TableRelation = Employee;
            ValidateTableRelation = false;

            trigger OnLookup()
            begin
                EmpVar.Reset;
                if Page.RunModal(0, EmpVar) = Action::LookupOK then
                    if StrPos("Approver Code", EmpVar."No.") = 0 then
                        Validate("Approver Code", EmpVar."No.");
            end;

            trigger OnValidate()
            begin
                if "Approver Code" = "Employee No." then
                    Error('You cannot choose your own Employee ID as Approver.');
                //requirement not fixed
                HRMgt.GetEmployeeName("Approver Code", "Approver Name");
                if "Approver Code" <> '' then begin
                    HRSetup.Get;
                    if EmployeeRec.Get("Recommender Code") then;
                    if Type = Type::Resignation then begin
                        if not (EmployeeRec."Functional Title" = HRSetup."HR Head Functional Title") then
                            if "Recommender Code" = "Approver Code" then
                                Error('Recommender and Approver cannot be same person.');
                    end else
                        if Type <> Type::Overtime then
                            if "Recommender Code" = "Approver Code" then
                                Error('Recommender and Approver cannot be same person.');

                    EmployeeRec.Get("Approver Code");
                    HRSetup.Get;
                    if EmployeeRec."Functional Title" <> HRSetup."HR Head Functional Title" then begin
                        if SalaryLevel.Get("Salary Level Code") then;
                        if SalaryLevel1.Get(EmployeeRec."Salary Level") then;
                        if SalaryLevel.Rank >= SalaryLevel1.Rank then
                            Error('Salary level of approver (%1) must be greater than salary level of employee (%2).', EmployeeRec."Full Name", "Employee Name");
                    end;
                end;
            end;
        }
        field(24; "Employee Work Shift"; Code[20])
        {
            Editable = false;
            TableRelation = "Employee Work Shift";
        }
        field(25; "Salary Level Code"; Code[20])
        {
            Editable = false;
            TableRelation = "Salary Level";
        }
        field(26; "Recommender Name"; Text[50])
        {
            Editable = false;
        }
        field(27; "Approver Name"; Text[50])
        {
            Editable = false;
        }
        field(28; "Extension Counter Code"; Code[20])
        {
            // TableRelation = "Employee Hierarchy Master".Code where(Type = const("Extension Counter"));
        }
        // field(29; "Sub Province Code"; Code[20])
        // {
        //     TableRelation = "Sub Province".Code;
        // }
        field(30; "Province Code"; Code[20])
        {
            TableRelation = Province;
        }
        field(31; "Unit Code"; Code[20])
        {
            // TableRelation = "Employee Hierarchy Master".Code where(Type = const(Unit));
        }
        field(32; "Compensatory Days"; Decimal)
        {
        }
        field(33; "Payroll No."; Code[20])
        {
        }
        field(34; Ecosystem; Code[20])
        {
        }
        field(35; "Office Code"; Code[20])
        {
        }
        field(36; "Rejection Remarks"; Text[100])
        {
        }
        field(37; "Approved Date"; Date)
        {
        }
        field(38; "Approver Type"; Enum "Approver Type")
        {
            Editable = false;
        }
        field(39; Cancelled; Boolean) { }
        field(40; "Cancelled No."; Code[20]) { }
        field(41; "Cancelled Document No."; Code[20])
        {
            Editable = false;
        }
        field(42; "Screener ID"; Code[20])
        {
            Editable = false;

            trigger OnValidate()
            begin
                if EmployeeRec.Get("Screener ID") then
                    Validate("Screener Name", EmployeeRec."Full Name")
                else
                    Clear("Screener Name");
            end;
        }
        field(43; "Screener Date"; Date)
        {
            Editable = false;
        }
        field(44; "Screener Name"; Text[50])
        {
            Editable = false;
        }
        field(45; "Final Approver"; Code[20])
        {
            Editable = false;
            TableRelation = Employee;

            trigger OnValidate()
            begin
                if EmployeeRec.Get("Final Approver") then
                    Validate("Final Approver Name", EmployeeRec."Full Name")
                else
                    Clear("Final Approver Name");
            end;
        }
        field(46; "Final Approver Name"; Text[50])
        {
            Description = 'S';
            Editable = false;
        }
        field(47; "Final Approver Date"; Date)
        {
            Editable = false;
        }
        field(48; "Reason Code"; Code[20])
        {
            TableRelation = "Standard Text" where("Employee Activity Type" = field(Type));

            trigger OnValidate()
            begin
                if Standardtext.Get("Reason Code") then
                    Validate("Reason Description", Standardtext.Description)
                else
                    Clear("Reason Description");
            end;
        }
        field(49; "Reason Description"; Text[50]) { }
        field(50; "Salary Level Code(To)"; Code[20])
        {
            TableRelation = "Salary Level".Code;
        }
        field(51; "Leave Code"; Code[20])
        {
            TableRelation = "Leave Type Setup";

            trigger OnValidate()
            begin
                if "Leave Code" <> xRec."Leave Code" then begin
                    Clear("For Death Of");
                    if LeaveTypeVar.Get("Leave Code") then begin
                        Validate("Leave Description", LeaveTypeVar.Description);
                        Validate("Pay Type", LeaveTypeVar."Pay Type");
                        Validate("Start Date", 0D);
                    end else begin
                        Clear("Leave Description");
                        Clear("Pay Type");
                    end;
                    Clear("Compensatory Date");
                    Clear("Child's Gender");
                    Clear("Contact No.");
                end;
                /*IF "Leave Code" = 'COMPENSATORY' THEN /
                  ERROR(Text002);*/
            end;
        }
        field(52; "Leave Description"; Text[50])
        {
            Editable = false;
        }
        field(53; "Leave Type"; Enum "Leave Type")
        {


            trigger OnValidate()
            begin
                WorkShift.Get("Employee Work Shift");
                case "Leave Type" of
                    "Leave Type"::"Full Day":
                        begin
                            Validate("Start Time", WorkShift."Start Time");
                            Validate("End Time", WorkShift."End Time");
                        end;

                    "Leave Type"::"First Half":
                        begin
                            Validate("Start Time", WorkShift."Start Time");
                            Validate("End Time", WorkShift."Lunch Start");
                        end;

                    "Leave Type"::"Second Half":
                        begin
                            Validate("Start Time", WorkShift."Lunch Start");
                            Validate("End Time", WorkShift."End Time");
                        end;
                end;

                if "End Date" <> 0D then
                    "No. of Days" := leaveMgt.CalculateNoOfDays("Start Date", "End Date", "Leave Code", Type, "Leave Type", "Employee No.");
            end;
        }
        field(54; "Pay Type"; Enum "Leave Pay Type")
        {
            Editable = false;
        }
        field(55; "Start Time"; Time)
        {
            Description = 'also used for OT';

            trigger OnValidate()
            begin
                if Type = Type::Overtime then begin
                    Clear("Time Duration");
                    Clear("Estimated Hours");
                    Clear("End Time");
                end;
            end;
        }
        field(56; "End Time"; Time)
        {
            Description = 'also used for OT';

            trigger OnValidate()
            begin
                //IF Type = Type::Overtime THEN
                //VALIDATE("Time Duration","End Time" - "Start Time");
            end;
        }
        field(57; "Compensatory Date"; Date)
        {
            trigger OnValidate()
            begin
                leaveMgt.CheckForCompensatory("Leave Code", "Employee No.", "Compensatory Date", "No. of Days");
            end;
        }
        field(58; "For Death Of"; Enum "For Death Of")
        {
        }
        field(59; "Child's Gender"; Enum Gender)
        {

        }
        field(60; "Type Of Visit"; Enum "Type Of Visit")
        {

        }
        field(61; "Mode Of Travel"; Enum "Mode Of Travel")
        {

        }
        field(62; "Depature From"; Code[20]) { }
        field(63; Destination; Code[20]) { }
        field(64; Description; Text[250]) { }
        field(65; "Purpose of Travel"; Text[100]) { }
        field(66; "Advance Cash Required"; Boolean)
        {
            trigger OnValidate()
            begin
                Clear("Advance Cash");
            end;
        }
        field(67; "Advance Cash"; Decimal)
        {
            CaptionClass = FieldName("Advance Cash") + HRMgt.ReturnCurrencyCode("Currency Code");

            trigger OnValidate()
            var
                ErrorAdvCash: Label 'Advance Cash cannot be greater than %1.';
            begin
                if (GuiAllowed) or (Type <> Type::"Travel Claim") then
                    if "Advance Cash" > ("Total Estimated Cost") then
                        Error(ErrorAdvCash, "Total Estimated Cost");
            end;
        }
        field(68; "Estimated Transportation Cost"; Decimal)
        {
            CaptionClass = FieldName("Estimated Transportation Cost") + HRMgt.ReturnCurrencyCode("Currency Code");

            trigger OnValidate()
            begin
                Validate("Total Estimated Cost", "Estimated Conveyance Expense" + "Estimated Fooding Cost" + "Estimated Lodging Cost" + "Estimated Transportation Cost" + "Other Estimated Cost");
            end;
        }
        field(69; "Estimated Lodging Cost"; Decimal)
        {
            CaptionClass = FieldName("Estimated Lodging Cost") + HRMgt.ReturnCurrencyCode("Currency Code");

            trigger OnValidate()
            begin
                if Type = Type::"Travel Request" then begin
                    if "Travel Countries" = "Travel Countries"::Nepal then
                        TravelMgt.CheckLodgingAmtNepal("Employee No.", "Estimated Lodging Cost", "No. of Days" - 1, "Travel With")
                    else if "Travel Countries" = "Travel Countries"::India then
                        TravelMgt.CheckLodgingAmtIndia("Employee No.", "Estimated Lodging Cost", "No. of Days" - 1, "Travel With");
                end;
                Validate("Total Estimated Cost", "Estimated Conveyance Expense" + "Estimated Fooding Cost" + "Estimated Lodging Cost" + "Estimated Transportation Cost" + "Other Estimated Cost");
            end;
        }
        field(70; "Estimated Fooding Cost"; Decimal)
        {
            CaptionClass = FieldName("Estimated Fooding Cost") + HRMgt.ReturnCurrencyCode("Currency Code");

            trigger OnValidate()
            begin
                if Type = Type::"Travel Request" then begin
                    if "Travel Countries" = "Travel Countries"::Nepal then
                        TravelMgt.CheckFoodingAmtNepal("Employee No.", "Estimated Fooding Cost", "No. of Days", "Travel With")
                    else if "Travel Countries" = "Travel Countries"::India then
                        TravelMgt.CheckFoodingAmtIndia("Employee No.", "Estimated Fooding Cost", "No. of Days", "Travel With");  //AT
                end;
                Validate("Total Estimated Cost", "Estimated Conveyance Expense" + "Estimated Fooding Cost" + "Estimated Lodging Cost" + "Estimated Transportation Cost" + "Other Estimated Cost");
            end;
        }
        field(71; "Estimated Conveyance Expense"; Decimal)
        {
            CaptionClass = FieldName("Estimated Conveyance Expense") + HRMgt.ReturnCurrencyCode("Currency Code");

            trigger OnValidate()
            begin
                Validate("Total Estimated Cost", "Estimated Conveyance Expense" + "Estimated Fooding Cost" + "Estimated Lodging Cost" + "Estimated Transportation Cost" + "Other Estimated Cost");
            end;
        }
        field(72; "Other Estimated Cost"; Decimal)
        {
            CaptionClass = FieldName("Other Estimated Cost") + HRMgt.ReturnCurrencyCode("Currency Code");

            trigger OnValidate()
            begin
                Validate("Total Estimated Cost", "Estimated Conveyance Expense" + "Estimated Fooding Cost" + "Estimated Lodging Cost" + "Estimated Transportation Cost" + "Other Estimated Cost");
            end;
        }
        field(73; "Auth. Account No."; Text[30])
        {
            Editable = false;
        }
        field(74; Extended; Boolean) { }
        field(75; "Travel Order No."; Code[20])
        {
            Editable = false;
            TableRelation = "Employee Activity" where(Type = const("Travel Request"),
                                                       "Approval Status" = const(Approved),
                                                       "Employee No." = field("Employee No."));

            trigger OnLookup()
            begin
                if EmpAct.Get("Travel Order No.") then
                    Page.Run(60072, EmpAct);
            end;
        }
        field(76; "Total No. of Days"; Decimal)
        {
            Editable = false;
        }
        field(77; "Travel Countries"; Enum "Travel Countries")
        {

            trigger OnValidate()
            begin
                Validate("No. of Days");
            end;
        }
        field(78; "Currency Code"; Code[20])
        {
            TableRelation = Currency;
        }
        field(79; "Exchange Rate"; Decimal) { }
        field(80; "Depature Time"; Time) { }
        field(81; "Arrival Time"; Time) { }
        field(82; "Total Estimated Cost"; Decimal)
        {
            Editable = false;
        }
        field(83; "Travel With"; Code[20])
        {
            TableRelation = Employee."No.";

            trigger OnValidate()
            begin
                if "Travel With" = "Employee No." then
                    Error(INVALID, "Travel With");
                Validate("No. of Days");//AT
            end;
        }
        field(84; "Payment From"; Enum "Payment From")
        {

            trigger OnValidate()
            begin
                if Rec."Payment From" <> xRec."Payment From" then
                    Validate("Estimated Transportation Cost", 0);
            end;
        }
        field(85; "Actual Travel Start Date"; Date) { }
        field(86; "Actual Travel End Date"; Date) { }
        field(87; "Actual Travel Start Time"; Time)
        {
            trigger OnValidate()
            begin
                if Type = Type::"Travel Claim" then begin
                    EmpVar.Get("Employee No.");
                    SalaryLevel.Get(EmpVar."Salary Level");
                    //VALIDATE("Out of Pocket Expense",(SalaryLevel."Out of Pocket Expense"*("No. of Days"-1)));
                    Clear("Out of Pocket Expense");
                    Clear("Actual Travel End Time");
                end;
            end;
        }
        field(88; "Actual Travel End Time"; Time)
        {
            trigger OnValidate()
            begin
                if Type = Type::"Travel Claim" then begin
                    EmpVar.Get("Employee No.");
                    SalaryLevel.Get(EmpVar."Salary Level");
                    Validate("Out of Pocket Expense", (SalaryLevel."Out of Pocket Expense(Nepal)" *
                        TravelMgt.GetOutofExpenseDuration("Actual Travel Start Time", "Actual Travel End Time", "Start Date", "End Date")));

                end;
            end;
        }
        field(89; "Travel Claimed"; Boolean)
        {
        }
        field(90; "Screener Remarks"; Text[100])
        {
        }
        field(91; "Claim Type"; Enum "Claim Type")
        {

            trigger OnValidate()
            begin
                CalculateTotalClaim;
            end;
        }
        field(92; "Claimed Country"; Text[30]) { }
        field(93; "Fooding Allowance"; Decimal)
        {
            Editable = false;

            trigger OnValidate()
            begin
                CalculateTotalClaim;
                if Type = Type::"Travel Claim" then
                    if "Travel Countries" = "Travel Countries"::India then
                        TravelMgt.CheckFoodingAmtIndia("Employee No.", "Fooding Allowance", "No. of Days", "Travel With")
                    else if "Travel Countries" = "Travel Countries"::Nepal then
                        TravelMgt.CheckFoodingAmtNepal("Employee No.", "Fooding Allowance", "No. of Days", "Travel With");//AT "No. of Days"-1
            end;
        }
        field(94; "Lodging Allowance"; Decimal)
        {
            Editable = false;

            trigger OnValidate()
            begin
                CalculateTotalClaim;
                if Type = Type::"Travel Claim" then
                    if "Travel Countries" = "Travel Countries"::Nepal then
                        TravelMgt.CheckLodgingAmtNepal("Employee No.", "Lodging Allowance", "No. of Days" - 1, "Travel With")
                    else if "Travel Countries" = "Travel Countries"::India then
                        TravelMgt.CheckLodgingAmtIndia("Employee No.", "Lodging Allowance", "No. of Days" - 1, "Travel With");
            end;
        }
        field(95; "Conveyance Expense"; Decimal)
        {
            trigger OnValidate()
            begin
                CalculateTotalClaim;
            end;
        }
        field(96; "Total Claimed Amount"; Decimal)
        {
            Editable = false;

            trigger OnValidate()
            begin
                Validate("Net Receivable/Payable", "Total Claimed Amount" - "Advance Cash");
            end;
        }
        field(97; "Other Expense"; Decimal)
        {
            trigger OnValidate()
            begin
                CalculateTotalClaim;
            end;
        }
        field(98; "Net Receivable/Payable"; Decimal)
        {
            Editable = false;
        }
        field(99; "Out of Pocket Expense"; Decimal)
        {
            Editable = false;

            trigger OnValidate()
            begin
                CalculateTotalClaim;
            end;
        }
        field(100; "Road/Air Fare"; Decimal)
        {
            trigger OnValidate()
            begin
                CalculateTotalClaim;
            end;
        }
        field(101; Reimbursable; Boolean)
        {
            trigger OnValidate()
            begin
                CalculateTotalClaim;
            end;
        }
        field(102; "Fooding Allowance Limit"; Decimal)
        {
            Editable = false;
        }
        field(103; "Lodging Allowance Limit"; Decimal)
        {
            Editable = false;
        }
        field(104; "Fooding Per Day Limit"; Decimal)
        {
            Editable = false;
        }
        field(105; "Lodging Per Day Limit"; Decimal)
        {
            Editable = false;
        }
        field(106; "Time Duration"; Duration) { }
        field(107; "Estimated Hours"; Decimal)
        {
            trigger OnValidate()
            begin
                HRSetup.Get;
                if "Estimated Hours" <> 0 then
                    if "Estimated Hours" < HRSetup."OT eligible hour" then
                        Error('You cannot submit overtime less than %1 hour(s).', HRSetup."OT eligible hour");
            end;
        }
        field(108; "Actual Hours"; Decimal)
        {
        }
        field(109; "Transfer Type"; Enum "Transfer Type")
        {
            trigger OnValidate()
            begin
                if "Transfer Type" in ["Transfer Type"::"Intra Branch", "Transfer Type"::"Intra Department", "Transfer Type"::"Intra Provincial"] then begin
                    "Deputation On (To)" := "Deputation On";
                    "Shortcut Dimension 1 Code (To)" := "Shortcut Dimension 1 Code";
                    // "Sub Province Code (To)" := "Sub Province Code";
                    "Department Code (To)" := Department;
                    "Province Code (To)" := "Province Code";
                    "Unit (To)" := "Unit Code";
                    GetTransferName;
                end;
                if "Transfer Type" in ["Transfer Type"::"Inter Branch", "Transfer Type"::"Inter Department", "Transfer Type"::"Inter Provincial"] then begin
                    "Deputation On (To)" := "Deputation On";
                    GetTransferName;
                end;
                if "Transfer Type" = "Transfer Type"::"Cross Transfer" then
                    "Deputation On (To)" := "Deputation On (To)"::" ";

            end;
        }
        field(110; "Shortcut Dimension 1 Code (To)"; Code[20])
        {
            CaptionClass = '1,2,1';
            Description = 'Transfer';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));

            trigger OnValidate()
            begin
                // if "Shortcut Dimension 1 Code (To)" <> xRec."Shortcut Dimension 1 Code (To)" then begin
                //     GLSetup.Get;
                //     if DimValue.Get(GLSetup."Global Dimension 1 Code", "Shortcut Dimension 1 Code (To)") then begin
                //         "Province Code (To)" := DimValue.Province;
                //         // "Sub Province Code (To)" := DimValue."Sub-Province";
                //         "Department Code (To)" := '';
                //         "Unit (To)" := '';
                //         "Extension Counter (To)" := '';
                //     end;
                // end;
            end;
        }
        // field(111; "Sub Province Code (To)"; Code[20])
        // {
        //     Description = 'Transfer';
        //     TableRelation = "Sub Province".Code;

        //     trigger OnValidate()
        //     begin
        //         if "Sub Province Code (To)" <> xRec."Sub Province Code (To)" then begin
        //             SubProvinceVar.Reset;
        //             SubProvinceVar.SetRange(Code, "Sub Province Code (To)");
        //             if SubProvinceVar.FindFirst then begin
        //                 "Province Code (To)" := SubProvinceVar."Province Code";
        //                 "Shortcut Dimension 1 Code (To)" := '';
        //                 "Department Code (To)" := '';
        //                 "Unit (To)" := '';
        //                 "Extension Counter (To)" := '';
        //             end;
        //         end;
        //     end;
        // }
        field(112; "Province Code (To)"; Code[20])
        {
            Description = 'Transfer';
            TableRelation = Province;

            trigger OnValidate()
            begin
                if "Province Code (To)" <> xRec."Province Code (To)" then begin
                    if ProvinceVar.Get("Province Code (To)") then begin
                        // "Sub Province Code (To)" := '';
                        "Shortcut Dimension 1 Code (To)" := '';
                        "Department Code (To)" := '';
                        "Unit (To)" := '';
                        "Extension Counter (To)" := '';
                    end;
                end;
            end;
        }
        field(113; "Unit (To)"; Code[20])
        {
            Description = 'Transfer';
            // TableRelation = "Employee Hierarchy Master" where(Type = const(Unit));

            // trigger OnValidate()
            // begin
            //     if "Unit (To)" <> xRec."Unit (To)" then begin
            //         EmpHie.Reset;
            //         EmpHie.SetRange(Type, EmpHie.Type::Unit);
            //         EmpHie.SetRange(Code, "Unit (To)");
            //         if EmpHie.FindFirst then
            //             "Department Code (To)" := EmpHie."Department Code"
            //         else
            //             "Department Code (To)" := '';
            //         if DepartVar.Get("Department Code (To)") then
            //             "Province Code (To)" := DepartVar."Province Code"
            //         else
            //             "Province Code (To)" := '';
            //         "Sub Province Code (To)" := '';
            //         "Shortcut Dimension 1 Code (To)" := '';
            //         "Extension Counter (To)" := '';
            //     end;
            // end;
        }
        field(114; "Department Code (To)"; Code[20])
        {
            Description = 'Transfer';
            // TableRelation = Department;

            // trigger OnValidate()
            // begin
            //     if "Department Code (To)" <> xRec."Department Code (To)" then begin
            //         if DepartVar.Get("Department Code (To)") then begin
            //             "Province Code (To)" := DepartVar."Province Code";
            //             "Sub Province Code (To)" := '';
            //             "Unit (To)" := '';
            //             "Shortcut Dimension 1 Code (To)" := '';
            //             "Extension Counter (To)" := '';
            //         end;
            //     end;
            // end;
        }
        // field(115; "Reporting Line 1 (To)"; Code[20])
        // {
        //     Description = 'Transfer';
        //     TableRelation = "Employee Hierarchy Master" where(Type = const("Reporting Line 1"));
        // }
        // field(116; "Reporting Line 2 (To)"; Code[20])
        // {
        //     Description = 'Transfer';
        //     TableRelation = "Employee Hierarchy Master" where(Type = const("Reporting Line 2"));
        // }
        // field(117; "Eco-System (To)"; Code[20])
        // {
        //     Description = 'Transfer';
        //     TableRelation = "Employee Hierarchy Master" where(Type = const("Eco-System"));
        // }
        // field(118; "Office (To)"; Code[20])
        // {
        //     Description = 'Transfer';
        //     TableRelation = "Employee Hierarchy Master" where(Type = const(Office));
        // }
        field(119; "Extension Counter (To)"; Code[20])
        {
            Description = 'Transfer';
            // TableRelation = "Employee Hierarchy Master".Code where(Type = const("Extension Counter"));

            trigger OnValidate()
            begin
                // if "Extension Counter (To)" <> xRec."Extension Counter (To)" then begin
                //     EmpHie.Reset;
                //     EmpHie.SetRange(Type, EmpHie.Type::"Extension Counter");
                //     EmpHie.SetRange(Code, "Extension Counter (To)");
                //     if EmpHie.FindFirst then
                //         "Shortcut Dimension 1 Code (To)" := EmpHie."Shortcut Dimension 1 Code"
                //     else
                //         "Shortcut Dimension 1 Code (To)" := '';
                //     GLSetup.Get;
                //     if DimValue.Get(GLSetup."Shortcut Dimension 1 Code", "Shortcut Dimension 1 Code (To)") then;
                //     "Province Code (To)" := DimValue.Province;
                //     "Sub Province Code (To)" := DimValue."Sub-Province";
                //     "Department Code (To)" := '';
                //     "Unit (To)" := '';
                // end;
            end;
        }
        field(120; "Transfer Effective Date"; Date)
        {
            Description = 'Transfer';

            trigger OnValidate()
            begin
                if Type in [Type::"HR Transfer", Type::"Employee Transfer"] then begin
                    if "Transfer Effective Date" < Today then
                        Error(Text001, Today);
                end;
            end;
        }
        field(121; "Functional Title (To)"; Code[20])
        {
            Description = 'Transfer';
            TableRelation = "Functional Title";
        }
        field(122; "Deputation On"; Enum "Deputation Type")
        {

        }
        field(123; "Deputation On (To)"; Enum "Deputation Type")
        {


            trigger OnValidate()
            begin
                if "Deputation On (To)" <> xRec."Deputation On (To)" then begin
                    Clear("Shortcut Dimension 1 Code (To)");
                    Clear("Department Code (To)");
                    Clear("Unit (To)");
                    Clear("Functional Title (To)");
                    Clear("Province Code (To)");
                    // Clear("Sub Province Code (To)");
                    Clear("Extension Counter (To)");
                end;
            end;
        }
        field(124; "Relocation Allow."; Decimal)
        {
            Description = 'Transfer';

            trigger OnValidate()
            begin
                if "Relocation Allow." > xRec."Relocation Allow." then
                    Error('Invalid Amount.');
            end;
        }
        field(125; "Outstation/Discomfort Allow."; Decimal)
        {
            Description = 'Transfer';

            trigger OnValidate()
            begin
                if "Outstation/Discomfort Allow." > xRec."Outstation/Discomfort Allow." then
                    Error('Invalid Amount.');
            end;
        }
        field(126; "BM Accomodation Allow."; Decimal)
        {
            Description = 'Transfer';

            trigger OnValidate()
            begin
                if "BM Accomodation Allow." > xRec."BM Accomodation Allow." then
                    Error('Invalid Amount.');
            end;
        }
        field(127; "Remote Area Allow."; Decimal)
        {
            Description = 'Transfer';

            trigger OnValidate()
            begin
                if "Remote Area Allow." > xRec."Remote Area Allow." then
                    Error('Invalid Amount.');
            end;
        }
        field(128; "Officiating Allow."; Decimal)
        {
            Description = 'Transfer';

            trigger OnValidate()
            begin
                if "Officiating Allow." > xRec."Officiating Allow." then
                    Error('Invalid Amount.');
            end;
        }
        field(129; "Relocation Distance"; Decimal)
        {
            Description = 'Transfer';

            // trigger OnValidate()
            // begin
            //     TransferMgt.CalculateAllowance(Rec);
            // end;
        }
        field(130; "Outstation Distance"; Decimal)
        {
            Description = 'Transfer';

            // trigger OnValidate()
            // begin
            //     TransferMgt.CalculateAllowance(Rec);
            // end;
        }
        field(131; "BMAF Distance"; Decimal)
        {
            Description = 'Transfer';

            // trigger OnValidate()
            // begin
            //     TransferMgt.CalculateAllowance(Rec);
            // end;
        }
        field(132; "Transfer Allowance Approval"; enum "Approval Status")
        {
            Description = 'Transfer';
        }
        field(133; "Transfer Claim Recommender"; Code[20])
        {
            Description = 'Transfer';
            TableRelation = Employee;
            ValidateTableRelation = false;
        }
        field(134; "Outgoing Branch Rep. Person"; Code[20])
        {
            Description = 'Transfer';
            TableRelation = Employee;

            trigger OnValidate()
            begin
                if "Outgoing Branch Rep. Person" <> '' then begin
                    EmployeeRec.Get("Outgoing Branch Rep. Person");
                    if SalaryLevel.Get("Salary Level Code") then;
                    if SalaryLevel1.Get(EmployeeRec."Salary Level") then;
                    if SalaryLevel.Rank >= SalaryLevel1.Rank then
                        Error('Salary level of Outgoing Branch Person (%1) must be greater than salary level of employee (%2)', EmployeeRec."Full Name", "Employee Name");
                end;
            end;
        }
        field(135; "Transfer Claim Reviewer"; Code[20])
        {
            Description = 'Transfer';
            TableRelation = Employee;
        }
        field(136; "Acknowledged Date"; Date)
        {
            Description = 'Transfer';
            Editable = false;
        }
        field(137; "Transfer Claim Reviewer Name"; Text[30])
        {
            CalcFormula = lookup(Employee."Full Name" where("No." = field("Transfer Claim Reviewer")));
            Description = 'Transfer';
            Editable = false;
            FieldClass = FlowField;
        }
        field(138; "Outgoing Reporting Person Name"; Text[30])
        {
            CalcFormula = lookup(Employee."Full Name" where("No." = field("Outgoing Branch Rep. Person")));
            Description = 'Transfer';
            Editable = false;
            FieldClass = FlowField;
        }
        field(139; Reviewer; Code[20])
        {
            Description = 'Transfer';
            TableRelation = Employee;

            trigger OnValidate()
            begin
                if EmpVar.Get(Reviewer) then
                    Validate("Reviewer Name", EmpVar."Full Name")
                else
                    Clear("Reviewer Name");
            end;
        }
        field(140; "Reviewer Name"; Text[50])
        {
            Description = 'Transfer';
            Editable = false;
        }
        field(141; "Incoming Supervisior"; Code[20])
        {
            Description = 'Transfer';
            TableRelation = Employee;

            trigger OnValidate()
            begin
                if "Incoming Supervisior" <> '' then begin
                    EmployeeRec.Get("Incoming Supervisior");
                    if SalaryLevel.Get("Salary Level Code") then;
                    if SalaryLevel1.Get(EmployeeRec."Salary Level") then;
                    if SalaryLevel.Rank >= SalaryLevel1.Rank then
                        Error('Salary level of Incoming Supervisior (%1) must be greater than salary level of employee (%2)', EmployeeRec."Full Name", "Employee Name");
                end;
                if EmpVar.Get("Incoming Supervisior") then
                    Validate("Incoming Supervisior Name", EmpVar."Full Name")
                else
                    Clear("Incoming Supervisior Name");
            end;
        }
        field(142; "Incoming Supervisior Name"; Text[50])
        {
            Description = 'Transfer';
            Editable = false;
        }
        field(143; "Reviewer Remarks"; Text[50]) { }
        field(144; "Proposed Date of Resignation"; Date)
        {
            Description = 'Resignation';

            trigger OnValidate()
            begin
                if not GuiAllowed then
                    if "Proposed Date of Resignation" < Today then
                        Error(INVALID, FieldCaption("Proposed Date of Resignation"));
                // ResignationMgt.UpdateResignationWaiver(Rec);
            end;
        }
        field(145; "Reason for Resignation"; Text[100])
        {
            Description = 'Resignation';
        }
        field(146; "Waiver Case"; Enum "Waiver Case")
        {
            Description = 'Resignation';


            trigger OnValidate()
            begin
                if "Waiver Case" <> xRec."Waiver Case" then begin
                    Clear("Apply for Waiver");
                    Clear("Reason for Waiver");
                end;
            end;
        }
        field(147; "Supervisor Proposed Date"; Date)
        {
            Description = 'Resignation';

            trigger OnValidate()
            begin
                if "Supervisor Proposed Date" < "Requested Date" then
                    Error('Supervisor proposed date(%1) must be greater than requested date(%2)', "Supervisor Proposed Date", "Requested Date");
            end;
        }
        field(148; "HR Proposed Date"; Date)
        {
            Description = 'Resignation';
        }
        field(149; "Insurance Claim"; Enum "Insurance Claim")
        {

            trigger OnValidate()
            begin
                Clear("Father Name");
                Clear("Mother Name");
                Clear("Spouse Name");
                Clear("Child Name");
                EmpRelative.Reset;
                EmpRelative.SetRange("Employee No.", "Employee No.");
                if "Insurance Claim" <> "Insurance Claim"::"General Checkup" then begin
                    EmpRelative.SetRange("Relative Code", Format("Insurance Claim"));
                    if EmpRelative.FindFirst then begin
                        case "Insurance Claim" of
                            "Insurance Claim"::Father:
                                Validate("Father Name", EmpRelative."First Name" + ' ' + EmpRelative."Middle Name" + ' ' + EmpRelative."Last Name");
                            "Insurance Claim"::Mother:
                                Validate("Mother Name", EmpRelative."First Name" + ' ' + EmpRelative."Middle Name" + ' ' + EmpRelative."Last Name");
                            "Insurance Claim"::Spouse:
                                Validate("Spouse Name", EmpRelative."First Name" + ' ' + EmpRelative."Middle Name" + ' ' + EmpRelative."Last Name");
                            "Insurance Claim"::Child:
                                Validate("Child Name", EmpRelative."First Name" + ' ' + EmpRelative."Middle Name" + ' ' + EmpRelative."Last Name");
                            else
                                Error('Please enter the family details in "Employee Relative" table.');
                        end;
                    end;
                end;
            end;
        }
        field(150; "Father Name"; Text[50])
        {
            FieldClass = Normal;
        }
        field(151; "Mother Name"; Text[50])
        {
        }
        field(152; "Spouse Name"; Text[50])
        {
        }
        field(153; "Child Name"; Text[50])
        {
        }
        field(154; "Total Insurance Claim Amount"; Decimal)
        {
        }
        field(155; "Medical Prescription Date"; Date)
        {
        }
        field(156; "Discharge Date"; Date)
        {
        }
        field(157; "Bank Account No."; Text[30])
        {
        }
        field(158; "Contact No."; Text[30])
        {
        }
        field(159; "Insurance Status"; Enum "Insurance Status")
        {

        }
        field(160; "Apply for Waiver"; Boolean)
        {
            Description = 'Resignation';
        }
        field(161; "Reason for Waiver"; Text[50])
        {
            Description = 'Resignation';
        }
        field(162; "Izone User Id"; Enum YesNo)
        {

        }
        field(163; VPN; Enum YesNo)
        {

        }
        field(164; OCAS; Enum YesNo)
        {

        }
        field(165; "Finacle User Id"; Enum YesNo)
        {

        }
        field(166; "Email Id"; Enum YesNo)
        {
        }
        field(167; "Swift User Id"; Enum YesNo)
        {
        }
        field(168; "Other If Any"; Enum YesNo)
        {
        }
        field(169; Whatsapp; Code[20])
        {
        }
        // field(170; "Request Case"; Enum "Request Case")
        // {
        //     Description = 'Access Control';

        // trigger OnValidate()
        // begin
        //     if "Request Case" <> xRec."Request Case" then begin
        //         AccessControlLine.Reset;
        //         AccessControlLine.SetRange("Document No.", "No.");
        //         AccessControlLine.DeleteAll;
        //     end;
        // end;
        // }
        field(171; "Date of Joining Of Transfer"; Date)
        {
            Description = 'Transfer';

            trigger OnValidate()
            begin
                TestField("Transfer Effective Date");
                if "Date of Joining Of Transfer" < "Transfer Effective Date" then
                    Error('Date of joining of transfer %1 cannot be less than HR Proposed date %2', "Date of Joining Of Transfer", "Transfer Effective Date");
            end;
        }
        field(172; "Transfer Remarks"; Text[50])
        {
            Description = 'Transfer';
        }
        field(173; "Mobile No."; Text[30])
        {
        }
        field(174; "Marital Status"; Enum "Marital Status")
        {

        }
        field(175; "Email (Personal)"; Text[50])
        {
        }
        field(176; "Passport No."; Code[20])
        {
        }
        field(177; "Differently Able"; Boolean)
        {
        }
        field(178; "Vehicle Type"; Enum "Vehicle Type")
        {
        }
        field(179; "Temporary Address"; Text[65])
        {
        }
        field(180; "Temporary Province"; Text[30])
        {
        }
        field(181; VDC; Text[30])
        {
        }
        field(182; "Temporary District"; Text[30])
        {
        }
        field(203; "Temporary Ward No"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(183; House; Text[30])
        {
        }
        field(184; "Blood Group"; Enum "Blood Group")
        {

        }
        field(185; "Notify to"; Text[200])
        {
            Description = 'Transfer';

            trigger OnLookup()
            begin
                Validate("Notify to", HRMgt.ReturnSelectedEmployeeCode("Notify to"));
            end;

            trigger OnValidate()
            begin
                if StrPos("Notify to", ',') <> 0 then
                    Error('Please use ";" instead of ","');
            end;
        }
        field(186; "Transfer Category"; Enum "Transfer Category")
        {
            Description = 'Transfer';
            trigger OnValidate()
            begin
                if Type in [Type::"Employee Transfer", Type::"HR Transfer"] then begin
                    if xRec."Transfer Category" <> "Transfer Category" then begin
                        Clear("Start Date");
                        Clear("End Date");
                        if "No." <> '' then
                            InsertAttachmentLines;
                    end;
                end;
            end;
        }
        field(187; "Curr. Placement Period(Month)"; Decimal)
        {
            Description = 'Transfer';
            Editable = false;
        }
        field(188; "Reason For Hold"; Text[50])
        {
            Description = 'Transfer';
            Editable = false;
        }
        field(189; "On Hold Date"; Date)
        {
            Description = 'Transfer';

            trigger OnValidate()
            begin
                if "On Hold Date" <> 0D then
                    Validate("Transfer Effective Date", "On Hold Date")
            end;
        }
        field(190; "Reason For Cancel"; Text[50])
        {
            Description = 'Transfer';
            Editable = false;
        }
        field(191; "Cancelled Date"; Date)
        {
            Description = 'Transfer';
            Editable = false;
        }
        field(192; "LFA Paid"; Boolean)
        {
            Editable = false;
        }
        field(193; Extension; Text[10])
        {
            Caption = 'Extension';
        }
        field(194; "Encashment Code"; Code[30])
        {
            TableRelation = "OT Encashment Setup";

            trigger OnValidate()
            begin
                /*IF EncashmentPeriodSetup.GET("Encashment Code") THEN
                  "Encashment Period" := EncashmentPeriodSetup.Period
                ELSE
                  CLEAR("Encashment Period");*/
            end;
        }
        field(195; "OT Amount"; Decimal) { }
        field(196; "OT Disbursed"; Boolean) { }
        field(197; "Updated Payroll Line"; Boolean) { }
        field(198; "From Branch"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code;
        }
        field(199; "To Branch"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code;
        }
        field(200; "Total Cash"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(201; "Total Distance (In KM)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(202; "Total Estimate Time (In Hour)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(204; "Temporary VDC"; text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(205; "Disable"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(206; "Temporary House"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(207; "Mobile Phone No"; Code[30])
        {
            DataClassification = ToBeClassified;
        }



    }

    keys
    {
        key(Key1; "No.") { }
        key(Key2; "Start Date") { }
    }

    fieldgroups { }

    trigger OnDelete()
    begin
        //IF NOT ("Approval Status" IN ["Approval Status"::Open,"Approval Status"::" "]) THEN
        //ERROR('Cannot Delete this record.');
    end;

    trigger OnInsert()
    begin
        if "Requested Date" = 0D then
            "Requested Date" := Today;
        HRSetup.Get;
        if "No." = '' then
            if Cancelled then begin
                HRSetup.TestField("Cancel Document No. Series");
                NoSeriesMgt.InitSeries(HRSetup."Cancel Document No. Series", xRec."No. Series", "Requested Date", "No.", "No. Series");
            end else begin
                case Type of

                    //change in employee
                    Type::"Employee Edit":
                        begin
                            HRSetup.TestField("Employee Change No. Series");
                            NoSeriesMgt.InitSeries(HRSetup."Employee Change No. Series", xRec."No. Series", "Requested Date", "No.", "No. Series");
                        end;

                    //for access control
                    Type::"Access Control":
                        begin
                            HRSetup.TestField("Access Control No.");
                            NoSeriesMgt.InitSeries(HRSetup."Access Control No.", xRec."No. Series", "Requested Date", "No.", "No. Series");
                        end;

                    //for leave
                    Type::"Leave Request":
                        begin
                            HRSetup.TestField("Leave No. Series");
                            NoSeriesMgt.InitSeries(HRSetup."Leave No. Series", xRec."No. Series", "Requested Date", "No.", "No. Series");
                        end;

                    //for travel request
                    Type::"Travel Request":
                        begin
                            HRSetup.TestField("Travel Request No.");
                            NoSeriesMgt.InitSeries(HRSetup."Travel Request No.", xRec."No. Series", "Requested Date", "No.", "No. Series");
                        end;

                    //for travel claim
                    Type::"Travel Claim":
                        begin
                            HRSetup.TestField("Travel Claimed No.");
                            NoSeriesMgt.InitSeries(HRSetup."Travel Claimed No.", xRec."No. Series", "Requested Date", "No.", "No. Series");
                        end;

                    //for transfer
                    Type::"Employee Transfer", Type::"HR Transfer":
                        begin
                            HRSetup.TestField("Transfer No.");
                            NoSeriesMgt.InitSeries(HRSetup."Transfer No.", xRec."No. Series", "Requested Date", "No.", "No. Series");
                            "Temporary Address" := "Employee No.";
                            "Temporary District" := "Employee Name";
                        end;

                    //for overtime
                    Type::Overtime:
                        begin
                            HRSetup.TestField("OT No.");
                            NoSeriesMgt.InitSeries(HRSetup."OT No.", xRec."No. Series", "Requested Date", "No.", "No. Series");
                        end;

                    //for out of office
                    Type::"Out of Office":
                        begin
                            HRSetup.TestField("Out of office No.");
                            NoSeriesMgt.InitSeries(HRSetup."Out of office No.", xRec."No. Series", "Requested Date", "No.", "No. Series");
                        end;

                    //for bulk cash
                    Type::"Bulk Cash":
                        begin
                            HRSetup.TestField("Bulk Cash No.");
                            NoSeriesMgt.InitSeries(HRSetup."Bulk Cash No.", xRec."No. Series", "Requested Date", "No.", "No. Series");
                        end;

                    //for resignation
                    Type::Resignation:
                        begin
                            HRSetup.TestField("Resignation No.");
                            NoSeriesMgt.InitSeries(HRSetup."Resignation No.", xRec."No. Series", "Requested Date", "No.", "No. Series");
                        end;

                    //for medical insurance claim
                    Type::"Medical Insurance Claim":
                        begin
                            HRSetup.TestField("Medical Insurance No.");
                            NoSeriesMgt.InitSeries(HRSetup."Medical Insurance No.", xRec."No. Series", "Requested Date", "No.", "No. Series");
                        end;

                    //for promotion
                    Type::Promotion:
                        begin
                            HRSetup.TestField("Promotion No.");
                            NoSeriesMgt.InitSeries(HRSetup."Promotion No.", xRec."No. Series", "Requested Date", "No.", "No. Series");
                        end;

                    //attendance missed
                    Type::"Attendance Missed":
                        begin
                            HRSetup.TestField("Attendance Missed No.");
                            NoSeriesMgt.InitSeries(HRSetup."Attendance Missed No.", xRec."No. Series", "Requested Date", "No.", "No. Series");
                            InsertAttendanceMissedAttachment;
                        end;
                end;
            end;

        InsertAttachmentLines;
    end;

    trigger OnModify()
    begin
        //InsertAttachmentLines;
    end;

    var
        EmpVar: Record Employee;
        EngNepDate: Record "English-Nepali Date";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        HRSetup: Record "Human Resources Setup";
        HRMgt: Codeunit "HR Mgt.";
        TravelMgt: Codeunit "Travel Mgt.";
        TransferMgt: Codeunit "Transfer Mgt.";
        ResignationMgt: Codeunit "Resignation Mgt";
        LeaveTypeVar: Record "Leave Type Setup";
        WorkShift: Record "Employee Work Shift";
        SalaryLevel: Record "Salary Level";
        GLSetup: Record "General Ledger Setup";
        DimValue: Record "Dimension Value";
        EmpAct: Record "Employee Activity";
        SalaryLevel1: Record "Salary Level";
        EmployeeRec: Record Employee;
        INVALID: Label 'Invalid %1';
        EmpRelative: Record "Employee Relative";
        // AccessControlLine: Record "Access Control Request Line";
        ProvinceVar: Record Province;
        // SubProvinceVar: Record "Sub Province";
        // DepartVar: Record Department;
        // EmpHie: Record "Employee Hierarchy Master";
        Standardtext: Record "Standard Text";
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
        FunctionalTitle: Record "Functional Title";
        FunctionalDescFrom: Text;
        FunctionalDescTo: Text;
        EmpAttendanceActivity: Record "Employee Attendance & Activity";
        LeaveError: Label 'You cannot apply leave in Present day %1.';
        EmpActivityRec: Record "Employee Activity";
        Text001: Label 'You cannot apply Transfer of Effective Date less than %1.';
        EmployeeAttendanceActivity: Record "Employee Attendance & Activity";
        PayrollGenSetup: Record "Payroll General Setup";
        SalaryLevelRec: Record "Salary Level";
        SalaryGrade: Record "Salary Grade";
        EncashmentPeriodSetup: Record "OT Encashment Setup";
        Error1: Label 'Cannot apply before your employment date.';
        leaveMgt: Codeunit "Leave Mgt.";

    procedure AssistEdit(OldEmpAct: Record "Employee Activity"): Boolean
    var
        EmpAct: Record "Employee Activity";
    begin
        HRSetup.Get;
        EmpAct := Rec;
        if EmpAct.Cancelled then begin
            HRSetup.TestField("Cancel Document No. Series");
            if NoSeriesMgt.SelectSeries(HRSetup."Cancel Document No. Series", OldEmpAct."No. Series", EmpAct."No. Series") then begin
                NoSeriesMgt.SetSeries(EmpAct."No.");
                Rec := EmpAct;
                exit(true);
            end;
        end else begin
            case EmpAct.Type of
                //change in employee
                EmpAct.Type::"Employee Edit":
                    begin
                        HRSetup.TestField("Employee Change No. Series");
                        if NoSeriesMgt.SelectSeries(HRSetup."Employee Change No. Series", OldEmpAct."No. Series", EmpAct."No. Series") then begin
                            NoSeriesMgt.SetSeries(EmpAct."No.");
                            Rec := EmpAct;
                            exit(true);
                        end;
                    end;

                //access control
                EmpAct.Type::"Access Control":
                    begin
                        HRSetup.TestField("Access Control No.");
                        if NoSeriesMgt.SelectSeries(HRSetup."Access Control No.", OldEmpAct."No. Series", EmpAct."No. Series") then begin
                            NoSeriesMgt.SetSeries(EmpAct."No.");
                            Rec := EmpAct;
                            exit(true);
                        end;
                    end;

                //attendance missed
                EmpAct.Type::"Attendance Missed":
                    begin
                        HRSetup.TestField("Attendance Missed No.");
                        if NoSeriesMgt.SelectSeries(HRSetup."Attendance Missed No.", OldEmpAct."No. Series", EmpAct."No. Series") then begin
                            NoSeriesMgt.SetSeries(EmpAct."No.");
                            Rec := EmpAct;
                            exit(true);
                        end;
                    end;

                //for leave
                EmpAct.Type::"Leave Request":
                    begin
                        HRSetup.TestField("Leave No. Series");
                        if NoSeriesMgt.SelectSeries(HRSetup."Leave No. Series", OldEmpAct."No. Series", EmpAct."No. Series") then begin
                            NoSeriesMgt.SetSeries(EmpAct."No.");
                            Rec := EmpAct;
                            exit(true);
                        end;
                    end;

                //for travel request
                EmpAct.Type::"Travel Request":
                    begin
                        HRSetup.TestField("Travel Request No.");
                        if NoSeriesMgt.SelectSeries(HRSetup."Travel Request No.", OldEmpAct."No. Series", EmpAct."No. Series") then begin
                            NoSeriesMgt.SetSeries(EmpAct."No.");
                            Rec := EmpAct;
                            exit(true);
                        end;
                    end;

                //for travel claim
                EmpAct.Type::"Travel Claim":
                    begin
                        HRSetup.TestField("Travel Claimed No.");
                        if NoSeriesMgt.SelectSeries(HRSetup."Travel Claimed No.", OldEmpAct."No. Series", EmpAct."No. Series") then begin
                            NoSeriesMgt.SetSeries(EmpAct."No.");
                            Rec := EmpAct;
                            exit(true);
                        end;
                    end;

                //for transfer
                EmpAct.Type::"Employee Transfer", EmpAct.Type::"HR Transfer":
                    begin
                        HRSetup.TestField("Transfer No.");
                        if NoSeriesMgt.SelectSeries(HRSetup."Transfer No.", OldEmpAct."No. Series", EmpAct."No. Series") then begin
                            NoSeriesMgt.SetSeries(EmpAct."No.");
                            Rec := EmpAct;
                            exit(true);
                        end;
                    end;

                //for OT
                EmpAct.Type::Overtime:
                    begin
                        HRSetup.TestField("OT No.");
                        if NoSeriesMgt.SelectSeries(HRSetup."OT No.", OldEmpAct."No. Series", EmpAct."No. Series") then begin
                            NoSeriesMgt.SetSeries(EmpAct."No.");
                            Rec := EmpAct;
                            exit(true);
                        end;
                    end;

                //for out of office
                EmpAct.Type::"Out of Office":
                    begin
                        HRSetup.TestField("Out of office No.");
                        if NoSeriesMgt.SelectSeries(HRSetup."Out of office No.", OldEmpAct."No. Series", EmpAct."No. Series") then begin
                            NoSeriesMgt.SetSeries(EmpAct."No.");
                            Rec := EmpAct;
                            exit(true);
                        end;
                    end;

                //for bulk cash
                EmpAct.Type::"Bulk Cash":
                    begin
                        HRSetup.TestField("Bulk Cash No.");
                        if NoSeriesMgt.SelectSeries(HRSetup."Bulk Cash No.", OldEmpAct."No. Series", EmpAct."No. Series") then begin
                            NoSeriesMgt.SetSeries(EmpAct."No.");
                            Rec := EmpAct;
                            exit(true);
                        end;
                    end;

                //for promotion
                EmpAct.Type::Promotion:
                    begin
                        HRSetup.TestField("Promotion No.");
                        if NoSeriesMgt.SelectSeries(HRSetup."Promotion No.", OldEmpAct."No. Series", EmpAct."No. Series") then begin
                            NoSeriesMgt.SetSeries(EmpAct."No.");
                            Rec := EmpAct;
                            exit(true);
                        end;
                    end;
            end;
        end;
    end;

    procedure GetExtendedTravelNo(): Text
    var
        TravelOrder: Record "Employee Activity";
    begin
        TravelOrder.Reset;
        TravelOrder.SetRange("Travel Order No.", "No.");
        if TravelOrder.FindFirst then
            exit(TravelOrder."No.");
    end;

    local procedure CalculateTotalClaim()
    var
        ReduceBy: Decimal;
    begin
        if xRec."Claim Type" <> "Claim Type"::" " then
            TestField("Claim Type");
        ReduceBy := 1;
        if "Claim Type" = "Claim Type"::"Without Bill" then
            ReduceBy := 1    //without bill not need
        else if "Claim Type" = "Claim Type"::"With Bill" then
            if xRec."Claim Type" = "Claim Type"::"Without Bill" then
                ReduceBy := 1;   //without bill not needed

        if Reimbursable then
            Validate("Total Claimed Amount", ("Fooding Allowance" + "Lodging Allowance") / ReduceBy +
                    "Out of Pocket Expense" + "Conveyance Expense" + "Other Expense" + "Road/Air Fare")
        else begin
            "Fooding Allowance" := "Fooding Allowance" / ReduceBy;
            "Lodging Allowance" := "Lodging Allowance" / ReduceBy;//AT
            Validate("Total Claimed Amount", ("Fooding Allowance" + "Lodging Allowance") / ReduceBy +
                    "Out of Pocket Expense" + "Conveyance Expense" + "Other Expense");
        end;
    end;

    local procedure ValdiateEmployeeName(EmpCodeFilter: Text)
    var
        EmpVar2: Record Employee;
        EmpName: Text;
    begin
        if EmpCodeFilter <> '' then begin
            EmpVar2.Reset;
            EmpVar2.SetFilter("No.", EmpCodeFilter);
            if EmpVar2.Find('-') then
                repeat
                    if EmpName = '' then
                        EmpName := EmpVar2."Full Name"
                    else
                        EmpName += ',' + EmpVar2."Full Name";
                until EmpVar2.Next = 0;
        end;
    end;

    local procedure ValidateTransfer()
    begin
        if not (Type in [Type::"Employee Transfer", Type::"HR Transfer"]) then
            exit;

        if EmpVar.Get("Employee No.") then begin
            /* VALIDATE("Deputation On (To)",EmpVar."Deputation on");
             VALIDATE("Province Code (To)", EmpVar."Province Code");
             VALIDATE("Sub Province Code (To)", EmpVar."Sub Province Code");
             VALIDATE("Shortcut Dimension 1 Code (To)",EmpVar."Global Dimension 1 Code");
             VALIDATE("Department Code (To)",EmpVar."Department Code");
             VALIDATE("Unit (To)", EmpVar."Unit Code");
             VALIDATE("Reporting Line 1 (To)", EmpVar."Reporting Line 1");
             VALIDATE("Reporting Line 2 (To)", EmpVar."Reporting Line 2");
             VALIDATE("Eco-System (To)", EmpVar."Eco-System");
             VALIDATE("Extension Counter (To)",EmpVar."Extension Counter Code");
             VALIDATE("Office (To)", EmpVar.Office);
             VALIDATE("Functional Title (To)", EmpVar."Functional Title");*/
            EmpVar.TestField("Employment Date");
            if EmpVar."Last Placement Date" <> 0D then
                Validate("Curr. Placement Period(Month)", Round((Today - EmpVar."Last Placement Date") / 30, 0.01, '='))
            else
                Validate("Curr. Placement Period(Month)", Round((Today - EmpVar."Employment Date") / 30, 0.01, '='));
            CheckForTransfer;
        end;
    end;

    procedure ValidateSolID()
    var
        NotFirstTime: Boolean;
        DimensionValue: Record "Dimension Value";
    // SubProv: Record "Sub Province";
    // EmpHie: Record "Employee Hierarchy Master";
    begin
        //CLEAR("Sol Id");
        if NotFirstTime then
            exit;
        NotFirstTime := true;

        GLSetup.Get;

        // case "Deputation On" of
        //     "Deputation On"::Branch:
        //         begin
        //             if DimensionValue.Get(GLSetup."Global Dimension 1 Code", "Shortcut Dimension 1 Code (To)") then begin
        //                 Validate("Province Code (To)", DimensionValue.Province);
        //                 Validate("Sub Province Code (To)", DimensionValue."Sub-Province");
        //             end;
        //         end;

        //     "Deputation On"::"Sub Province":
        //         begin
        //             SubProv.SetRange(Code, "Sub Province Code");
        //             if SubProv.FindFirst then begin
        //                 Validate("Province Code (To)", SubProv."Province Code");
        //             end;
        //         end;

        //     "Deputation On"::"Extension Counter":
        //         begin
        //             EmpHie.Reset;
        //             EmpHie.SetRange(Code, "Extension Counter Code");
        //             EmpHie.SetRange(Type, EmpHie.Type::"Extension Counter");
        //             if EmpHie.FindFirst then begin
        //                 DimensionValue.Reset;
        //                 DimensionValue.SetRange("Dimension Code", GLSetup."Global Dimension 1 Code");
        //                 DimensionValue.SetRange(Code, EmpHie."Shortcut Dimension 1 Code");
        //                 if DimensionValue.FindFirst then begin
        //                     Validate("Shortcut Dimension 1 Code (To)", EmpHie."Shortcut Dimension 1 Code");
        //                     Validate("Province Code (To)", DimensionValue.Province);
        //                     Validate("Sub Province Code (To)", DimensionValue."Sub-Province");
        //                 end;
        //             end;
        //         end;

        //     "Deputation On"::Unit:
        //         begin
        //             EmpHie.Reset;
        //             EmpHie.SetRange(Code, "Unit Code");
        //             EmpHie.SetRange(Type, EmpHie.Type::Unit);
        //             if EmpHie.FindFirst then begin
        //                 Validate("Department Code (To)", EmpHie."Department Code");
        //             end;
        //         end;
        // end;
    end;

    local procedure InsertAttachmentLines()
    var
        IncomingDocument: Record "Incoming Document";
        AttachmentMandatory: Record "Attachment Setup";
    begin
        case Type of
            Type::"Employee Transfer", Type::"HR Transfer":
                begin
                    IncomingDocument.Reset;
                    IncomingDocument.SetRange("Table ID", Database::"Employee Activity");
                    IncomingDocument.SetRange("No.", "No.");
                    IncomingDocument.DeleteAll(true);
                    AttachmentMandatory.Reset;
                    AttachmentMandatory.SetRange(Type, AttachmentMandatory.Type::"Employee Transfer");
                    AttachmentMandatory.SetRange("Transfer Category", "Transfer Category");
                    if AttachmentMandatory.FindFirst then
                        repeat
                            Clear(IncomingDocument);
                            IncomingDocument.Reset;
                            IncomingDocument.SetRange("Table ID", Database::"Employee Activity");
                            IncomingDocument.SetRange("No.", "No.");
                            IncomingDocument.SetRange("Attachment Code", AttachmentMandatory."Attachment Code");
                            if not IncomingDocument.FindFirst then begin
                                IncomingDocument.Reset;
                                IncomingDocument.Init;
                                IncomingDocument."Entry No." := IncomingDocument.GetEntryNo();
                                IncomingDocument.Description := Rec.TableName;
                                IncomingDocument."Attachment Code" := AttachmentMandatory."Attachment Code";
                                IncomingDocument."No." := "No.";
                                IncomingDocument."Employee Code" := "Employee No.";
                                IncomingDocument."Table ID" := Database::"Employee Activity";
                                IncomingDocument.Insert(true);
                            end;
                        until AttachmentMandatory.Next = 0;
                end;
        end;
    end;

    procedure ReopenDocument()
    var
        EmpActFilterPageBuilder: FilterPageBuilder;
        RecommenderCode: Code[20];
        ApproverCode: Code[20];
    begin
        if "Approval Status" in ["Approval Status"::Approved, "Approval Status"::Open] then
            Error('You cannot change Recommender and Approver of already open or approved request.');

        if not Confirm('Do you want to change Recommender and Approver of this request ?', false) then
            exit;

        EmpActFilterPageBuilder.AddRecord('Employee Activity', Rec);
        EmpActFilterPageBuilder.AddField('Employee Activity', "Recommender Code");
        EmpActFilterPageBuilder.AddField('Employee Activity', "Approver Code");
        EmpActFilterPageBuilder.RunModal;
        EmpAct.SetView(EmpActFilterPageBuilder.GetView('Employee Activity'));
        RecommenderCode := EmpAct.GetFilter("Recommender Code");
        ApproverCode := EmpAct.GetFilter("Approver Code");

        if (RecommenderCode = '') and (ApproverCode = '') then
            Error('Please select either recommender or approver of the request.');

        if RecommenderCode <> '' then begin
            TestField("Approver Type", "Approver Type"::"With Recommendation");
            Validate("Recommender Code", RecommenderCode);
        end;
        if ApproverCode <> '' then
            Validate("Approver Code", ApproverCode);
        Modify;

        Message('The request has been update sucessfully.');
    end;

    local procedure CheckForTransfer()
    begin
        EmpAct.Reset;
        EmpAct.SetRange("Employee No.", "Employee No.");
        EmpAct.SetRange(Type, EmpAct.Type::"HR Transfer");
        EmpAct.SetFilter("No.", '<>%1', "No.");
        EmpAct.SetFilter("Approval Status", '<>%1&<>%2&<>%3', "Approval Status"::Acknowledged, "Approval Status"::Canceled, "Approval Status"::Rejected);
        if EmpAct.FindFirst then
            Error('Transfer for employee %1 (%2) is still pending. Please check the transfer no. %3', EmpAct."Employee Name", EmpAct."Employee No.", EmpAct."No.");
    end;

    local procedure InsertAttendanceMissedAttachment()
    var
        AttachmentMandatory: Record "Attachment Setup";
        IncomingDocument: Record "Incoming Document";
    begin
        AttachmentMandatory.Reset;
        AttachmentMandatory.SetRange(Type, AttachmentMandatory.Type::"Attendance Missed");
        if AttachmentMandatory.FindFirst then
            repeat
                Clear(IncomingDocument);
                IncomingDocument.Reset;
                IncomingDocument.SetRange("Table ID", Database::"Employee Activity");
                IncomingDocument.SetRange("No.", "No.");
                IncomingDocument.SetRange("Attachment Code", AttachmentMandatory."Attachment Code");
                if not IncomingDocument.FindFirst then begin
                    IncomingDocument.Reset;
                    IncomingDocument.Init;
                    IncomingDocument."Entry No." := IncomingDocument.GetEntryNo();
                    IncomingDocument.Description := Rec.TableName;
                    IncomingDocument."Attachment Code" := AttachmentMandatory."Attachment Code";
                    IncomingDocument."No." := "No.";
                    IncomingDocument."Employee Code" := "Employee No.";
                    IncomingDocument."Table ID" := Database::"Employee Activity";
                    IncomingDocument.Insert(true);
                end;
            until AttachmentMandatory.Next = 0;
    end;

    local procedure GetTransferName()
    var
        GLSetup: Record "General Ledger Setup";
        DimValue: Record "Dimension Value";
        // DepartVar: Record Department;
        ProvinceVar: Record Province;
    // SubProvinceVar: Record "Sub Province";
    // EmpHie: Record "Employee Hierarchy Master";
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
        if FunctionalTitle.Get("Functional Title") then
            FunctionalDescFrom := FunctionalTitle.Description;
        if FunctionalTitle.Get("Functional Title (To)") then
            FunctionalDescTo := FunctionalTitle.Description;

        if DimValue.Get(GLSetup."Global Dimension 1 Code", "Shortcut Dimension 1 Code") then
            BranchName := DimValue.Name;

        if DimValue.Get(GLSetup."Global Dimension 1 Code", "Shortcut Dimension 1 Code (To)") then
            BranchNameTo := DimValue.Name;

        // if DepartVar.Get(Department) then
        //     DepartmentName := DepartVar.Name;

        // if DepartVar.Get("Department Code (To)") then
        //     DepartmentNameTo := DepartVar.Name;

        if ProvinceVar.Get("Province Code") then
            ProvinceName := ProvinceVar.Description;

        if ProvinceVar.Get("Province Code (To)") then
            ProvinceNameTo := ProvinceVar.Description;

        // SubProvinceVar.Reset;
        // SubProvinceVar.SetRange(Code, "Sub Province Code");
        // if SubProvinceVar.FindFirst then
        //     SubProvinceName := SubProvinceVar.City;

        // SubProvinceVar.Reset;
        // SubProvinceVar.SetRange(Code, "Sub Province Code (To)");
        // if SubProvinceVar.FindFirst then
        //     SubProvinceNameTo := SubProvinceVar.City;

        // EmpHie.Reset;
        // EmpHie.SetRange(Type, EmpHie.Type::Unit);
        // EmpHie.SetRange(Code, "Unit Code");
        // if EmpHie.FindFirst then
        //     UnitName := EmpHie.Description;

        // EmpHie.Reset;
        // EmpHie.SetRange(Type, EmpHie.Type::Unit);
        // EmpHie.SetRange(Code, "Unit (To)");
        // if EmpHie.FindFirst then
        //     UnitNameTo := EmpHie.Description;

        // EmpHie.Reset;
        // EmpHie.SetRange(Type, EmpHie.Type::"Extension Counter");
        // EmpHie.SetRange(Code, "Extension Counter Code");
        // if EmpHie.FindFirst then
        //     ExtensionName := EmpHie.Description;

        // EmpHie.Reset;
        // EmpHie.SetRange(Type, EmpHie.Type::"Extension Counter");
        // EmpHie.SetRange(Code, "Extension Counter (To)");
        // if EmpHie.FindFirst then
        //     ExtensionNameTo := EmpHie.Description;
    end;
}
