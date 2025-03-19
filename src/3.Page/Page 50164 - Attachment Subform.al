page 50164 "Attachment Subform"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = "Incoming Document";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Attachment Code"; Rec."Attachment Code")
                {
                    ToolTip = 'Specifies the value of the Attachment Code field.';
                    ApplicationArea = All;
                }
                field(number; Rec."No.")
                {
                    Editable = not isGUIAllowed;
                    // Enabled = true;
                    Visible = false;
                    ToolTip = 'Specifies the value of the No. field.';
                    ApplicationArea = All;
                    Caption = 'No.';
                }
                field(fileName; Rec."File Name")
                {
                    Editable = not isGUIAllowed;
                    ToolTip = 'Specifies the value of the File Name field.';
                    ApplicationArea = All;
                    Caption = 'File Name';
                    trigger OnAssistEdit()
                    begin
                        if Confirm('Do You Want to Download Attachment?', false) then
                            LoanMgt.DownloadAttachment(Rec);
                    end;

                    trigger OnDrillDown()
                    begin
                        // if Confirm('Do You Want to Download Attachment?', false) then
                        //     LoanMgt.DownloadAttachment(Rec);
                        page.Run(page::"Preview Attachment", Rec);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        page.Run(page::"Preview Attachment", Rec);
                    end;

                    // trigger OnValidate() nilesh
                    // begin
                    //     Error('Cannot modify.'); nilesh
                    // end; nilesh
                }
                field(type; Rec.Type)
                {
                    Editable = not isGUIAllowed;
                    Visible = not isGUIAllowed;
                    ToolTip = 'Specifies the value of the Type field.';
                    ApplicationArea = All;
                }
                field(empCode; Rec."Employee Code")
                {
                    Visible = not isGUIAllowed;
                    ToolTip = 'Specifies the value of the Employee Code field.';
                    ApplicationArea = All;
                }
                field(leaveCode; Rec."Leave Type Code")
                {
                    Visible = not isGUIAllowed;
                    ToolTip = 'Specifies the value of the Leave Type Code field.';
                    ApplicationArea = All;
                }
                field(empActivityType; Rec."Employee Activity Type")
                {
                    Visible = not isGUIAllowed;
                    ToolTip = 'Specifies the value of the Employee Activity Type field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Upload)
            {
                Image = MoveUp;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Upload action.';
                ApplicationArea = All;
                Visible = true;

                trigger OnAction()
                var
                    Employee: Record Employee;
                    EmployeeTransfer: Record "Employee/HR Transfer";
                //EmpAct: Record "Employee Activity";
                begin
                    if EmpLoan.Get(Rec."No.") then begin //loan controls 
                        IF NOT (EmpLoan."Approval Status" IN [EmpLoan."Approval Status"::Open, EmpLoan."Approval Status"::" "]) THEN
                            ERROR('Approval status must be Open.');
                        LoanMgt.UploadAttachment(Rec);
                    end else if EmployeeTransfer.Get(Rec."No.") then begin
                        EmployeeTransfer.TestField("Transfer Claim", false);
                        if (EmployeeTransfer."Is Transfer Details Added") and (EmployeeTransfer."Approval Status" = EmployeeTransfer."Approval Status"::Approved) then
                            if HrMgt.GetEmployeeNo() = rec."Employee Code" then
                                LoanMgt.UploadAttachment(Rec)
                            else
                                Error('You arenot Allowed to Upload attachment');
                    end else
                        LoanMgt.UploadAttachment(Rec);

                    // if Employee.Get(Rec."Order No.") then //employee controls
                    //     LoanMgt.UploadAttachment(Rec)

                    // else if EmpAct.Get(Rec."No.") then begin//resignation controls
                    //                                         //EmpAct.TESTFIELD();
                    //     LoanMgt.UploadAttachment(Rec)
                    // end else if EmpAct.Get(Rec."Order No.") then begin
                    //     LoanMgt.UploadAttachment(Rec); end else
                    if (Rec."Leave Type Code" <> '') then begin
                        if Leave.Get(Rec."No.") then begin
                            IF NOT (Leave."Approval Status" IN [Leave."Approval Status"::Open, Leave."Approval Status"::" "]) THEN
                                ERROR('Approval status must be Open.');
                            LoanMgt.UploadAttachment(Rec);
                        end else
                            LoanMgt.UploadAttachment(Rec);
                    end;
                end;
            }
            action(Download)
            {
                Image = MoveDown;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Download action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if Confirm('Do You Want to Download Attachment?', false) then
                        LoanMgt.DownloadAttachment(Rec);
                end;
            }
            action(Preview)
            {
                Image = View;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Download action.';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    page.Run(page::"Preview Attachment", Rec);
                end;
            }
            action(Remove)
            {
                Image = Delete;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Remove action.';
                ApplicationArea = All;

                trigger OnAction()
                var
                    Employee: Record Employee;
                    EmpAct: Record "Employee Activity";

                begin
                    Leave.Reset();
                    if (Rec."Leave Type Code" <> '') then begin
                        if Leave.Get(Rec."No.") then begin
                            IF NOT (Leave."Approval Status" IN [Leave."Approval Status"::Pending, Leave."Approval Status"::Open]) THEN
                                ERROR('Approval status must be Open.');
                            LoanMgt.DeleteAttachment(Rec)
                        end;
                    end;
                    if EmpLoan.Get(Rec."No.") then begin
                        LoanMgt.DeleteAttachment(Rec);
                    end
                    else if Employee.Get(Rec."Order No.") then
                        LoanMgt.DeleteAttachment(Rec)
                    else if Candidate.Get(Rec."No.") then
                        LoanMgt.DeleteAttachment(Rec)
                    else if EmpAct.Get(Rec."No.") then begin
                        //EmpAct.TESTFIELD();
                        if EmpAct.Type in [EmpAct.Type::"Employee Transfer", EmpAct.Type::"HR Transfer"] then begin
                            if EmpAct."Approval Status" = EmpAct."Approval Status"::Acknowledged then
                                Error('Acknowledge transfer attachment cannot be deleted.');
                        end else if EmpAct."Approval Status" = EmpAct."Approval Status"::Approved then
                                Error('Cannot delete attachment of approved doucment.');
                        LoanMgt.DeleteAttachment(Rec);
                    end;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        if GuiAllowed then
            isGUIAllowed := true
        else
            isGUIAllowed := false;
    end;

    var
        LoanMgt: Codeunit "Loan Mgt.";
        EmpLoan: Record "Employee Loan/Advance";
        Leave: Record Leave;
        Candidate: Record Candidate;
        [InDataSet]
        isGUIAllowed: Boolean;
        HrMgt: Codeunit "HR Mgt.";
}
