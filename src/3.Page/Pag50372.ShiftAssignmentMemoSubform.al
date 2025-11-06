page 50372 "Shift Assignment Memo Subform"
{
    ApplicationArea = All;
    Caption = 'Shift Assignment Memo Subform';
    PageType = ListPart;
    SourceTable = "Assignment Memo Line";
    SourceTableView = where("Emp Act Type" = const("Shift Assignment Memo"));
    AutoSplitKey = true;
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Employee Code"; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the value of the Employee Code field.', Comment = '%';
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("Employee Work Shift"; Rec."Employee Work Shift")
                {
                    ToolTip = 'Specifies the value of the Employee Work Shift field.', Comment = '%';
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
                field("Approval Status"; Rec."Approval Status")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Approval Status field.', Comment = '%';
                }
                field("No of Approved Days"; Rec."No of Approved Days")
                {
                    ToolTip = 'Specifies the value of the No of Approved Days field.', Comment = '%';
                    DrillDownPageId = "Assignment Memo Ledger Entries";
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
                Visible = SubstituteActionVisible;

                trigger OnAction()
                var
                    AllowanceLineTemp: Record "Allowance Assignment Line" temporary;
                    FilterPage: FilterPageBuilder;
                    AllowanceLine: Record "Assignment Memo Line";
                    FromDate, Todate : date;
                    AllowanceType, EmpCode : code[20];
                    AssignmentMemoMgt: Codeunit "Assignment Memo Mgt";
                begin
                    Rec.TestField("Approval Status", Rec."Approval Status"::Approved);
                    FilterPage.AddRecord('Select Employee Details', AllowanceLine);
                    FilterPage.AddField('Select Employee Details', AllowanceLine."From Date");
                    FilterPage.AddField('Select Employee Details', AllowanceLine."To Date");
                    FilterPage.AddField('Select Employee Details', AllowanceLine."Employee No.");
                    if FilterPage.RunModal() then begin
                        AllowanceLine.SetView(FilterPage.GetView('Select Employee Details'));
                        Evaluate(FromDate, AllowanceLine.GetFilter("From Date"));
                        Evaluate(ToDate, AllowanceLine.GetFilter("To Date"));
                        Evaluate(EmpCode, AllowanceLine.GetFilter("Employee No."));
                    end;
                    if (FromDate <> 0D) and (ToDate <> 0D) and (EmpCode <> '') then begin
                        AssignmentMemoMgt.InsertSubstituteAssignmentMemo(Rec."Document No.", Rec."Line No.", FromDate, ToDate, EmpCode);
                        Message('Substitute Assignment Memo inserted successfully.');
                    end;
                    CurrPage.Update();
                end;
            }

        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Emp Act Type" := Rec."Emp Act Type"::"Shift Assignment Memo";
    end;

    trigger OnOpenPage()
    begin
        SetLayout();
    end;

    trigger OnAfterGetRecord()
    begin
        SetLayout();
    end;

    procedure SetLayout()
    var
        AssignmentMemoHdr: Record "Assignment Memo Header";
    begin
        SubstituteActionVisible := Rec."Approval Status" = Rec."Approval Status"::Approved;
        if AssignmentMemoHdr.Get(Rec."Document No.") then
            SubstituteActionVisible := SubstituteActionVisible <> (AssignmentMemoHdr."Substitute Approval Status" = AssignmentMemoHdr."Substitute Approval Status"::Pending);

    end;

    var
        SubstituteActionVisible, RequestDoc : boolean;
}
