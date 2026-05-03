table 50072 "Training Budget Header"
{
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
            Editable = false;
        }
        field(2; "Fiscal Year"; Code[20])
        {
            TableRelation = "Pay Cycle Term".Term;
            trigger OnValidate()
            begin
                if "Fiscal Year" <> xRec."Fiscal Year" then begin
                    TrainBudgetHead.Reset;
                    TrainBudgetHead.SetRange("Fiscal Year", "Fiscal Year");
                    if TrainBudgetHead.FindFirst then
                        Error(ErrorFiscal, TrainBudgetHead."Fiscal Year");
                end;
            end;
        }
        field(3; Description; Text[50]) { }
        field(4; "Total Budget"; Decimal) { }
    }

    keys
    {
        key(Key1; "Entry No.") { }
    }

    fieldgroups { }

    trigger OnDelete()
    begin
        TrainBudgetLine.Reset;
        TrainBudgetLine.SetRange("Training Header Entry No.", "Entry No.");
        TrainBudgetLine.DeleteAll;
    end;

    var
        TrainBudgetHead: Record "Training Budget Header";
        ErrorFiscal: Label 'Fiscal Year %1 already exist.';
        TrainBudgetLine: Record "Training Budget Line";
        TrainBudgetLine2: Record "Training Budget Line";
        Amt: Decimal;

    procedure GetTrainBudgetLine()
    var
        i: Integer;
        LineNo: Integer;
        j: Integer;
        TrainingMaster: Record "Training Master";
    begin
        TrainBudgetLine.Reset;
        TrainBudgetLine.SetRange("Training Header Entry No.", "Entry No.");
        TrainBudgetLine.DeleteAll;
        Clear(LineNo);
        LineNo := 10000;
        for i := 1 to 12 do begin
            j := (i + 3) mod 12;
            TrainBudgetLine.Init;
            TrainBudgetLine.Validate("Training Header Entry No.", "Entry No.");
            TrainBudgetLine.Validate("Line No", LineNo);
            TrainBudgetLine.Validate("Budget By", TrainBudgetLine."Budget By"::Month);
            LineNo += 10000;
            if j = 0 then
                j := 12;
            TrainBudgetLine.Validate(Month, j);
            TrainBudgetLine.Insert;
        end;

        TrainingMaster.Reset();
        TrainingMaster.SetRange("Master Type", "Training Setup Type"::"Training Category");
        if TrainingMaster.FindSet() then
            repeat
                TrainBudgetLine.Init();
                TrainBudgetLine.Validate("Training Header Entry No.", "Entry No.");
                TrainBudgetLine.Validate("Line No", LineNo);
                TrainBudgetLine.Validate("Budget By", TrainBudgetLine."Budget By"::"Training Category");
                TrainBudgetLine.Validate("Training Category", TrainingMaster.Code);
                TrainBudgetLine.Insert();
                LineNo += 10000;
            until TrainingMaster.Next() = 0;
    end;

    procedure CalculateMonthlyTrainBudgetLine()
    begin
        TrainBudgetLine.Reset;
        TrainBudgetLine.SetRange("Training Header Entry No.", "Entry No.");
        TrainBudgetLine.SetCurrentKey("Training Header Entry No.", "Line No");
        TrainBudgetLine.SetRange("Budget By", TrainBudgetLine."Budget By"::Month);
        if TrainBudgetLine.Find('-') then
            repeat
                TrainBudgetLine."Budgeted No. of Trainings" := GetBudgetedTrainingNoInMonth(TrainBudgetLine.Month, '', true);
                TrainBudgetLine."Budgeted Amount" := GetBudgetedAmountInAMonth(TrainBudgetLine.Month, '', true);
                TrainBudgetLine."Actual No. of Trainings" := GetActualTrainingNoInMonth(TrainBudgetLine.Month, '', true);
                TrainBudgetLine."Actual Amount" := GetActualAmountInAMonth(TrainBudgetLine.Month, '', true);

                TrainBudgetLine2.SetRange("Training Header Entry No.", "Entry No.");
                TrainBudgetLine2.SetFilter("Line No", '<%1', TrainBudgetLine."Line No");
                TrainBudgetLine2.CalcSums("Budgeted Amount", "Actual Amount");
                TrainBudgetLine."YTD Budgeted Amount" := TrainBudgetLine2."Budgeted Amount" + TrainBudgetLine."Budgeted Amount";
                TrainBudgetLine."YTD Actual Amount" := TrainBudgetLine2."Actual Amount" + TrainBudgetLine."Actual Amount";
                TrainBudgetLine.Modify;
            until TrainBudgetLine.Next = 0;
    end;

    procedure CalculateCategorizedTrainingBudgetLine()
    begin
        TrainBudgetLine.Reset;
        TrainBudgetLine.SetRange("Training Header Entry No.", "Entry No.");
        TrainBudgetLine.SetCurrentKey("Training Header Entry No.", "Line No");
        TrainBudgetLine.SetRange("Budget By", TrainBudgetLine."Budget By"::"Training Category");
        if TrainBudgetLine.FindSet() then
            repeat
                TrainBudgetLine."Budgeted No. of Trainings" := GetBudgetedTrainingNoInMonth(TrainBudgetLine.Month, TrainBudgetLine."Training Category", false);
                TrainBudgetLine."Budgeted Amount" := GetBudgetedAmountInAMonth(TrainBudgetLine.Month, TrainBudgetLine."Training Category", false);
                TrainBudgetLine."Actual No. of Trainings" := GetActualTrainingNoInMonth(TrainBudgetLine.Month, TrainBudgetLine."Training Category", false);
                TrainBudgetLine."Actual Amount" := GetActualAmountInAMonth(TrainBudgetLine.Month, TrainBudgetLine."Training Category", false);
                TrainBudgetLine.Modify();
            until TrainBudgetLine.Next() = 0;
    end;

    local procedure GetBudgetedTrainingNoInMonth(TrainingMonth: Enum "Nepali Month"; TrainingCategory: Code[20]; IsMonth: Boolean): Integer
    var
        TrainingCalendar: Record "Training Calendar";
    begin
        TrainingCalendar.Reset();
        if IsMonth then
            TrainingCalendar.SetRange(Month, TrainingMonth)
        else
            TrainingCalendar.SetRange("Training Category", TrainingCategory);
        exit(TrainingCalendar.Count);
    end;

    local procedure GetBudgetedAmountInAMonth(TrainingMonth: Enum "Nepali Month"; TrainingCategory: Code[20]; IsMonth: Boolean): Decimal
    var
        TrainingCalendar: Record "Training Calendar";
    begin
        TrainingCalendar.Reset();
        if IsMonth then
            TrainingCalendar.SetRange(Month, TrainingMonth)
        else
            TrainingCalendar.SetRange("Training Category", TrainingCategory);
        TrainingCalendar.CalcSums("Total Cost");
        exit(TrainingCalendar."Total Cost");
    end;

    local procedure GetActualTrainingNoInMonth(TrainingMonth: Enum "Nepali Month"; TrainingCategory: Code[20]; IsMonth: Boolean): Integer
    var
        TrainingHeader: Record "Training Header";
    begin
        TrainingHeader.Reset();
        if IsMonth then
            TrainingHeader.SetRange(Month, TrainingMonth)
        else
            TrainingHeader.SetRange("Training Category", TrainingCategory);
        exit(TrainingHeader.Count);
    end;

    local procedure GetActualAmountInAMonth(TrainingMonth: Enum "Nepali Month"; TrainingCategory: Code[20]; IsMonth: Boolean): Integer
    var
        TrainingHeader: Record "Training Header";
    begin
        TrainingHeader.Reset();
        if IsMonth then
            TrainingHeader.SetRange(Month, TrainingMonth)
        else
            TrainingHeader.SetRange("Training Category", TrainingCategory);
        TrainingHeader.CalcSums("Actual Total Cost");
        exit(TrainingHeader."Actual Total Cost");
    end;
}
