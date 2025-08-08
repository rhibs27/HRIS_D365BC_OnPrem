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
                    Editable = IsOpen;
                    ToolTip = 'Specifies the value of the No. field.';
                    ApplicationArea = All;

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update;
                    end;
                }
                field("Training Nature"; Rec."Training Nature")
                {
                    Editable = IsOpen;
                    ToolTip = 'Specifies the value of the Training Nature field.';
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
                    Editable = IsOpen;
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = All;
                }
                field(Province; Rec.Province)
                {
                    Editable = IsOpen;
                    ToolTip = 'Specifies the value of the Province field.';
                    ApplicationArea = All;
                }
                field("Province Name"; Rec."Province Name")
                {
                    Editable = IsOpen;
                    ToolTip = 'Specifies the value of the Province Name field.';
                    ApplicationArea = All;
                }
                field(Venue; Rec.Venue)
                {
                    Editable = IsOpen;
                    ToolTip = 'Specifies the value of the Venue field.';
                    ApplicationArea = All;
                }
                field("Training Type"; Rec."Training Type")
                {
                    Editable = IsOpen;
                    ToolTip = 'Specifies the value of the Training Type field.';
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
                    Visible = false;
                    ToolTip = 'Specifies the value of the Start Time field.';
                    ApplicationArea = All;
                }
                field("End Time"; Rec."End Time")
                {
                    Editable = IsOpen;
                    Visible = false;
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
                // field("Sub-Province"; Rec."Sub-Province")
                // {
                //     Editable = IsOpen;
                //     ToolTip = 'Specifies the value of the Sub-Province field.';
                //     ApplicationArea = All;
                // }
                field("Branch Code"; Rec."Branch Code")
                {
                    Editable = IsOpen;
                    ToolTip = 'Specifies the value of the Branch Code field.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        if Rec."Branch Code" <> '' then
                            FieldEditable := false
                        else
                            FieldEditable := true;
                        CurrPage.Update;
                    end;
                }
                field(Department; Rec.Department)
                {
                    Editable = FieldEditable;
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
                    Editable = IsOpen;
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
                    Editable = IsOpen;
                    ToolTip = 'Specifies the value of the Resource Person field.';
                    ApplicationArea = All;
                }
                field(Month; Rec.Month)
                {
                    Editable = IsOpen;
                    ToolTip = 'Specifies the value of the Month field.';
                    ApplicationArea = All;
                }
                field(Online; Rec.Online)
                {
                    ToolTip = 'Specifies the value of the Online field.';
                    ApplicationArea = All;
                }
            }
            group("Training Expense")
            {
                Caption = 'Training Expense';
                group(Estimated)
                {
                    Caption = 'Estimated';
                    field(Vendor; Rec.Vendor)
                    {
                        Caption = 'Vendor Code';
                        Editable = IsOpen;
                        ToolTip = 'Specifies the value of the Vendor Code field.';
                        ApplicationArea = All;
                    }
                    field("Vendor Name"; Rec."Vendor Name")
                    {
                        Editable = IsOpen;
                        ToolTip = 'Specifies the value of the Vendor Name field.';
                        ApplicationArea = All;
                    }
                    field("Estimated Training Cost"; Rec."Estimated Training Cost")
                    {
                        Editable = IsOpen;
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
                    field("Actual Total Budget"; Rec."Actual Total Budget")
                    {
                        ToolTip = 'Specifies the value of the Actual Total Budget field.';
                        ApplicationArea = All;
                    }
                }
            }
            group(Budget)
            {
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
            part("Training Approval"; "Document Approver")
            {
                Caption = 'Training Approval';
                Editable = not IsApproved;
                SubPageLink = "Document No." = field("No.");
                ApplicationArea = All;
            }
            group(HR)
            {
                Visible = false;
                field("HR Manager Code"; Rec."HR Manager Code")
                {
                    ToolTip = 'Specifies the value of the HR Manager Code field.';
                    ApplicationArea = All;
                }
                field("HR Manager Name"; Rec."HR Manager Name")
                {
                    ToolTip = 'Specifies the value of the HR Manager Name field.';
                    ApplicationArea = All;
                }
                field("HR Head Code"; Rec."HR Head Code")
                {
                    ToolTip = 'Specifies the value of the HR Head Code field.';
                    ApplicationArea = All;
                }
                field("HR Head Name"; Rec."HR Head Name")
                {
                    ToolTip = 'Specifies the value of the HR Head Name field.';
                    ApplicationArea = All;
                }
            }
            part("Training Payment"; "Training Payee")
            {
                Caption = 'Training Payment';
                Editable = IsApproved;
                SubPageLink = "Training No." = field("No."),
                              Type = const(Vendor);
                Visible = IsApproved;
                ApplicationArea = All;
            }
            group("Training Review")
            {
                Visible = IsApproved;
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
                            Rec.Validate("Trainer Remarks", Format(RatingSetup.Remarks));
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
                // Visible = false;
                action("Send Approval Request")
                {
                    Caption = 'Send A&pproval Request';
                    Enabled = not OpenApprovalEntriesExist;
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Send A&pproval Request action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        //HRMgt.CheckDocumentApprover("No.");
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
                        if not ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId) then begin
                            if (Rec."Approval Status" = Rec."Approval Status"::Open) then begin
                                Rec.CheckLineForApproval;
                                Rec.OnSendTrainingDocForApproval(Rec);
                            end;
                        end else
                            Message('Workflow is not enable for training');
                    end;
                }
                action("Cancel Approval Request")
                {
                    Caption = 'Cancel Approval Re&quest';
                    Enabled = OpenApprovalEntriesExist;
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Cancel Approval Re&quest action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        Rec.OnCancelTrainingDocForApproval(Rec);
                    end;
                }
                action("Sending Mail")
                {
                    Image = SendConfirmation;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Sending Mail action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        Rec.TestField("Prepared By");
                        HRMgt.SendMailFromTemplate(Database::"Training Header", EmailTemplate."Document Type"::Training, 0, '', Rec."Prepared By", Rec."No.", 0);
                        Message('Mail has been send.');
                    end;
                }
                action("Calculate Training Marks")
                {
                    Image = CalculateBalanceAccount;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Visible = IsApproved;
                    ToolTip = 'Executes the Calculate Training Marks action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        HRMgt.CalTrainingMarks(Rec."No.");
                    end;
                }
                action("Payment Memo")
                {
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = IsApproved;
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
                action("Calculate YTD And MTD")
                {
                    Image = Calculate;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Calculate YTD And MTD action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        Rec.CalculateYTDExpense;
                        Rec.CalcualteMTDExpense;
                    end;
                }
                action(Post)
                {
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Visible = IsApproved;
                    ToolTip = 'Executes the Post action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        Rec.SetPosted;
                    end;
                }
                action(Approvals)
                {
                    Image = Approvals;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Approvals action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        ApprovalEntries: Record "Approval Entry";
                    begin
                        ApprovalEntries.Reset;
                        ApprovalEntries.SetRange("Document No.", Rec."No.");
                        ApprovalEntries.SetRange(Status, ApprovalEntries.Status::Open);
                        if ApprovalEntries.FindFirst then
                            Page.Run(658, ApprovalEntries);
                    end;
                }
                action("Export Trainees")
                {
                    Image = Export;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Executes the Export Trainees action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        HRMgt.ExportTrainee(Rec);
                    end;
                }
                action("Import Trainees")
                {
                    Image = Import;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Import Trainees action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        HRMgt.ImportTrainee(Rec);
                    end;
                }
                action("Export Attendance")
                {
                    Image = ExportDatabase;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Export Attendance action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        HRMgt.ExportTraineeAttendance(Rec);
                    end;
                }
                action("Import Attendance")
                {
                    Image = ImportDatabase;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Import Attendance action.';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        HRMgt.ImportTraineeAttendance(Rec);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        TrainingCalendarEditable := Rec."Training Nature" = Rec."Training Nature"::Calendar;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Approval Status" := Rec."Approval Status"::Open;
    end;

    trigger OnOpenPage()
    begin
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
        Rec.CalcFields("Total No. of Participant");
        if (Rec."Start Date" <> 0D) and (Rec."End Date" <> 0D) then
            SetColumn;

        if TrainHead.Get(Rec."No.") then begin
            IsApproved := TrainHead."Approval Status" = TrainHead."Approval Status"::Released;
            IsOpen := TrainHead."Approval Status" = TrainHead."Approval Status"::Open;
        end else
            IsOpen := true;

        if Rec.Posted then
            CurrPage.Editable(false);

        if Rec."Branch Code" <> '' then
            FieldEditable := false
        else
            FieldEditable := true;
    end;

    var

        OpenApprovalEntriesExist: Boolean;
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        DateFilter: Text;
        NoOfColumn: Integer;
        HRMgt: Codeunit "HR Mgt.";

        IsApproved: Boolean;
        TrainHead: Record "Training Header";

        IsOpen: Boolean;
        EmailTemplate: Record "Email Template";
        RatingSetup: Record "Rating Setup";
        TrainingCalendarEditable: Boolean;
        TrainingLine: Record "Training Line";
        FieldEditable: Boolean;

    local procedure SetColumn()
    var
        StartDate: Date;
        EndDate: Date;
    begin
        DateFilter := StrSubstNo('%1..%2', Rec."Start Date", Rec."End Date");
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
