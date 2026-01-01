table 50070 "Training Line"
{
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Training No."; Code[20]) { }
        field(2; "Line No"; Integer) { }
        field(3; "Employee Code"; Code[20])
        {
            TableRelation = if (Type = const(Trainee)) Employee where(Status = const(Active))
            else if (Type = const(Trainer),
                                     "Trainer Type" = const(Internal)) "Facilitator Pool"."Employee No." where("Fiscal Year" = field("Fiscal Year"),
                                                                                                              "Approval Status" = const(released))
            else if (Type = const(Vendor)) Vendor where(Blocked = const(" "));

            trigger OnValidate()
            begin
                GetTrainHead;
                Validate("Training Description", TrainHead.Description);
                Validate("Training Start Date", TrainHead."Start Date");
                Validate("Training End Date", TrainHead."End Date");
                EmpVar.Reset;
                if Type <> Type::Vendor then begin
                    if EmpVar.Get("Employee Code") then begin
                        if "Employee Code" <> xRec."Employee Code" then begin
                            EmpVar.TestField(Status, EmpVar.Status::Active);
                            TrainLine.Reset;
                            TrainLine.SetRange("Employee Code", "Employee Code");
                            TrainLine.SetRange("Training No.", "Training No.");
                            if Type = Type::Trainer then begin
                                TestField("Trainer Date");
                                TrainLine.SetRange("Trainer Date", "Trainer Date");
                            end;
                            if TrainLine.FindFirst then
                                Error(ErrorEmp, "Training No.");
                            Validate(Name, EmpVar."Full Name");
                            Validate("Department Code", EmpVar."Department Code");
                            Validate("Shortcut Dimension 1 Code", EmpVar."Global Dimension 1 Code");
                        end;
                    end else begin
                        Clear(Name);
                        Clear("Department Code");
                        Clear("Shortcut Dimension 1 Code");
                    end;
                end else begin
                    if Vendor.Get("Employee Code") then
                        Validate(Name, Vendor.Name);
                end;
                if Type = Type::Trainee then
                    HRMgt.InsertEmployeeWiseTrainingQuestion("Training No.", "Employee Code");
            end;
        }
        field(4; Name; Text[100]) { }
        field(5; "Department Code"; Code[20])
        {
            TableRelation = "Organization Structure List".Code where(Type = const(Department));
        }
        field(6; "Department Name"; Text[100]) { }
        field(7; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1),
                                                          Blocked = const(false));
        }
        field(8; "Branch Name"; Text[100]) { }
        field(9; Type; Enum "Training Line Type") { }
        field(10; "Training Description"; Text[250]) { }
        field(11; Attended; Boolean) { }
        field(12; "Training Start Date"; Date) { }
        field(13; "Training End Date"; Date) { }
        field(14; "Fiscal Year"; Text[10]) { }
        field(15; "Trainer Type"; Enum InternalExternal)
        {
            trigger OnValidate()
            begin
                GetTrainHead;
                Validate("Training Description", TrainHead.Description);
                Validate("Training Start Date", TrainHead."Start Date");
                Validate("Training End Date", TrainHead."End Date");
                case TrainHead."Resource Person" of
                    TrainHead."Resource Person"::External:
                        if "Trainer Type" <> "Trainer Type"::External then
                            Error(ErrorExtRes);

                    TrainHead."Resource Person"::Internal:
                        if "Trainer Type" <> "Trainer Type"::Internal then
                            Error(ErrorExtInt);
                end;
            end;
        }
        field(16; "Name of Organization"; Text[250]) { }
        field(17; "Start Time"; Time)
        {
            trigger OnValidate()
            begin
                if "Start Time" <> xRec."Start Time" then begin
                    Clear("End Time");
                    Clear("Trainer Cost");
                    Clear("Total Hours");
                end;
            end;
        }
        field(18; "End Time"; Time)
        {
            trigger OnValidate()
            begin
                if "End Time" <> xRec."End Time" then begin
                    Clear("Total Hours");
                    Clear("Trainer Cost");
                    Validate("Total Hours", "End Time" - "Start Time");
                end;
                Modify;
                GetTrainerHours;
            end;
        }
        field(19; "Total Hours"; Duration)
        {
            Editable = false;

            trigger OnValidate()
            begin
                SetTrainerCost;
                //GetTrainerHours;
            end;
        }
        field(20; "Trainer Date"; Date)
        {
            trigger OnValidate()
            begin
                if ("Training Start Date" > "Trainer Date") or ("Training End Date" < "Trainer Date") then
                    Error(ErrorTrainerDate, "Training Start Date", "Training End Date");
            end;
        }
        field(21; "Trainer Marks"; Decimal)
        {
            Editable = false;
        }
        field(22; "Training Marks"; Decimal)
        {
            Editable = false;
        }
        field(23; "Trainer Cost"; Decimal)
        {
            trigger OnValidate()
            begin
                CalculateTrainerCost;
            end;
        }
        field(24; "Payment Mode"; Enum "Payment Mode") { }
        field(25; Amount; Decimal)
        {
            trigger OnValidate()
            begin
                Clear(Amt);
                TrainLine.Reset;
                TrainLine.SetRange("Training No.", "Training No.");
                TrainLine.SetRange(Type, TrainLine.Type::Vendor);
                TrainLine.SetFilter("Line No", '<>%1', "Line No");
                if TrainLine.Find('-') then
                    repeat
                        Amt += TrainLine.Amount;
                    until TrainLine.Next = 0;
                Amt += Amount;
                GetTrainHead;
                if Amt > (TrainHead."Actual Other Cost" + TrainHead."Actual Training Cost") then
                    Error(ErrorVendPay, TrainHead."Actual Other Cost" + TrainHead."Actual Training Cost");
            end;
        }
        field(26; "Vendor Invoice No."; Text[30]) { }
        field(27; "Training Type"; enum "Training Type") { }
        field(28; "Account No."; Code[20]) { }
        field(29; "Sponsorship Type"; Enum "Sponsorship Type") { }
        field(30; Country; Code[20])
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
        field(31; "Country Name"; Text[100])
        {
            Editable = false;
        }
        field(32; "Branch Code"; Code[20])
        {
            TableRelation = "Organization Structure List".Code where(Type = const(Branch));
            trigger OnValidate()
            var
                OrgStructureList: Record "Organization Structure List";
            begin
                if OrgStructureList.Get(OrgStructureList.Type::Branch, "Branch Code") then
                    "Branch Name" := OrgStructureList.Name
                else
                    "Branch Name" := '';
            end;
        }
        field(54; "Training Remarks"; Text[500])
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Training No.", Type, "Line No") { }
    }

    fieldgroups { }

    trigger OnDelete()
    begin
        TrainingAtt.Reset;
        TrainingAtt.SetRange("Employee No.", "Employee Code");
        TrainingAtt.SetRange("Training No", "Training No.");
        TrainingAtt.DeleteAll;

        QATraining.Reset;
        QATraining.SetRange("Employee No.", "Employee Code");
        QATraining.SetRange(Code, "Training No.");
        QATraining.DeleteAll;
    end;

    trigger OnInsert()
    begin
        GetTrainHead;
        Validate("Training Description", TrainHead.Description);
        Validate("Training Start Date", TrainHead."Start Date");
        Validate("Training End Date", TrainHead."End Date");
        Validate("Fiscal Year", TrainHead."Fiscal Year");
        Validate("Training Type", TrainHead."Training Type");
    end;

    var
        EmpVar: Record Employee;
        TrainHead: Record "Training Header";
        TrainLine: Record "Training Line";
        ErrorEmp: Label 'Employee already exists in Training Document No. %1.';
        ErrorExtRes: Label 'Trainer Type must be external.';
        ErrorExtInt: Label 'Trainer Type must be internal.';
        ErrorTrainerDate: Label 'Date must be between %1 and %2.';
        HRMgt: Codeunit "HR Mgt.";
        TrainingAtt: Record "Training Attendance";
        QATraining: Record "Employee Feedback";
        SalaryLevel: Record "Salary Level";
        LevelWiseAttributes: Record "Level Wise Attributes";
        PRSetup: Record "Payroll General Setup";
        Vendor: Record Vendor;
        Amt: Decimal;
        ErrorVendPay: Label 'Total payee amount must be less than %1.';

    procedure GetTrainHead(): Text
    begin
        TrainHead.Get("Training No.");
        TrainHead.TestField(Description);
        TrainHead.TestField("Start Date");
        TrainHead.TestField("End Date");
        exit(TrainHead."Fiscal Year");
    end;

    local procedure SetTrainerCost()
    begin
        if (Type = Type::Trainer) and ("Trainer Type" = "Trainer Type"::Internal) then begin
            PRSetup.Get;
            EmpVar.Get("Employee Code");
            SalaryLevel.Get(EmpVar."Salary Level");
            LevelWiseAttributes.Get(EmpVar."Salary Grade", EmpVar."Salary Level");
            Validate("Trainer Cost", Round(SalaryLevel."Net Learning" * ("Total Hours" / 3600000 / PRSetup."Base Teaching Hours") * (LevelWiseAttributes."Total Basic Salary" + LevelWiseAttributes.Allowance) / GetNepalMonthiDays, 0.01, '='));
        end;
    end;

    local procedure GetNepalMonthiDays(): Integer
    var
        EngNepDate: Record "English-Nepali Date";
        NepaliMonth: Enum "Nepali Month";
        NepaliYear: Integer;
        StartDate: Date;
        EndDate: Date;
    begin
        EngNepDate.Reset;
        EngNepDate.SetRange("English Date", "Training Start Date");
        if EngNepDate.FindFirst then begin
            NepaliMonth := EngNepDate."Nepali Month";
            NepaliYear := EngNepDate."Nepali Year";
        end;

        Clear(EngNepDate);
        EngNepDate.SetCurrentKey("Nepali Year", "Nepali Month", "Nepali Day");
        EngNepDate.SetRange("Nepali Month", NepaliMonth);
        EngNepDate.SetRange("Nepali Year", NepaliYear);
        if EngNepDate.FindFirst then
            StartDate := EngNepDate."English Date";

        Clear(EngNepDate);
        EngNepDate.SetCurrentKey("Nepali Year", "Nepali Month", "Nepali Day");
        EngNepDate.SetRange("Nepali Month", NepaliMonth);
        EngNepDate.SetRange("Nepali Year", NepaliYear);
        if EngNepDate.FindLast then
            EndDate := EngNepDate."English Date";

        exit(EndDate - StartDate + 1);
    end;

    local procedure CalculateTrainerCost()
    var
        TrainerCost: Decimal;
    begin
        Clear(TrainerCost);
        TrainLine.Reset;
        TrainLine.SetRange("Training No.", "Training No.");
        TrainLine.SetRange(Type, TrainLine.Type::Trainer);
        TrainLine.SetFilter("Line No", '<>%1', "Line No");
        if TrainLine.Find('-') then
            repeat
                TrainerCost += TrainLine."Trainer Cost";
            until TrainLine.Next = 0;
        TrainerCost += "Trainer Cost";
        GetTrainHead;
        TrainHead.Validate("Actual Trainer Cost", TrainerCost);
        TrainHead.Modify;
    end;

    local procedure GetTrainerHours()
    var
        TrainLine: Record "Training Line";
        TrainHead: Record "Training Header";
        TotalHours: Decimal;
    begin
        Clear(TotalHours);
        TrainLine.Reset;
        TrainLine.SetRange("Training No.", "Training No.");
        TrainLine.SetRange(Type, TrainLine.Type::Trainer);
        if TrainLine.FindFirst then
            repeat
                TotalHours += TrainLine."End Time" - TrainLine."Start Time";
            until TrainLine.Next = 0;
        TrainHead.Get("Training No.");
        /*IF TrainHead."Training Hours"<TotalHours THEN
          ERROR(TEXT001, TrainHead."Training Hours", TotalHours);*/
        TrainHead.Validate("Training Hours", TotalHours);
        TrainHead.Modify;
    end;
}
