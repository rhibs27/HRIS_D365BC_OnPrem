table 50136 "Travel Request"
{
    Caption = 'Travel Request';
    DataClassification = ToBeClassified;
    //Field 1,2,16,36,100 are used in ApprovalMgt Codeunit as field Ref
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
            Editable = false;

            trigger OnValidate()
            begin
                if EmpVar.Get("Employee No.") then begin
                    Validate("Employee Name", EmpVar."Full Name");
                    Validate("Shortcut Dimension 1 Code", EmpVar."Global Dimension 1 Code");
                    Validate(Department, EmpVar."Department Code");
                    Validate("Branch Name", EmpVar."Branch Name");
                    Validate("Department Name", EmpVar."Department Name");
                    // Validate("Deputation On", EmpVar."Deputation on");
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
        field(5; Posted; Boolean)
        {
        }
        field(6; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(7; "Start Date"; Date)
        {
            trigger OnValidate()
            begin
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
                //AT Travel Req Control
                if Type = Type::"Travel Request" then begin
                    TravelRequest.Reset;
                    TravelRequest.SetRange("Employee No.", "Employee No.");
                    TravelRequest.SetRange(Type, TravelRequest.Type::"Travel Request");
                    TravelRequest.SetFilter("No.", '<>%1', "No.");
                    TravelRequest.SetFilter("Approval Status", '<>%1 &<>%2&<>%3', TravelRequest."Approval Status"::Rejected, TravelRequest."Approval Status"::Open, TravelRequest."Approval Status"::Withdrawn);
                    TravelRequest.SetRange("Start Date", "Start Date");
                    if TravelRequest.FindFirst then
                        Error('Travel Request for Start Date = %1 already exists for %2', "Start Date", "Employee Name");
                end;
                //Min 4.26.2022 -- Check for Missed Attendance.
                // if Type = Type::"Attendance Missed" then begin
                //     EmpActivityRec.Reset;
                //     EmpActivityRec.SetRange("Employee No.", "Employee No.");
                //     EmpActivityRec.SetRange(Type, EmpActivityRec.Type::"Attendance Missed");
                //     EmpActivityRec.SetRange("Start Date", Rec."Start Date");
                //     EmpActivityRec.SetFilter("Approval Status", '<>%1', EmpActivityRec."Approval Status"::Rejected);
                //     if EmpActivityRec.FindFirst then
                //         Error('Missed Attendance already applied for date %1', Rec."Start Date");
                // end;
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
                if "End Date" <> 0D then
                    Validate("No. of Days", TravelMgt.CalculateNoOfDaysTravel("Start Date", "End Date"))
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
            var
                IsHandled: Boolean;
            begin
                if Type in [Type::"Travel Request"] then begin
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
                    end
                    else if "Travel Countries" = "Travel Countries"::"Other Countries" then begin
                        if "Travel With" <> '' then begin
                            if EmployeeRec.Get("Travel With") then//AT
                                if not SalaryLevel."Travel With Not Eligible" then
                                    SalaryLevel1.Get(EmployeeRec."Salary Level");
                            if (SalaryLevel."Others Fooding Allowance" > SalaryLevel1."Others Fooding Allowance")
                              and (SalaryLevel."Others Lodging Allowance" > SalaryLevel1."Others Lodging Allowance") then begin
                                Validate("Estimated Fooding Cost", SalaryLevel."Others Fooding Allowance" * "No. of Days");
                                Validate("Estimated Lodging Cost", SalaryLevel."Others Lodging Allowance" * ("No. of Days" - 1));
                            end
                            else begin
                                Validate("Estimated Fooding Cost", SalaryLevel1."Others Fooding Allowance" * "No. of Days");
                                Validate("Estimated Lodging Cost", SalaryLevel1."Others Lodging Allowance" * ("No. of Days" - 1));
                            end;
                        end
                        else begin
                            Validate("Estimated Fooding Cost", SalaryLevel."Others Fooding Allowance" * "No. of Days");
                            Validate("Estimated Lodging Cost", SalaryLevel."Others Lodging Allowance" * ("No. of Days" - 1));
                        end;
                    end;
                end;
                if Type in [Type::"Travel Claim", Type::"Travel Request"] then begin
                    OnBeforeOutOfPocketValidate(Rec, IsHandled);
                end;

            end;
        }
        field(10; "Requested Date"; Date)
        {
            trigger OnValidate()
            begin
                EngNepDate.Reset;
                EngNepDate.SetRange("English Date", "Start Date");
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
            trigger OnValidate()
            begin
                Clear("Rejection Remarks");
            end;

            // trigger OnLookup()
            // begin
            //     PAGE.Run(PAGE::"Employee List");
            // end;
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
                // if "Approval Status" = "Approval Status"::Screened then begin
                //     Validate("Screener Date", Today);
                //     Validate("Screener ID", HRMgt.GetEmployeeNo);
                // end;
                // if "Approval Status" = "Approval Status"::"Final Approved & Forwarded to Finance Department" then begin
                //     Validate("Final Approver Date", Today);
                //     if GuiAllowed then
                //         Validate("Final Approver", HRMgt.GetEmployeeNo);
                // end;
            end;
        }
        field(17; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

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
            // TableRelation = Department;

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
        // field(22; "Recommender Code"; Code[50])
        // {
        //     TableRelation = Employee;
        //     ValidateTableRelation = false;

        //     trigger OnLookup()
        //     begin
        //         EmpVar.Reset;
        //         if PAGE.RunModal(0, EmpVar) = ACTION::LookupOK then
        //             if StrPos("Recommender Code", EmpVar."No.") = 0 then
        //                 Validate("Recommender Code", EmpVar."No.");
        //     end;

        //     trigger OnValidate()
        //     begin
        //         if "Recommender Code" = "Employee No." then
        //             Error('You cannot choose your own Employee ID as Recommender.');
        //         HRMgt.GetEmployeeName("Recommender Code", "Recommender Name");
        //         if "Recommender Code" = '' then
        //             Validate("Approver Type", "Approver Type"::Direct)
        //         else
        //             Validate("Approver Type", "Approver Type"::"With Recommendation");
        //         //requirement not fixed
        //         if "Recommender Code" <> '' then begin
        //             // if Type <> Type::Overtime then //Min 8.25.2022
        //             //     if "Recommender Code" = "Approver Code" then
        //             //         Error('Recommender and Approver cannot be same person.');
        //             EmployeeRec.Get("Recommender Code");
        //             if SalaryLevel.Get("Salary Level Code") then;
        //             if SalaryLevel1.Get(EmployeeRec."Salary Level") then;
        //             if SalaryLevel.Rank >= SalaryLevel1.Rank then
        //                 Error('Salary level of recommender (%1) must be greater than salary level of employee (%2)', EmployeeRec."Full Name", "Employee Name");
        //         end;
        //     end;
        // }
        // field(23; "Approver Code"; Code[50])
        // {
        //     TableRelation = Employee;
        //     ValidateTableRelation = false;

        //     trigger OnLookup()
        //     begin
        //         EmpVar.Reset;
        //         if PAGE.RunModal(0, EmpVar) = ACTION::LookupOK then
        //             if StrPos("Approver Code", EmpVar."No.") = 0 then
        //                 Validate("Approver Code", EmpVar."No.");
        //     end;

        //     trigger OnValidate()
        //     begin
        //         if "Approver Code" = "Employee No." then
        //             Error('You cannot choose your own Employee ID as Approver.');
        //         //requirement not fixed
        //         HRMgt.GetEmployeeName("Approver Code", "Approver Name");
        //         if "Approver Code" <> '' then begin
        //             HRSetup.Get;
        //             if EmployeeRec.Get("Recommender Code") then;
        //             // if Type = Type::Resignation then begin
        //             //     if not (EmployeeRec."Functional Title" = HRSetup."HR Head Functional Title") then
        //             //         if "Recommender Code" = "Approver Code" then
        //             //             Error('Recommender and Approver cannot be same person.');
        //             // end else
        //             //     if Type <> Type::Overtime then //Min 8.25.2022
        //             //         if "Recommender Code" = "Approver Code" then
        //             //             Error('Recommender and Approver cannot be same person.');

        //             EmployeeRec.Get("Approver Code");
        //             HRSetup.Get;
        //             if EmployeeRec."Functional Title" <> HRSetup."HR Head Functional Title" then begin
        //                 if SalaryLevel.Get("Salary Level Code") then;
        //                 if SalaryLevel1.Get(EmployeeRec."Salary Level") then;
        //                 if SalaryLevel.Rank >= SalaryLevel1.Rank then
        //                     Error('Salary level of approver (%1) must be greater than salary level of employee (%2).', EmployeeRec."Full Name", "Employee Name");
        //             end;
        //         end;
        //     end;
        // }
        field(24; "Employee Work Shift"; Code[10])
        {
            Editable = false;
            TableRelation = "Employee Work Shift";
        }
        field(25; "Salary Level Code"; Code[20])
        {
            Editable = false;
            TableRelation = "Salary Level";
        }
        // field(26; "Recommender Name"; Text[50])
        // {
        //     Editable = false;
        // }
        // field(27; "Approver Name"; Text[50])
        // {
        //     Editable = false;
        // }
        field(28; "Extension Counter Code"; Code[20])
        {
            // TableRelation = "Employee Hierarchy Master".Code WHERE(Type = CONST("Extension Counter"));
        }

        field(30; "Province Code"; Code[20])
        {
        }
        field(31; "Unit Code"; Code[20])
        {
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
            trigger OnValidate()
            begin
                Clear(Remarks);
            end;
        }
        field(37; "Approved Date"; Date)
        {
        }
        field(38; "Approver Type"; Enum "Approver Type")
        {
            Editable = false;
        }
        field(39; Cancelled; Boolean)
        {
        }
        field(40; "Cancelled No."; Code[20])
        {
        }
        field(41; "Cancelled Document No."; Code[20])
        {
            Editable = false;
        }
        // field(42; "Screener ID"; Code[20])
        // {
        //     Editable = false;

        //     trigger OnValidate()
        //     begin
        //         if EmployeeRec.Get("Screener ID") then
        //             Validate("Screener Name", EmployeeRec."Full Name")
        //         else
        //             Clear("Screener Name");
        //     end;
        // }
        // field(43; "Screener Date"; Date)
        // {
        //     Editable = false;
        // }
        // field(44; "Screener Name"; Text[50])
        // {
        //     Editable = false;
        // }
        // field(45; "Final Approver"; Code[20])
        // {
        //     Editable = false;
        //     TableRelation = Employee;

        //     trigger OnValidate()
        //     begin
        //         if EmployeeRec.Get("Final Approver") then
        //             Validate("Final Approver Name", EmployeeRec."Full Name")
        //         else
        //             Clear("Final Approver Name");
        //     end;
        // }
        // field(46; "Final Approver Name"; Text[50])
        // {
        //     Description = 'S';
        //     Editable = false;
        // }
        // field(47; "Final Approver Date"; Date)
        // {
        //     Editable = false;
        // }
        // field(48; "Reason Code"; Code[20])
        // {
        //     TableRelation = "Standard Text" WHERE("Employee Activity Type" = FIELD(Type));

        //     trigger OnValidate()
        //     begin
        //         if Standardtext.Get("Reason Code") then
        //             Validate("Reason Description", Standardtext.Description)
        //         else
        //             Clear("Reason Description");
        //     end;
        // }
        // field(49; "Reason Description"; Text[50])
        // {
        // }
        field(50; "Type Of Visit"; Enum "Type Of Visit")
        {
        }
        field(51; "Mode Of Travel"; Enum "Mode Of Travel")
        {
        }
        field(52; "Departure From"; Text[30])
        {
            trigger OnValidate()
            begin
                if (Rec."Departure From" <> xRec."Departure From") and ("Departure From" <> '') then
                    HRMgt.CheckDistrictName("Departure From");
            END;

            trigger OnLookup()
            begin
                Validate("Departure From", HRMgt.LookupAllDistrict());
            end;
        }
        field(53; Destination; Text[30])
        {
            trigger OnValidate()
            begin
                if "Travel Countries" = "Travel Countries"::Nepal then begin
                    if (Rec."Destination" <> xRec."Destination") and ("Destination" <> '') then
                        HRMgt.CheckDistrictName("Destination");
                end else if "Travel Countries" = "Travel Countries"::"Other Countries" then
                        if (Rec."Destination" <> xRec."Destination") and ("Destination" <> '') then
                            HRMgt.CheckCountryName("Destination");
            END;

            trigger OnLookup()
            begin
                if "Travel Countries" = "Travel Countries"::Nepal then
                    Validate("Destination", HRMgt.LookupAllDistrict())
                else if "Travel Countries" = "Travel Countries"::"Other Countries" then
                    Validate("Destination", HRMgt.LookupCountry());
            end;
        }
        field(54; Description; Text[250])
        {
        }
        field(55; "Purpose of Travel"; Text[100])
        {
        }
        field(56; "Advance Cash Required"; Boolean)
        {
            trigger OnValidate()
            begin
                Clear("Advance Cash");
            end;
        }
        field(57; "Advance Cash"; Decimal)
        {
            CaptionClass = FieldName("Advance Cash") + HRMgt.ReturnCurrencyCode("Currency Code");
            trigger OnValidate()
            var
                ErrorAdvCash: Label 'Advance Cash cannot be greater than %1.';
            begin
                if (GuiAllowed) or (Type <> Type::"Travel Claim") then
                    if "Advance Cash" > ("Total Estimated Cost") then
                        Error(ErrorAdvCash, "Total Estimated Cost");
                CalculateTotalClaim();
            end;

        }
        field(58; "Estimated Transportation Cost"; Decimal)
        {
            CaptionClass = FieldName("Estimated Transportation Cost") + HRMgt.ReturnCurrencyCode("Currency Code");

            trigger OnValidate()
            begin
                Validate("Total Estimated Cost", "Estimated Conveyance Expense" + "Estimated Fooding Cost" + "Estimated Lodging Cost" + "Estimated Transportation Cost" + "Other Estimated Cost");
            end;
        }
        field(59; "Estimated Lodging Cost"; Decimal)
        {
            CaptionClass = FieldName("Estimated Lodging Cost") + HRMgt.ReturnCurrencyCode("Currency Code");

            trigger OnValidate()
            begin
                if Type = Type::"Travel Request" then begin
                    if "Travel Countries" = "Travel Countries"::Nepal then
                        TravelMgt.CheckLodgingAmtNepal("Employee No.", "Estimated Lodging Cost", "No. of Days" - 1, "Travel With")
                    else if "Travel Countries" = "Travel Countries"::India then
                        TravelMgt.CheckLodgingAmtIndia("Employee No.", "Estimated Lodging Cost", "No. of Days" - 1, "Travel With")
                    else if "Travel Countries" = "Travel Countries"::"Other Countries" then
                        TravelMgt.CheckLodgingAmtOther("Employee No.", "Estimated Lodging Cost", "No. of Days" - 1, "Travel With");
                end;
                Validate("Total Estimated Cost", "Estimated Conveyance Expense" + "Estimated Fooding Cost" + "Estimated Lodging Cost" + "Estimated Transportation Cost" + "Other Estimated Cost");
            end;
        }
        field(60; "Estimated Fooding Cost"; Decimal)
        {
            CaptionClass = FieldName("Estimated Fooding Cost") + HRMgt.ReturnCurrencyCode("Currency Code");

            trigger OnValidate()
            begin
                if Type = Type::"Travel Request" then begin
                    if "Travel Countries" = "Travel Countries"::Nepal then
                        TravelMgt.CheckFoodingAmtNepal("Employee No.", "Estimated Fooding Cost", "No. of Days", "Travel With")
                    else if "Travel Countries" = "Travel Countries"::India then
                        TravelMgt.CheckFoodingAmtIndia("Employee No.", "Estimated Fooding Cost", "No. of Days", "Travel With")
                    else if "Travel Countries" = "Travel Countries"::"Other Countries" then
                        TravelMgt.CheckFoodingAmtOther("Employee No.", "Estimated Fooding Cost", "No. of Days", "Travel With");
                end;
                Validate("Total Estimated Cost", "Estimated Conveyance Expense" + "Estimated Fooding Cost" + "Estimated Lodging Cost" + "Estimated Transportation Cost" + "Other Estimated Cost");
            end;
        }
        field(61; "Estimated Conveyance Expense"; Decimal)
        {
            CaptionClass = FieldName("Estimated Conveyance Expense") + HRMgt.ReturnCurrencyCode("Currency Code");

            trigger OnValidate()
            begin
                Validate("Total Estimated Cost", "Estimated Conveyance Expense" + "Estimated Fooding Cost" + "Estimated Lodging Cost" + "Estimated Transportation Cost" + "Other Estimated Cost");
            end;
        }
        field(62; "Other Estimated Cost"; Decimal)
        {
            CaptionClass = FieldName("Other Estimated Cost") + HRMgt.ReturnCurrencyCode("Currency Code");

            trigger OnValidate()
            begin
                Validate("Total Estimated Cost", "Estimated Conveyance Expense" + "Estimated Fooding Cost" + "Estimated Lodging Cost" + "Estimated Transportation Cost" + "Other Estimated Cost");
            end;
        }
        field(63; "Auth. Account No."; Text[30])
        {
            Editable = false;
        }
        field(64; Extended; Boolean)
        {
        }
        field(65; "Travel Order No."; Code[20])
        {
            Editable = false;
            TableRelation = "Travel Request" WHERE(Type = CONST("Travel Request"),
                                                       "Approval Status" = CONST(Approved),
                                                       "Employee No." = FIELD("Employee No."));

            trigger OnLookup()
            begin
                if TravelRequest.Get("Travel Order No.") then
                    PAGE.Run(50093, TravelRequest);
            end;
        }
        field(66; "Total No. of Days"; Decimal)
        {
            Editable = false;
        }
        field(67; "Travel Countries"; Enum "Travel Countries")
        {
            trigger OnValidate()
            var
                Employee, Employee1 : Record Employee;
            begin
                if "Travel Countries" = "Travel Countries"::India then
                    Validate(Destination, Format("Travel Countries"::India));
                Validate("No. of Days");
                if type = Type::"Travel Claim" then begin
                    Employee.Get("Employee No.");
                    SalaryLevel.Get(Employee."Salary Level");
                    if "Travel With" <> '' then begin//AT
                        Employee1.Get("Travel With");
                        if not SalaryLevel."Travel With Not Eligible" then
                            SalaryLevel1.Get(Employee1."Salary Level");
                        TravelMgt.GetFoodingLimit(Rec, SalaryLevel1, SalaryLevel);
                        TravelMgt.GetLodgingLimit(Rec, SalaryLevel1, SalaryLevel);
                    end;
                end;
                if ("Travel Countries" <> xRec."Travel Countries") and ("Travel Countries" <> "Travel Countries"::India) then
                    Clear(Destination);
                //anupam
                if "Travel Countries" = "Travel Countries"::Nepal then begin
                    GLSetup.get();
                    if GLSetup."LCY Code" = '' then
                        Error('Local currency in GL setup is empty');
                    "Currency Code" := GLSetup."LCY Code";
                end;
            end;
        }
        field(68; "Currency Code"; Code[10])
        {
            TableRelation = Currency;


        }
        field(69; "Exchange Rate"; Decimal)
        {
        }
        field(70; "Departure Time"; Time)
        {
            trigger OnValidate()
            begin
                if "Departure Time" <> xRec."Departure Time" then
                    Clear("Arrival Time");

            end;
        }
        field(71; "Arrival Time"; Time)
        {
            trigger OnValidate()
            var
            begin
                if "Start Date" = "End Date" then
                    if "Departure Time" > "Arrival Time" then
                        Error('Arrival Time Cannot be Earlier then Departure Time');
            end;
        }
        field(72; "Total Estimated Cost"; Decimal)
        {
            Editable = false;
        }
        field(73; "Travel With"; Code[20])
        {
            TableRelation = Employee."No.";

            trigger OnValidate()
            begin
                if "Travel With" <> '' then begin
                    if "Travel With" = "Employee No." then
                        Error(INVALID, "Travel With");
                    if EmployeeRec.Get("Travel With") then
                        Validate("Travel With Name", EmployeeRec."Full Name");
                    Validate("No. of Days");//AT
                end;
            end;
        }
        field(74; "Payment From"; Enum "Payment From")
        {
            trigger OnValidate()
            begin
                if Rec."Payment From" <> xRec."Payment From" then
                    Validate("Estimated Transportation Cost", 0);
            end;
        }
        field(75; "Actual Travel Start Date"; Date)
        {
        }
        field(76; "Actual Travel End Date"; Date)
        {
        }
        field(77; "Actual Travel Start Time"; Time)
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
        field(78; "Actual Travel End Time"; Time)
        {
            trigger OnValidate()
            var
                IsHandled: Boolean;
            begin
                if Type = Type::"Travel Claim" then begin
                    EmpVar.Get("Employee No.");
                    SalaryLevel.Get(EmpVar."Salary Level");
                    OnBeforeOutOfPocketValidate(Rec, IsHandled);
                    if not IsHandled then
                        if "Travel Countries" = "Travel Countries"::Nepal then
                            Validate("Out of Pocket Expense", (SalaryLevel."Out of Pocket Expense(Nepal)" * TravelMgt.GetOutofExpenseDuration("Actual Travel Start Time", "Actual Travel End Time", "Start Date", "End Date")))
                        else if "Travel Countries" = "Travel Countries"::India then
                            Validate("Out of Pocket Expense", (SalaryLevel."Out of Pocket Expense(India)" * TravelMgt.GetOutofExpenseDuration("Actual Travel Start Time", "Actual Travel End Time", "Start Date", "End Date")))
                        else if "Travel Countries" = "Travel Countries"::"Other Countries" then
                            Validate("Out of Pocket Expense", (SalaryLevel."Out of Pocket Expense(Other)" * TravelMgt.GetOutofExpenseDuration("Actual Travel Start Time", "Actual Travel End Time", "Start Date", "End Date")));
                end;
            end;
        }
        field(79; "Travel Claimed"; Boolean)
        {
        }
        // field(80; "Screener Remarks"; Text[100])
        // {
        // }
        field(80; "Travel With Name"; Text[100])
        {
            Editable = false;
        }

        field(81; "Claim Type"; Enum "Claim Type")
        {
            trigger OnValidate()
            begin
                CalculateTotalClaim;
            end;
        }
        field(82; "Claimed Country"; Text[30])
        {
        }
        field(83; "Fooding Allowance"; Decimal)
        {
            Editable = false;

            trigger OnValidate()
            begin
                CalculateTotalClaim;
                if Type = Type::"Travel Claim" then
                    if "Travel Countries" = "Travel Countries"::India then
                        TravelMgt.CheckFoodingAmtIndia("Employee No.", "Fooding Allowance", "No. of Days", "Travel With")
                    else if "Travel Countries" = "Travel Countries"::Nepal then
                        TravelMgt.CheckFoodingAmtNepal("Employee No.", "Fooding Allowance", "No. of Days", "Travel With")//AT "No. of Days"-1
                    else if "Travel Countries" = "Travel Countries"::"Other Countries" then
                        TravelMgt.CheckFoodingAmtOther("Employee No.", "Fooding Allowance", "No. of Days", "Travel With");
            end;
        }
        field(84; "Lodging Allowance"; Decimal)
        {
            Editable = false;
            trigger OnValidate()
            begin
                CalculateTotalClaim;
                if Type = Type::"Travel Claim" then
                    if "Travel Countries" = "Travel Countries"::Nepal then
                        TravelMgt.CheckLodgingAmtNepal("Employee No.", "Lodging Allowance", "No. of Days" - 1, "Travel With")
                    else if "Travel Countries" = "Travel Countries"::India then
                        TravelMgt.CheckLodgingAmtIndia("Employee No.", "Lodging Allowance", "No. of Days" - 1, "Travel With")
                    else if "Travel Countries" = "Travel Countries"::"Other Countries" then
                        TravelMgt.CheckLodgingAmtOther("Employee No.", "Lodging Allowance", "No. of Days" - 1, "Travel With");
            end;
        }
        field(85; "Conveyance Expense"; Decimal)
        {

            trigger OnValidate()
            begin
                CalculateTotalClaim;
            end;
        }
        field(86; "Total Claimed Amount"; Decimal)
        {
            Editable = false;
            trigger OnValidate()
            begin
                Validate("Net Receivable/Payable", "Total Claimed Amount" - "Advance Cash");
            end;
        }
        field(87; "Other Expense"; Decimal)
        {
            trigger OnValidate()
            begin
                CalculateTotalClaim;
            end;
        }
        field(88; "Net Receivable/Payable"; Decimal)
        {
            Editable = false;
        }
        field(89; "Out of Pocket Expense"; Decimal)
        {
            Editable = false;

            trigger OnValidate()
            begin
                CalculateTotalClaim;
            end;
        }
        field(90; "Road/Air Fare"; Decimal)
        {

            trigger OnValidate()
            begin
                CalculateTotalClaim;
            end;
        }
        field(91; Reimbursable; Boolean)
        {

            trigger OnValidate()
            begin
                CalculateTotalClaim;
            end;
        }
        field(92; "Fooding Allowance Limit"; Decimal)
        {
            Editable = false;
        }
        field(93; "Lodging Allowance Limit"; Decimal)
        {
            Editable = false;
        }
        field(94; "Fooding Per Day Limit"; Decimal)
        {
            Editable = false;
        }
        field(95; "Lodging Per Day Limit"; Decimal)
        {
            Editable = false;
        }
        field(96; "Currency Type"; code[20])
        {
            Editable = true;
            TableRelation = Currency;
        }
        field(100; Status; Text[20])
        {
            DataClassification = ToBeClassified;
        }

    }
    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Start Date")
        {
        }
    }

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

                    //for travel request
                    Type::"Travel Request":
                        begin
                            HRSetup.TestField("Travel Request No.");
                            NoSeriesMgt.InitSeries(HRSetup."Travel Request No.", xRec."No. Series", "Requested Date", "No.", "No. Series");
                            ApproverMgt.InsertApproval("Employee No.", "No.", Type, "Approval Status"); //Create Approval line from Setup Santosh 
                        end;

                    //for travel claim
                    Type::"Travel Claim":
                        begin
                            HRSetup.TestField("Travel Claimed No.");
                            NoSeriesMgt.InitSeries(HRSetup."Travel Claimed No.", xRec."No. Series", "Requested Date", "No.", "No. Series");
                            ApproverMgt.InsertApproval("Employee No.", "No.", Type, "Approval Status");//Create Approval line from Setup Santosh 
                        end;
                end;
            end;
    end;

    trigger OnDelete()
    var
        CannotDelete: Label 'Cannot delete document.';

    begin
        //for Delete Approval Entry when Document is delete Santosh
        if not ("Approval Status" in ["Approval Status"::" ", "Approval Status"::Open]) then
            Error(CannotDelete)
        else begin
            ApprovalEntry.Reset();
            ApprovalEntry.SetRange("Document No.", "No.");
            ApprovalEntry.SetRange("Employee No", "Employee No.");
            ApprovalEntry.DeleteAll();
        end;

    end;

    procedure AssistEdit(OldTravel: Record "Travel Request"): Boolean
    var
        //EmpAct: Record "Employee Activity";
        Travel: Record "Travel Request";
    begin
        HRSetup.Get;
        Travel := Rec;
        if TravelRequest.Cancelled then begin
            HRSetup.TestField("Cancel Document No. Series");
            if NoSeriesMgt.SelectSeries(HRSetup."Cancel Document No. Series", OldTravel."No. Series", TravelRequest."No. Series") then begin
                NoSeriesMgt.SetSeries(TravelRequest."No.");
                Rec := Travel;
                exit(true);
            end;
        end else begin
            case TravelRequest.Type of
                //for travel request
                TravelRequest.Type::"Travel Request":
                    begin
                        HRSetup.TestField("Travel Request No.");
                        if NoSeriesMgt.SelectSeries(HRSetup."Travel Request No.", OldTravel."No. Series", TravelRequest."No. Series") then begin
                            NoSeriesMgt.SetSeries(TravelRequest."No.");
                            Rec := Travel;
                            exit(true);
                        end;
                    end;

                //for travel claim
                TravelRequest.Type::"Travel Claim":
                    begin
                        HRSetup.TestField("Travel Claimed No.");
                        if NoSeriesMgt.SelectSeries(HRSetup."Travel Claimed No.", OldTravel."No. Series", TravelRequest."No. Series") then begin
                            NoSeriesMgt.SetSeries(TravelRequest."No.");
                            Rec := Travel;
                            exit(true);
                        end;
                    end;
            end;
        end;
    end;

    // local procedure InsertAttendanceMissedAttachment()
    // var
    //     AttachmentMandatory: Record "Attachment Setup";
    //     IncomingDocument: Record "Incoming Document";
    // begin
    //     AttachmentMandatory.Reset;
    //     AttachmentMandatory.SetRange(Type, AttachmentMandatory.Type::"Attendance Missed");
    //     if AttachmentMandatory.FindFirst then
    //         repeat
    //             Clear(IncomingDocument);
    //             IncomingDocument.Reset;
    //             IncomingDocument.SetRange("Table ID", DATABASE::"Employee Activity");
    //             IncomingDocument.SetRange("No.", "No.");
    //             IncomingDocument.SetRange("Attachment Code", AttachmentMandatory."Attachment Code");
    //             if not IncomingDocument.FindFirst then begin
    //                 IncomingDocument.Reset;
    //                 IncomingDocument.Init;
    //                 IncomingDocument."Entry No." := IncomingDocument.GetEntryNo();
    //                 IncomingDocument.Description := Rec.TableName;
    //                 IncomingDocument."Attachment Code" := AttachmentMandatory."Attachment Code";
    //                 IncomingDocument."No." := "No.";
    //                 IncomingDocument."Employee Code" := "Employee No.";
    //                 IncomingDocument."Table ID" := DATABASE::"Employee Activity";
    //                 IncomingDocument.Insert(true);
    //             end;
    //         until AttachmentMandatory.Next = 0;
    // end;

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
                    "Out of Pocket Expense" + "Conveyance Expense" + "Other Expense" + "Road/Air Fare");
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

    var
        EmpVar: Record Employee;
        EngNepDate: Record "English-Nepali Date";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        HRSetup: Record "Human Resources Setup";
        HRMgt: Codeunit "HR Mgt.";
        TravelMgt: Codeunit "Travel Mgt.";
        //LeaveTypeVar: Record "Leave Type Setup";
        //WorkShift: Record "Employee Work Shift";
        SalaryLevel: Record "Salary Level";
        GLSetup: Record "General Ledger Setup";
        DimValue: Record "Dimension Value";
        //EmpAct: Record "Employee Activity";
        TravelRequest: Record "Travel Request";
        SalaryLevel1: Record "Salary Level";
        EmployeeRec: Record Employee;
        INVALID: Label 'Invalid %1';
        // EmpRelative: Record "Employee Relative";
        // SystemAccessControl: Record "System Access Control";
        // AccessControlLine: Record "Access Control Request Line";
        // ProvinceVar: Record Province;
        // SubProvinceVar: Record "Sub Province";
        // DepartVar: Record Department;
        //EmpHie: Record "Employee Hierarchy Master";
        // Standardtext: Record "Standard Text";
        // BranchNameTo: Text;
        // DepartmentNameTo: Text;
        // ProvinceNameTo: Text;
        // SubProvinceNameTo: Text;
        // ExtensionNameTo: Text;
        // UnitNameTo: Text;
        // BranchName: Text;
        // DepartmentName: Text;
        // ProvinceName: Text;
        // SubProvinceName: Text;
        // ExtensionName: Text;
        // UnitName: Text;
        // FunctionalTitle: Record "Functional Title";
        // FunctionalDescFrom: Text;
        // FunctionalDescTo: Text;
        //EmpAttendanceActivity: Record "Employee Attendance & Activity";
        //LeaveError: Label 'You cannot apply leave in Present day %1.';
        //EmpActivityRec: Record "Employee Activity";
        //Text001: Label 'You cannot apply Transfer of Effective Date less than %1.';
        //Text002: Label 'Compensatory leave has been restricted in HRMS.';
        //EmployeeAttendanceActivity: Record "Employee Attendance & Activity";
        //PayrollGenSetup: Record "Payroll General Setup";
        //SalaryLevelRec: Record "Salary Level";
        //SalaryGrade: Record "Salary Grade";
        //EncashmentPeriodSetup: Record "OT Encashment Setup";
        //Error1: Label 'Cannot apply before your employment date.';
        ApproverMgt: Codeunit "Approver Mgt";
        ApprovalEntry: Record "Approval HRMS";


    [IntegrationEvent(false, false)]
    procedure OnBeforeOutOfPocketValidate(var TravelRequest: Record "Travel Request"; var IsHandled: Boolean)
    begin
    end;

}
