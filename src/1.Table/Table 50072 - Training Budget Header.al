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
        field(2; "Fiscal Year"; Code[10])
        {
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
            LineNo += 10000;
            if j = 0 then
                j := 12;
            TrainBudgetLine.Validate(Month, j);
            TrainBudgetLine.Insert;
        end;
    end;

    procedure CalculateTrainBudgetLine()
    begin
        Clear(Amt);
        TrainBudgetLine.Reset;
        TrainBudgetLine.SetRange("Training Header Entry No.", "Entry No.");
        TrainBudgetLine.SetCurrentKey("Training Header Entry No.", "Line No");
        if TrainBudgetLine.Find('-') then
            repeat
                TrainBudgetLine2.SetRange("Training Header Entry No.", "Entry No.");
                TrainBudgetLine2.SetFilter("Line No", '<%1', TrainBudgetLine."Line No");
                TrainBudgetLine2.CalcSums("Budget Amount");
                TrainBudgetLine."YTD Budget" := TrainBudgetLine2."Budget Amount" + TrainBudgetLine."Budget Amount";
                TrainBudgetLine.Modify;
                Amt := TrainBudgetLine2."Budget Amount" + TrainBudgetLine."Budget Amount";
                ;
            until TrainBudgetLine.Next = 0;
        "Total Budget" := Amt;
        Modify;
    end;
}
