codeunit 50028 "Excel Import"
{

    procedure ImportFromExcelSheet(TableID: Integer; DocNo: Code[20]; UseColumnName: Boolean)
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
                for ColNo := 1 to (NoOfField - 1) do begin
                    if Database::"Employee Payroll Adjustment" = TableID then begin
                        FieldRef := RecRef.Field(1);
                        FieldRef.Validate(DocNo);
                    end;
                    FieldRef := RecRef.Field(ColNo + 1);//Reduced by 1 to exclude 2 fields in the table referred i.e. Entry Number and Posted
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

    procedure ImportJournalFromExcelSheet(EmpActType: Enum "Employee Activity Type")
    var
        FileMgt: Codeunit "File Management";
        IStream: InStream;
        FromFile, CellValue : Text;
        RowNo, LastRow, LastColumn, NoOfField, ColNo, LineNo : Integer;
        FieldRef: FieldRef;
        RecRef: RecordRef;
        EmployeeActJournal: Record "Employee Activity Journal";
        FirstLine: Boolean;
        EmpActNo: Code[20];
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
            FirstLine := true;
            for RowNo := 2 to LastRow do begin
                if EmpActType = EmpActType::"Attendance Missed" then begin
                    EmployeeActJournal.Init();
                    EmployeeActJournal.Validate(Type, EmployeeActJournal.Type::"Employee Journal");
                    EmployeeActJournal.Validate("Employee Act Type", EmpActType);
                    EmployeeActJournal.Validate("Approval Status", EmployeeActJournal."Approval Status"::Open);
                    Evaluate(EmployeeActJournal."Employee No.", GetValueAtCell(RowNo, 1));
                    EmployeeActJournal.Validate("Employee No.");
                    Evaluate(EmployeeActJournal."Start Date", GetValueAtCell(RowNo, 3));
                    EmployeeActJournal.Validate("Start Date");
                    Evaluate(EmployeeActJournal."CheckIn Time", GetValueAtCell(RowNo, 4));
                    EmployeeActJournal.Validate("CheckIn Time");
                    Evaluate(EmployeeActJournal."CheckOut Time", GetValueAtCell(RowNo, 5));
                    EmployeeActJournal.Validate("CheckOut Time");
                    Evaluate(EmployeeActJournal."CheckOut OverNight", GetValueAtCell(RowNo, 6));
                    EmployeeActJournal.Validate("CheckOut OverNight");
                    Evaluate(EmployeeActJournal.Remarks, GetValueAtCell(RowNo, 7));
                    EmployeeActJournal.Validate(Remarks);
                    EmployeeActJournal.InsertApproval(FirstLine, EmpActNo);
                    EmployeeActJournal."Emp Act. No" := EmpActNo;
                    EmployeeActJournal."Line No" := EmployeeActJournal."Line No" + 10000;
                    EmployeeActJournal.Insert(true);
                end;
                if EmpActType = EmpActType::"Leave Request" then begin
                    EmployeeActJournal.Init();
                    EmployeeActJournal.Validate(Type, EmployeeActJournal.Type::"Employee Journal");
                    EmployeeActJournal.Validate("Employee Act Type", EmpActType);
                    EmployeeActJournal.Validate("Approval Status", EmployeeActJournal."Approval Status"::Open);
                    Evaluate(EmployeeActJournal."Employee No.", GetValueAtCell(RowNo, 1));
                    EmployeeActJournal.Validate("Employee No.");
                    Evaluate(EmployeeActJournal."Leave Code", GetValueAtCell(RowNo, 3));
                    EmployeeActJournal.Validate("Leave Code");
                    Evaluate(EmployeeActJournal."Leave Type", GetValueAtCell(RowNo, 4));
                    EmployeeActJournal.Validate("Leave Type");
                    Evaluate(EmployeeActJournal."Adjustment Type", GetValueAtCell(RowNo, 5));
                    EmployeeActJournal.Validate("Adjustment Type");
                    Evaluate(EmployeeActJournal."Start Date", GetValueAtCell(RowNo, 6));
                    EmployeeActJournal.Validate("Start Date");
                    Evaluate(EmployeeActJournal."End Date", GetValueAtCell(RowNo, 7));
                    EmployeeActJournal.Validate("End Date");
                    Evaluate(EmployeeActJournal.Remarks, GetValueAtCell(RowNo, 8));
                    EmployeeActJournal.Validate(Remarks);
                    EmployeeActJournal.InsertApproval(FirstLine, EmpActNo);
                    EmployeeActJournal."Emp Act. No" := EmpActNo;
                    EmployeeActJournal."Line No" := EmployeeActJournal."Line No" + 10000;
                    EmployeeActJournal.Insert(true);
                end;
            end;
        end;
        Message(ExcelImportSuccess);
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
