page 33019910 "Pending Transfer Request Card"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Employee/HR Transfer";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(General)
            {
                group(From)
                {
                    Editable = false;
                    field("No."; Rec."No.")
                    {
                        ToolTip = 'Specifies the value of the No. field.';
                        ApplicationArea = All;
                    }
                    field("Employee No."; Rec."Employee No.")
                    {
                        ToolTip = 'Specifies the value of the Employee No. field.';
                        ApplicationArea = All;
                    }
                    field("Employee Name"; Rec."Employee Name")
                    {
                        ToolTip = 'Specifies the value of the Employee Name field.';
                        ApplicationArea = All;
                    }
                    field("Extension Counter Code"; Rec."Extension Counter Code")
                    {
                        ToolTip = 'Specifies the value of the Extension Counter Code field.';
                        ApplicationArea = All;
                    }
                    field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                    {
                        ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field.';
                        ApplicationArea = All;
                    }
                    field("Sub Province Code"; Rec."Sub Province Code")
                    {
                        ToolTip = 'Specifies the value of the Sub Province Code field.';
                        ApplicationArea = All;
                    }
                    field("Province Code"; Rec."Province Code")
                    {
                        ToolTip = 'Specifies the value of the Province Code field.';
                        ApplicationArea = All;
                    }
                    field("Unit Code"; Rec."Unit Code")
                    {
                        ToolTip = 'Specifies the value of the Unit Code field.';
                        ApplicationArea = All;
                    }
                    field(Department; Rec.Department)
                    {
                        ToolTip = 'Specifies the value of the Department field.';
                        ApplicationArea = All;
                    }
                    field("Compensatory Days"; Rec."Compensatory Days")
                    {
                        ToolTip = 'Specifies the value of the Compensatory Days field.';
                        ApplicationArea = All;
                    }
                    field("Payroll No."; Rec."Payroll No.")
                    {
                        ToolTip = 'Specifies the value of the Payroll No. field.';
                        ApplicationArea = All;
                    }
                    field(Ecosystem; Rec.Ecosystem)
                    {
                        ToolTip = 'Specifies the value of the Ecosystem field.';
                        ApplicationArea = All;
                    }
                    field("Office Code"; Rec."Office Code")
                    {
                        ToolTip = 'Specifies the value of the Office Code field.';
                        ApplicationArea = All;
                    }
                }
                group("To")
                {
                    field("Extension Counter (To)"; Rec."Extension Counter (To)")
                    {
                        ToolTip = 'Specifies the value of the Extension Counter (To) field.';
                        ApplicationArea = All;
                    }
                    field("Shortcut Dimension 1 Code (To)"; Rec."Shortcut Dimension 1 Code (To)")
                    {
                        ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code (To) field.';
                        ApplicationArea = All;
                    }
                    field("Sub Province Code (To)"; Rec."Sub Province Code (To)")
                    {
                        ToolTip = 'Specifies the value of the Sub Province Code (To) field.';
                        ApplicationArea = All;
                    }
                    field("Province Code (To)"; Rec."Province Code (To)")
                    {
                        ToolTip = 'Specifies the value of the Province Code (To) field.';
                        ApplicationArea = All;
                    }
                    field("Unit (To)"; Rec."Unit (To)")
                    {
                        ToolTip = 'Specifies the value of the Unit (To) field.';
                        ApplicationArea = All;
                    }
                    field("Department Code (To)"; Rec."Department Code (To)")
                    {
                        ToolTip = 'Specifies the value of the Department Code (To) field.';
                        ApplicationArea = All;
                    }
                    field("Reporting Line 1 (To)"; Rec."Reporting Line 1 (To)")
                    {
                        ToolTip = 'Specifies the value of the Reporting Line 1 (To) field.';
                        ApplicationArea = All;
                    }
                    field("Reporting Line 2 (To)"; Rec."Reporting Line 2 (To)")
                    {
                        ToolTip = 'Specifies the value of the Reporting Line 2 (To) field.';
                        ApplicationArea = All;
                    }
                    field("Eco-System (To)"; Rec."Eco-System (To)")
                    {
                        ToolTip = 'Specifies the value of the Eco-System (To) field.';
                        ApplicationArea = All;
                    }
                    field("Office (To)"; Rec."Office (To)")
                    {
                        ToolTip = 'Specifies the value of the Office (To) field.';
                        ApplicationArea = All;
                    }
                }
            }
            group(Control28)
            {
                ShowCaption = false;
                field("Recommender Code"; Rec."Recommender Code")
                {
                    ToolTip = 'Specifies the value of the Recommender Code field.';
                    ApplicationArea = All;
                }
                field("Approver Code"; Rec."Approver Code")
                {
                    ToolTip = 'Specifies the value of the Approver Code field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Approve)
            {
                ToolTip = 'Executes the Approve action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    TransferMgt.ApproveTransfer(Rec);
                end;
            }
            action(Reject)
            {
                ToolTip = 'Executes the Reject action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    TransferMgt.ApproveTransfer(Rec);
                end;
            }
        }
    }

    var
        HRMgt: Codeunit "HR Mgt.";
        TransferMgt:Codeunit "Transfer Mgt.";
}
