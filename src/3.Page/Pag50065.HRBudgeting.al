page 50065 "HR Budgeting"
{

    UsageCategory = History;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(Control2)
            {
                ShowCaption = false;
                field("View By"; ViewBy)
                {
                    ToolTip = 'Specifies the value of the ViewBy field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        SetColumn(SetWanted::Initial);
                    end;
                }
                field(ColumnSet; ColumnSet)
                {
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the value of the ColumnSet field.';
                    ApplicationArea = All;
                }
                field(DeputationOn; DeputationOn)
                {
                    Caption = 'Deputation On';
                    ToolTip = 'Specifies the value of the Deputation On field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        SetColumn(SetWanted::Initial);
                    end;
                }
                field(ShowCaption; ShowCaption)
                {
                    Caption = 'Show Caption';
                    ToolTip = 'Specifies the value of the Show Caption field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        SetColumn(SetWanted::Initial);
                    end;
                }
            }
            part(HRBudgetMatrixSubform; "HR Budget Matrix Subform")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Previous Set")
            {
                Image = PreviousSet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Previous Set action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    SetColumn(SetWanted::Previous);
                end;
            }
            action("Previous Column")
            {
                Image = PreviousRecord;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Previous Column action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    SetColumn(SetWanted::PreviousColumn);
                end;
            }
            action("Next Column")
            {
                Image = NextRecord;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Next Column action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    SetColumn(SetWanted::NextColumn);
                end;
            }
            action("Next Set")
            {
                Image = NextSet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Next Set action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    SetColumn(SetWanted::Next);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        SetColumn(SetWanted::Initial);
    end;

    var
        ViewBy: Option Actual,Setup;
        RecRef: RecordRef;
        SetWanted: Option Initial,Previous,Same,Next,PreviousColumn,NextColumn;
        MatrxiColumnCaption: array[32] of Text;
        ColumnSet: Text;
        RecordPosition: Text[1024];
        CurrLength: Integer;
        GLSetup: Record "General Ledger Setup";
        FieldRefs: FieldRef;
        DeputationOn: Option " ",Branch,"Extension Counter","Sub Province",Province,Unit,Department;
        ShowCaption: Boolean;
        ActualMatrixColumnCaption: array[32] of Text;

    local procedure SetColumn(SetWanted: Option Initial,Previous,Same,Next,PreviousColumn,NextColumn)
    var
        FieldNo: Integer;
        DescFieldNo: Integer;
        HrMgt: Codeunit "HR Mgt.";
    begin
        if DeputationOn = DeputationOn::" " then
            exit;
        case DeputationOn of
            DeputationOn::Branch:
                begin
                    GLSetup.Get;
                    RecRef.Open(Database::"Dimension Value");
                    FieldRefs := RecRef.Field(1);
                    FieldRefs.SetRange(GLSetup."Global Dimension 1 Code");
                    FieldRefs := RecRef.Field(6);
                    FieldRefs.SetRange(false);
                    DescFieldNo := 3;
                    FieldNo := 2;
                end;
            DeputationOn::Department:
                begin
                    RecRef.Open(Database::Department);
                    FieldRefs := RecRef.Field(16);
                    FieldRefs.SetRange(false);
                    DescFieldNo := 2;
                    FieldNo := 1;
                end;
            DeputationOn::"Extension Counter":
                begin
                    RecRef.Open(Database::"Employee Hierarchy Master");
                    FieldRefs := RecRef.Field(4);
                    FieldRefs.SetRange(2);
                    FieldRefs := RecRef.Field(9);
                    FieldRefs.SetRange(false);
                    DescFieldNo := 2;
                    FieldNo := 1;
                end;
            DeputationOn::Province:
                begin
                    RecRef.Open(Database::Province);
                    FieldRefs := RecRef.Field(7);
                    FieldRefs.SetRange(false);
                    DescFieldNo := 2;
                    FieldNo := 1;
                end;
            DeputationOn::"Sub Province":
                begin
                    RecRef.Open(Database::"Sub Province");
                    FieldRefs := RecRef.Field(60001);
                    FieldRefs.SetRange(false);
                    DescFieldNo := 2;
                    FieldNo := 1;
                end;
            DeputationOn::Unit:
                begin
                    RecRef.Open(Database::"Employee Hierarchy Master");
                    FieldRefs := RecRef.Field(4);
                    FieldRefs.SetRange(3);
                    FieldRefs := RecRef.Field(9);
                    FieldRefs.SetRange(false);
                    DescFieldNo := 2;
                    FieldNo := 1;
                end;
        end;

        if RecordPosition = '' then
            RecordPosition := RecRef.GetPosition(false);
        HrMgt.GenerateActualMatrixData(RecRef, SetWanted, ArrayLen(MatrxiColumnCaption), FieldNo, RecordPosition, MatrxiColumnCaption, ColumnSet, CurrLength, ActualMatrixColumnCaption, DescFieldNo, ShowCaption);
        CurrPage.HRBudgetMatrixSubform.Page.SetDeputationOn(DeputationOn);
        CurrPage.HRBudgetMatrixSubform.Page.SetShowCaption(ShowCaption);
        CurrPage.HRBudgetMatrixSubform.Page.SetMatrixData(MatrxiColumnCaption, RecRef, CurrLength, ViewBy, ActualMatrixColumnCaption);
        RecRef.Close;
        CurrPage.Update(false);
    end;
}
