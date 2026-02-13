table 50069 "Training Header"
{
    DataCaptionFields = "No.", Description;
    LookupPageId = "Training Lists";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20])
        {
            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    HRSetup.Get;
                    NoSeriesMgt.GetNextNo(HRSetup."Training No.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; Description; Text[250])
        {
            Editable = false;
        }
        field(3; "Start Date"; Date)
        {
            trigger OnValidate()
            begin
                if "Start Date" <> xRec."Start Date" then begin
                    Validate("End Date", 0D);
                    Clear("End Time");
                    Clear("Training Hours");
                    Clear("Start Time");
                    Clear("No. of Days");
                    //TrainingLine.Reset();
                    //TrainingLine.SetRange("Training No.","No.");
                    //TrainingLine.MODIFYALL("Training Start Date","Start Date");
                end;
            end;
        }
        field(4; "End Date"; Date)
        {
            trigger OnValidate()
            begin
                if ("End Date" <> xRec."End Date") and ("End Date" <> 0D) then begin
                    Clear("Start Time");
                    Clear("End Time");
                    Clear("Training Hours");
                    if ("End Date" <> 0D) then begin
                        TestField("Start Date");
                        Validate("No. of Days", leaveMgt.CalculateNoOfDays("Start Date", "End Date", '', 0, 0, ''));
                        //TrainingLine.Reset();
                        //TrainingLine.SetRange("Training No.","No.");
                        //TrainingLine.MODIFYALL("Training End Date","End Date");
                    end;
                end;
                if "End Date" <> 0D then
                    if "Start Date" > "End Date" then
                        Error(DateError, FieldCaption("End Date"), "End Date", FieldCaption("Start Date"), "Start Date");
            end;
        }
        field(5; "Start Time"; Time)
        {
            trigger OnValidate()
            begin
                TestField("Start Date");
                TestField("End Date");
                if xRec."Start Time" <> "Start Time" then begin
                    Clear("End Time");
                    Clear("Training Hours");
                end;
            end;
        }
        field(6; "End Time"; Time)
        {
            trigger OnValidate()
            begin
                TestField("No. of Days");
                TestField("Start Date");
                TestField("End Date");
                TestField("Start Time");
                if "End Time" < "Start Time" then
                    Error(DateError, FieldCaption("End Time"), "End Time", FieldCaption("Start Time"), "Start Time");

                /*VALIDATE("Training Hours",("End Time"-"Start Time"));
                VALIDATE("Training Hours", "Training Hours"*"No. of Days");*/
            end;
        }
        field(7; "Resource Person"; Enum "Resouce person")
        {
            trigger OnValidate()
            begin
                if "Resource Person" <> "Resource Person" then begin
                    TrainingLine.Reset;
                    TrainingLine.SetRange("Training No.", "No.");
                    TrainingLine.SetRange(Type, TrainingLine.Type::Trainer);
                    TrainingLine.DeleteAll;
                end;
            end;
        }
        field(8; Venue; Text[250]) { }
        field(9; Vendor; Code[20])
        {
            TableRelation = Vendor;

            trigger OnValidate()
            begin
                if VendorVar.Get(Vendor) then
                    Validate("Vendor Name", VendorVar.Name)
                else
                    Clear("Vendor Name");
            end;
        }
        field(10; "Vendor Name"; Text[50]) { }
        field(11; "Training Type"; Enum "Training Type") { }
        field(12; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(13; "Requested Date"; Date)
        {
            trigger OnValidate()
            begin
                Validate("Fiscal Year", HRMgt.ReturnFiscalYear("Requested Date"));
                EngNepDate.Reset;
                EngNepDate.SetRange("English Date", "Requested Date");
                if EngNepDate.FindFirst then
                    Validate(Month, EngNepDate."Nepali Month")
                else
                    Validate(Month, 0);
            end;
        }
        field(14; "Training Hours"; Duration)
        {
            Editable = false;
        }
        field(15; "No. of Days"; Decimal)
        {
            Editable = false;
        }
        field(16; "Estimated Total Budget"; Decimal)
        {
            Editable = false;
        }
        field(17; "Training Nature"; Enum "Training Nature")
        {
            trigger OnValidate()
            begin
                Validate("Training Calendar No", '');
            end;
        }
        field(18; Province; Code[100])
        {
            trigger OnLookup()
            begin
                Validate(Province, HRMgt.SetCalendarHolidayProvience(Province));
            end;

            trigger OnValidate()
            begin
                if Province <> xRec.Province then begin
                    "Province Name" := '';
                    if Province <> '' then begin
                        ProvienceVar.Reset;
                        ProvienceVar.SetFilter(Code, Province);
                        if ProvienceVar.Find('-') then
                            repeat
                                if "Province Name" = '' then
                                    "Province Name" := ProvienceVar.Description
                                else
                                    "Province Name" += ',' + ProvienceVar.Description;
                            until ProvienceVar.Next = 0
                    end;
                    // "Sub-Province" := '';
                    "Branch Code" := '';
                end;
            end;
        }
        field(19; "Expected No. of Participant"; Decimal) { }
        field(20; "Province Name"; Text[250])
        {
            Editable = false;
        }
        field(21; "Approval Status"; enum "Approval Status")
        {
            Editable = false;
        }
        field(22; "Fiscal Year"; Text[10])
        {
            Editable = false;
        }
        field(23; "Training Calendar No"; Code[20])
        {
            TableRelation = if ("Training Nature" = const(Calendar)) "Training Calendar"
            else
            "Training Master";

            trigger OnValidate()
            begin
                if "Training Nature" = "Training Nature"::Calendar then begin
                    if TrainingCalendar.Get("Training Calendar No") then begin
                        Validate(Description, TrainingCalendar.Description);
                        Validate(Venue, TrainingCalendar."Expected Venue");
                        Validate("Expected No. of Participant", TrainingCalendar."Maximum Participant");
                        Validate("Training Type", TrainingCalendar."Training Type");
                        Validate("Estimated Total Budget", TrainingCalendar."Total Cost");
                        Validate("Resource Person", TrainingCalendar."Resouce person");
                        Validate(Cost, TrainingCalendar."Total Cost");
                        Validate(Province, TrainingCalendar.Province);
                        // Validate("Sub-Province", TrainingCalendar."Sub-Province");
                        Validate("Branch Code", TrainingCalendar."Coverage Branch");
                        Validate(Department, TrainingCalendar."Coverage Department");
                        Validate("Estimated Trainer Cost", TrainingCalendar."Trainer Cost");
                        Validate("Estimated Training Cost", TrainingCalendar."Training Cost");
                    end else begin
                        Clear(Description);
                        ClearFields;
                    end;
                end else begin
                    if TrainingMaster.Get("Training Calendar No") then
                        Validate(Description, TrainingMaster.Description);
                    ClearFields;
                end;
            end;
        }
        field(24; Cost; Decimal) { }
        // field(25; "Sub-Province"; Code[100])
        // {
        //     trigger OnLookup()
        //     begin
        //         Validate("Sub-Province", HRMgt.LookupSubProvinceTraining("Sub-Province", Province));
        //     end;

        //     trigger OnValidate()
        //     begin
        //         if "Sub-Province" <> xRec."Sub-Province" then
        //             "Branch Code" := '';
        //     end;
        // }
        field(26; "Branch Code"; Code[100])
        {
            TableRelation = "Organization Structure List".Code where(Type = filter("Deputation Type"::branch), Blocked = filter(false));
            // trigger OnLookup()
            // begin
            //     Validate("Branch Code", HRMgt.LookupBranch("Branch Code", Province, "Sub-Province"));
            // end;
        }
        field(27; Department; Code[100])
        {
            TableRelation = "Organization Structure List".Code where(Type = filter("Deputation Type"::Department), Blocked = filter(false));
            // trigger OnLookup()
            // begin
            //     Validate(Department, HRMgt.LookupDepartment(Department));
            // end;
        }
        field(28; Valley; enum "Outside/Inside Valley") { }
        field(29; "Total No. of Participant"; Integer)
        {
            CalcFormula = count("Training Line" where("Training No." = field("No."),
                                                       Type = const(Trainee)));
            FieldClass = FlowField;
            Editable = false;
        }
        field(30; "Function"; Enum "Training Function Type") { }
        field(31; "Estimated Training Cost"; Decimal)
        {
            trigger OnValidate()
            begin
                CalculateEstimatedTotalBudget;
            end;
        }
        field(32; "Estimated Trainer Cost"; Decimal)
        {
            trigger OnValidate()
            begin
                CalculateEstimatedTotalBudget;
            end;
        }
        field(33; "Estimated Other Cost"; Decimal)
        {
            trigger OnValidate()
            begin
                CalculateEstimatedTotalBudget;
            end;
        }
        field(34; "Training Category"; Enum "Training Category") { }
        field(35; "Total Trainer Marks"; Decimal)
        {
            Editable = false;
        }
        field(36; "Total Training Marks"; Decimal)
        {
            Editable = false;
        }
        field(37; "Actual Trainer Cost"; Decimal)
        {
            Editable = false;

            trigger OnValidate()
            begin
                if not Online then begin
                    Validate("Estimated Trainer Cost", "Actual Trainer Cost");
                    CalculateTotalBudget;
                end;
            end;
        }
        field(38; "Actual Other Cost"; Decimal)
        {
            trigger OnValidate()
            begin
                CalculateTotalBudget;
            end;
        }
        field(39; "Actual Training Cost"; Decimal)
        {
            trigger OnValidate()
            begin
                CalculateTotalBudget;
            end;
        }
        field(40; "Actual Total Budget"; Decimal)
        {
            Editable = false;
        }
        field(41; "ROCE Code"; Text[30]) { }
        field(42; "Prepared By"; Code[20])
        {
            TableRelation = Employee where(Status = const(Active));

            trigger OnValidate()
            begin
                HRMgt.GetEmployeeName("Prepared By", "Prepared By Name");
            end;
        }
        field(43; "Reviewed By"; Code[20])
        {
            TableRelation = Employee where(Status = const(Active));

            trigger OnValidate()
            begin
                HRMgt.GetEmployeeName("Reviewed By", "Reviewed By Name");
            end;
        }
        field(44; Month; Enum "Nepali Month")
        {
            trigger OnValidate()
            begin
                TestField("Fiscal Year");
                if not ("Approval Status" in ["Approval Status"::Open, "Approval Status"::Pending]) then
                    Error(MonthError, "No.");
                TrainBudgHead.Reset;
                TrainBudgHead.SetRange("Fiscal Year", "Fiscal Year");
                if TrainBudgHead.FindFirst then begin
                    TrainBudgtLine.Reset;
                    TrainBudgtLine.SetRange("Training Header Entry No.", TrainBudgHead."Entry No.");
                    TrainBudgtLine.SetRange(Month, Month);
                    if TrainBudgtLine.FindFirst then begin
                        Validate("MTD Amount", TrainBudgtLine."Budget Amount");
                        Validate("YTD Amount", TrainBudgtLine."YTD Budget");
                    end else begin
                        Validate("MTD Amount", 0);
                        Validate("YTD Amount", 0);
                    end;
                end else begin
                    Validate("MTD Amount", 0);
                    Validate("YTD Amount", 0);
                end;
            end;
        }
        field(45; "YTD Amount"; Decimal)
        {
            Editable = false;
        }
        field(46; "MTD Amount"; Decimal)
        {
            Editable = false;
        }
        field(47; "YTD Expense"; Decimal)
        {
            Editable = false;
        }
        field(48; "MTD Expense"; Decimal)
        {
            Editable = false;
        }
        field(49; "Supported By"; Code[20])
        {
            TableRelation = Employee where(Status = const(Active));

            trigger OnLookup()
            begin
                EmpVar.Reset;
                if Page.RunModal(0, EmpVar) = Action::LookupOK then
                    if StrPos("Supported By", EmpVar."No.") = 0 then
                        if "Supported By" <> '' then
                            Validate("Supported By", "Supported By" + '|' + EmpVar."No.")
                        else
                            Validate("Supported By", EmpVar."No.");
            end;

            trigger OnValidate()
            begin
                HRMgt.GetEmployeeName("Supported By", "Supported By Name");
            end;
        }
        field(50; Posted; Boolean) { }
        field(51; "Trainer Percent"; Decimal)
        {
            Editable = false;

            trigger OnValidate()
            begin
                RatingSetup.Reset;
                RatingSetup.SetRange(Type, RatingSetup.Type::Training);
                RatingSetup.SetFilter(From, '<=%1', "Trainer Percent");
                RatingSetup.SetFilter("To", '>=%1', "Trainer Percent");
                if RatingSetup.FindFirst then
                    Validate("Trainer Remarks", Format(RatingSetup.Rating));
            end;
        }
        field(52; "Training Percent"; Decimal)
        {
            Editable = false;

            trigger OnValidate()
            begin
                RatingSetup.Reset;
                RatingSetup.SetRange(Type, RatingSetup.Type::Training);
                RatingSetup.SetFilter(From, '<=%1', "Training Percent");
                RatingSetup.SetFilter("To", '>=%1', "Training Percent");
                if RatingSetup.FindFirst then
                    Validate("Training Remarks", Format(RatingSetup.Rating));
            end;
        }
        field(53; "Trainer Remarks"; Text[50])
        {
            Editable = false;
        }
        field(54; "Training Remarks"; Text[500])
        {
            Editable = false;
        }
        field(55; "HR Manager Code"; Code[20])
        {
            TableRelation = Employee;

            trigger OnValidate()
            begin
                if Employee.Get("HR Manager Code") then
                    Validate("HR Manager Name", Employee."Full Name");
            end;
        }
        field(56; "HR Manager Name"; Text[50]) { }
        field(57; "HR Head Code"; Code[20])
        {
            TableRelation = Employee;
        }
        field(58; "HR Head Name"; Text[50])
        {
            trigger OnValidate()
            begin
                if Employee.Get("HR Head Code") then
                    Validate("HR Head Name", Employee."Full Name");
            end;
        }
        field(59; "Estimated Fooding Cost"; Decimal)
        {
            trigger OnValidate()
            begin
                CalculateEstimatedTotalBudget;
            end;
        }
        field(60; "Actual Fooding Cost"; Decimal) { }
        field(61; "Prepared By Name"; Text[50]) { }
        field(62; "Reviewed By Name"; Text[50]) { }
        field(63; "Supported By Name"; Text[50]) { }
        field(64; Online; Boolean) { }
        field(65; "Sponsorship Type"; Enum "Sponsorship Type") { }
        field(66; Country; Code[20])
        {
            TableRelation = "Country/Region";
            trigger OnValidate()
            var
                CountryRec: Record "Country/Region";
            begin
                if CountryRec.Get(Country) then
                    Validate("Country Name", CountryRec.Name)
                else
                    Clear("Country Name");
            end;
        }
        field(67; "Country Name"; Text[100])
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "No.") { }
    }

    fieldgroups { }

    trigger OnDelete()
    begin
        if "Approval Status" <> "Approval Status"::Open then
            Error(DeleteError, "No.");

        TrainingLine.Reset;
        TrainingLine.SetRange("Training No.", "No.");
        TrainingLine.DeleteAll(true);
    end;

    trigger OnInsert()
    var
        TrainingHeader: Record "Training Header";
    begin
        if "No." = '' then begin
            HRSetup.Get;
            HRSetup.TestField("Training No.");
            HRMgt.InitNoSeriesNew(HRSetup."Training No.", xRec."No. Series", 0D, "No.", "No. Series");

            TrainingHeader.ReadIsolation(IsolationLevel::ReadUncommitted);
            TrainingHeader.SetLoadFields("No.");
            while TrainingHeader.Get("No.") do
                "No." := NoSeriesMgt.GetNextNo("No. Series");
        end;
        Validate("Requested Date", Today);
    end;

    var
        HRSetup: Record "Human Resources Setup";
        NoSeriesMgt: Codeunit "No. Series";
        HRMgt: Codeunit "HR Mgt.";
        ProvienceVar: Record Province;
        TrainingCalendar: Record "Training Calendar";
        TrainingLine: Record "Training Line";
        DeleteError: Label 'Document %1 must be open. ';
        TrainingMaster: Record "Training Master";
        VendorVar: Record Vendor;
        EngNepDate: Record "English-Nepali Date";
        TrainBudgHead: Record "Training Budget Header";
        TrainBudgtLine: Record "Training Budget Line";
        MonthError: Label 'Document %1 must be open or pending.';
        TrainHead: Record "Training Header";
        TrainLine: Record "Training Line";
        RatingSetup: Record "Rating Setup";
        DateError: Label '%1 : %2 should be greater than %3: %4';
        Employee: Record Employee;
        TrainAttendance: Record "Training Attendance";
        Found: Boolean;
        EmpFeedback: Record "Employee Feedback";
        EmpVar: Record Employee;
        leaveMgt: Codeunit "Leave Mgt.";

    procedure AssistEdit(OldRec: Record "Training Header"): Boolean
    var
        TrainHeader: Record "Training Header";
    begin
        TrainHeader := Rec;
        HRSetup.Get;
        HRSetup.TestField("Training No.");
        if NoSeriesMgt.LookupRelatedNoSeries(HRSetup."Training No.", OldRec."No. Series", TrainHeader."No. Series") then begin
            NoSeriesMgt.GetNextNo(TrainHeader."No.");
            exit(true);
        end;
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendTrainingDocForApproval(var TrainHead: Record "Training Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelTrainingDocForApproval(var TrainHead: Record "Training Header")
    begin
    end;

    procedure UpdateApprovalStatus(var TrainHead: Record "Training Header"; ApprovalStatus: enum "Approval Status")
    begin
        TrainHead.Validate("Approval Status", ApprovalStatus);
        TrainHead.Modify;
    end;

    local procedure CalculateEstimatedTotalBudget()
    begin
        if not Online then
            Validate("Estimated Total Budget", "Estimated Training Cost" + "Estimated Trainer Cost" + "Estimated Other Cost" + "Estimated Fooding Cost");
    end;

    local procedure ClearFields()
    begin
        Clear(Venue);
        Clear("Expected No. of Participant");
        Clear("Training Type");
        Clear("Estimated Total Budget");
        Clear("Resource Person");
        Clear(Cost);
        // Clear("Sub-Province");
        Clear(Province);
        Clear("Province Name");
        Clear("Branch Code");
        Clear(Department);
    end;

    local procedure CalculateTotalBudget()
    begin
        if not Online then
            Validate("Actual Total Budget", "Actual Trainer Cost" + "Actual Training Cost" + "Actual Other Cost" + "Actual Fooding Cost");
    end;

    procedure CalculateYTDExpense()
    var
        YTDAmt: Decimal;
    begin
        TestField("Fiscal Year");
        TrainHead.Reset;
        TrainHead.SetRange("Fiscal Year", "Fiscal Year");
        TrainHead.SetRange("Approval Status", "Approval Status"::Released);
        TrainHead.SetFilter("No.", '<>%1', "No.");
        if TrainHead.Find('-') then
            repeat
                YTDAmt += TrainHead."Actual Total Budget";
            until TrainHead.Next = 0;
        Validate("YTD Expense", YTDAmt + "Actual Total Budget");
    end;

    procedure CalcualteMTDExpense()
    var
        MTDExpense: Decimal;
    begin
        TestField(Month);
        TestField("Fiscal Year");
        Clear(MTDExpense);
        Clear("MTD Expense");

        TrainHead.Reset;
        TrainHead.SetRange("Fiscal Year", "Fiscal Year");
        TrainHead.SetRange("Approval Status", "Approval Status"::Released);
        TrainHead.SetRange(Month, Month);
        TrainHead.SetFilter("No.", '<>%1', "No.");
        if TrainHead.Find('-') then
            repeat
                MTDExpense += TrainHead."Actual Total Budget";
            until TrainHead.Next = 0;
        Validate("MTD Expense", MTDExpense + "Actual Total Budget");
    end;

    procedure SetPosted()
    begin
        TestField("Approval Status", "Approval Status"::Released);
        TrainLine.Reset;
        TrainLine.SetRange("Training No.", "No.");
        TrainLine.SetRange(Type, TrainLine.Type::Trainee);
        if TrainLine.FindFirst then
            repeat
                TrainAttendance.Reset;
                TrainAttendance.SetRange("Training No", TrainLine."Training No.");
                TrainAttendance.SetRange("Employee No.", TrainLine."Employee Code");
                Found := TrainAttendance.FindFirst;

                EmpFeedback.Reset;
                EmpFeedback.SetRange(Code, TrainLine."Training No.");
                EmpFeedback.SetRange("Employee No.", TrainLine."Employee Code");
                EmpFeedback.SetRange(Type, EmpFeedback.Type::Training);
                EmpFeedback.SetRange("Sub Type", EmpFeedback."Sub Type"::Training);
                EmpFeedback.SetRange("Is Subjective", false);
                if (EmpFeedback.FindFirst) and (Found) then
                    repeat
                        EmpFeedback.TestField(Answer);
                    until EmpFeedback.Next = 0;
            until TrainLine.Next = 0;

        TrainLine.Reset;
        TrainLine.SetRange("Training No.", "No.");
        if TrainLine.FindFirst then
            if TrainLine."Payment Mode" = TrainLine."Payment Mode"::"account Credit" then begin
                TrainLine.TestField("Account No.");
                TrainLine.TestField("Shortcut Dimension 1 Code", '');
                TrainLine.TestField("Department Code", '');
            end
            else if TrainLine."Payment Mode" = TrainLine."Payment Mode"::IDT then begin
                TrainLine.TestField("Account No.");
                TrainLine.TestField("Shortcut Dimension 1 Code");
                TrainLine.TestField("Department Code");
            end;

        Posted := true;
    end;

    procedure CheckLineForApproval()
    begin
        Clear(TrainLine);
        TrainLine.SetRange("Training No.", "No.");
        TrainLine.SetRange(Type, TrainLine.Type::Trainer);
        if TrainLine.Count = 0 then
            Error('There must be a trainer in training No %1', "No.");
        Clear(TrainLine);
        TrainLine.SetRange("Training No.", "No.");
        TrainLine.SetRange(Type, TrainLine.Type::Trainee);
        if TrainLine.Count = 0 then
            Error('There must be a trainee in training No %1', "No.");
    end;
}
