page 50368 "Assignment Memo Subform"
{
    ApplicationArea = All;
    Caption = 'Assignment Memo Subform';
    PageType = ListPart;
    SourceTable = "Assignment Memo Line";
    SourceTableView = where("Emp Act Type" = const("Allowance Assignment Memo"));
    AutoSplitKey = true;
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Allowance Type"; Rec."Payroll Attribute Code")
                {
                    ToolTip = 'Specifies the value of the Allowance Type field.', Comment = '%';
                }
                field("Employee Code"; Rec."Employee No.")
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
                field(Panel; Rec.Panel)
                {
                    ToolTip = 'Specifies the value of the Panel field.', Comment = '%';
                }
                field("ATM Site"; Rec."ATM Site")
                {
                    ToolTip = 'Specifies the value of the ATM Site field.', Comment = '%';
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
                    SubstituteAssignmentreport: Report "Substitute Assignment Memo";
                begin
                    Rec.TestField("Approval Status", Rec."Approval Status"::Approved);
                    // FilterPage.AddRecord('Select Employee Details', AllowanceLine);
                    // FilterPage.AddField('Select Employee Details', AllowanceLine."From Date");
                    // FilterPage.AddField('Select Employee Details', AllowanceLine."To Date");
                    // FilterPage.AddField('Select Employee Details', AllowanceLine."Employee No.");
                    // if FilterPage.RunModal() then begin
                    //     AllowanceLine.SetView(FilterPage.GetView('Select Employee Details'));
                    //     Evaluate(FromDate, AllowanceLine.GetFilter("From Date"));
                    //     Evaluate(ToDate, AllowanceLine.GetFilter("To Date"));
                    //     Evaluate(EmpCode, AllowanceLine.GetFilter("Employee No."));
                    // end;
                    // if (FromDate <> 0D) and (ToDate <> 0D) and (EmpCode <> '') then begin
                    //     AssignmentMemoMgt.InsertSubstituteAssignmentMemo(Rec."Document No.", Rec."Line No.", FromDate, ToDate, EmpCode);
                    //     Message('Substitute Assignment Memo inserted successfully.');
                    // end;
                    Clear(SubstituteAssignmentreport);
                    SubstituteAssignmentreport.SetAssignmentmemoLine(Rec);
                    SubstituteAssignmentreport.Run();
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
        Rec.SetFilter("Date Filter", '%1..%2', Rec."From Date", Rec."To Date");
    end;

    var
        SubstituteActionVisible : boolean;
}
