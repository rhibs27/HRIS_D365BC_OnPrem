codeunit 50028 "Excel Import"
{

    procedure ImportFromExcelSheet(TableID: Integer; UseColumnName: Boolean)
    var
        FileMgt: Codeunit "File Management";
        IStream: InStream;
        FromFile, CellValue : Text;
        RowNo, LastRow, NoOfField, ColNo : Integer;
        FieldRef: FieldRef;
        RecRef: RecordRef;
    begin
        if UploadIntoStream('Import From Excel', '', '', FromFile, IStream) then begin
            if FromFile <> '' then begin
                FileName := FileMgt.GetFileName(FromFile);
                SheetName := ExcelBuffer.SelectSheetsNameStream(IStream);
            end
            else
                Error('No file found.');

            ExcelBuffer.Reset();
            ExcelBuffer.DeleteAll();
            ExcelBuffer.OpenBookStream(IStream, SheetName);
            ExcelBuffer.ReadSheet();
            ExcelBuffer.SetRange("Column No.", 1);
            ExcelBuffer.FindLast();
            LastRow := ExcelBuffer."Row No.";

            ExcelBuffer.Reset();
            RecRef.Open(TableID);
            NoOfField := RecRef.FieldCount;
            for RowNo := 2 to LastRow do begin
                RecRef.Init();
                for ColNo := 1 to (NoOfField - 2) do begin          //Reduced by 1 to exclude 2 fields in the table referred i.e. Entry Number and Posted
                    FieldRef := RecRef.Field(ColNo + 1);
                    CellValue := GetValueAtCell(RowNo, ColNo);
                    if CellValue <> '' then begin
                        case FieldRef.Type of
                            FieldRef.Type::Integer:
                                FieldRef.Validate(EvaluateInt(CellValue));
                            FieldRef.Type::Decimal:
                                FieldRef.Validate(EvaluateDecimal(CellValue));
                            FieldRef.Type::Date:
                                FieldRef.Validate(EvaluateDate(CellValue));
                            FieldRef.Type::Boolean:
                                FieldRef.Validate(EvaluateBoolean(CellValue));
                            else
                                FieldRef.Validate(CellValue);
                        end;
                    end;
                end;
                RecRef.Insert(true);
            end;
            Message(ExcelImportSuccess);
        end;
    end;

    local procedure GetValueAtCell(RowNo: Integer; ColNo: Integer): Text
    begin

        ExcelBuffer.Reset();
        if ExcelBuffer.Get(RowNo, ColNo) then
            exit(ExcelBuffer."Cell Value as Text")
        else
            exit('');
    end;

    local procedure EvaluateInt(Value: Text): Integer
    var
        IntValue: Integer;
    begin
        Evaluate(IntValue, Value);
        exit(IntValue);
    end;

    local procedure EvaluateDecimal(Value: Text): Decimal
    var
        DecValue: Decimal;
    begin
        Evaluate(DecValue, Value);
        exit(DecValue);
    end;

    local procedure EvaluateDate(Value: Text): Date
    var
        DateValue: Date;
    begin
        Evaluate(DateValue, Value);
        exit(DateValue);
    end;

    local procedure EvaluateBoolean(Value: Text): Boolean
    begin
        exit(LowerCase(Value) in ['yes', 'true', '1']);
    end;

    var
        ExcelBuffer: Record "Excel Buffer" temporary;
        Filename: Text[250];
        SheetName: Text[250];
        ExcelImportSuccess: Label 'Data is successfully imported.';

}
