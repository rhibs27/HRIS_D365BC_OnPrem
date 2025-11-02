page 50368 "Assignment Memo Subform"
{
    ApplicationArea = All;
    Caption = 'Assignment Memo Subform';
    PageType = ListPart;
    SourceTable = "Assignment Memo Line";
    AutoSplitKey = true;
    DelayedInsert = true;


    layout
    {
        area(Content)
        {
            repeater(General)
            {

                field("Employee Code"; Rec."Employee Code")
                {
                    ToolTip = 'Specifies the value of the Employee Code field.', Comment = '%';
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Employee Name field.', Comment = '%';
                }
                field("From Date"; Rec."From Date")
                {
                    ToolTip = 'Specifies the value of the From Date field.', Comment = '%';
                }
                field("To Date"; Rec."To Date")
                {
                    ToolTip = 'Specifies the value of the To Date field.', Comment = '%';
                }
                field("Allowance Type"; Rec."Allowance Type")
                {
                    ToolTip = 'Specifies the value of the Allowance Type field.', Comment = '%';
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Approval Status field.', Comment = '%';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Substitute)
            {
                Image = Refresh;
                ToolTip = 'Executes the Substitute action.';
                ApplicationArea = All;
                Visible = DocumentApproved;

                trigger OnAction()
                var
                    AllowanceLineTemp: Record "Allowance Assignment Line" temporary;
                    FilterPage: FilterPageBuilder;
                    AllowanceLine: Record "Assignment Memo Line";
                    FromDate, Todate : date;
                    AllowanceType, EmpCode : code[20];
                    AssignmentMemoMgt: Codeunit "Assignment Memo Mgt";
                begin
                    Rec.TestField("Substitute type", rec."Substitute Type"::" ");
                    Rec.TestField("Approval Status", Rec."Approval Status"::Approved);
                    // AllowanceLineTemp.Reset;
                    // AllowanceLineTemp.SetRange("No.", Rec."No.");
                    // AllowanceLineTemp.SetRange("Substitute of Line No.", Rec."Line No.");
                    // AllowanceLineTemp.SetRange("Substitute Type", AllowanceLineTemp."Substitute Type"::"Added as Substitute");
                    // AllowanceLineTemp.SetRange("Employee Code", '');
                    // if not AllowanceLineTemp.FindFirst then begin
                    //     AllowanceLineTemp.Reset;
                    //     AllowanceLineTemp.Init;
                    //     AllowanceLineTemp."No." := Rec."No.";
                    //     AllowanceLineTemp."Substitute type" := AllowanceLineTemp."Substitute type"::"Added as Substitute";
                    //     AllowanceLineTemp."Substitute of Line No." := Rec."Line No.";
                    //     AllowanceLineTemp."Allowance Type" := Rec."Allowance Type";
                    //     AllowanceLineTemp.Type := rec.Type;
                    //     AllowanceLineTemp.Code := rec.code;
                    //     AllowanceLineTemp.Panel := rec.Panel;
                    //     AllowanceLineTemp."From Date" := rec."From Date";
                    //     AllowanceLineTemp."To Date" := rec."To Date";
                    //     AllowanceLineTemp.Insert();
                    // end;
                    // Page.Run(Page::"Allowance Assign. Substitute", AllowanceLineTemp);

                    FilterPage.AddRecord('Select Employee Details', AllowanceLine);
                    FilterPage.AddField('Select Employee Details', AllowanceLine."From Date");
                    FilterPage.AddField('Select Employee Details', AllowanceLine."To Date");
                    FilterPage.AddField('Select Employee Details', AllowanceLine."Employee Code");
                    FilterPage.AddField('Select Employee Details', AllowanceLine."Allowance Type");
                    if FilterPage.RunModal() then begin
                        AllowanceLine.SetView(FilterPage.GetView('Select Employee Details'));
                        Evaluate(FromDate, AllowanceLine.GetFilter("From Date"));
                        Evaluate(ToDate, AllowanceLine.GetFilter("To Date"));
                        Evaluate(AllowanceType, AllowanceLine.GetFilter("Allowance Type"));
                        Evaluate(EmpCode, AllowanceLine.GetFilter("Employee Code"));
                    end;
                    AssignmentMemoMgt.InsertSubstituteAssignmentMemo(Rec."Document No.", Rec."Employee Code", AllowanceType, panel::" ", EmpCode, FromDate, ToDate);
                    CurrPage.Update();
                end;
            }

        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Emp Act Type" := Rec."Emp Act Type"::"Allowance Assignment Memo";
    end;

    trigger OnOpenPage()
    begin

    end;

    procedure SetLayout()
    begin
        DocumentApproved := Rec."Approval Status" = Rec."Approval Status"::Approved;

    end;

    var
        DocumentApproved, RequestDoc : boolean;
}
