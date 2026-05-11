page 50097 "Training Card"
{
    PageType = Card;
    SourceTable = "Training Header";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                    ApplicationArea = All;
                }
                field("Training Calendar No"; Rec."Training Calendar No")
                {
                    Editable = IsOpen;
                    ToolTip = 'Specifies the value of the Training Calendar No field.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = All;
                }
                field(Province; Rec.Province)
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Province field.';
                    ApplicationArea = All;
                }
                field("Province Name"; Rec."Province Name")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Province Name field.';
                    ApplicationArea = All;
                }
                field(Venue; Rec.Venue)
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Venue field.';
                    ApplicationArea = All;
                }
                field("Training Type"; Rec."Training Type")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Training Type field.';
                    ApplicationArea = All;
                }
                field("Training Category"; Rec."Training Category")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Training Category field.';
                    ApplicationArea = All;
                }
                field("Training Module"; Rec."Training Module")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Training Module field.';
                    ApplicationArea = All;
                }
                field("Training Mode"; Rec."Training Mode")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Training Mode field.';
                    ApplicationArea = All;
                }
                field("Start Date"; Rec."Start Date")
                {
                    Editable = IsOpen;
                    ToolTip = 'Specifies the value of the Start Date field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        if (Rec."Start Date" <> 0D) and (Rec."End Date" <> 0D) then
                            SetColumn;
                    end;
                }
                field("End Date"; Rec."End Date")
                {
                    Editable = IsOpen;
                    ToolTip = 'Specifies the value of the End Date field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        SetColumn;
                    end;
                }
                field("No. of Days"; Rec."No. of Days")
                {
                    ToolTip = 'Specifies the value of the No. of Days field.';
                    ApplicationArea = All;
                }
                field("Start Time"; Rec."Start Time")
                {
                    Editable = IsOpen;
                    ToolTip = 'Specifies the value of the Start Time field.';
                    ApplicationArea = All;
                }
                field("End Time"; Rec."End Time")
                {
                    Editable = IsOpen;
                    ToolTip = 'Specifies the value of the End Time field.';
                    ApplicationArea = All;
                }
                field("Training Hours"; Rec."Training Hours")
                {
                    ToolTip = 'Specifies the value of the Training Hours field.';
                    ApplicationArea = All;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.';
                    ApplicationArea = All;
                }
                field("Branch Code"; Rec."Branch Code")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Branch Code field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        if Rec."Branch Code" <> '' then
                            FieldEditable := false
                        else
                            FieldEditable := true;
                    end;
                }
                field("Department Code"; Rec."Department Code")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Department field.';
                    ApplicationArea = All;
                }
                field("Requested Date"; Rec."Requested Date")
                {
                    Editable = IsOpen;
                    ToolTip = 'Specifies the value of the Requested Date field.';
                    ApplicationArea = All;
                }
                field("Fiscal Year"; Rec."Fiscal Year")
                {
                    ToolTip = 'Specifies the value of the Fiscal Year field.';
                    ApplicationArea = All;
                }
                field("Expected No. of Participant"; Rec."Expected No. of Participant")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Expected No. of Participant field.';
                    ApplicationArea = All;
                }
                field("Total No. of Participant"; Rec."Total No. of Participant")
                {
                    ToolTip = 'Specifies the value of the Total No. of Participant field.';
                    ApplicationArea = All;
                }
                field("Resource Person"; Rec."Resource Person")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Resource Person field.';
                    ApplicationArea = All;
                }
                field(Month; Rec.Month)
                {
                    Editable = IsOpen;
                    ToolTip = 'Specifies the value of the Month field.';
                    ApplicationArea = All;
                }
                field("Sponsorship Type"; Rec."Sponsorship Type")
                {
                    Editable = IsOpen;
                    ToolTip = 'Specifies the value of the Sponsorship Type field.';
                    ApplicationArea = All;
                }
            }
            group("Training Expense")
            {
                Caption = 'Training Expense';
                group(Estimated)
                {
                    Caption = 'Estimated';
                    field("Vendor Code"; Rec."Institute Code")
                    {
                        Caption = 'Vendor Code';
                        ToolTip = 'Specifies the value of the Vendor Code field.';
                        ApplicationArea = All;
                    }
                    field("Vendor Name"; Rec."Institute Name")
                    {
                        Editable = false;
                        ToolTip = 'Specifies the value of the Vendor Name field.';
                        ApplicationArea = All;
                    }
                    field("Estimated Training Cost"; Rec."Estimated Training Cost")
                    {
                        Editable = false;
                        ToolTip = 'Specifies the value of the Estimated Training Cost field.';
                        ApplicationArea = All;
                    }
                    field("Estimated Fooding Cost"; Rec."Estimated Fooding Cost")
                    {
                        Editable = false;
                        ToolTip = 'Specifies the value of the Estimated Fooding Cost field.';
                        ApplicationArea = All;
                    }
                    field("Estimated Trainer Cost"; Rec."Estimated Trainer Cost")
                    {
                        Editable = false;
                        ToolTip = 'Specifies the value of the Estimated Trainer Cost field.';
                        ApplicationArea = All;
                    }
                    field("Estimated Other Cost"; Rec."Estimated Other Cost")
                    {
                        Editable = IsOpen;
                        ToolTip = 'Specifies the value of the Estimated Other Cost field.';
                        ApplicationArea = All;
                    }
                    field("Estimated Total Budget"; Rec."Estimated Total Budget")
                    {
                        ToolTip = 'Specifies the value of the Estimated Total Budget field.';
                        ApplicationArea = All;
                        Editable = false;
                    }
                }
                group("Actual Expense")
                {
                    Caption = 'Actual Expense';
                    Visible = IsApproved;
                    field("Actual Other Cost"; Rec."Actual Other Cost")
                    {
                        Editable = IsApproved;
                        ToolTip = 'Specifies the value of the Actual Other Cost field.';
                        ApplicationArea = All;
                    }
                    field("Actual Fooding Cost"; Rec."Actual Fooding Cost")
                    {
                        ToolTip = 'Specifies the value of the Actual Fooding Cost field.';
                        ApplicationArea = All;
                    }
                    field("Actual Training Cost"; Rec."Actual Training Cost")
                    {
                        Editable = IsApproved;
                        ToolTip = 'Specifies the value of the Actual Training Cost field.';
                        ApplicationArea = All;
                    }
                    field("Actual Trainer Cost"; Rec."Actual Trainer Cost")
                    {
                        ToolTip = 'Specifies the value of the Actual Trainer Cost field.';
                        ApplicationArea = All;
                    }
                    field("Actual Total Budget"; Rec."Actual Total Cost")
                    {
                        ToolTip = 'Specifies the value of the Actual Total Budget field.';
                        ApplicationArea = All;
                    }
                }
            }
            group(Budget)
            {
                Visible = false;
                field("YTD Amount"; Rec."YTD Amount")
                {
                    ToolTip = 'Specifies the value of the YTD Amount field.';
                    ApplicationArea = All;
                }
                field("MTD Amount"; Rec."MTD Amount")
                {
                    ToolTip = 'Specifies the value of the MTD Amount field.';
                    ApplicationArea = All;
                }
                field("YTD Expense"; Rec."YTD Expense")
                {
                    ToolTip = 'Specifies the value of the YTD Expense field.';
                    ApplicationArea = All;
                }
                field("MTD Expense"; Rec."MTD Expense")
                {
                    ToolTip = 'Specifies the value of the MTD Expense field.';
                    ApplicationArea = All;
                }
            }
            group("Training Review")
            {
                Visible = false;
                field("Total Trainer Marks"; Rec."Total Trainer Marks")
                {
                    ToolTip = 'Specifies the value of the Total Trainer Marks field.';
                    ApplicationArea = All;
                }
                field("Total Trainer Percent"; Rec."Training Percent")
                {
                    DecimalPlaces = 0 : 2;
                    ToolTip = 'Specifies the value of the Training Percent field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        RatingSetup.Reset;
                        RatingSetup.SetRange(Type, RatingSetup.Type::Training);
                        RatingSetup.SetFilter(From, '<=%1', Rec."Trainer Percent");
                        RatingSetup.SetFilter("To", '>=%1', Rec."Trainer Percent");
                        if RatingSetup.FindFirst then
                            Rec.Validate("Trainer Remarks", Format(RatingSetup.Rating));
                    end;
                }
                field("Trainer Remarks"; Rec."Trainer Remarks")
                {
                    ToolTip = 'Specifies the value of the Trainer Remarks field.';
                    ApplicationArea = All;
                }
                field("Total Training Marks"; Rec."Total Training Marks")
                {
                    ToolTip = 'Specifies the value of the Total Training Marks field.';
                    ApplicationArea = All;
                }
                field("Total Training Percent"; Rec."Training Percent")
                {
                    DecimalPlaces = 0 : 2;
                    ToolTip = 'Specifies the value of the Training Percent field.';
                    ApplicationArea = All;
                }
                field("Training Remarks"; Rec."Training Remarks")
                {
                    ToolTip = 'Specifies the value of the Training Remarks field.';
                    ApplicationArea = All;
                }
            }
            group("Training Payment Approval")
            {
                Editable = IsApproved;
                Visible = false;
                field("ROCE Code"; Rec."ROCE Code")
                {
                    Editable = IsApproved;
                    ToolTip = 'Specifies the value of the ROCE Code field.';
                    ApplicationArea = All;
                }
                field("Prepared By"; Rec."Prepared By")
                {
                    ToolTip = 'Specifies the value of the Prepared By field.';
                    ApplicationArea = All;
                }
                field("Prepared By Name"; Rec."Prepared By Name")
                {
                    ToolTip = 'Specifies the value of the Prepared By Name field.';
                    ApplicationArea = All;
                }
                field("Reviewed By"; Rec."Reviewed By")
                {
                    ToolTip = 'Specifies the value of the Reviewed By field.';
                    ApplicationArea = All;
                }
                field("Reviewed By Name"; Rec."Reviewed By Name")
                {
                    ToolTip = 'Specifies the value of the Reviewed By Name field.';
                    ApplicationArea = All;
                }
                field("Supported By"; Rec."Supported By")
                {
                    ToolTip = 'Specifies the value of the Supported By field.';
                    ApplicationArea = All;
                }
                field("Supported By Name"; Rec."Supported By Name")
                {
                    ToolTip = 'Specifies the value of the Supported By Name field.';
                    ApplicationArea = All;
                }
            }
            part(Control29; "Trainer Subform")
            {
                SubPageLink = "Training No." = field("No."),
                              Type = const(Trainer);
                ApplicationArea = All;
            }
            part("Trainee Subform"; "Trainee Subform")
            {
                SubPageLink = "Training No." = field("No."),
                              Type = const(Trainee);
                UpdatePropagation = Both;
                ApplicationArea = All;
            }

            part("Training Payment"; "Training Payee")
            {
                Caption = 'Training Payment';
                SubPageLink = "Training No." = field("No."),
                              Type = const(Vendor);
                Visible = IsApproved;
                ApplicationArea = All;
            }
            // part("Approval Subform"; "HRMS Approval Entry")
            // {
            //     SubPageLink = "Document No." = field("No."), "Document Type" = field(Type);
            //     ApplicationArea = all;
            //     Editable = false;
            // }
        }
        area(FactBoxes)
        {
            systempart(Control20; Notes)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group("Request Approval")
            {
                Caption = 'Request Approval';
                action("Send Approval Request")
                {
                    Caption = 'Send A&pproval Request';
                    Enabled = false;
                    Visible = false;
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Send A&pproval Request action.';
                    ApplicationArea = All;
                    trigger OnAction()
                    begin
                        if Confirm('Do you want to Send training for approve?', false) then begin
                            Rec.TestField(Description);
                            Rec.TestField("Start Date");
                            Rec.TestField("End Date");
                            TrainingLineCheck(Rec."No.");
                            TrainingLine.Reset;
                            TrainingLine.SetRange("Training No.", Rec."No.");
                            TrainingLine.SetRange(Type, TrainingLine.Type::Trainer);
                            TrainingLine.SetFilter("Employee Code", '<>%1', '');
                            if TrainingLine.FindFirst then
                                repeat
                                    TrainingLine.TestField("Start Time");
                                    TrainingLine.TestField("End Time");
                                until TrainingLine.Next = 0;
                            Rec."Approval Status" := Rec."Approval Status"::Pending;
                            Rec.Modify();
                            ApproverMgt.UpdateFirstApproverStatus(Rec."No.");
                        end;
                    end;
                }
                action("Release")
                {
                    Image = ReleaseDoc;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Export Attendance action.';
                    ApplicationArea = All;
                    Visible = IsOpen;
                    trigger OnAction()
                    var
                        EmpFeedback: Record "Employee Feedback";
                        TraineeLine: Record "Training Line";
                    begin
                        Rec.TestField("Approval Status", Rec."Approval Status"::Open);
                        Rec."Approval Status" := Rec."Approval Status"::Released;
                        Rec.Modify();
                        CurrPage.Update();
                    end;
                }
                action("Re Open")
                {
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Export Attendance action.';
                    ApplicationArea = All;
                    Enabled = not Rec.Posted;
                    Visible = (Rec."Approval Status" = Rec."Approval Status"::Released);
                    trigger OnAction()
                    var
                        TrainingLine: Record "Training Line";
                    begin
                        Rec.TestField("Approval Status", Rec."Approval Status"::Released);
                        Rec."Approval Status" := Rec."Approval Status"::Open;
                        Rec.Modify();

                        TrainingLine.Reset();
                        TrainingLine.SetRange("Training No.", Rec."No.");
                        TrainingLine.ModifyAll(Posted, false);
                        CurrPage.Update();
                    end;
                }
                action(Post)
                {
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Post action.';
                    ApplicationArea = All;
                    Visible = not Rec.Posted;
                    trigger OnAction()
                    begin
                        if Confirm('Do you want to Post Training Card?', false) then begin
                            Rec.SetPosted;
                            CurrPage.Close();
                        end;
                    end;
                }
                // action("Approve Attendance")
                // {
                //     Caption = 'Approve Attendance';
                //     Image = Approve;
                //     Promoted = true;
                //     PromotedCategory = Process;
                //     PromotedIsBig = true;
                //     ToolTip = 'Approve the attendance records for this training and update employee training records.';
                //     ApplicationArea = All;
                //     trigger OnAction()
                //     var
                //         TrainingAttendance: Record "Training Attendance";
                //         ApproverEmpNo: Code[20];
                //         ApprovedCount: Integer;
                //         ConfirmApprove: Label 'Do you want to approve all attendance records for training %1? This will update employee training records.';
                //     begin
                //         if not Confirm(StrSubstNo(ConfirmApprove, Rec."No."), false) then
                //             exit;

                //         ApproverEmpNo := HRMgt.GetEmployeeNo();
                //         TrainingAttendance.Reset();
                //         TrainingAttendance.SetRange("Training No", Rec."No.");
                //         TrainingAttendance.SetRange(Approved, false);
                //         if TrainingAttendance.FindSet(true) then
                //             repeat
                //                 TrainingAttendance.Approved := true;
                //                 TrainingAttendance."Approved By" := ApproverEmpNo;
                //                 TrainingAttendance."Approved Date" := Today;
                //                 TrainingAttendance.Modify(true);
                //                 ApprovedCount += 1;
                //             until TrainingAttendance.Next() = 0;

                //         if ApprovedCount > 0 then
                //             Message('%1 attendance record(s) approved and training records updated.', ApprovedCount)
                //         else
                //             Message('All attendance records are already approved.');

                //         CurrPage.Update(false);
                //     end;
                // }
            }
            group("Calculation")
            {
                Caption = 'Calculation';
                action("Sending Mail")
                {
                    Image = SendConfirmation;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Sending Mail action.';
                    ApplicationArea = All;
                    Visible = false;
                    trigger OnAction()
                    begin
                        Rec.TestField("Prepared By");
                        EmailMgt.SendMailFromTemplate(Database::"Training Header", EmailTemplate."Document Type"::Training, 0, Rec."Prepared By", Rec."No.", false);
                        Message('Mail has been send.');
                    end;
                }
                // action("Calculate Training Marks")
                // {
                //     Image = CalculateBalanceAccount;
                //     Promoted = true;
                //     PromotedCategory = Process;
                //     PromotedIsBig = true;
                //     PromotedOnly = true;
                //     Visible = IsApproved;
                //     ToolTip = 'Executes the Calculate Training Marks action.';
                //     ApplicationArea = All;

                //     trigger OnAction()
                //     begin
                //         TrainingMgt.CalTrainingMarks(Rec."No.");
                //     end;
                // }
                action("Payment Memo")
                {
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = false;
                    ToolTip = 'Executes the Payment Memo action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        Rec.TestField("Approval Status", Rec."Approval Status"::Released);
                        TrainHead.Reset;
                        TrainHead.SetRange("No.", Rec."No.");
                        if TrainHead.FindFirst then
                            Report.Run(Report::"Payment Memo", true, true, TrainHead);
                    end;
                }
                // action("Calculate YTD And MTD")
                // {
                //     Image = Calculate;
                //     Promoted = true;
                //     PromotedCategory = Process;
                //     PromotedIsBig = true;
                //     PromotedOnly = true;
                //     ToolTip = 'Executes the Calculate YTD And MTD action.';
                //     ApplicationArea = All;

                //     trigger OnAction()
                //     begin
                //         Rec.CalculateYTDExpense;
                //         Rec.CalcualteMTDExpense;
                //     end;
                // }
                action("Approve Request")
                {
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Visible = IsPending;
                    ToolTip = 'Executes the Approve Request action.';
                    ApplicationArea = All;
                    trigger OnAction()
                    begin
                        if Confirm('Do you want to approve the request?', false) then begin
                            ApproverMgt.ApproveRejectDocument(RecRef, true);
                            Message('Document is Approved by %1', HRMgt.GetEmpName());
                        end;
                    end;
                }
                action("View Training Needs")
                {
                    Caption = 'View Training Needs';
                    Image = "List";
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'View training need requests linked to this training.';
                    ApplicationArea = All;
                    Visible = false;
                    trigger OnAction()
                    var
                        TrainingNeedRequest: Record "Training Need Request";
                    begin
                        TrainingNeedRequest.Reset();
                        TrainingNeedRequest.SetRange("Linked Training No.", Rec."No.");
                        Page.Run(Page::"Training Need List", TrainingNeedRequest);
                    end;
                }
                action("View Employee Feedback")
                {
                    Image = "List";
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'View training need requests linked to this training.';
                    ApplicationArea = All;
                    trigger OnAction()
                    var
                        EmployeeFeedback: Record "Employee Feedback";
                    begin
                        EmployeeFeedback.Reset();
                        EmployeeFeedback.SetRange("Training No.", Rec."No.");
                        Page.Run(Page::"Employee Training Feedback", EmployeeFeedback);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        RecRef.GetTable(Rec);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Approval Status" := Rec."Approval Status"::Open;
    end;

    trigger OnOpenPage()
    begin
        Rec.CalcFields("Total No. of Participant");
        if (Rec."Start Date" <> 0D) and (Rec."End Date" <> 0D) then
            SetColumn;

        if TrainHead.Get(Rec."No.") then begin
            IsApproved := TrainHead."Approval Status" = TrainHead."Approval Status"::Released;
            IsOpen := TrainHead."Approval Status" = TrainHead."Approval Status"::Open;
        end else
            IsOpen := true;
        IsPending := Rec."Approval Status" = Rec."Approval Status"::Pending;
        if Rec."Branch Code" <> '' then
            FieldEditable := false
        else
            FieldEditable := true;
        if Rec.Posted then
            CurrPage.Editable(false);
        RecRef.GetTable(Rec);
    end;

    var

        ApproverMgt: Codeunit "Approver Mgt";
        TrainingMgt: Codeunit "Training Mgt";
        ExcelImport: Codeunit "Excel Import";
        RecRef: RecordRef;
        NoOfColumn: Integer;
        HRMgt: Codeunit "HR Mgt.";
        EmailMgt: Codeunit "Email Mgt";
        TrainHead: Record "Training Header";
        IsOpen, IsPending, IsApproved : Boolean;
        EmailTemplate: Record "Email Template";
        RatingSetup: Record "Rating Setup";
        TrainingLine: Record "Training Line";
        FieldEditable: Boolean;

    local procedure SetColumn()
    var
        StartDate: Date;
        EndDate: Date;
    begin
        NoOfColumn := Rec."End Date" - Rec."Start Date" + 1;
        StartDate := Rec."Start Date";
        EndDate := Rec."End Date";
        CurrPage."Trainee Subform".Page.SetMatrixData(NoOfColumn, StartDate);
        CurrPage.Update;
    end;

    local procedure TrainingLineCheck(TrainingNo: Code[20])
    var
        TrainLine: Record "Training Line";
        Text001: Label 'Training card must have at least one %1 in %2.';
    begin
        TrainLine.Reset;
        TrainLine.SetRange("Training No.", TrainingNo);
        TrainLine.SetRange(Type, TrainLine.Type::Trainee);
        if not TrainLine.FindFirst then
            Error(Text001, 'Trainee', TrainingNo);

        TrainLine.Reset;
        TrainLine.SetRange("Training No.", TrainingNo);
        TrainLine.SetRange(Type, TrainLine.Type::Trainer);
        if not TrainLine.FindFirst then
            Error(Text001, 'Trainer', TrainingNo);
    end;
}
