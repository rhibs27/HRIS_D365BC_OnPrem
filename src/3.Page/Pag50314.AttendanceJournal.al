page 50314 "Attendance Journal"
{
    ApplicationArea = All;
    Caption = 'Attendance Journal';
    PageType = Worksheet;
    SourceTable = "Employee Activity Journal";
    SourceTableView = where("Employee Act Type" = filter("Employee Activity Type"::"Attendance Missed"));
    UsageCategory = Tasks;
    AutoSplitKey = true;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the value of the Employee No. field.', Comment = '%';
                    Editable = IsOpen;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee No. field.', Comment = '%';
                    Editable = IsOpen;
                }
                field("Start Date"; Rec."Start Date")
                {
                    Caption = 'Attendance Missed Date';
                    ToolTip = 'Specifies the value of the Start Date field.';
                    ApplicationArea = All;
                    Editable = IsOpen;
                }
                field("Employee Work Shift"; Rec."Employee Work Shift")
                {
                    Caption = 'Employee Work Shift';
                    ToolTip = 'Specifies the value of the Employee Work Shift field.';
                    ApplicationArea = All;
                }
                field("CheckIn Time"; Rec."CheckIn Time")
                {
                    Caption = 'Check-In Time';
                    ToolTip = 'Specifies the value of the CheckIn Time field.';
                    ApplicationArea = All;
                    Editable = IsOpen;
                }
                field("CheckOut Time"; Rec."CheckOut Time")
                {
                    Caption = 'Check-Out Time';
                    ToolTip = 'Specifies the value of the CheckIn Time field.';
                    ApplicationArea = All;
                    Editable = IsOpen;
                }
                field("CheckOut OverNight"; rec."CheckOut OverNight")
                {
                    Caption = 'CheckOut OverNight';
                    ToolTip = 'Specifies the value of the CheckIn Time field.';
                    ApplicationArea = All;
                    Editable = IsOpen;
                }

                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.';
                    ApplicationArea = All;
                    Visible = ApprovalStatusView;
                }
                field(Status; Rec.Status)
                {
                    Visible = StatusView;
                }
                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field.';
                    ApplicationArea = All;
                    Editable = IsOpen or IsPending;
                }
            }
            part("Approval Subform"; "HRMS Approval Entry")
            {
                Editable = false;
                SubPageLink = "Document No." = field("Emp Act. No"), "Document Type" = field(Type);
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Send For Approval")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = SendApprovalRequest;
                Visible = IsOpen;
                trigger OnAction()
                begin
                    if Confirm('Do you want to Send for Approval request?', false) then begin
                        Clear(ListOfDocNo);
                        CurrPage.SetSelectionFilter(Rec);
                        if Rec.FindSet() then
                            repeat
                                if not ListOfDocNo.Contains(Rec."Emp Act. No") then
                                    ListOfDocNo.Add(rec."Emp Act. No");
                            until rec.Next() = 0;
                        Rec.Reset();
                        Rec.SetRange("Employee Act Type", Rec."Employee Act Type"::"Attendance Missed");
                        for i := 1 to ListOfDocNo.Count do begin
                            EmpActMgt.SendForApproval(ListOfDocNo.Get(i), Rec."Employee Act Type"::"Attendance Missed");
                        end;
                    end;
                end;
            }
            action("Approve")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Approve;
                Visible = IsPending;
                trigger OnAction()
                begin
                    if Confirm('Do you want to Approve request?', false) then begin
                        Clear(ListOfDocNo);
                        CurrPage.SetSelectionFilter(Rec);
                        if Rec.FindSet() then
                            repeat
                                if not ListOfDocNo.Contains(Rec."Emp Act. No") then
                                    ListOfDocNo.Add(rec."Emp Act. No");
                            until rec.Next() = 0;
                        Rec.Reset();
                        Rec.SetRange("Employee Act Type", Rec."Employee Act Type"::"Attendance Missed");
                        for i := 1 to ListOfDocNo.Count do begin
                            ApproverMgt.ApproveJournalDocument(ListOfDocNo.Get(i), true);
                        end;
                    end;
                end;
            }

            action(Post)
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Post;
                Visible = IsApproved;
                trigger OnAction()
                begin
                    if Confirm('Do you want to Post Document?', false) then begin
                        Clear(ListOfDocNo);
                        CurrPage.SetSelectionFilter(Rec);
                        if Rec.FindSet() then
                            repeat
                                if not ListOfDocNo.Contains(Rec."Emp Act. No") then
                                    ListOfDocNo.Add(rec."Emp Act. No");
                            until rec.Next() = 0;
                        for i := 1 to ListOfDocNo.Count do begin
                            EmpActMgt.PostAttendanceJournal(ListOfDocNo.Get(i));
                        end;
                        Message('Attendance Journal is posted');
                        CurrPage.Close();
                    end;
                end;
            }
            action(Reject)
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Reject;
                Visible = IsPending;
                trigger OnAction()
                begin
                    if not Confirm('Do you want to Reject Attendance Journal?', false) then
                        exit;
                    EmpActMgt.RejectJournal(Rec, true);
                end;
            }
            action("Import From Excel")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = ImportExcel;
                trigger OnAction()
                begin
                    if not Confirm('Do you want Import Attendance Journal From Excel?', false) then
                        exit;
                    ExcelImportMgt.ImportJournalFromExcelSheet(Rec."Employee Act Type"::"Attendance Missed");
                end;
            }

        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Approval Status" := Rec."Approval Status"::Open;
        Rec."Employee Act Type" := Rec."Employee Act Type"::"Attendance Missed";
        Rec.Type := Rec.Type::"Employee Journal";
        Rec.SetUpNewLine(xRec);
        CurrPage.Update(false);
    end;

    trigger OnAfterGetCurrRecord()
    begin
        SetLayout();
    end;

    trigger OnOpenPage()
    begin
        SetLayout();
        CurrPage.Update();
    end;

    procedure SetLayout()
    begin
        IsOpen := Rec."Approval Status" = Rec."Approval Status"::Open;
        if (Rec."Approval Status" = Rec."Approval Status"::pending) and not (rec.Status = '') then
            StatusView := true
        else
            ApprovalStatusView := true;
        IsPending := Rec."Approval Status" = Rec."Approval Status"::Pending;
        IsApproved := Rec."Approval Status" = Rec."Approval Status"::Approved;
        IsRejected := Rec."Approval Status" = rec."Approval Status"::Rejected;
    end;

    var
        StatusView, ApprovalStatusView : Boolean;
        IsOpen, IsPending, IsApproved, IsRejected : Boolean;
        EmpActMgt: Codeunit EmployeeActivityMgt;
        ApproverMgt: Codeunit "Approver Mgt";
        ExcelImportMgt: Codeunit "Excel Import";
        ListOfDocNo: List of [code[20]];
        i: Integer;
}
