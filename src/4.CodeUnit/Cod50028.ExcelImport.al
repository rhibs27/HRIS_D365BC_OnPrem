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
                    case TableID of
                        Database::"Employee Payroll Adjustment":
                            begin
                                FieldRef := RecRef.Field(1);
                                FieldRef.Validate(DocNo);
                                FieldRef := RecRef.Field(ColNo + 1);
                            end;
                        Database::"Import Attribute Usage":
                            begin
                                FieldRef := RecRef.Field(ColNo + 1);//Reduced by 1 to exclude 2 fields in the table referred i.e. Entry Number and Posted
                            end;
                        else
                            FieldRef := RecRef.Field(ColNo)
                    end;

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
                            else begin
                                Evaluate(FieldRef, CellValue);
                                FieldRef.Validate(FieldRef.Value);
                            end;
                        end;
                    end;
                end;
                RecRef.Insert(true);
            end;
            Message(ExcelImportSuccess);
        end;
    end;

    procedure ExportDataInExcel(var RecRef: RecordRef)
    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        RowNo, LastRow, NoOfField, ColNo : Integer;
    begin
        //Header
        NoOfField := RecRef.FieldCount;
        TempExcelBuffer.NewRow();
        for ColNo := 1 to (NoOfField) do begin
            TempExcelBuffer.AddColumn(RecRef.Field(ColNo).Caption(), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        end;
        //Data
        if RecRef.FindSet() then
            repeat
                TempExcelBuffer.NewRow();
                for ColNo := 1 to (NoOfField) do begin
                    TempExcelBuffer.AddColumn(RecRef.Field(ColNo), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                end;
            until RecRef.Next() = 0;
        CreateExcelBook(TempExcelBuffer, RecRef.Caption());
    end;

    procedure ImportJournalFromExcelSheet(EmpActType: Enum "Employee Activity Type")
    var
        FileMgt: Codeunit "File Management";
        IStream: InStream;
        FromFile: Text;
        RowNo, LastRow : Integer;
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
                case EmpActType of
                    EmpActType::"Attendance Missed":
                        ImportAttendanceLine(EmployeeActJournal, RowNo, EmpActNo, FirstLine);
                    EmpActType::"Leave Request":
                        ImportLeaveLine(EmployeeActJournal, RowNo, EmpActNo, FirstLine);
                    EmpActType::Promotion:
                        ImportPromotionLine(EmployeeActJournal, RowNo, EmpActNo, FirstLine);
                    EmpActType::"Late Deduction":
                        ImportLateDeductionLine(EmployeeActJournal, RowNo, EmpActNo, FirstLine);
                end;
            end;
            Message(ExcelImportSuccess);
        end;
    end;

    procedure EvaluateInt(Value: Text): Integer
    var
        IntValue: Integer;
    begin
        Evaluate(IntValue, Value);
        exit(IntValue);
    end;

    procedure EvaluateDecimal(Value: Text): Decimal
    var
        DecValue: Decimal;
    begin
        Evaluate(DecValue, Value);
        exit(DecValue);
    end;

    procedure EvaluateDate(Value: Text): Date
    var
        DateValue: Date;
    begin
        Evaluate(DateValue, Value);
        exit(DateValue);
    end;

    procedure EvaluateBoolean(Value: Text): Boolean
    begin
        exit(LowerCase(Value) in ['yes', 'true', '1']);
    end;

    local procedure ImportAttendanceLine(var EmployeeActJournal: Record "Employee Activity Journal"; RowNo: Integer; var DocNo: Code[20]; var FirstLine: Boolean)
    begin
        EmployeeActJournal.Init();
        EmployeeActJournal.Validate(Type, EmployeeActJournal.Type::"Employee Journal");
        EmployeeActJournal.Validate("Employee Act Type", EmployeeActJournal."Employee Act Type"::"Attendance Missed");
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
        EmployeeActJournal.InsertApproval(FirstLine, DocNo);
        EmployeeActJournal."Emp Act. No" := DocNo;
        EmployeeActJournal."Line No" := EmployeeActJournal."Line No" + 10000;
        EmployeeActJournal.Insert(true);
    end;

    local procedure ImportLeaveLine(var EmployeeActJournal: Record "Employee Activity Journal"; RowNo: Integer; var DocNo: Code[20]; var FirstLine: Boolean)
    begin
        EmployeeActJournal.Init();
        EmployeeActJournal.Validate(Type, EmployeeActJournal.Type::"Employee Journal");
        EmployeeActJournal.Validate("Employee Act Type", EmployeeActJournal."Employee Act Type"::"Leave Request");
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
        OnImportLeaveLineBeforeInsertApproval(EmployeeActJournal, RowNo, DocNo, FirstLine, ExcelBuffer);
        EmployeeActJournal.InsertApproval(FirstLine, DocNo);
        EmployeeActJournal."Emp Act. No" := DocNo;
        EmployeeActJournal."Line No" := EmployeeActJournal."Line No" + 10000;
        EmployeeActJournal.Insert(true);
    end;

    local procedure ImportPromotionLine(var EmployeeActJournal: Record "Employee Activity Journal"; RowNo: Integer; var DocNo: Code[20]; var FirstLine: Boolean)
    begin
        EmployeeActJournal.Init();
        EmployeeActJournal.Validate(Type, EmployeeActJournal.Type::"Employee Journal");
        EmployeeActJournal.Validate("Employee Act Type", EmployeeActJournal."Employee Act Type"::Promotion);
        EmployeeActJournal.Validate("Approval Status", EmployeeActJournal."Approval Status"::Open);
        Evaluate(EmployeeActJournal."Employee No.", GetValueAtCell(RowNo, 1));
        EmployeeActJournal.Validate("Employee No.");
        Evaluate(EmployeeActJournal."Promotion Date", GetValueAtCell(RowNo, 3));
        EmployeeActJournal.Validate("Promotion Date");
        Evaluate(EmployeeActJournal."Functional Title (To)", GetValueAtCell(RowNo, 4));
        EmployeeActJournal.Validate("Functional Title (To)");
        Evaluate(EmployeeActJournal."Promoted Salary level", GetValueAtCell(RowNo, 5));
        EmployeeActJournal.Validate("Promoted Salary level");
        Evaluate(EmployeeActJournal."Promoted Salary Grade", GetValueAtCell(RowNo, 6));
        EmployeeActJournal.Validate("Promoted Salary Grade");
        Evaluate(EmployeeActJournal."Promoted Staff Level", GetValueAtCell(RowNo, 7));
        EmployeeActJournal.Validate("Promoted Staff Level");
        Evaluate(EmployeeActJournal."Approver Role (TO)", GetValueAtCell(RowNo, 8));
        EmployeeActJournal.Validate("Approver Role (TO)");
        Evaluate(EmployeeActJournal.Remarks, GetValueAtCell(RowNo, 9));
        EmployeeActJournal.Validate(Remarks);
        EmployeeActJournal.InsertApproval(FirstLine, DocNo);
        EmployeeActJournal."Emp Act. No" := DocNo;
        EmployeeActJournal."Line No" := EmployeeActJournal."Line No" + 10000;
        EmployeeActJournal.Insert(true);
    end;

    procedure ImportLateDeductionLine(var EmployeeActJournal: Record "Employee Activity Journal"; RowNo: Integer; var DocNo: Code[20]; var FirstLine: Boolean)
    begin
        EmployeeActJournal.Init();
        EmployeeActJournal.Validate(Type, EmployeeActJournal.Type::"Employee Journal");
        EmployeeActJournal.Validate("Employee Act Type", EmployeeActJournal."Employee Act Type"::"Late Deduction");
        EmployeeActJournal.Validate("Approval Status", EmployeeActJournal."Approval Status"::Open);
        Evaluate(EmployeeActJournal."Employee No.", GetValueAtCell(RowNo, 1));
        EmployeeActJournal.Validate("Employee No.");
        Evaluate(EmployeeActJournal."Start Date", GetValueAtCell(RowNo, 3));
        EmployeeActJournal.Validate("Start Date");
        Evaluate(EmployeeActJournal.Remarks, GetValueAtCell(RowNo, 4));
        EmployeeActJournal.Validate(Remarks);
        EmployeeActJournal.InsertApproval(FirstLine, DocNo);
        EmployeeActJournal."Emp Act. No" := DocNo;
        EmployeeActJournal."Line No" := EmployeeActJournal."Line No" + 10000;
        EmployeeActJournal.Insert(true);
    end;

    procedure ExportLateDeductionSheet(EmployeeActJournal: Record "Employee Activity Journal")
    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
    begin
        //Header
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(EmployeeActJournal.FieldCaption("Employee No."), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(EmployeeActJournal.FieldCaption("Employee Name"), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(EmployeeActJournal.FieldCaption("Start Date"), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(EmployeeActJournal.FieldCaption(Remarks), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        //Data
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(EmployeeActJournal."Employee No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(EmployeeActJournal."Employee Name", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(EmployeeActJournal."Start Date", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Date);
        TempExcelBuffer.AddColumn(EmployeeActJournal.Remarks, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        //
        CreateExcelBook(TempExcelBuffer, 'LateDeductionJournal');
    end;

    procedure ExportLeaveSheet(EmployeeActJournal: Record "Employee Activity Journal")
    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
    begin
        //Header
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(EmployeeActJournal.FieldCaption("Employee No."), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(EmployeeActJournal.FieldCaption("Employee Name"), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(EmployeeActJournal.FieldCaption("Leave Code"), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(EmployeeActJournal.FieldCaption("Leave Type"), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(EmployeeActJournal.FieldCaption("Adjustment Type"), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(EmployeeActJournal.FieldCaption("Start Date"), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(EmployeeActJournal.FieldCaption("End Date"), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(EmployeeActJournal.FieldCaption(Remarks), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        OnExportLeaveSheetOnAfterHeader(TempExcelBuffer, EmployeeActJournal);
        //Data
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(EmployeeActJournal."Employee No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(EmployeeActJournal."Employee Name", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(EmployeeActJournal."Leave Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(EmployeeActJournal."Leave Type", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(EmployeeActJournal."Adjustment Type", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(EmployeeActJournal."Start Date", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Date);
        TempExcelBuffer.AddColumn(EmployeeActJournal."End Date", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Date);
        TempExcelBuffer.AddColumn(EmployeeActJournal.Remarks, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        OnExportLeaveSheetOnAfterData(TempExcelBuffer, EmployeeActJournal);
        CreateExcelBook(TempExcelBuffer, 'leaveJournal');
    end;

    procedure ExportLines(DocumentNo: Code[20])
    var
        AdjLine: Record "Attribute Adjustment Line";
        CellType: Option Number,Text,Date,Time;
    begin
        ExcelBuffer.Reset;
        ExcelBuffer.DeleteAll;
        MakeExcelDataHeader(AdjLine.FieldCaption("Document No."), CellType::Text);
        MakeExcelDataHeader(AdjLine.FieldCaption("Line No."), CellType::Number);
        MakeExcelDataHeader(AdjLine.FieldCaption("Employee No."), CellType::Text);
        MakeExcelDataHeader(AdjLine.FieldCaption("Employee Name"), CellType::Text);
        MakeExcelDataHeader(AdjLine.FieldCaption("Adjustment Type"), CellType::Text);
        MakeExcelDataHeader(AdjLine.FieldCaption("Attribute Code"), CellType::Text);
        MakeExcelDataHeader(AdjLine.FieldCaption("Old Amount"), CellType::Number);
        MakeExcelDataHeader(AdjLine.FieldCaption("New Amount"), CellType::Number);
        MakeExcelDataHeader(AdjLine.FieldCaption("Effective Start Date"), CellType::Date);
        MakeExcelDataHeader(AdjLine.FieldCaption("Effective End Date"), CellType::Date);

        AdjLine.Reset;
        AdjLine.SetRange("Document No.", DocumentNo);
        if AdjLine.FindFirst then
            repeat
                ExcelBuffer.NewRow;
                MakeExcelDataBody(AdjLine."Document No.", CellType::Text);
                MakeExcelDataBody(AdjLine."Line No.", CellType::Number);
                MakeExcelDataBody(AdjLine."Employee No.", CellType::Text);
                MakeExcelDataBody(AdjLine."Employee Name", CellType::Text);
                MakeExcelDataBody(AdjLine."Adjustment Type", CellType::Text);
                MakeExcelDataBody(AdjLine."Attribute Code", CellType::Text);
                MakeExcelDataBody(AdjLine."Old Amount", CellType::Number);
                MakeExcelDataBody(AdjLine."New Amount", CellType::Number);
                MakeExcelDataBody(AdjLine."Effective Start Date", CellType::Date);
                MakeExcelDataBody(AdjLine."Effective End Date", CellType::Date);
            until AdjLine.Next = 0;

        CreateExcelBook('Attribute Adjustment Lines');
    end;

    procedure ImportLines(DocumentNo: Code[20])
    var
        FirstLine: Boolean;
        IStream: InStream;
        FromFile: Text;
        RowNo, LastRow, LineNo : Integer;
        AdjLine: Record "Attribute Adjustment Line";
        FileMgt: Codeunit "File Management";
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
            AdjLine.SetRange("Document No.", DocumentNo);
            if AdjLine.FindLast then
                LineNo := AdjLine."Line No.";

            for RowNo := 2 to LastRow do begin
                LineNo += 10000;
                InsertLine(RowNo, DocumentNo, LineNo);
            end;
            // Message('%1 lines imported successfully.', TotalRows - 1);
        end;
        if not ExcelBuffer.IsEmpty() then
            ExcelBuffer.DeleteAll;
    end;

    local procedure MakeExcelDataHeader(HeadingCaption: Text; CellType: Option Number,Text,Date,Time)
    begin
        ExcelBuffer.AddColumn(HeadingCaption, false, '', true, false, true, '', CellType);
    end;

    local procedure MakeExcelDataBody(BodyValue: Variant; CellType: Option Number,Text,Date,Time)
    begin
        ExcelBuffer.AddColumn(BodyValue, false, '', false, false, false, '', CellType);
    end;

    local procedure CreateExcelBook(SheetName: Text)
    var
        ExcelFileName: Label '%1_%2_%3';
    begin
        ExcelBuffer.CreateNewBook(SheetName);
        ExcelBuffer.WriteSheet(SheetName, CompanyName, UserId);
        ExcelBuffer.CloseBook();
        ExcelBuffer.SetFriendlyFilename(StrSubstNo(ExcelFileName, SheetName, CurrentDateTime, UserId));
        ExcelBuffer.OpenExcel();
    end;

    local procedure CreateExcelBook(var ExcelBuffer: Record "Excel Buffer"; SheetName: Text)
    var
        ExcelFileName1: Label '%1_%2_%3';
    begin
        ExcelBuffer.CreateNewBook(SheetName);
        ExcelBuffer.WriteSheet(SheetName, CompanyName, UserId);
        ExcelBuffer.CloseBook();
        ExcelBuffer.SetFriendlyFilename(StrSubstNo(ExcelFileName1, SheetName, CurrentDateTime, UserId));
        ExcelBuffer.OpenExcel();
    end;

    local procedure OpenReadExcelBook()
    var
        InStr: InStream;
        SheetName: Text;
    begin
        UploadIntoStream(UploadFileTxt, ExlExt, '', Filename, InStr);
        ExcelBuffer.Reset;
        ExcelBuffer.LockTable;
        ExcelBuffer.OpenBookStream(InStr, SheetName);
        ExcelBuffer.ReadSheet;
    end;

    local procedure GetLastRowandColumn(var TotalRows: Integer)
    begin
        TotalRows := ExcelBuffer.Count;
    end;

    procedure GetValueAtCell(RowNo: Integer; ColNo: Integer): Text
    begin
        if ExcelBuffer.Get(RowNo, ColNo) then
            exit(ExcelBuffer."Cell Value as Text")
        else
            exit('');
    end;

    local procedure InsertLine(RowNo: Integer; DocumentNo: Code[20]; var LineNo: Integer)
    var
        AdjLine: Record "Attribute Adjustment Line";
        EffStart: Date;
        EffEnd: Date;
    begin
        AdjLine.Init();
        AdjLine."Document No." := DocumentNo;
        AdjLine."Line No." := LineNo;
        AdjLine.Validate("Employee No.", GetValueAtCell(RowNo, 3));
        AdjLine.Validate("Employee Name", GetValueAtCell(RowNo, 4));
        //   AdjLine.Validate("Adjustment Type", EvaluateInteger(GetValueAtCell(RowNo, 5)));
        Evaluate(AdjLine."Adjustment Type", GetValueAtCell(RowNo, 5));
        AdjLine.Validate("Attribute Code", GetValueAtCell(RowNo, 6));
        if GetValueAtCell(RowNo, 7) <> '' then
            AdjLine.Validate("Old Amount", EvaluateDecimal(GetValueAtCell(RowNo, 7)));
        if GetValueAtCell(RowNo, 8) <> '' then
            AdjLine.Validate("New Amount", EvaluateDecimal(GetValueAtCell(RowNo, 8)));
        if GetValueAtCell(RowNo, 9) <> '' then begin
            Evaluate(EffStart, GetValueAtCell(RowNo, 9));
            AdjLine.Validate("Effective Start Date", EffStart);
        end;
        if GetValueAtCell(RowNo, 10) <> '' then begin
            Evaluate(EffEnd, GetValueAtCell(RowNo, 10));
            AdjLine.Validate("Effective End Date", EffEnd);
        end;
        if AdjLine."Employee No." <> '' then
            AdjLine.Insert(true);
    end;

    procedure ImportShiftLineFromExcelSheet(DocNo: Code[20])
    var
        FileMgt: Codeunit "File Management";
        IStream: InStream;
        FromFile, CellValue : Text;
        RowNo, LastRow, LastColumn, NoOfField, ColNo, LineNo : Integer;
        FieldRef: FieldRef;
        RecRef: RecordRef;
        ShiftLine: Record "Shift Line";
        ShiftAssignmentHeader: Record "Shift Assignment Header";
    begin
        if UploadIntoStream('Import From Excel', '', '', FromFile, IStream) then begin
            if FromFile <> '' then begin
                FileName := FileMgt.GetFileName(FromFile);
                SheetName := ExcelBuffer.SelectSheetsNameStream(IStream);
            end
            else
                Error('No file found.');
            if ShiftAssignmentHeader.Get(DocNo) then;
            ExcelBuffer.Reset();
            ExcelBuffer.DeleteAll();
            ExcelBuffer.OpenBookStream(IStream, SheetName);
            ExcelBuffer.ReadSheet();
            ExcelBuffer.SetRange("Column No.", 1);
            ExcelBuffer.FindLast();
            LastRow := ExcelBuffer."Row No.";
            for RowNo := 2 to LastRow do begin
                ShiftLine.Init();
                ShiftLine.Validate(Type, ShiftLine.Type::"Shift Assignment");
                ShiftLine.Validate("Approval Status", ShiftLine."Approval Status"::Open);
                if ShiftAssignmentHeader."Deputation Sub Type" = ShiftAssignmentHeader."Deputation Sub Type"::" " then begin
                    ShiftLine.Validate("Deputation Type", ShiftAssignmentHeader."Deputation Type");
                    ShiftLine.Validate("Deputation Code", ShiftAssignmentHeader."Deputation Code");
                end else begin
                    ShiftLine.Validate("Deputation Type", ShiftAssignmentHeader."Deputation Sub Type");
                    ShiftLine.Validate("Deputation Code", ShiftAssignmentHeader."Deputation Sub Type Code");
                end;
                ShiftLine.Validate("No.", DocNo);
                ShiftLine."Line No" := ShiftLine.GetLineNo(DocNo);
                Evaluate(ShiftLine."Employee No", GetValueAtCell(RowNo, 1));
                ShiftLine.Validate("Employee No");
                Evaluate(ShiftLine."Employee Work Shift", GetValueAtCell(RowNo, 3));
                ShiftLine.Validate("Employee Work Shift");
                Evaluate(ShiftLine."Roster Date", GetValueAtCell(RowNo, 4));
                ShiftLine.Validate("Roster Date");
                Evaluate(ShiftLine.Remarks, GetValueAtCell(RowNo, 5));
                ShiftLine.Validate(Remarks);
                ShiftLine.Insert(true);
            end;
            Message(ExcelImportSuccess);
        end;
    end;

    procedure ExportShiftAssignmentLineFormat(ShiftLine: Record "Shift Line")
    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
    begin
        //Header
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(ShiftLine.FieldCaption("Employee No"), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(ShiftLine.FieldCaption("Employee Name"), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(ShiftLine.FieldCaption("Employee Work Shift"), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(ShiftLine.FieldCaption("Roster Date"), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(ShiftLine.FieldCaption(Remarks), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        //Data
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(ShiftLine."Employee No", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(ShiftLine."Employee Name", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(ShiftLine."Employee Work Shift", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(ShiftLine."Roster Date", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Date);
        TempExcelBuffer.AddColumn(ShiftLine.Remarks, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        //
        CreateExcelBook(TempExcelBuffer, 'ShiftLine');
    end;

    [IntegrationEvent(false, false)]
    procedure OnImportLeaveLineBeforeInsertApproval(var EmployeeActJournal: Record "Employee Activity Journal"; RowNo: Integer; DocNo: Code[20]; var FirstLine: Boolean; var ExcelBuffer: Record "Excel Buffer" temporary)
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnExportLeaveSheetOnAfterHeader(var TempExcelBuffer: Record "Excel Buffer" temporary; EmployeeActJournal: Record "Employee Activity Journal")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnExportLeaveSheetOnAfterData(var TempExcelBuffer: Record "Excel Buffer" temporary; EmployeeActJournal: Record "Employee Activity Journal")
    begin
    end;

    var
        ExcelBuffer: Record "Excel Buffer" temporary;
        Filename: Text[250];
        SheetName: Text[250];
        ExcelImportSuccess: Label 'Data is successfully imported.';
        UploadFileTxt: Label 'Select the Excel File to Import';
        ExlExt: Label '.xlsx';
}
