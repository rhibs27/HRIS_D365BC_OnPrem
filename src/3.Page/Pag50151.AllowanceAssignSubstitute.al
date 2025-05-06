page 50151 "Allowance Assign. Substitute"
{
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Allowance Assignment Line";
    SourceTableTemporary = true;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("From Date"; Rec."From Date")
                {
                    ToolTip = 'Specifies the value of the From Date field.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("To Date"; Rec."To Date")
                {
                    ToolTip = 'Specifies the value of the To Date field.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Employee Code"; Rec."Employee Code")
                {
                    ToolTip = 'Specifies the value of the Employee Code field.';
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Substitute Employee")
            {
                Image = Refresh;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Substitute action.';
                ApplicationArea = All;
                trigger OnAction()
                var
                    AllowanceLine, AllowanceLine1 : Record "Allowance Assignment Line";
                begin
                    AllowanceLine.Init();
                    AllowanceLine.TransferFields(Rec);
                    AllowanceLine.Validate("Allowance Type", Rec."Allowance Type");
                    AllowanceLine.Validate("Employee Code", Rec."Employee Code");
                    AllowanceLine.Validate("From Date", Rec."From Date");
                    AllowanceLine."Approval Status" := Rec."Approval Status"::Approved;
                    AllowanceLine.Insert(true);
                    AllowanceAssignmentMgt.InsertAllowanceAssignmentDayInAttendance(AllowanceLine);
                    AllowanceAssignmentMgt.RemoveAllowanceAssignmentDayInAttendance(AllowanceLine."No.", rec."Substitute of Line No.");
                    if AllowanceLine1.Get(Rec."No.", Rec."Substitute of Line No.") then
                        AllowanceLine1."Substitute Type" := AllowanceLine."Substitute Type"::Substituted;
                    AllowanceLine1.Modify();
                    CurrPage.Close();
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        // Rec.CalcFields(Code);
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        // AllowanceLine.Copy(Rec);
        // if (AllowanceLine."Employee Code" <> '') and (AllowanceLine."From Date" <> 0D)
        //   and (AllowanceLine."To Date" <> 0D) then begin
        //     AllowanceLine."Line No." := 0;
        //     AllowanceLine.Insert(true);
        //     AllowanceLine.UpdateSubstitue();
        // end;
        // if rec."Employee Code" = '' then
        //     Error('Please Select Substitute Employee');
    end;

    var
        AllowanceLine: Record "Allowance Assignment Line";
        AllowanceAssignmentMgt: Codeunit "Allowance Assignment Mgt";
}
