page 50064 "HR Budget Matrix Subform"
{
    PageType = ListPart;
    SourceTable = "Functional Title";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                Editable = false;
                field("Code"; Rec.Code)
                {
                    ToolTip = 'Specifies the value of the Code field.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = All;
                }
                field("MatrixCellData[1]"; MatrixCellData[1])
                {
                    CaptionClass = '3,' + ActualMatrixCaption[1];
                    Visible = FieldVisible1;
                    ToolTip = 'Specifies the value of the MatrixCellData[1] field.';
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    begin
                        DrillDownMatrix(1);
                    end;
                }
                field("MatrixCellData[2]"; MatrixCellData[2])
                {
                    CaptionClass = '3,' + ActualMatrixCaption[2];
                    Visible = FieldVisible2;
                    ToolTip = 'Specifies the value of the MatrixCellData[2] field.';
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    begin
                        DrillDownMatrix(2);
                    end;
                }
                field("MatrixCellData[3]"; MatrixCellData[3])
                {
                    CaptionClass = '3,' + ActualMatrixCaption[3];
                    Visible = FieldVisible3;
                    ToolTip = 'Specifies the value of the MatrixCellData[3] field.';
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    begin
                        DrillDownMatrix(3);
                    end;
                }
                field("MatrixCellData[4]"; MatrixCellData[4])
                {
                    CaptionClass = '3,' + ActualMatrixCaption[4];
                    Visible = FieldVisible4;
                    ToolTip = 'Specifies the value of the MatrixCellData[4] field.';
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    begin
                        DrillDownMatrix(4);
                    end;
                }
                field("MatrixCellData[5]"; MatrixCellData[5])
                {
                    CaptionClass = '3,' + ActualMatrixCaption[5];
                    Visible = FieldVisible5;
                    ToolTip = 'Specifies the value of the MatrixCellData[5] field.';
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    begin
                        DrillDownMatrix(5);
                    end;
                }
                field("MatrixCellData[6]"; MatrixCellData[6])
                {
                    CaptionClass = '3,' + ActualMatrixCaption[6];
                    Visible = FieldVisible6;
                    ToolTip = 'Specifies the value of the MatrixCellData[6] field.';
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    begin
                        DrillDownMatrix(6);
                    end;
                }
                field("MatrixCellData[7]"; MatrixCellData[7])
                {
                    CaptionClass = '3,' + ActualMatrixCaption[7];
                    Visible = FieldVisible7;
                    ToolTip = 'Specifies the value of the MatrixCellData[7] field.';
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    begin
                        DrillDownMatrix(7);
                    end;
                }
                field("MatrixCellData[8]"; MatrixCellData[8])
                {
                    CaptionClass = '3,' + ActualMatrixCaption[8];
                    Visible = FieldVisible8;
                    ToolTip = 'Specifies the value of the MatrixCellData[8] field.';
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    begin
                        DrillDownMatrix(8);
                    end;
                }
                field("MatrixCellData[9]"; MatrixCellData[9])
                {
                    CaptionClass = '3,' + ActualMatrixCaption[9];
                    Visible = FieldVisible9;
                    ToolTip = 'Specifies the value of the MatrixCellData[9] field.';
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    begin
                        DrillDownMatrix(9);
                    end;
                }
                field("MatrixCellData[10]"; MatrixCellData[10])
                {
                    CaptionClass = '3,' + ActualMatrixCaption[10];
                    Visible = FieldVisible10;
                    ToolTip = 'Specifies the value of the MatrixCellData[10] field.';
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    begin
                        DrillDownMatrix(10);
                    end;
                }
                field("MatrixCellData[11]"; MatrixCellData[11])
                {
                    CaptionClass = '3,' + ActualMatrixCaption[11];
                    Visible = FieldVisible11;
                    ToolTip = 'Specifies the value of the MatrixCellData[11] field.';
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    begin
                        DrillDownMatrix(11);
                    end;
                }
                field("MatrixCellData[12]"; MatrixCellData[12])
                {
                    CaptionClass = '3,' + ActualMatrixCaption[12];
                    Visible = FieldVisible12;
                    ToolTip = 'Specifies the value of the MatrixCellData[12] field.';
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    begin
                        DrillDownMatrix(12);
                    end;
                }
                field("MatrixCellData[13]"; MatrixCellData[13])
                {
                    CaptionClass = '3,' + ActualMatrixCaption[13];
                    Visible = FieldVisible13;
                    ToolTip = 'Specifies the value of the MatrixCellData[13] field.';
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    begin
                        DrillDownMatrix(13);
                    end;
                }
                field("MatrixCellData[14]"; MatrixCellData[14])
                {
                    CaptionClass = '3,' + ActualMatrixCaption[14];
                    Visible = FieldVisible14;
                    ToolTip = 'Specifies the value of the MatrixCellData[14] field.';
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    begin
                        DrillDownMatrix(14);
                    end;
                }
                field("MatrixCellData[15]"; MatrixCellData[15])
                {
                    CaptionClass = '3,' + ActualMatrixCaption[15];
                    Visible = FieldVisible15;
                    ToolTip = 'Specifies the value of the MatrixCellData[15] field.';
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    begin
                        DrillDownMatrix(15);
                    end;
                }
                field("MatrixCellData[16]"; MatrixCellData[16])
                {
                    CaptionClass = '3,' + ActualMatrixCaption[16];
                    Visible = FieldVisible16;
                    ToolTip = 'Specifies the value of the MatrixCellData[16] field.';
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    begin
                        DrillDownMatrix(16);
                    end;
                }
                field("MatrixCellData[17]"; MatrixCellData[17])
                {
                    CaptionClass = '3,' + ActualMatrixCaption[17];
                    Visible = FieldVisible17;
                    ToolTip = 'Specifies the value of the MatrixCellData[17] field.';
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    begin
                        DrillDownMatrix(17);
                    end;
                }
                field("MatrixCellData[18]"; MatrixCellData[18])
                {
                    CaptionClass = '3,' + ActualMatrixCaption[18];
                    Visible = FieldVisible18;
                    ToolTip = 'Specifies the value of the MatrixCellData[18] field.';
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    begin
                        DrillDownMatrix(18);
                    end;
                }
                field("MatrixCellData[19]"; MatrixCellData[19])
                {
                    CaptionClass = '3,' + ActualMatrixCaption[19];
                    Visible = FieldVisible19;
                    ToolTip = 'Specifies the value of the MatrixCellData[19] field.';
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    begin
                        DrillDownMatrix(19);
                    end;
                }
                field("MatrixCellData[20]"; MatrixCellData[20])
                {
                    CaptionClass = '3,' + ActualMatrixCaption[20];
                    Visible = FieldVisible20;
                    ToolTip = 'Specifies the value of the MatrixCellData[20] field.';
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    begin
                        DrillDownMatrix(20);
                    end;
                }
                field("MatrixCellData[21]"; MatrixCellData[21])
                {
                    CaptionClass = '3,' + ActualMatrixCaption[21];
                    Visible = FieldVisible21;
                    ToolTip = 'Specifies the value of the MatrixCellData[21] field.';
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    begin
                        DrillDownMatrix(21);
                    end;
                }
                field("MatrixCellData[22]"; MatrixCellData[22])
                {
                    CaptionClass = '3,' + ActualMatrixCaption[22];
                    Visible = FieldVisible22;
                    ToolTip = 'Specifies the value of the MatrixCellData[22] field.';
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    begin
                        DrillDownMatrix(22);
                    end;
                }
                field("MatrixCellData[23]"; MatrixCellData[23])
                {
                    CaptionClass = '3,' + ActualMatrixCaption[23];
                    Visible = FieldVisible23;
                    ToolTip = 'Specifies the value of the MatrixCellData[23] field.';
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    begin
                        DrillDownMatrix(23);
                    end;
                }
                field("MatrixCellData[24]"; MatrixCellData[24])
                {
                    CaptionClass = '3,' + ActualMatrixCaption[24];
                    Visible = FieldVisible24;
                    ToolTip = 'Specifies the value of the MatrixCellData[24] field.';
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    begin
                        DrillDownMatrix(24);
                    end;
                }
                field("MatrixCellData[25]"; MatrixCellData[25])
                {
                    CaptionClass = '3,' + ActualMatrixCaption[25];
                    Visible = FieldVisible25;
                    ToolTip = 'Specifies the value of the MatrixCellData[25] field.';
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    begin
                        DrillDownMatrix(25);
                    end;
                }
                field("MatrixCellData[26]"; MatrixCellData[26])
                {
                    CaptionClass = '3,' + ActualMatrixCaption[26];
                    Visible = FieldVisible26;
                    ToolTip = 'Specifies the value of the MatrixCellData[26] field.';
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    begin
                        DrillDownMatrix(26);
                    end;
                }
                field("MatrixCellData[27]"; MatrixCellData[27])
                {
                    CaptionClass = '3,' + ActualMatrixCaption[27];
                    Visible = FieldVisible27;
                    ToolTip = 'Specifies the value of the MatrixCellData[27] field.';
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    begin
                        DrillDownMatrix(27);
                    end;
                }
                field("MatrixCellData[28]"; MatrixCellData[28])
                {
                    CaptionClass = '3,' + ActualMatrixCaption[28];
                    Visible = FieldVisible28;
                    ToolTip = 'Specifies the value of the MatrixCellData[28] field.';
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    begin
                        DrillDownMatrix(28);
                    end;
                }
                field("MatrixCellData[29]"; MatrixCellData[29])
                {
                    CaptionClass = '3,' + ActualMatrixCaption[29];
                    Visible = FieldVisible29;
                    ToolTip = 'Specifies the value of the MatrixCellData[29] field.';
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    begin
                        DrillDownMatrix(29);
                    end;
                }
                field("MatrixCellData[30]"; MatrixCellData[30])
                {
                    CaptionClass = '3,' + ActualMatrixCaption[30];
                    Visible = FieldVisible30;
                    ToolTip = 'Specifies the value of the MatrixCellData[30] field.';
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    begin
                        DrillDownMatrix(30);
                    end;
                }
                field("MatrixCellData[31]"; MatrixCellData[31])
                {
                    CaptionClass = '3,' + ActualMatrixCaption[31];
                    Visible = FieldVisible31;
                    ToolTip = 'Specifies the value of the MatrixCellData[31] field.';
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    begin
                        DrillDownMatrix(31);
                    end;
                }
                field("MatrixCellData[32]"; MatrixCellData[32])
                {
                    CaptionClass = '3,' + ActualMatrixCaption[32];
                    Visible = FieldVisible32;
                    ToolTip = 'Specifies the value of the MatrixCellData[32] field.';
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    begin
                        DrillDownMatrix(32);
                    end;
                }
            }
        }
    }

    actions { }

    trigger OnAfterGetRecord()
    begin
        for Counter := 1 to MatrixColumnCount do begin
            OnAfterGetMatrix(Counter);
        end;
    end;

    var
        RecordRe: RecordRef;
        ViewBy: Option Actual,Setup;
        ReqEmpInBranch: Record "Required Emp In Branch";
        MatrixColumnCount: Integer;
        MatrixCellData: array[32] of Decimal;
        [InDataSet]
        FieldVisible1: Boolean;
        [InDataSet]
        FieldVisible2: Boolean;
        [InDataSet]
        FieldVisible3: Boolean;
        [InDataSet]
        FieldVisible4: Boolean;
        [InDataSet]
        FieldVisible5: Boolean;
        [InDataSet]
        FieldVisible6: Boolean;
        [InDataSet]
        FieldVisible7: Boolean;
        [InDataSet]
        FieldVisible8: Boolean;
        [InDataSet]
        FieldVisible9: Boolean;
        [InDataSet]
        FieldVisible10: Boolean;
        [InDataSet]
        FieldVisible11: Boolean;
        [InDataSet]
        FieldVisible12: Boolean;
        [InDataSet]
        FieldVisible13: Boolean;
        [InDataSet]
        FieldVisible14: Boolean;
        [InDataSet]
        FieldVisible15: Boolean;
        [InDataSet]
        FieldVisible16: Boolean;
        [InDataSet]
        FieldVisible17: Boolean;
        [InDataSet]
        FieldVisible18: Boolean;
        [InDataSet]
        FieldVisible19: Boolean;
        [InDataSet]
        FieldVisible20: Boolean;
        [InDataSet]
        FieldVisible21: Boolean;
        [InDataSet]
        FieldVisible22: Boolean;
        [InDataSet]
        FieldVisible23: Boolean;
        [InDataSet]
        FieldVisible24: Boolean;
        [InDataSet]
        FieldVisible25: Boolean;
        [InDataSet]
        FieldVisible26: Boolean;
        [InDataSet]
        FieldVisible27: Boolean;
        [InDataSet]
        FieldVisible28: Boolean;
        [InDataSet]
        FieldVisible29: Boolean;
        [InDataSet]
        FieldVisible30: Boolean;
        [InDataSet]
        FieldVisible31: Boolean;
        [InDataSet]
        FieldVisible32: Boolean;
        MatrixCaption: array[32] of Text;
        Counter: Integer;
        ActualMatrixCaption: array[32] of Text;
        GblDeputationOn: Option " ",Branch,"Extension Counter","Sub Province",Province,Unit,Department;
        GblShowCaption: Boolean;

    procedure SetMatrixData(ColumnCaption: array[32] of Text; var RecRef: RecordRef; ColumnLength: Integer; View: Option Actual,Setup; ActualColumnCaption: array[32] of Text)
    var
        i: Integer;
    begin
        for i := 1 to ArrayLen(ColumnCaption) do begin
            if ColumnCaption[i] = '' then begin
                MatrixCaption[i] := ' ';
                //DimensionCode[i] := ' ';
            end else begin
                MatrixCaption[i] := ColumnCaption[i];
                if GblShowCaption then
                    ActualMatrixCaption[i] := ActualColumnCaption[i]
                else
                    ActualMatrixCaption[i] := ColumnCaption[i];
                //DimensionCode[i] := DimCode[i];
            end;
        end;
        RecordRe := RecRef;
        ViewBy := View;
        MatrixColumnCount := ColumnLength;
        ShowHideColumn;
    end;

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
        FieldVisible21 := MatrixColumnCount >= 21;
        FieldVisible22 := MatrixColumnCount >= 22;
        FieldVisible23 := MatrixColumnCount >= 23;
        FieldVisible24 := MatrixColumnCount >= 24;
        FieldVisible25 := MatrixColumnCount >= 25;
        FieldVisible26 := MatrixColumnCount >= 26;
        FieldVisible27 := MatrixColumnCount >= 27;
        FieldVisible28 := MatrixColumnCount >= 28;
        FieldVisible29 := MatrixColumnCount >= 29;
        FieldVisible30 := MatrixColumnCount >= 30;
        FieldVisible31 := MatrixColumnCount >= 31;
        FieldVisible32 := MatrixColumnCount >= 32;
    end;

    local procedure OnAfterGetMatrix(i: Integer)
    var
        EmpVar: Record Employee;
    begin
        if ViewBy = ViewBy::Actual then begin
            EmpVar.Reset;
            EmpVar.SetRange(Status, EmpVar.Status::Active);
            EmpVar.SetRange("Functional Title", Rec.Code);
            EmpVar.SetRange("Deputation on", GblDeputationOn);

            case GblDeputationOn of
                GblDeputationOn::Branch:
                    EmpVar.SetRange("Global Dimension 1 Code", MatrixCaption[i]);

                GblDeputationOn::Department:
                    EmpVar.SetRange("Department Code", MatrixCaption[i]);

                GblDeputationOn::"Extension Counter":
                    EmpVar.SetRange("Extension Counter Code", MatrixCaption[i]);

                GblDeputationOn::Province:
                    EmpVar.SetRange("Province Code", MatrixCaption[i]);

                // GblDeputationOn::"Sub Province":
                //     EmpVar.SetRange("Sub Province Code", MatrixCaption[i]);

                GblDeputationOn::Unit:
                    EmpVar.SetRange("Unit Code", MatrixCaption[i]);
            end;
            MatrixCellData[i] := EmpVar.Count;
        end else begin
            if ReqEmpInBranch.Get(MatrixCaption[i], Rec.Code) then
                MatrixCellData[i] := ReqEmpInBranch."Required Employee"
            else
                MatrixCellData[i] := 0;
        end;
    end;

    local procedure DrillDownMatrix(i: Integer)
    var
        EmpVar: Record Employee;
    begin
        if ViewBy = ViewBy::Actual then begin
            EmpVar.Reset;
            EmpVar.SetRange(Status, EmpVar.Status::Active);
            EmpVar.SetRange("Functional Title", Rec.Code);
            EmpVar.SetRange("Deputation on", GblDeputationOn);

            case GblDeputationOn of
                GblDeputationOn::Branch:
                    EmpVar.SetRange("Global Dimension 1 Code", MatrixCaption[i]);

                GblDeputationOn::Department:
                    EmpVar.SetRange("Department Code", MatrixCaption[i]);

                GblDeputationOn::"Extension Counter":
                    EmpVar.SetRange("Extension Counter Code", MatrixCaption[i]);

                GblDeputationOn::Province:
                    EmpVar.SetRange("Province Code", MatrixCaption[i]);

                // GblDeputationOn::"Sub Province":
                //     EmpVar.SetRange("Sub Province Code", MatrixCaption[i]);

                GblDeputationOn::Unit:
                    EmpVar.SetRange("Unit Code", MatrixCaption[i]);
            end;
            Page.Run(0, EmpVar);
        end;
    end;

    procedure SetDeputationOn(DeputationOn: Option)
    begin
        GblDeputationOn := DeputationOn;
    end;

    procedure SetShowCaption(ShowCaption: Boolean)
    begin
        GblShowCaption := ShowCaption;
    end;
}
