page 50070 "Document Approver Resignation"
{
    Caption = 'Document Approver Resignation';
    PageType = ListPart;
    SourceTable = "Document Approver";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the value of the Line No. field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Employee No. field.';
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Approved Date"; Rec."Approved Date")
                {
                    ToolTip = 'Specifies the value of the Approved Date field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Remarks; Rec.Remarks)
                {
                    Caption = 'Resign Clearance Remarks';
                    ToolTip = 'Specifies the value of the Resign Clearance Remarks field.';
                    ApplicationArea = All;
                }
                field("Rejection Remarks"; Rec."Rejection Remarks")
                {
                    Caption = 'Resign Clearance Rejection Remarks';
                    ToolTip = 'Specifies the value of the Resign Clearance Rejection Remarks field.';
                    ApplicationArea = All;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Approval Status field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Return Rejected")
            {
                Image = Return;
                Visible = Rec."Approval Status" = Rec."Approval Status"::Rejected;
                ToolTip = 'Executes the Return Rejected action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if Confirm('Do you want to return rejected record?', false) then begin
                        if not HrMgt.IsSaaS() then //garima
                            Employee.Get(HRMgt.GetEmployeeNo);
                        // if not Employee.Screener then
                        //     Error('You are not eligible.');
                        Rec."Approval Status" := Rec."Approval Status"::Open;
                        Rec.Modify;
                    end;
                end;
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.SetRange("Document Type", Rec."Document Type"::Resignation);
    end;

    trigger OnOpenPage()
    begin
        Rec.SetRange("Document Type", Rec."Document Type"::Resignation);
    end;

    var
        Employee: Record Employee;
        HRMgt: Codeunit "HR Mgt.";
}
