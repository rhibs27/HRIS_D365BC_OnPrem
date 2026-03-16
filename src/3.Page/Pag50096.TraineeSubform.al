page 50096 "Trainee Subform"
{
    AutoSplitKey = true;
    PageType = ListPart;
    RefreshOnActivate = true;
    SourceTable = "Training Line";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Employee Code"; Rec."Employee Code")
                {
                    Editable = not IsApproved;
                    ToolTip = 'Specifies the value of the Employee Code field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Name field.';
                    ApplicationArea = All;
                }
                field("Department Name"; Rec."Department Name")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Department Name field.';
                    ApplicationArea = All;
                }
                field("Branch Name"; Rec."Branch Name")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Branch Name field.';
                    ApplicationArea = All;
                }
                field("MatrixCellData[1]"; MatrixCellData[1])
                {
                    CaptionClass = '3,' + MatrixCaption[1];
                    Editable = IsApproved;
                    Visible = FieldVisible1;
                    ToolTip = 'Specifies the value of the MatrixCellData[1] field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        InsertDeleteTrainingAtt(1);
                    end;
                }
                field("MatrixCellData[2]"; MatrixCellData[2])
                {
                    CaptionClass = '3,' + MatrixCaption[2];
                    Editable = IsApproved;
                    Visible = FieldVisible2;
                    ToolTip = 'Specifies the value of the MatrixCellData[2] field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        InsertDeleteTrainingAtt(2);
                    end;
                }
                field("MatrixCellData[3]"; MatrixCellData[3])
                {
                    CaptionClass = '3,' + MatrixCaption[3];
                    Editable = IsApproved;
                    Visible = FieldVisible3;
                    ToolTip = 'Specifies the value of the MatrixCellData[3] field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        InsertDeleteTrainingAtt(3);
                    end;
                }
                field("MatrixCellData[4]"; MatrixCellData[4])
                {
                    CaptionClass = '3,' + MatrixCaption[4];
                    Editable = IsApproved;
                    Visible = FieldVisible4;
                    ToolTip = 'Specifies the value of the MatrixCellData[4] field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        InsertDeleteTrainingAtt(4);
                    end;
                }
                field("MatrixCellData[5]"; MatrixCellData[5])
                {
                    CaptionClass = '3,' + MatrixCaption[5];
                    Editable = IsApproved;
                    Visible = FieldVisible5;
                    ToolTip = 'Specifies the value of the MatrixCellData[5] field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        InsertDeleteTrainingAtt(5);
                    end;
                }
                field("MatrixCellData[6]"; MatrixCellData[6])
                {
                    CaptionClass = '3,' + MatrixCaption[6];
                    Editable = IsApproved;
                    Visible = FieldVisible6;
                    ToolTip = 'Specifies the value of the MatrixCellData[6] field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        InsertDeleteTrainingAtt(6);
                    end;
                }
                field("MatrixCellData[7]"; MatrixCellData[7])
                {
                    CaptionClass = '3,' + MatrixCaption[7];
                    Editable = IsApproved;
                    Visible = FieldVisible7;
                    ToolTip = 'Specifies the value of the MatrixCellData[7] field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        InsertDeleteTrainingAtt(7);
                    end;
                }
                field("MatrixCellData[8]"; MatrixCellData[8])
                {
                    CaptionClass = '3,' + MatrixCaption[8];
                    Editable = IsApproved;
                    Visible = FieldVisible8;
                    ToolTip = 'Specifies the value of the MatrixCellData[8] field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        InsertDeleteTrainingAtt(8);
                    end;
                }
                field("MatrixCellData[9]"; MatrixCellData[9])
                {
                    CaptionClass = '3,' + MatrixCaption[9];
                    Editable = IsApproved;
                    Visible = FieldVisible9;
                    ToolTip = 'Specifies the value of the MatrixCellData[9] field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        InsertDeleteTrainingAtt(9);
                    end;
                }
                field("MatrixCellData[10]"; MatrixCellData[10])
                {
                    CaptionClass = '3,' + MatrixCaption[10];
                    Editable = IsApproved;
                    Visible = FieldVisible10;
                    ToolTip = 'Specifies the value of the MatrixCellData[10] field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        InsertDeleteTrainingAtt(10);
                    end;
                }
                field("MatrixCellData[11]"; MatrixCellData[11])
                {
                    CaptionClass = '3,' + MatrixCaption[11];
                    Editable = IsApproved;
                    Visible = FieldVisible11;
                    ToolTip = 'Specifies the value of the MatrixCellData[11] field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        InsertDeleteTrainingAtt(11);
                    end;
                }
                field("MatrixCellData[12]"; MatrixCellData[12])
                {
                    CaptionClass = '3,' + MatrixCaption[12];
                    Editable = IsApproved;
                    Visible = FieldVisible12;
                    ToolTip = 'Specifies the value of the MatrixCellData[12] field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        InsertDeleteTrainingAtt(12);
                    end;
                }
                field("MatrixCellData[13]"; MatrixCellData[13])
                {
                    CaptionClass = '3,' + MatrixCaption[13];
                    Editable = IsApproved;
                    Visible = FieldVisible13;
                    ToolTip = 'Specifies the value of the MatrixCellData[13] field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        InsertDeleteTrainingAtt(13);
                    end;
                }
                field("MatrixCellData[14]"; MatrixCellData[14])
                {
                    CaptionClass = '3,' + MatrixCaption[14];
                    Editable = IsApproved;
                    Visible = FieldVisible14;
                    ToolTip = 'Specifies the value of the MatrixCellData[14] field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        InsertDeleteTrainingAtt(14);
                    end;
                }
                field("MatrixCellData[15]"; MatrixCellData[15])
                {
                    CaptionClass = '3,' + MatrixCaption[15];
                    Editable = IsApproved;
                    Visible = FieldVisible15;
                    ToolTip = 'Specifies the value of the MatrixCellData[15] field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        InsertDeleteTrainingAtt(15);
                    end;
                }
                field("MatrixCellData[16]"; MatrixCellData[16])
                {
                    CaptionClass = '3,' + MatrixCaption[16];
                    Editable = IsApproved;
                    Visible = FieldVisible16;
                    ToolTip = 'Specifies the value of the MatrixCellData[16] field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        InsertDeleteTrainingAtt(16);
                    end;
                }
                field("MatrixCellData[17]"; MatrixCellData[17])
                {
                    CaptionClass = '3,' + MatrixCaption[17];
                    Editable = IsApproved;
                    Visible = FieldVisible17;
                    ToolTip = 'Specifies the value of the MatrixCellData[17] field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        InsertDeleteTrainingAtt(17);
                    end;
                }
                field("MatrixCellData[18]"; MatrixCellData[18])
                {
                    CaptionClass = '3,' + MatrixCaption[18];
                    Editable = IsApproved;
                    Visible = FieldVisible18;
                    ToolTip = 'Specifies the value of the MatrixCellData[18] field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        InsertDeleteTrainingAtt(18);
                    end;
                }
                field("MatrixCellData[19]"; MatrixCellData[19])
                {
                    CaptionClass = '3,' + MatrixCaption[19];
                    Editable = IsApproved;
                    Visible = FieldVisible19;
                    ToolTip = 'Specifies the value of the MatrixCellData[19] field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        InsertDeleteTrainingAtt(19);
                    end;
                }
                field("MatrixCellData[20]"; MatrixCellData[20])
                {
                    CaptionClass = '3,' + MatrixCaption[20];
                    Editable = IsApproved;
                    Visible = FieldVisible20;
                    ToolTip = 'Specifies the value of the MatrixCellData[20] field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        InsertDeleteTrainingAtt(20);
                    end;
                }
                field("Trainer Marks"; Rec."Trainer Marks")
                {
                    ToolTip = 'Specifies the value of the Trainer Marks field.';
                    ApplicationArea = All;
                }
                field("Training Marks"; Rec."Training Marks")
                {
                    ToolTip = 'Specifies the value of the Training Marks field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Post Attended")
            {
                Image = Register;
                ToolTip = 'Executes the Post Attended action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    TrainingLine.Reset;
                    TrainingLine.SetRange("Training No.", Rec."Training No.");
                    TrainingLine.SetRange(Type, Rec.Type::Trainee);
                    TrainingLine.ModifyAll(Posted, true);
                end;
            }
            action(InsertTrainee)
            {
                Image = InsertAccount;
                Visible = false;
                ToolTip = 'Executes the InsertTrainee action.';
                ApplicationArea = All;
                trigger OnAction()
                begin
                    TrainingMgt.GenerateTraineeForTraining(Rec."Training No.");
                end;
            }
            action("Import Trainees")
            {
                Image = Import;
                ToolTip = 'Executes the Import Trainees action.';
                ApplicationArea = All;
                trigger OnAction()
                var
                    Traline: Record "Training Line";
                begin
                    Traline.SetRange("Training No.", Rec."Training No.");
                    Traline.DeleteAll();
                    if Confirm('Do you want to import Trainees From Excel?', false) then
                        ExcelImport.ImportTraineeFromExcelSheet(Rec."Training No.");
                end;
            }
            action("Import Trainees Attendance")
            {
                Image = Import;
                ToolTip = 'Executes the Import Trainees action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if Confirm('Do you want to import Trainee Attendance From Excel?', false) then
                        ExcelImport.ImportTrainingAttendanceFromExcelSheet(Rec."Training No.");
                end;
            }
            action("Export Trainee Attendance Format")
            {
                Image = Import;
                ToolTip = 'Executes the Import Trainees action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if Confirm('Do you want to import Trainee Attendance Format For Excel?', false) then
                        ExcelImport.ExportTrainingAttendanceExcelFormat();
                end;
            }
            // action("Show Training Question")
            // {
            //     Image = Questionaire;
            //     Visible = IsApproved;
            //     ToolTip = 'Executes the Show Training Question action.';
            //     ApplicationArea = All;

            //     trigger OnAction()
            //     begin
            //         TrainingMgt.ShowTrainingList(Rec."Training No.", Rec."Employee Code");
            //     end;
            // }
            // action("Show Trainer Question")
            // {
            //     Image = Questionaire;
            //     Visible = IsApproved;
            //     ToolTip = 'Executes the Show Trainer Question action.';
            //     ApplicationArea = All;

            //     trigger OnAction()
            //     begin
            //         TrainingMgt.ShowTrainerList(Rec."Training No.", Rec."Employee Code");
            //     end;
            // }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if TrainHead.Get(Rec."Training No.") then
            IsApproved := TrainHead."Approval Status" = TrainHead."Approval Status"::Released;

        for i := 1 to 20 do begin
            MatrixCellData[i] := GetTraining(i);
        end;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        CurrPage.Update;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Type := Rec.Type::Trainee;
    end;

    var
        TrainingLine: Record "Training Line";
        TrainingMgt: Codeunit "Training Mgt";
        ExcelImport: Codeunit "Excel Import";
        MatrixCellData: array[20] of Boolean;

        FieldVisible1: Boolean;

        FieldVisible2: Boolean;

        FieldVisible3: Boolean;

        FieldVisible4: Boolean;

        FieldVisible5: Boolean;

        FieldVisible6: Boolean;

        FieldVisible7: Boolean;

        FieldVisible8: Boolean;

        FieldVisible9: Boolean;

        FieldVisible10: Boolean;

        FieldVisible11: Boolean;

        FieldVisible12: Boolean;

        FieldVisible13: Boolean;

        FieldVisible14: Boolean;

        FieldVisible15: Boolean;

        FieldVisible16: Boolean;

        FieldVisible17: Boolean;

        FieldVisible18: Boolean;

        FieldVisible19: Boolean;

        FieldVisible20: Boolean;
        MatrixCaption: array[20] of Text;
        MatrixColumnCount: Integer;
        i: Integer;
        CalDate: Date;
        TrainingAtt: Record "Training Attendance";
        HRMgt: Codeunit "HR Mgt.";

        IsApproved: Boolean;
        TrainHead: Record "Training Header";
        EmpFeedback: Record "Employee Feedback";

    local procedure ShowHideColumn()
    begin
        FieldVisible1 := MatrixColumnCount >= 1;
        FieldVisible2 := MatrixColumnCount >= 2;
        FieldVisible3 := MatrixColumnCount >= 3;
        FieldVisible4 := MatrixColumnCount >= 4;
        FieldVisible5 := MatrixColumnCount >= 5;
        FieldVisible6 := MatrixColumnCount >= 6;
        FieldVisible7 := MatrixColumnCount >= 7;
        FieldVisible8 := MatrixColumnCount >= 8;
        FieldVisible9 := MatrixColumnCount >= 9;
        FieldVisible10 := MatrixColumnCount >= 10;
        FieldVisible11 := MatrixColumnCount >= 11;
        FieldVisible12 := MatrixColumnCount >= 12;
        FieldVisible13 := MatrixColumnCount >= 13;
        FieldVisible14 := MatrixColumnCount >= 14;
        FieldVisible15 := MatrixColumnCount >= 15;
        FieldVisible16 := MatrixColumnCount >= 16;
        FieldVisible17 := MatrixColumnCount >= 17;
        FieldVisible18 := MatrixColumnCount >= 18;
        FieldVisible19 := MatrixColumnCount >= 19;
        FieldVisible20 := MatrixColumnCount >= 20;
    end;

    procedure SetMatrixData(NoOfColumn: Integer; StartDate: Date)
    begin
        for i := 1 to NoOfColumn do begin
            MatrixCaption[i] := Format(StartDate);
            StartDate += 1;
        end;
        MatrixColumnCount := NoOfColumn;
        ShowHideColumn;
    end;

    local procedure GetTraining(j: Integer): Boolean
    begin
        TrainingAtt.Reset;
        Evaluate(CalDate, MatrixCaption[j]);
        TrainingAtt.SetRange("Employee No.", Rec."Employee Code");
        TrainingAtt.SetRange("Training No", Rec."Training No.");
        TrainingAtt.SetRange("Attended Date", CalDate);
        if TrainingAtt.FindFirst then
            exit(true);
    end;

    local procedure InsertDeleteTrainingAtt(j: Integer)
    var
        LineNo: Integer;
    begin
        Rec.TestField("Employee Code");
        Evaluate(CalDate, MatrixCaption[j]);
        Clear(LineNo);
        TrainHead.Get(Rec."Training No.");
        TrainHead.TestField("Approval Status", TrainHead."Approval Status"::Released);
        TrainingAtt.Reset;
        TrainingAtt.SetRange("Training No", Rec."Training No.");
        if TrainingAtt.FindLast then
            LineNo := TrainingAtt."Line No.";

        if MatrixCellData[j] then begin
            TrainingAtt.Reset;
            TrainingAtt.SetRange("Employee No.", Rec."Employee Code");
            TrainingAtt.SetRange("Training No", Rec."Training No.");
            TrainingAtt.SetRange("Attended Date", CalDate);
            if not TrainingAtt.FindFirst then begin
                TrainingAtt.Init;
                TrainingAtt.Validate("Employee No.", Rec."Employee Code");
                TrainingAtt.Validate("Training No", Rec."Training No.");
                TrainingAtt.Validate("Attended Date", CalDate);
                TrainingAtt.Validate("Line No.", LineNo + 10000);
                TrainingAtt.Insert;
            end;
            EmpFeedback.Reset;
            EmpFeedback.SetRange(Code, Rec."Training No.");
            EmpFeedback.SetRange("Employee No.", Rec."Employee Code");
            if not EmpFeedback.FindFirst then
                TrainingMgt.InsertEmployeeWiseTrainingQuestion(Rec."Training No.", Rec."Employee Code");

        end else begin
            TrainingAtt.Reset;
            TrainingAtt.SetRange("Employee No.", Rec."Employee Code");
            TrainingAtt.SetRange("Training No", Rec."Training No.");
            TrainingAtt.SetRange("Attended Date", CalDate);
            if TrainingAtt.FindFirst then
                TrainingAtt.Delete(true);
        end;
    end;
}
