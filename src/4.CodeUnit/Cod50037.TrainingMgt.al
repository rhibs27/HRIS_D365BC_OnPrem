codeunit 50037 "Training Mgt"
{
    procedure InsertEmployeeWiseTrainingQuestion(TrainingNo: Code[20]; EmployeeNo: Code[20])
    var
        TrainingQuestionSetup: Record "Employee Question Setup";
        EmployeeFeedBack: Record "Employee Feedback";
        TrainerLine: Record "Training Line";
    begin
        TrainingQuestionSetup.Reset;
        TrainingQuestionSetup.SetRange(Type, TrainingQuestionSetup.Type::Training);
        TrainingQuestionSetup.SetFilter("Sub Type", '<>%1', "Employee Question SubType"::"Trainer Ratings");
        if TrainingQuestionSetup.Find('-') then
            repeat
                EmployeeFeedBack.Reset;
                EmployeeFeedBack.SetRange("Employee No.", EmployeeNo);
                EmployeeFeedBack.SetRange("Training No.", TrainingNo);
                EmployeeFeedBack.SetRange("Question Code", TrainingQuestionSetup."Question Code");
                EmployeeFeedBack.SetFilter("Trainer Name", '%1', '');
                EmployeeFeedBack.SetRange(Type, EmployeeFeedBack.Type::Training);
                EmployeeFeedBack.SetFilter("Sub Type", '<>%1', "Employee Question SubType"::"Trainer Ratings");
                if not EmployeeFeedBack.FindFirst then begin
                    EmployeeFeedBack.Init;
                    EmployeeFeedBack.Validate("Training No.", TrainingNo);
                    EmployeeFeedBack.Validate("Question Code", TrainingQuestionSetup."Question Code");
                    EmployeeFeedBack.Validate("Employee No.", EmployeeNo);
                    EmployeeFeedBack.Validate("Line No.", GetLineNo(TrainingNo, EmployeeNo, TrainingQuestionSetup."Question Code"));
                    EmployeeFeedBack.Validate("Trainer Name", '');
                    EmployeeFeedBack.Validate(Type, EmployeeFeedBack.Type::Training);
                    EmployeeFeedBack.Validate("Sub Type", TrainingQuestionSetup."Sub Type");
                    EmployeeFeedBack.Validate(Question, TrainingQuestionSetup.Question);
                    EmployeeFeedBack.Validate("Is Subjective", TrainingQuestionSetup."Is Subjective");
                    EmployeeFeedBack.Insert;
                end;
            until TrainingQuestionSetup.Next = 0;

        TrainingQuestionSetup.Reset;
        TrainingQuestionSetup.SetRange(Type, TrainingQuestionSetup.Type::Training);
        TrainingQuestionSetup.SetFilter("Sub Type", '%1', "Employee Question SubType"::"Trainer Ratings");
        if TrainingQuestionSetup.Find('-') then
            repeat
                TrainerLine.Reset();
                TrainerLine.SetRange("Training No.", TrainingNo);
                TrainerLine.SetRange(Type, "Training Line Type"::Trainer);
                if TrainerLine.FindFirst() then
                    repeat
                        EmployeeFeedBack.Reset;
                        EmployeeFeedBack.SetRange("Employee No.", EmployeeNo);
                        EmployeeFeedBack.SetRange("Training No.", TrainingNo);
                        EmployeeFeedBack.SetRange("Question Code", TrainingQuestionSetup."Question Code");
                        EmployeeFeedBack.SetRange("Trainer Name", TrainerLine."Employee Name");
                        EmployeeFeedBack.SetRange(Type, EmployeeFeedBack.Type::Training);
                        EmployeeFeedBack.SetFilter("Sub Type", '%1', "Employee Question SubType"::"Trainer Ratings");
                        if not EmployeeFeedBack.FindFirst() then begin
                            EmployeeFeedBack.Init;
                            EmployeeFeedBack.Validate("Training No.", TrainingNo);
                            EmployeeFeedBack.Validate("Employee No.", EmployeeNo);
                            EmployeeFeedBack.Validate("Question Code", TrainingQuestionSetup."Question Code");
                            EmployeeFeedBack.Validate("Line No.", GetLineNo(TrainingNo, EmployeeNo, TrainingQuestionSetup."Question Code"));
                            EmployeeFeedBack.Validate("Trainer Name", TrainerLine."Employee Name");
                            EmployeeFeedBack.Validate(Type, EmployeeFeedBack.Type::Training);
                            EmployeeFeedBack.Validate("Sub Type", TrainingQuestionSetup."Sub Type");
                            EmployeeFeedBack.Validate(Question, TrainingQuestionSetup.Question);
                            EmployeeFeedBack.Validate("Is Subjective", TrainingQuestionSetup."Is Subjective");
                            EmployeeFeedBack.Insert;
                        end
                    until TrainerLine.Next() = 0;
            until TrainingQuestionSetup.Next = 0;
    end;

    local procedure GetLineNo(TrainingNo: Code[20]; EmployeeNo: Code[20]; QuestionCode: Code[20]): Integer
    var
        EmpFeedback: Record "Employee Feedback";
    begin
        EmpFeedback.Reset();
        EmpFeedback.SetRange("Training No.", TrainingNo);
        EmpFeedback.SetRange("Employee No.", EmployeeNo);
        EmpFeedback.SetRange("Question Code", QuestionCode);
        if EmpFeedback.FindLast() then
            exit(EmpFeedback."Line No." + 10000)
        else
            exit(10000)
    end;

    procedure ShowTrainerList(TrainingNo: Code[20];
                EmployeeNo: Code[20])
    var
        QATrain: Record "Employee Feedback";
    begin
        QATrain.Reset;
        QATrain.FilterGroup(2);
        QATrain.SetRange("Training No.", TrainingNo);
        QATrain.SetRange("Employee No.", EmployeeNo);
        QATrain.SetRange(Type, QATrain.Type::Training);
        QATrain.SetRange("Sub Type", QATrain."Sub Type"::Trainer);
        QATrain.FilterGroup(0);
        PAGE.Run(PAGE::"Employee Training Feedback", QATrain);
    end;

    procedure ShowTrainingList(TrainingNo: Code[20]; EmployeeNo: Code[20])
    var
        QATrain: Record "Employee Feedback";
    begin
        QATrain.Reset;
        QATrain.FilterGroup(2);
        QATrain.SetRange("Training No.", TrainingNo);
        QATrain.SetRange("Employee No.", EmployeeNo);
        QATrain.SetRange("Sub Type", QATrain."Sub Type"::Training);
        QATrain.SetRange(Type, QATrain.Type::Training);
        QATrain.FilterGroup(0);
        PAGE.Run(PAGE::"Employee Training Feedback", QATrain);
    end;

    local procedure CalculateTrainingMarks(TrainNo: Code[20]; EmpNo: Code[20]): Decimal
    var
        TrainingFeedback: Record "Employee Feedback";
        TotalMarks: Decimal;
    begin
        TrainingFeedback.Reset;
        TrainingFeedback.SetRange("Training No.", TrainNo);
        TrainingFeedback.SetRange("Employee No.", EmpNo);
        TrainingFeedback.SetRange("Sub Type", TrainingFeedback."Sub Type"::Training);
        TrainingFeedback.SetRange(Type, TrainingFeedback.Type::Training);
        TrainingFeedback.CalcSums(Marks);
        TotalMarks := TrainingFeedback.Marks;
        if TrainingFeedback.Count <> 0 then
            exit(TotalMarks / TrainingFeedback.Count);
    end;

    local procedure CalculateTrainerMarks(TrainNo: Code[20]; EmpNo: Code[20]): Decimal
    var
        QATrain: Record "Employee Feedback";
        TotalMarks: Decimal;
    begin
        QATrain.Reset;
        QATrain.SetRange("Training No.", TrainNo);
        QATrain.SetRange("Employee No.", EmpNo);
        QATrain.SetRange("Sub Type", QATrain."Sub Type"::Trainer);
        QATrain.SetRange(Type, QATrain.Type::Training);
        QATrain.CalcSums(Marks);
        TotalMarks := QATrain.Marks;
        if QATrain.Count <> 0 then
            exit(TotalMarks / QATrain.Count);
    end;

    procedure CalTraineeRemarksTraining(TrainNo: Code[20]; EmpNo: Code[20])
    var
        TrainLine: Record "Training Line";
    begin
        TrainLine.Reset;
        TrainLine.SetRange("Training No.", TrainNo);
        TrainLine.SetRange(Type, TrainLine.Type::Trainee);
        TrainLine.SetRange("Employee Code", EmpNo);
        if TrainLine.FindFirst then begin
            TrainLine.Validate("Training Marks", CalculateTrainingMarks(TrainNo, EmpNo));
            TrainLine.Validate("Trainer Marks", CalculateTrainerMarks(TrainNo, EmpNo));
            TrainLine.Modify;
        end;
    end;

    procedure CalTrainingMarks(TrainNo: Code[20])
    var
        TrainHead: Record "Training Header";
        TrainLine: Record "Training Line";
    begin
        if TrainHead.Get(TrainNo) then begin
            TrainLine.Reset;
            TrainLine.SetRange("Training No.", TrainNo);
            TrainLine.SetRange(Type, TrainLine.Type::Trainee);
            TrainHead.CalcFields("Total No. of Participant");
            TrainLine.CalcSums("Trainer Marks", "Training Marks");
            if TrainHead."Total No. of Participant" <> 0 then begin
                TrainHead.Validate("Total Trainer Marks", TrainLine."Trainer Marks" / TrainHead."Total No. of Participant");
                TrainHead.Validate("Total Training Marks", TrainLine."Training Marks" / TrainHead."Total No. of Participant");
                TrainHead.Validate("Trainer Percent", TrainHead."Total Trainer Marks" / 5 * 100);
                TrainHead.Validate("Training Percent", TrainHead."Total Training Marks" / 5 * 100);
                TrainHead.Modify;
            end;
        end;
    end;

    procedure GenerateTraineeForTraining(TrainNo: Code[20])
    var
        TrainHead: Record "Training Header";
        TrainLine: Record "Training Line";
        TrainerCode: Text;
        LineNo: Integer;
    begin
        Clear(TrainerCode);
        TrainHead.Get(TrainNo);
        TrainLine.Reset;
        TrainLine.SetRange("Training No.", TrainNo);
        //TrainLine.SetRange(Type,TrainLine.Type::Trainer);
        TrainLine.SetFilter("Trainer Type", '<>%1', TrainLine."Trainer Type"::External);
        if TrainLine.Find('-') then
            repeat
                if TrainerCode = '' then
                    TrainerCode := '<>' + TrainLine."Employee Code"
                else
                    TrainerCode += '|<>' + TrainLine."Employee Code";
            until TrainLine.Next = 0;
        Clear(TrainLine);
        TrainLine.SetRange("Training No.", TrainNo);
        TrainLine.SetRange(Type, TrainLine.Type::Trainee);
        TrainLine.SetCurrentKey("Training No.", "Line No", Type);
        if TrainLine.FindLast then
            LineNo := TrainLine."Line No";
        Employee.Reset;
        Employee.SetFilter("No.", TrainerCode);
        if Employee."Deputation on" = "Deputation Type"::Branch then
            Employee.SetFilter("Branch Code", TrainHead."Branch Code");
        if Employee."Deputation on" = "Deputation Type"::Department then
            Employee.SetFilter("Department Code", TrainHead."Department Code");
        if Employee.Find('-') then
            repeat
                LineNo := TrainLine."Line No" + 10000;
                TrainLine.Init;
                TrainLine.Validate("Training No.", TrainNo);
                TrainLine.Validate(Type, TrainLine.Type::Trainee);
                TrainLine.Validate("Line No", LineNo);
                TrainLine.Validate("Employee Code", Employee."No.");
                TrainLine.Insert(true);
            until Employee.Next = 0;
    end;


    procedure ExportTrainee(TrainingHeader: Record "Training Header")
    var
        TrainingLine: Record "Training Line";
        CellType: Option Number,Text,Date,Time;
    begin
        ExcelBuffer.Reset;
        ExcelBuffer.DeleteAll;
        MakeExcelDataHeader(TrainingLine.FieldCaption("Training No."), CellType::Text);
        MakeExcelDataHeader(TrainingLine.FieldCaption("Employee Code"), CellType::Text);
        MakeExcelDataHeader(TrainingLine.FieldCaption("Employee Name"), CellType::Text);
        TrainingLine.Reset;
        TrainingLine.SetRange("Training No.", TrainingHeader."No.");
        if TrainingLine.FindFirst then begin
            repeat
                ExcelBuffer.NewRow;
                MakeExcelDataBody(TrainingLine."Training No.", CellType::Text);
                MakeExcelDataBody(TrainingLine."Employee Code", CellType::Text);
                MakeExcelDataBody(TrainingLine."Employee Name", CellType::Text);
            until TrainingLine.Next = 0;
        end;
        CreateExcelBook(ExportTraineeTxt);
    end;

    procedure ExportTraineeAttendance(TrainingHeader: Record "Training Header")
    var
        TrainingAttendance: Record "Training Attendance";
        CellType: Option Number,Text,Date,Time;
    begin
        ExcelBuffer.Reset;
        ExcelBuffer.DeleteAll;
        MakeExcelDataHeader(TrainingAttendance.FieldCaption("Training No"), CellType::Text);
        MakeExcelDataHeader(TrainingAttendance.FieldCaption("Employee No."), CellType::Text);
        MakeExcelDataHeader(TrainingAttendance.FieldCaption("Attended Date"), CellType::Text);
        TrainingAttendance.Reset;
        TrainingAttendance.SetRange("Training No", TrainingHeader."No.");
        if TrainingAttendance.FindFirst then begin
            repeat
                ExcelBuffer.NewRow;
                MakeExcelDataBody(TrainingAttendance."Training No", CellType::Text);
                MakeExcelDataBody(TrainingAttendance."Employee No.", CellType::Text);
                MakeExcelDataBody(TrainingAttendance."Attended Date", CellType::Text);
            until TrainingAttendance.Next = 0;
        end;
        CreateExcelBook(ExportAttendanceTxt);
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
    begin
        ExcelBuffer.CreateNewBook(SheetName);
        ExcelBuffer.OpenExcel();
        // ExcelBuffer.CreateBookAndOpenExcel('', SheetName, '', '', UserId);
        Error('');
    end;

    procedure ImportTrainee(TrainingHeader: Record "Training Header")
    var
        TotalRows: Integer;
        TrainingLine: Record "Training Line";
        LineNo, i : Integer;
    begin
        ExcelBuffer.Reset;
        LineNo := 0;
        OpenReadExcelBook;
        GetLastRowandColumn(TotalRows);
        TrainingLine.Reset;
        TrainingLine.SetRange("Training No.", TrainingHeader."No.");
        if TrainingLine.FindLast then
            LineNo := TrainingLine."Line No";
        for i := 2 to TotalRows do begin
            LineNo += 10000;
            InsertTrainee(i, TrainingHeader."No.", LineNo);
        end;
        ExcelBuffer.DeleteAll;
        Message('Trainees imported successfully.');
    end;

    local procedure OpenReadExcelBook()
    var
        ServerFileName: Text;
        SheetName: Text;
        tmpBlob: Codeunit "Temp Blob";
        InStr: InStream;
        File: File;
    begin
        UploadExcelFileToImport(ServerFileName, SheetName);
        ExcelBuffer.Reset;
        ExcelBuffer.LockTable;
        InStr.ReadText(ServerFileName);
        tmpBlob.CreateInStream(InStr);
        ExcelBuffer.OpenBookStream(InStr, SheetName);
        ExcelBuffer.ReadSheet;
    end;

    local procedure GetLastRowandColumn(var TotalRows: Integer)
    begin
        TotalRows := ExcelBuffer.Count;
    end;

    local procedure GetValueAtCell(RowNo: Integer; ColNo: Integer): Text
    begin
        if ExcelBuffer.Get(RowNo, ColNo) then
            exit(ExcelBuffer."Cell Value as Text")
        else
            exit('');
    end;

    local procedure InsertTrainee(RowNo: Integer; TrainingNo: Code[20]; LineNo: Integer)
    var
        TrainingLine: Record "Training Line";
    begin
        TrainingLine.Reset;
        TrainingLine.SetRange("Training No.", TrainingNo);
        TrainingLine.SetRange("Employee Code", GetValueAtCell(RowNo, 2));
        if not TrainingLine.FindFirst then begin
            TrainingLine.Init;
            TrainingLine."Training No." := TrainingNo;
            TrainingLine."Line No" := LineNo;
            TrainingLine.Validate("Employee Code", GetValueAtCell(RowNo, 2));
            TrainingLine.Type := TrainingLine.Type::Trainee;
            if TrainingLine."Employee Code" <> '' then
                TrainingLine.Insert(true);
        end;
    end;

    procedure ImportTraineeAttendance(TrainingHeader: Record "Training Header")
    var
        TotalRows: Integer;
        TrainingAttendance: Record "Training Attendance";
        LineNo, i : Integer;
    begin
        ExcelBuffer.Reset;
        LineNo := 0;
        OpenReadExcelBook;
        GetLastRowandColumn(TotalRows);
        TrainingAttendance.Reset;
        TrainingAttendance.SetRange("Training No", TrainingHeader."No.");
        if TrainingAttendance.FindLast then
            LineNo := TrainingAttendance."Line No.";
        for i := 2 to TotalRows do begin
            LineNo += 10000;
            InsertTraineeAttendance(i, TrainingHeader."No.", LineNo);
        end;
        ExcelBuffer.DeleteAll;
        Message('Attendance imported successfully.');
    end;

    local procedure InsertTraineeAttendance(RowNo: Integer; TrainingNo: Code[20]; LineNo: Integer)
    var
        TrainingAttendance: Record "Training Attendance";
        AttendedDate: Date;
    begin
        AttendedDate := 0D;
        TrainingAttendance.Reset;
        TrainingAttendance.SetRange("Training No", TrainingNo);
        TrainingAttendance.SetRange("Employee No.", GetValueAtCell(RowNo, 2));
        TrainingAttendance.SetFilter("Attended Date", GetValueAtCell(RowNo, 3));
        if not TrainingAttendance.FindFirst then begin
            TrainingAttendance.Init;
            TrainingAttendance."Training No" := TrainingNo;
            TrainingAttendance."Line No." := LineNo;
            TrainingAttendance.Validate("Employee No.", GetValueAtCell(RowNo, 2));
            Evaluate(AttendedDate, GetValueAtCell(RowNo, 3));
            TrainingAttendance.Validate("Attended Date", AttendedDate);
            if TrainingAttendance."Employee No." <> '' then
                TrainingAttendance.Insert(true);
        end;
    end;

    local procedure UploadExcelFileToImport(var ServerFileName: Text; var SheetName: Text)
    var
        FileManagement: Codeunit "File Management";
        InStr: InStream;
        tmpBlob: Codeunit "Temp Blob";
        File: File;
        Filebool: Boolean;
    begin
        Filebool := UploadIntoStream(UploadFileTxt, InStr);
        // ServerFileName := FileManagement.UploadFile(UploadFileTxt, ExlExt);
        // InStr.ReadText(ServerFileName);
        // tmpBlob.CreateInStream(InStr);
        SheetName := ExcelBuffer.SelectSheetsNameStream(InStr);
    end;

    procedure Submit(var TrainingNeed: Record "Training Need Request")
    begin
        TrainingNeed.TestField("Employee No.");
        TrainingNeed.TestField("Training Name");
        TrainingNeed.Validate(Status, TrainingNeed.Status::Pending);
        TrainingNeed.Modify(true);
    end;

    procedure UpdateTrainingOnEmpAttAct(TrainingNo: Code[20])
    Var
        TrainingAttendance: Record "Training Attendance";
        EmployeeAttendanceActivity: Record "Employee Attendance & Activity";
        EmployeeActType: Enum "Employee Activity Type";
    begin
        HRMgt.DeleteExistingActivityLedgerEntries(EmployeeActType::Training, TrainingNo);
        TrainingAttendance.SetRange("Training No", TrainingNo);
        if TrainingAttendance.FindSet() then
            repeat
                HRMgt.CreateEmpActLedger(EmployeeActType::Training, TrainingAttendance."Training No", TrainingAttendance."Employee No.", TrainingAttendance."Attended Date", false, 1);
                EmployeeAttendanceActivity.SetRange("Employee No.", TrainingAttendance."Employee No.");
                EmployeeAttendanceActivity.SetRange("Attendance Date", TrainingAttendance."Attended Date");
                if EmployeeAttendanceActivity.FindFirst() then begin
                    EmployeeAttendanceActivity."Training Day" := 1;
                    EmployeeAttendanceActivity.Modify();
                end;
            until TrainingAttendance.Next() = 0;
    end;


    var
        ExcelBuffer: Record "Excel Buffer";
        Employee: Record Employee;
        ExportTraineeTxt: Label 'Export Trainee';
        UploadFileTxt: Label 'Select the Excel File to Import';
        ExportAttendanceTxt: Label 'Export Attendance';
        HRMgt: Codeunit "HR Mgt.";
}
