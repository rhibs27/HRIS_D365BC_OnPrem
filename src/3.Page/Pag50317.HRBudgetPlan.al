page 50317 "HR Budget Plan"
{
    ApplicationArea = Basic, Suite;
    Caption = 'HR Budget Plan';
    PageType = List;
    SourceTable = "HR Budget Plan";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            field(FiscalYear; FiscalYear)
            {
                ApplicationArea = All;
                Caption = 'Fiscal Year';
                ToolTip = 'Specifies the value of the Fiscal Year field.';
                trigger OnValidate()
                begin
                    if FiscalYear <> '' then begin
                        Rec.FilterGroup(2);
                        Rec.SetRange("Fiscal Year", FiscalYear);
                        Rec.FilterGroup(0);
                    end
                    else begin
                        rec.Reset();
                    end;
                    CurrPage.Update;
                end;
            }
            repeater(General)
            {
                field("Fiscal Year"; Rec."Fiscal Year")
                {
                    ToolTip = 'Specifies the value of the Fiscal Year field.', Comment = '%';
                    Editable = FieldEditable;
                    ApplicationArea = All;
                }
                field("Deputation On"; Rec."Deputation On")
                {
                    ToolTip = 'Specifies the value of the Deputation On field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Functional Title Code"; Rec."Functional Title Code")
                {
                    ToolTip = 'Specifies the value of the Functional Title Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Functional Title"; Rec."Functional Title")
                {
                    ToolTip = 'Specifies the value of the Functional Title field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Salary Level Code"; Rec."Salary Level Code")
                {
                    ToolTip = 'Specifies the value of the Salary Level Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Salary Level"; Rec."Salary Level")
                {
                    ToolTip = 'Specifies the value of the Salary Level field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("No. of Employees"; Rec."No. of Employees")
                {
                    ToolTip = 'Specifies the value of the No. of Employees field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Created By"; Rec."Created By")
                {
                    ToolTip = 'Specifies the value of the Created By field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Created DateTime"; Rec."Created DateTime")
                {
                    ToolTip = 'Specifies the value of the Created DateTime field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Posted; Rec.Posted)
                {
                    ToolTip = 'Specifies the value of the Posted field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Posted By"; Rec."Posted By")
                {
                    ToolTip = 'Specifies the value of the Posted By field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Posted DateTime"; Rec."Posted DateTime")
                {
                    ToolTip = 'Specifies the value of the Posted DateTime field.', Comment = '%';
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Create HR Budget")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Image = CreateForm;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'Executes the Create HR Budget action.';
                trigger OnAction()
                begin
                    if FiscalYear = '' then
                        Error('Enter Fiscal Year Filter.');
                    Rec.InsertHRBudgetCombination(FiscalYear);
                end;
            }
        }
    }
    var
        FiscalYear: Text[10];
        FieldEditable: Boolean;

    local procedure ControlLayout();
    begin
        FieldEditable := not Rec.Posted;
    end;

    trigger OnOpenPage()

    begin
        FiscalYear := '';
        ControlLayout;
    end;

    trigger OnAfterGetRecord()
    begin
        ControlLayout;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Fiscal Year" := FiscalYear;
    end;
}
