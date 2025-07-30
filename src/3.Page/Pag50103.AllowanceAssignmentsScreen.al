page 50103 "Allowance Assignments (Screen)"
{
    DelayedInsert = true;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SaveValues = true;
    SourceTable = "Allowance Assignment Line";
    UsageCategory = Lists;
    SourceTableView = where("Approval Status" = const("Pending"), "Substitute Type" = const("Added as Substitute"));
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Control2)
            {
                Editable = false;
                ShowCaption = false;
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                    ApplicationArea = All;
                }
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the value of the Line No. field.';
                    ApplicationArea = All;
                }
                field("Code"; Rec.Code)
                {
                    ToolTip = 'Specifies the value of the Code field.';
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.';
                    ApplicationArea = All;
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
                field(Week; Rec.Week)
                {
                    ToolTip = 'Specifies the value of the Week field.';
                    ApplicationArea = All;
                }
                field("From Date"; Rec."From Date")
                {
                    ToolTip = 'Specifies the value of the From Date field.';
                    ApplicationArea = All;
                }
                field("To Date"; Rec."To Date")
                {
                    ToolTip = 'Specifies the value of the To Date field.';
                    ApplicationArea = All;
                }
                field("Allowance Type"; Rec."Allowance Type")
                {
                    ToolTip = 'Specifies the value of the Allowance Type field.';
                    ApplicationArea = All;
                }
                field("Allowance Amount"; Rec."Allowance Amount")
                {
                    ToolTip = 'Specifies the value of the Allowance Amount field.';
                    ApplicationArea = All;
                }
                field("Is Substitute"; Rec."Substitute Type")
                {
                    ToolTip = 'Specifies the value of the Is Substitute field.';
                    ApplicationArea = All;
                }
                field("Substitute of Line No."; Rec."Substitute of Line No.")
                {
                    ToolTip = 'Specifies the value of the Substitue of Line No. field.';
                    ApplicationArea = All;
                }
                field("Created Date"; Rec."Created Date")
                {
                    ToolTip = 'Specifies the value of the Created Date field.';
                    ApplicationArea = All;
                }
                field("Created By"; Rec."Created By")
                {
                    ToolTip = 'Specifies the value of the Created By field.';
                    ApplicationArea = All;
                }
                field("Last Modified Date"; Rec."Last Modified Date")
                {
                    ToolTip = 'Specifies the value of the Last Modified Date field.';
                    ApplicationArea = All;
                }
                field("Last Modified By"; Rec."Last Modified By")
                {
                    ToolTip = 'Specifies the value of the Last Modified By field.';
                    ApplicationArea = All;
                }
                field("Approved Date"; Rec."Approved Date")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Approved Date field.';
                    ApplicationArea = All;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.';
                    ApplicationArea = All;
                }
                field("No. of Days"; Rec."No. of Days")
                {
                    ToolTip = 'Specifies the value of the No. of Days field.';
                    ApplicationArea = All;
                }
                field("Rejection Remarks"; Rec."Rejection Remarks")
                {
                    ToolTip = 'Specifies the value of the Rejection Remarks field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Reject Substitute")
            {
                Image = Approve;
                ToolTip = 'Executes the Reject Substitute action.';
                ApplicationArea = All;
                Visible = rec."Approval Status" = Rec."Approval Status"::"Pending";
                trigger OnAction()
                var
                    AllowanceLine1: Record "Allowance Assignment Line";
                begin
                    if Confirm('Do you want to Reject this document?', false) then begin
                        Rec.TestField("Substitute Type", Rec."Substitute Type"::"Added as Substitute");
                        Rec.TestField("Approval Status", Rec."Approval Status"::"Pending");
                        Rec.Validate("Approval Status", Rec."Approval Status"::Rejected);
                        Rec.Modify();
                        if AllowanceLine1.Get(Rec."No.", Rec."Substitute of Line No.") then begin
                            AllowanceLine1."Substitute Type" := Rec."Substitute Type"::" ";
                            AllowanceLine1."Approved Date" := Today;
                            AllowanceLine1.Modify();
                        end;
                    end;
                    Message('Substitute Allowance is Rejected');
                end;
            }
            action("Approve Substitute")
            {
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Approve action.';
                ApplicationArea = All;
                trigger OnAction()
                begin
                    if Confirm('Do you want to approve this document?', false) then begin
                        Rec.TestField("Substitute Type", Rec."Substitute Type"::"Added as Substitute");
                        Rec.TestField("Approval Status", Rec."Approval Status"::"Pending");
                        Rec.Validate("Approval Status", Rec."Approval Status"::Approved);
                        // AllowanceMgt.InsertHighestPriorityAllowanceInAttendance(Rec."Employee Code", Rec."From Date"); handled in allowance claim
                        // AllowanceMgt.RemoveAllowanceAssignmentDayInAttendance(Rec."No.", rec."Substitute of Line No.");
                        Rec.Modify();
                    end;
                    Message('Substitute Allowance is Approved');
                end;
            }
        }
    }


    var
        LoanMgt: Codeunit "Loan Mgt.";
        FromDate: Date;
        ToDate: Date;
        HRMgt: Codeunit "HR Mgt.";
        AllowanceMgt: Codeunit "Allowance Assignment Mgt";
}
